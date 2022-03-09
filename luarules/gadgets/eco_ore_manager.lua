---
--- Created by Breno "MaDDoX" Azevedo.
--- DateTime: 14-Nov-18 9:19 AM
---
function gadget:GetInfo()
    return {
        name      = "Eco - Ore Manager",
        desc      = "Spawn Ore Chunks around metal spots at game start then repeatedly",
        author    = "MaDDoX",
        date      = "July 2021",
        license   = "GNU GPL, v2 or later",
        layer     = 100,
        enabled   = true,
    }
end

VFS.Include("gamedata/taptools.lua")

if gadgetHandler:IsSyncedCode() then
    -----------------
    ---- SYNCED
    -----------------

    --harvest_eco = 1 --(tonumber(Spring.GetModOptions().harvest_eco)) or 1
    local updateRate = 120 * 30 -- 1m30 (was 2 mins)
    local oreSpots = {} -- { 1 = { chunks = { unitID = { pos, kind, spotIdx, idxInSpot }, ...},
                   --TODO:    sprawlLevel = 1..5,   //1 = no Sprawler; 2 = basic Sprawler, 3 = large, 4 = moho, 5 = mantle
                   --         ringCap = 2..4,       //2 = close to Map edges; 4 = close to the center of the Map
                   --       }, ...
                   -- }
    local startFrame
    local gaiaTeamID = Spring.GetGaiaTeamID()
    local sprawlChance = 0.2
    local deadZone = 30
    local startOreKind = "lrg"  -- the initial ore chunks on the map
    local baseOreKind = "sml"   -- base ore type to be spawned in each global spawning, when no sprawler assigned to the spot
    local sprawlerMult = { ["sml"]=1.25, ["lrg"]=1.5, ["moho"]=2, ["uber"]=4 }
    local maxIter = 50 -- it'll quit trying to recurse (find an appropriate spot) after 50 attempts
    --local respawnTime = 60 -- in frames; 60f = 2s
    --local geosToRespawn = {}
    local spawnHeight = 240 -- how high above the ground the chunks are spawned, then "rain down" at the ground

    local math_random = math.random
    local math_sqrt = math.sqrt
    local math_cos = math.cos
    local math_sin = math.sin
    local math_pi = math.pi
    local minSpawnDistance = 18  -- 12   -- This prevents stacked ore chunks when spawning
    local startingChunkCount = 3 --
    local maxChunkCount = 10     -- Won't have more than this amount of chunks in a single spot (on respawn)
    local baseChunkMult = 1      -- existing chunks times this number will be spawned (up to maxChunkCount above)
    local spawnIterMult = 0.11   -- every global spawning iteration, this is multiplied by the iter and subtracted from baseChunkMult
    local minChunkMult = 0.2     -- minimum chunk multiplier, per spot
    local spawnRadius = 55       -- starting spawn radius from oreSpot's center
    local spawnIter = 0          -- how many times the global spawning ("pandore rain") has occured
    local chunks = {} --{ unitID = { pos = {x=x, z=z}, kind="sml | lrg | moho | uber", spotIdx = idx {oreSpots[idx]}), idxInSpot = n }

    -- currently unused/obsolete, we're using the health of the chunk. 1 hp = 1 ore
    --local oreValue = { sml = 240, lrg = 360, moho = 720, mantle = 2160 } --calculating 4s for a drop cycle (reclaim/drop)

    local spCreateUnit = Spring.CreateUnit
    local spSetUnitNeutral = Spring.SetUnitNeutral
    local spGetUnitsInCylinder = Spring.GetUnitsInCylinder
    local spSendLuaUIMsg = Spring.SendLuaUIMsg
    local spGetGameFrame = Spring.GetGameFrame

    local ore = { ["sml"] = {id = UnitDefNames["oresml"].id},   --TODO: add minSpawnDistance, per type
                  ["lrg"] = {id = UnitDefNames["orelrg"].id},
                  ["moho"] = {id = UnitDefNames["oremoho"].id},
                  ["uber"] = {id = UnitDefNames["oreuber"].id} }

    --local function distance (x1, y1, z1, x2, y2, z2 )
    --    return math.sqrt(sqr(x2-x1) + sqr(y2-y1) + sqr(z2-z1))
    --end

    local function chunkOrUnitNearby(x, _, z, iter)
        if x == nil or z == nil then
            return false
        end
        local unitsNearSpawnpoint = spGetUnitsInCylinder(x, z, minSpawnDistance) --that should be the chunk collision width really
        if unitsNearSpawnpoint == nil or (istable(unitsNearSpawnpoint) and #unitsNearSpawnpoint == 0) then
            return false
        else
            --Spring.Echo("Not valid: "..x..", "..z..", count: "..(#unitsNearSpawnpoint)..", iter: "..tostring(iter.value))
            return true
        end
--        return false
    end

    local function tooCloseToSpot (x, z, cx, cz)
        return distance({x=x, z=z}, {x=cx, z=cz}) < deadZone
    end

    --- Returns: Spawned unitID
    local function SpawnChunk(cx, cy, cz, R, deadZone, spotIdx, kind, iter)
        if not cx or not cz then --or not cy or
            return nil
        end

        kind = kind or "sml"
        --https://dev.to/seanpgallivan/solution-generate-random-point-in-a-circle-ldh

        local ang = math_random() * 2 * math_pi
        local hyp = math_sqrt(math_random()) * R --(deadZone,1)
        local cos = math_cos(ang)
        local sin = math_sin(ang)
        local x = cx + cos * hyp
        local z = cz + sin * hyp
        --Spring.Echo("dist: "..distance({x, z}, {cx, cz}))

        --recurses when result is invalid (close to center or to existing chunk)
        if tooCloseToSpot(x,z,cx,cz) then --or chunkOrUnitNearby(x,cy,z, iter) then
            if iter.value >= maxIter then
                Spring.Echo("Couldn't spawn chunk at spot#: "..spotIdx)
                return nil  -- max attempts reached, too busy around. Quit trying
            else
                --Try again, until maxIter. We use a table for 'iter' (iteration) since it's passed by reference, so it can be read by caller's scope
                return SpawnChunk(cx, cy, cz, R, deadZone, spotIdx, kind, { value = iter.value+1 })
            end
        else    -- otherwise, actually spawn the unit and make it neutral
            --Spring.Echo("Name: "..(ore[kind] or "invalid"))
            --spCreateUnit((UnitDefs[ore[kind]]).id, x, cy, z, math_random(0, 3), gaiaTeamID)
            Spring.Echo("Kind: "..(kind or "nil"))
            --Spring.Echo("ID: "..(ore[tostring(kind)] and (ore[tostring(kind)]).id or "nil"))
            --local unitID = spCreateUnit((UnitDefs[(ore["lrg"]).id]).id, x, cy+spawnHeight, z, math_random(0, 3), gaiaTeamID)
            local unitID = spCreateUnit((UnitDefs[ore[kind]]).id, x, cy+spawnHeight, z, math_random(0, 3), gaiaTeamID)
            if unitID then
                --Spring.MoveCtrl.Enable(unitID)
                Spring.MoveCtrl.SetGravity(unitID, 0.1)
                spSetUnitNeutral(unitID, true)
                chunks[unitID] = { pos = { x=x, y=cy, z=z}, kind = kind, spotIdx = spotIdx, spawnR = R } --, time = sprawlTime }
                if not oreSpots[spotIdx] then
                    Spring.Echo("Ore Spot "..spotIdx.." not found")
                end
                if not oreSpots[spotIdx].chunks then
                    oreSpots[spotIdx].chunks = {}
                end
                (oreSpots[spotIdx].chunks)[unitID] = { pos = {x=x, z=z}, kind= startOreKind, spotIdx = spotIdx }
                SendToUnsynced("chunkSpawnedEvent", gaiaTeamID, spotIdx, unitID, startOreKind)   -- i = spotIdx, j = chunkIdx
            else
                Spring.Echo("Invalid chunk unit spawned at spot#: "..spotIdx)
            end
            return unitID
        end
    end

    local function spawnOneChunk(x, y, z, i)
        -- We also store the spawned chunks in each oreSpot, in oreSpots data
        --if spawnedUnitID then
        --    if not oreSpots[i] then
        --        Spring.Echo("Ore Spot "..i.." not found")
        --    end
        --    if not oreSpots[i].chunks then
        --        oreSpots[i].chunks = {}
        --    end
        --    oreSpots[i].chunks.spawnedUnitID = { pos = {x=x, z=z}, kind=startKind, spotIdx = i }
        --    SendToUnsynced("chunkSpawnedEvent", gaiaTeamID, i, spawnedUnitID, startKind)   -- i = spotIdx, j = chunkIdx
        --else
        --    Spring.Echo("Couldn't spawn chunk at spot#: "..i)
        --end
    end

    function gadget:Initialize()
        --if not harvest_eco == 1 then
        --    gadgetHandler:RemoveGadget(self)
        --end
        ore = { sml = UnitDefNames["oresml"].id, lrg = UnitDefNames["orelrg"].id, moho = UnitDefNames["oremoho"].id, uber = UnitDefNames["oreuber"].id }
        oreSpots = GG.metalSpots  -- Set by mex_spot_finder.lua
        --if not istable(oreSpots) then
        --    Spring.Echo("Warning: GG.metalSpots not found by eco_ore_manager.lua!")
        --    oreSpots = {} end
        --metalSpotsByPos = GG.metalSpotsByPos
        --gadget:GameStart()
    end

    --function gadget:GameFrame(frame)
    function gadget:GameStart()
        Spring.Echo("Number of ore spots found: "..#oreSpots)
        startFrame = Spring.GetGameFrame()
        for i, data in ipairs(oreSpots) do
            --Spring.Echo("Adding chunks to spot#: "..i)
            local x, y, z = data.x, data.y, data.z
            for j = 1, startingChunkCount do
                local unitID = SpawnChunk (x, y, z, spawnRadius, deadZone, i, startOreKind, { value=1 })
                Spring.Echo("Chunk unitID: "..(unitID or "nil").." added to spot #: "..i)
            end
        end
        _G.oreSpots = oreSpots; --make it available for the unsynced side
        DebugTable(oreSpots)
    end

    function gadget:UnitDestroyed(unitID) --, unitDefID, teamID, attackerID, attackerDefID, attackerTeam)
        local chunk = chunks[unitID]
        if chunk then
            local spotIdx = chunk.spotIdx
            if not oreSpots[spotIdx].chunks then
                oreSpots[spotIdx].chunks = {}
            end
            if (oreSpots[spotIdx].chunks)[unitID] then
                (oreSpots[spotIdx].chunks)[unitID] = nil
                chunks[unitID] = nil
                spSendLuaUIMsg("chunkDestroyed_"..unitID, "allies") --(message, mode)
                --_G.oreSpots = oreSpots;
                SendToUnsynced("chunkDestroyedEvent", gaiaTeamID, spotIdx, unitID) --should be 'gaiaAllyTeam' (irrelevant here)
                --Spring.Echo("Sending message: chunkDestroyed_"..unitID)
            else
                Spring.Echo("WARNING: Destroyed chunk "..(unitID or "nil").." not found in list of spot# "..spotIdx)
                if istable(oreSpots[spotIdx].chunks) then
                    DebugTable(oreSpots[spotIdx].chunks)
                else
                    Spring.Echo("chunks not found at oreSpot #: "..spotIdx)
                end
            end
        end
    end

    function gadget:GameFrame(f)
        if f % updateRate > 0.0001 or f <= startFrame then
            return end
        spawnIter = spawnIter + 1
        Spring.Echo("Spawn Iteration: "..spawnIter)

        for i, data in ipairs(oreSpots) do
            local x, y, z = data.x, data.y, data.z
            if not data.chunks then
                Spring.Echo("ore Spot idx "..i..".chunks not found")
            end
            local existingCount = data.chunks and tablelength(data.chunks) or 0
            -- eg: 2 chunks, baseChunkMult 1, spawnIterChunkMult 0.11, iteration 1 => ceil(2 * (1 - 1 * 0.11) => round (2 * 0.89) = 2
            -- eg: 2 chunks, baseChunkMult 1, spawnIterChunkMult 0.11, iteration 2 => ceil(2 * (1 - 2 * 0.11) => round (2 * 0.78) = 2
            -- eg: 2 chunks, baseChunkMult 1, spawnIterChunkMult 0.11, iteration 3 => ceil(2 * (1 - 3 * 0.11) => round (2 * 0.67) = 1

            -- eg: 1 chunk,  baseChunkMult 1, spawnIterChunkMult 0.75, iteration 1 => ceil(1 * 1 * ( 0.75 / 1)) => ceil (0.75) = 1
            local chunkMult = math.max(minChunkMult, baseChunkMult - (spawnIter * spawnIterMult)) --TODO: Apply oreSpot's sprawlerMult
            local targetNewChunks = math.round (existingCount * chunkMult )
            local chunksToSpawnHere = clamp( 0, maxChunkCount - existingCount, targetNewChunks)
            Spring.Echo("Existing: "..existingCount.."; Target: "..existingCount * baseChunkMult .."; max: "..maxChunkCount - existingCount.."; to spawn: "..chunksToSpawnHere)
            for j = 1, chunksToSpawnHere do
                SpawnChunk (x, y, z, spawnRadius, deadZone, i, baseOreKind, { value=1 })
            end
        end
    end

else
    -----------------
    ---- UNSYNCED
    -----------------

    ---- Here we'll make the 'capture' cursor the default action on top of ore chunks
    ---- for commanders and capture-enabled builders

    local spGetMouseState = Spring.GetMouseState
    local spTraceScreenRay = Spring.TraceScreenRay
    --local spAreTeamsAllied = Spring.AreTeamsAllied
    --local spGetUnitTeam = Spring.GetUnitTeam
    local spGetUnitDefID = Spring.GetUnitDefID
    local spGetSelectedUnits = Spring.GetSelectedUnits
    --local spGetLocalTeamID = Spring.GetLocalTeamID
    local spFindUnitCmdDesc = Spring.FindUnitCmdDesc
    local spGetUnitCmdDescs = Spring.GetUnitCmdDescs
    local spGetUnitPosition = Spring.GetUnitPosition
    local CMD_CAPTURE = CMD.CAPTURE
    local oreSpots  = {}        -- This will be updated by the events

    local strUnit = "unit"

    local oreDefIDs = {
        [UnitDefNames["oresml"].id] = true,
        [UnitDefNames["orelrg"].id] = true,
        [UnitDefNames["oremoho"].id] = true,
        [UnitDefNames["oreuber"].id] = true,
    }

    local function handleChunkDestroyedEvent(cmd, allyTeam, spotIdx, destroyedUnitID)
        oreSpots = SYNCED.oreSpots;
        Spring.Echo("<destroy> Message received. Spots #: "..(oreSpots and #oreSpots or "nil"))
        --DebugTable(oreSpots)
        --if not oreSpots[spotIdx] then
        --    Spring.Echo("[unsync]Ore Spot "..spotIdx.." not found")
        --end
        --if not oreSpots[spotIdx].chunks then
        --    oreSpots[spotIdx].chunks = {}
        --end
        --if (oreSpots[spotIdx].chunks)[chunkIdx] then
        --    table.remove(oreSpots[spotIdx].chunks, chunkIdx )
        --    Spring.Echo("Removed: i: "..spotIdx.." j: "..chunkIdx)
        --else
        --    Spring.Echo("Couldn't remove: i: "..spotIdx.." j: "..chunkIdx)
        --end
    end

    local function handleChunkSpawnedEvent(cmd, allyTeam, gaiaTeamID, i, spawnedUnitID, kind) --i = spotIdx
        oreSpots = SYNCED.oreSpots;
        Spring.Echo("<spawn> Message received. Spots #: "..(oreSpots and #oreSpots or "nil"))
        --DebugTable(oreSpots)
        --if not oreSpots[i] then
        --    Spring.Echo("[unsync]Ore Spot "..i.." not found")
        --end
        --if not oreSpots[i].chunks then
        --    oreSpots[i].chunks = {}
        --end
        --
        --local x, _, z = spGetUnitPosition(spawnedUnitID)
        --local chunkCount = #(oreSpots[i].chunks)
        --oreSpots[i].chunks[chunkCount+1] = { unitID = spawnedUnitID, pos = {x=x, z=z}, kind=kind, spotIdx = i } --, idxInSpot = j
        --Spring.Echo("Added: unitID: "..spawnedUnitID..", i: "..i..", j: "..j)
    end

    function gadget:Initialize()
        gadgetHandler:AddSyncAction("chunkDestroyedEvent", handleChunkDestroyedEvent)
        gadgetHandler:AddSyncAction("chunkSpawnedEvent", handleChunkSpawnedEvent)
        oreSpots = SYNCED.oreSpots;
    end

    function gadget:Shutdown()
        gadgetHandler:RemoveSyncAction("chunkDestroyedEvent")
        gadgetHandler:RemoveSyncAction("chunkSpawnedEvent")
    end


    function gadget:DefaultCommand()
        local function isOre(unitDefID)
            return oreDefIDs[unitDefID]
        end
        local mx, my = spGetMouseState()
        local s, targetID = spTraceScreenRay(mx, my)
        if s ~= strUnit then
            return false end

        --if not spAreTeamsAllied(myTeamID, spGetUnitTeam(targetID)) then
        --    return false
        --end

        -- Only proceed if target is one of the ore chunk variations
        local targetDefID = spGetUnitDefID(targetID)
        if not isOre(targetDefID) then
            return false end

        ---TODO: Replace with new 'harvest' icon
        -- If any of the selected units is a capturer, default to 'capture'
        --local sUnits = spGetSelectedUnits()
        --local teamID = spGetLocalTeamID()

        --for i=1,#sUnits do
        --    local unitID = sUnits[i]
        --    local unitDef = UnitDefs[spGetUnitDefID(unitID)]
        --    --if unitDef.customParams.iscommander then
        --    --    return CMD_CAPTURE
        --    --end
        --    if unitDef.canCapture then
        --        -- Check if the units has capture enabled already
        --        local cmdIdx = spFindUnitCmdDesc(unitID, CMD_CAPTURE)
        --        local cmdDesc = spGetUnitCmdDescs(unitID, cmdIdx, cmdIdx)[1]
        --        if not cmdDesc.disabled then
        --            return CMD_CAPTURE end
        --    end
        --end
        return false
    end

end
