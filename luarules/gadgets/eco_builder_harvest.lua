---
--- Created by Breno "MaDDoX" Azevedo.
--- DateTime: 14-Nov-18 9:19 AM
---
function gadget:GetInfo()
    return {
        name      = "Eco - Builder Harvest",
        desc      = "Damaged (Harvested) Pandore Chunks are converted (or stored) into ore resources",
        author    = "MaDDoX",
        date      = "Sep 2021",
        license   = "GNU GPL, v2 or later",
        layer     = 1,
        enabled   = true,
    }
end

VFS.Include("gamedata/tapevents.lua") --"LoadedHarvesterEvent"

if gadgetHandler:IsSyncedCode() then
    -----------------
    ---- SYNCED
    -----------------

    VFS.Include("gamedata/taptools.lua")

    local CHECK_FREQ = 30 --4

    local spGetGameFrame = Spring.GetGameFrame
    local spCreateUnit = Spring.CreateUnit
    local spSetUnitNeutral = Spring.SetUnitNeutral
    local spSetUnitHarvestStorage = Spring.SetUnitHarvestStorage
    local spGetUnitDefID = Spring.GetUnitDefID
    local spGetUnitHarvestStorage = Spring.GetUnitHarvestStorage
    local spGetUnitTeam = Spring.GetUnitTeam
    local spAddTeamResource = Spring.AddTeamResource
    local spCallCOBScript = Spring.CallCOBScript
    local spSetUnitWeaponState = Spring.SetUnitWeaponState
    local spGiveOrderToUnit = Spring.GiveOrderToUnit
    local spSetUnitRulesParam = Spring.SetUnitRulesParam
    local spGetUnitPosition = Spring.GetUnitPosition
    local spGetUnitSeparation = Spring.GetUnitSeparation
    local spGetUnitAllyTeam = Spring.GetUnitAllyTeam

    local defaultMaxStorage = 620
    local defaultOreTowerRange = 330
    local loadedHarvesters = {}
    local oreTowers = {}
    local doingHarvest = {} -- Harvesters "in action"

    local distBuffer = 40 -- distance buffer, units get further into the ore tower 'umbrella range' before dropping the load
    local deployPerTickAmount = 100

    local oreTowerDefNames = {
        armmstor = true, cormstor = true, armuwadvms = true, coruwadvms = true,
    }
    local canharvest = {
        armck = true, corck = true, armcv = true, corcv = true, armca = true, corca = true, armcs = true, corcs = true,
        armack = true, corack = true, armacv = true, coracv = true, armaca = true, coraca = true, armacsub = true, coracsub = true,
    }

    local CMD_STOP = CMD.STOP

    local ore = { sml = UnitDefNames["oresml"].id, lrg = UnitDefNames["orelrg"].id, moho = UnitDefNames["oremoho"].id, uber = UnitDefNames["oremantle"].id } --{ sm = UnitDefNames["oresml"].id, lrg = UnitDefNames["orelrg"].id, moho = UnitDefNames["oremoho"].id, uber = UnitDefNames["oremantle"].id }

    function gadget:Initialize()
        _G.OreTowers = oreTowers    -- making it available for unsynced access via SYNCED table
        --startFrame = Spring.GetGameFrame()
        --gaiaTeamID = Spring.GetGaiaTeamID()
        if Spring.GetModOptions().harvest_eco == 0 then
            gadgetHandler:RemoveGadget(self)
        end
    end

    function gadget:UnitFinished(unitID, unitDefID, unitTeam)
        local ud = UnitDefs[unitDefID]
        if ud == nil then
            return end
        if not oreTowerDefNames[ud.name] then
            return end
        Spring.Echo("Ore Tower added: "..unitID)
        oreTowers[unitID] = { range = (ud.buildDistance or 330), ally = spGetUnitAllyTeam(unitID) } -- 330 is lvl1 outpost build range
        spSetUnitRulesParam(unitID, "oretowerrange", (ud.buildDistance or defaultOreTowerRange)) --330
    end

    function gadget:UnitDestroyed(unitID, unitDefID, teamID, attackerID, attackerDefID, attackerTeam)
        oreTowers[unitID] = nil
        loadedHarvesters[unitID] = nil
        local ud = UnitDefs[unitDefID]
        if ud == nil then
            return end
        if not oreTowerDefNames[ud.name] then
            return end
        oreTowers[unitID] = nil
        --chunksToSprawl[unitID] = nil
        --local chunk = spawnedChunks[unitID]
        --if not spawnedChunks[unitID] then
        --    return end
        --local attackerDef = UnitDefs[attackerDefID]
        --if attackerDef and attackerDef.canCapture then
        --    spSetUnitHarvestStorage ( attackerID, oreValue[chunk.type])
        --end
        --spawnedChunks[unitID] = nil
    end

    ---Returns nearestTowerID (or nil if none found within 999 range) & nearestDeployPos
    local function getNearestTowerID(harvesterID)
        local nearestDist = 999
        local nearestTowerID = nil
        local nearestTowerRange = 999
        for oreTowerID, data in pairs(oreTowers) do
            local range = data.range
            local thisTowerDist = spGetUnitSeparation ( harvesterID, oreTowerID, true) -- [, bool surfaceDist ]] )
            if (thisTowerDist - range + distBuffer) <= nearestDist then  -- Eg: ttD = 600 - range = 200 => 600-200+40) => 440
                nearestTowerRange = range
                nearestTowerID = oreTowerID
            end
        end
        if nearestTowerRange == 999 then
            return nil
        end
        -- Get nearest point in deliver range of the Ore Tower
        --L = sqrt ((x2-x1)^2 + (y2-y1)^2) --that's already nearestDist
        local p = (nearestTowerRange - distBuffer) / nearestDist	--percentage (radius to discount / length of p1~p2)
        local x1, y1 = spGetUnitPosition(harvesterID)
        local x2, y2 = spGetUnitPosition(nearestTowerID)
        if x1==x2 and y1==y2 then
            return nil
        end
        local nearestDeployPos = { x = x2+p*(x1-x2), y = y2+p*(y1-y2) }
        return nearestTowerID, nearestDeployPos
    end

    local function isHarvesting(unitID)
        return doingHarvest[unitID]
    end

    local function inTowerRange(harvesterID)
        local harvesterAlly = spGetUnitAllyTeam(harvesterID)
        for oreTowerID, data in pairs(oreTowers) do
            local oreTowerAlly = data.ally --spGetUnitAllyTeam(oreTowerID)
            if (oreTowerAlly == harvesterAlly) then
                local range = data.range
                local thisTowerDist = spGetUnitSeparation ( harvesterID, oreTowerID, true) -- [, bool surfaceDist ]] )
                if thisTowerDist <= range then
                    return true
                end
            end
        end
        return false
    end

    local function DeliverResources(harvesterID, amount)
        local curStorage = spGetUnitHarvestStorage(harvesterID) or 0

        spAddTeamResource (spGetUnitTeam(harvesterID), "metal", math.min(curStorage, amount) ) --eg: curStorage = 3, amount = 5, add 3.
        spSetUnitHarvestStorage (harvesterID, math.max(curStorage - amount, 0))
        --TODO: If out of harvest storage, send idleHarvester event to ai_builder_brain
    end

    --- Delivers resource straight to the pool (it's in range of a tower)
    local function DeliverResourcesRaw(harvesterID, amount)
        spAddTeamResource (spGetUnitTeam(harvesterID), "metal", amount )
    end

    function gadget:UnitIdle(unitID, unitDefID, unitTeam)
        doingHarvest[unitID] = nil
    end

    ---can't issue attack if the builder is loaded
    ---must set states on the builder_brain (use spSetUnitRuleParams)
    ---must continuously check if an oretower is available, if is loaded

    -- attackerID => harvesterID, for legibility purposes
    function gadget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, harvesterID, harvesterDefID, attackerTeam)
        --Spring.Echo("Damage: "..(damage or "nil").." from: "..(attackerID or "nil"))
        if not IsValidUnit(harvesterID) or loadedHarvesters[harvesterID] then
            return end
        local uDef = UnitDefs[harvesterDefID]
        if not uDef or not canharvest[uDef.name] then
            return end
        local curStorage = spGetUnitHarvestStorage(harvesterID) or 0
        --Spring.Echo("cur Storage: "..curStorage.." damage: "..damage)

        -- Block further usage of the unit's harvest weapon while storage is full
        local attackerDef = UnitDefs[harvesterDefID]
        local maxStorage = attackerDef and attackerDef.harveststorage or defaultMaxStorage
        --Spring.Echo("cur Storage: "..curStorage.." max: "..maxStorage)

        doingHarvest[unitID] = true

        if curStorage < maxStorage then
            if inTowerRange(harvesterID) then
                DeliverResourcesRaw(harvesterID, damage)
            else
                spSetUnitHarvestStorage (harvesterID, math.min(maxStorage, curStorage + damage))
            end
        else
            --spSetUnitWeaponState(attackerID, 1, "range", 0)    --block weapon while it's running?
            --Spring.UnitWeaponHoldFire ( harvesterID, 1) --WeaponDefNames["armck_harvest_weapon"].id ) --TODO: Do it right. Just a sample.
            spCallCOBScript(harvesterID, "BlockWeapon", 0)

            Spring.Echo("gadget:: unit ".. harvesterID .." is loaded!!")
            local nearestTowerID = getNearestTowerID(harvesterID)
            loadedHarvesters[harvesterID] = nearestTowerID or true -- if there's no nearby tower, set it to true!
            --spSetUnitRulesParam(unitID, "loadedHarvester", 1)
            SendToUnsynced(LoadedHarvesterEvent, attackerTeam, harvesterID, nearestTowerID or true)
            --TODO: In ai_builder_brain, it'll move to be in range of closest ore tower
            --- once there it'll only return to previous harvest spot when it's totally unloaded
        end
    end

    function gadget:GameFrame(gf)
        if gf % CHECK_FREQ > 0.001 then
            return
        end

        for unitID, nearestTowerID in pairs(loadedHarvesters) do
            Spring.Echo("load harv id "..(unitID or "nil"))
            if IsValidUnit(unitID) then
                --Spring.Echo("intowerrange: "..tostring(inTowerRange(unitID)))
                if not isHarvesting(unitID) and inTowerRange(unitID) then
                    DeliverResources(unitID, deployPerTickAmount) ----TODO: Read from unitDefs (weapon damage)
                end
                local unitDefID = spGetUnitDefID(unitID)
                local uDef = UnitDefs[unitDefID]
                local maxStorage = uDef and (uDef.harvestStorage or defaultMaxStorage)
                local curStorage = spGetUnitHarvestStorage(unitID)
                if (curStorage < 10) then --< maxStorage
                    loadedHarvesters[unitID] = nil
                    spCallCOBScript(unitID, "UnblockWeapon", 0)
                    Spring.Echo("unit ".. unitID .." is no longer loaded")
                    --TODO: Check - Maybe locking range will help AI?
                    ---TODO: Cache original weapon ranges by unitDefID
                    --local weaponDefID = UnitDefs[Spring.GetUnitDefID(unitID)].weapons[1].weaponDef
                    --local origRange = WeaponDefs[weaponDefID].range
                    --spSetUnitWeaponState(unitID, 1, "range", origRange) --300) -- TODO: Remove temp fix --
                    ----Spring.Echo("Restored range to: "..origRange)
                end
            end
        end
    end

    -- *** DO NOT USE - Not yet fully implemented in the engine (105.0)
    --function gadget:UnitHarvestStorageFull(unitID)
    --    Spring.Echo("Harvest Storage is full!")
    --end
    --function gadget:UnitPreDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
    --end
else
    ----- UNSYNCED
    ---

    local function handleLoadedHarvesterEvent(cmd, harvesterTeam, unitID, value)
        if not Script.LuaUI(LoadedHarvesterEvent) then
            return end
        --- LuaUI event consumed by ai_builder_brain (to set loadedHarvesters[unitID])
        Script.LuaUI.LoadedHarvesterEvent(harvesterTeam, unitID, value)
    end

    function gadget:Initialize()
        --if not (SYNCED.OreTowers) then
        --    Spring.Echo("Ore Towers Global Table not found")
        --else
        --    Spring.Echo("Ore Towers Global Table FOUND!")
        --end
        gadgetHandler:AddSyncAction(LoadedHarvesterEvent, handleLoadedHarvesterEvent)
    end

    function gadget:Shutdown()
        gadgetHandler:RemoveSyncAction(LoadedHarvesterEvent)
    end
end