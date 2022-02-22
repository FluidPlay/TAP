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

if gadgetHandler:IsSyncedCode() then
    -----------------
    ---- SYNCED
    -----------------
    VFS.Include("gamedata/taptools.lua")

    --harvest_eco = 1 --(tonumber(Spring.GetModOptions().harvest_eco)) or 1
    local updateRate = 120 * 30 -- 2 mins
    local oreSpots = {} -- { 1 = { chunks = { 1 = { unitID, pos, kind, spotIdx, idxInSpot }, ...},
                   --TODO:    sprawlLevel = 1..5,   //1 = no Sprawler; 2 = basic Sprawler, 3 = large, 4 = moho, 5 = mantle
                   --         ringCap = 2..4,       //2 = close to Map edges; 4 = close to the center of the Map
                   --       }, ...
                   -- }
    local startFrame
    local gaiaTeamID = Spring.GetGaiaTeamID()
    local sprawlChance = 0.2
    local deadZone = 30
    local startKind = "lrg"
    local spawnDelay = { ["sml"]=300, ["lrg"]=400, ["moho"]=550, ["mantle"]=750 }
    local allUnits = {}
    --local respawnTime = 60 -- in frames; 60f = 2s
    --local geosToRespawn = {}

    local math_random = math.random
    local math_sqrt = math.sqrt
    local math_cos = math.cos
    local math_sin = math.sin
    local math_pi = math.pi
    local minSpawnDistance = 12     -- This prevents stacked ore chunks when spawning
    local startingChunkCount = 4    --
    local maxChunkCount = 10        -- Won't have more than this amount of chunks in a single spot (on respawn)
    local chunkMultiplier = 1       -- existing chunks times this number will be spawned (up to maxChunkCount above)
    local spawnRadius = 55 --starting spawn radius from oreSpot's center
    local chunks = {} --{ unitID = { pos = {x=x, z=z}, kind="sml | lrg | moho | mantle", spotIdx = idx {oreSpots[idx]}), idxInSpot = n }

    local oreValue = { sml = 240, lrg = 360, moho = 720, mantle = 2160 } --calculating 4s for a drop cycle (reclaim/drop)

    local spCreateUnit = Spring.CreateUnit
    local spSetUnitNeutral = Spring.SetUnitNeutral
    local spGetAllUnits = Spring.GetAllUnits
    local spSendLuaUIMsg = Spring.SendLuaUIMsg

    local ore = { sml = UnitDefNames["oresml"].id, lrg = UnitDefNames["orelrg"].id, moho = UnitDefNames["oremoho"].id, uber = UnitDefNames["oremantle"].id } --{ sm = UnitDefNames["oresml"].id, lrg = UnitDefNames["orelrg"].id, moho = UnitDefNames["oremoho"].id, uber = UnitDefNames["oremantle"].id }

    local function sqr (x)
        return math.pow(x, 2)
    end
    --local function distance (x1, y1, z1, x2, y2, z2 )
    --    return math.sqrt(sqr(x2-x1) + sqr(y2-y1) + sqr(z2-z1))
    --end
    local function distance (pos1, pos2)
        --Spring.Echo("x1: "..(pos1.x or "nil").." | z1: ".. (pos1.z or "nil") .. " | x2: "..(pos2.x or "nil").." | z2: "..(pos2.z or "nil"))
        if pos1.x == nil or pos2.x == nil or pos1.z == nil or pos2.z == nil then
            return 999
        end
        return math.sqrt(sqr(pos2.x-pos1.x) + sqr(pos2.z-pos1.z))
    end

    local function chunkOrUnitNearby(x, _, z, allUnits)
        if x == nil or z == nil then
            return false end
        for _, data in pairs(chunks) do
            if distance(data.pos, {x=x, z=z}) < minSpawnDistance then
                return true
            end
            --for _, unitID in pairs(allUnits) do
            --    local x,_,z = spGetUnitPosition(unitID)
            --    local unitPos = {x=x, z=z}
            --    if distance(unitPos, {x=x, z=z}) < minSpawnDistance then
            --        return true
            --    end
            --end
        end
        return false
    end

    local function TooCloseToSpot (x, z, cx, cz)
        return distance({x=x, z=z}, {x=cx, z=cz}) < deadZone
    end

    --- Returns: Spawned unitID
    local function SpawnChunk(cx, cy, cz, R, deadZone, spotIdx, idxInSpot, kind)

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
        if TooCloseToSpot(x,z,cx,cz) or chunkOrUnitNearby(x,cy,z, allUnits) then
            SpawnChunk(cx, cy, cz, R, deadZone, spotIdx, idxInSpot, kind)
        else    -- otherwise, actually spawn the unit and make it neutral
            --Spring.Echo("Name: "..(ore[kind] or "invalid"))
            --spCreateUnit((UnitDefs[ore[kind]]).id, x, cy, z, math_random(0, 3), gaiaTeamID)
            local unitID = spCreateUnit((UnitDefs[ore.moho]).id, x, cy, z, math_random(0, 3), gaiaTeamID)
            spSetUnitNeutral(unitID, true)
            --local featureID = spCreateFeature ( "ore_moho", x, cy, z, math_random(0,0.01), gaiaTeamID )--number heading [, number AllyTeamID [, number featureID ]]] )
            --local sprawlTime = spGetGameFrame() + (spawnDelay[kind] or 240) + math_random(0,60)
            chunks[unitID] = { pos = { x=x, y=cy, z=z}, kind = kind, spotIdx = spotIdx, spawnR = R, idxInSpot = idxInSpot } --, time = sprawlTime }
            --if math_random() < sprawlChance then
            --    chunksToSprawl[unitID] = spawnedChunks[unitID]
            --end
            return unitID
        end
    end

    function gadget:Initialize()
        --if not harvest_eco == 1 then
        --    gadgetHandler:RemoveGadget(self)
        --end
        ore = { sml = UnitDefNames["oresml"].id, lrg = UnitDefNames["orelrg"].id, moho = UnitDefNames["oremoho"].id, uber = UnitDefNames["oremantle"].id }
        startFrame = Spring.GetGameFrame()
        oreSpots = GG.metalSpots  -- Set by mex_spot_finder.lua
        --metalSpotsByPos = GG.metalSpotsByPos
        gadget:GameStart()
    end

    --function gadget:GameFrame(frame)
    function gadget:GameStart()
        --Spring.Echo("Number of ore spots found: "..#oreSpots)
        allUnits = spGetAllUnits()
        if not istable(oreSpots) then
            return end
        for i, data in ipairs(oreSpots) do
            local x, y, z = data.x, data.y, data.z
            for j = 1, startingChunkCount do
                local spawnedUnitID = SpawnChunk (x, y, z, spawnRadius, deadZone, i, j, startKind) -- spotIdx, idxInSpot
                -- We also store the spawned chunks from each oreSpot, in oreSpots data
                if (oreSpots[i].chunks == nil) then
                    oreSpots[i].chunks = {} end
                oreSpots[i].chunks[#(oreSpots[i].chunks)+1] = { unitID = spawnedUnitID, pos = {x=x, z=z}, kind=startKind, spotIdx = i, idxInSpot = j }
            end
        end
    end

    function gadget:UnitDestroyed(unitID) --, unitDefID, teamID, attackerID, attackerDefID, attackerTeam)
        if chunks[unitID] then
            local spotIdx = (chunks[unitID]).spotIdx
            local chunkIdx = (chunks[unitID]).idxInSpot
            table.remove(oreSpots[spotIdx].chunks, chunkIdx )
            chunks[unitID] = nil
            spSendLuaUIMsg("chunkDestroyed_"..unitID, "allies") --(message, mode)
            --Spring.Echo("Sending message: chunkDestroyed_"..unitID)
        end
    end

    function gadget:GameFrame(f)
        if f < startFrame + updateRate
            then return end
        if f % updateRate > 0.0001 then
            return end

        allUnits = spGetAllUnits()
        for i, data in ipairs(oreSpots) do
            local x, y, z = data.x, data.y, data.z
            local existingCount = oreSpots[i].chunks and #(oreSpots[i].chunks) or 0
            local chunksToSpawnHere = clamp( existingCount * chunkMultiplier,0, maxChunkCount - existingCount)
            if i == 1 then
                --Spring.Echo(i.."\n\n")
                --Spring.Echo("oreSpots#: "..#oreSpots)
                --Spring.Echo("chunks to spawn#: "..chunksToSpawnHere)
            end
            for j = 1, chunksToSpawnHere do
                local spawnedUnitID = SpawnChunk (x, y, z, spawnRadius, deadZone, i, j, startKind) -- spotIdx, idxInSpot
                oreSpots[i].chunks[#(oreSpots[i].chunks)+1] = { unitID = spawnedUnitID, pos = {x=x, z=z}, kind=startKind, spotIdx = i, idxInSpot = j }
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
    local CMD_CAPTURE = CMD.CAPTURE

    local strUnit = "unit"

    local oreDefIDs = {
        [UnitDefNames["oresml"].id] = true,
        [UnitDefNames["orelrg"].id] = true,
        [UnitDefNames["oremoho"].id] = true,
        [UnitDefNames["oremantle"].id] = true,
    }

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

        -- If any of the selected units is a capturer, default to 'capture'
        local sUnits = spGetSelectedUnits()
        --local teamID = spGetLocalTeamID()

        for i=1,#sUnits do
            local unitID = sUnits[i]
            local unitDef = UnitDefs[spGetUnitDefID(unitID)]
            --if unitDef.customParams.iscommander then
            --    return CMD_CAPTURE
            --end
            if unitDef.canCapture then
                -- Check if the units has capture enabled already
                local cmdIdx = spFindUnitCmdDesc(unitID, CMD_CAPTURE)
                local cmdDesc = spGetUnitCmdDescs(unitID, cmdIdx, cmdIdx)[1]
                if not cmdDesc.disabled then
                    return CMD_CAPTURE end
            end
        end
        return false
    end

end
