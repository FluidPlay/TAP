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

    local localDebug = false --true --|| Enables text state debug messages

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

    local defaultMaxStorage = 400 --620
    local defaultOreTowerRange = 330

    local harvesters = {} -- { unitID = unitDef.customparams.maxorestorage, ... }
    local partialLoadHarvesters = {} --{ unitID = true, ... }    -- Harvesters with ore load > 0% and < 100%
    local loadedHarvesters = {}
    local oreTowers = {}
    local harvestersInAction = {} -- Harvesters "in action"

    local distBuffer = 40 -- distance buffer, units get further into the ore tower 'umbrella range' before dropping the load
    local defaultDeliveryAmount = 20

    local oreTowerDefNames = {
        armmstor = true, cormstor = true, armuwadvms = true, coruwadvms = true,
    }
    local canharvest = {
        armck = true, corck = true, armcv = true, corcv = true, armca = true, corca = true, armcs = true, corcs = true,
        armack = true, corack = true, armacv = true, coracv = true, armaca = true, coraca = true, armacsub = true, coracsub = true,
    }

    local CMD_STOP = CMD.STOP

    local ore = { sml = UnitDefNames["oresml"].id, lrg = UnitDefNames["orelrg"].id, moho = UnitDefNames["oremoho"].id, uber = UnitDefNames["oreuber"].id }

    local function spEcho(string)
        if localDebug then --and isCom(unitID) and state ~= "deautomated"
            Spring.Echo("gadget|eco_builder:: "..string) end
    end

    function gadget:Initialize()
        _G.OreTowers = oreTowers    -- making it available for unsynced access via SYNCED table
        --startFrame = Spring.GetGameFrame()
        --gaiaTeamID = Spring.GetGaiaTeamID()
        if Spring.GetModOptions().harvest_eco == 0 then
            gadgetHandler:RemoveGadget(self)
        end
    end

    function gadget:UnitFinished(unitID, unitDefID, unitTeam)
        local unitDef = UnitDefs[unitDefID]
        if unitDef == nil then
            return end
        if oreTowerDefNames[unitDef.name] then
            spEcho("Ore Tower added: "..unitID)
            oreTowers[unitID] = { range = (unitDef.buildDistance or 330), ally = spGetUnitAllyTeam(unitID) } -- 330 is lvl1 outpost build range
            spSetUnitRulesParam(unitID, "oretowerrange", (unitDef.buildDistance or defaultOreTowerRange)) --330
        end

        local maxorestorage = tonumber(unitDef.customParams.maxorestorage)
        spEcho("finished unit harvestStorage: "..(maxorestorage or "nil")) --maxorestorage
        if maxorestorage and maxorestorage > 0 then
            harvesters[unitID] = maxorestorage
            spEcho("Harvester added: "..unitID.." storage: "..maxorestorage)
        else
            spEcho("Harvester not detected")
        end
    end

    function gadget:UnitDestroyed(unitID, unitDefID, teamID, attackerID, attackerDefID, attackerTeam)
        harvesters[unitID] = nil
        oreTowers[unitID] = nil
        loadedHarvesters[unitID] = nil

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

    -----Returns nearestTowerID (or nil if none found within 999 range) & nearestDeployPos
    --local function getNearestTowerID(harvesterID)
    --    local nearestDist = 999
    --    local nearestTowerID = nil
    --    local nearestTowerRange = 999
    --    for oreTowerID, data in pairs(oreTowers) do
    --        local range = data.range
    --        local thisTowerDist = spGetUnitSeparation ( harvesterID, oreTowerID, true) -- [, bool surfaceDist ]] )
    --        if (thisTowerDist - range + distBuffer) <= nearestDist then  -- Eg: ttD = 600 - range = 200 => 600-200+40) => 440
    --            nearestTowerRange = range
    --            nearestTowerID = oreTowerID
    --        end
    --    end
    --    if nearestTowerRange == 999 then
    --        return nil
    --    end
    --    -- Get nearest point in deliver range of the Ore Tower
    --    --L = sqrt ((x2-x1)^2 + (y2-y1)^2) --that's already nearestDist
    --    local p = (nearestTowerRange - distBuffer) / nearestDist	--percentage (radius to discount / length of p1~p2)
    --    local x1, y1 = spGetUnitPosition(harvesterID)
    --    local x2, y2 = spGetUnitPosition(nearestTowerID)
    --    if x1==x2 and y1==y2 then
    --        return nil
    --    end
    --    local nearestDeployPos = { x = x2+p*(x1-x2), y = y2+p*(y1-y2) }
    --    return nearestTowerID, nearestDeployPos
    --end

    local function isHarvesting(unitID)
        return harvestersInAction[unitID]
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

    local function DeliverResources(harvesterID)
        if not IsValidUnit(harvesterID) then
            return end
        local unitDef = UnitDefs[spGetUnitDefID(harvesterID)]
        --local weaponDef = WeaponDefNames[unitDef.name.."_harvest_weapon"]
        --local harvestWeapDefID = weaponDef.id    -- eg: armck_harvest_weapon
        local harvestWeaponDef = WeaponDefNames[unitDef.name.."_harvest_weapon"] --WeaponDefs[harvestWeapDefID]
        --Spring.Echo("Harvest weapon: "..(harvestWeaponDef.name or "nil"))

        local amount = harvestWeaponDef and harvestWeaponDef.damages[0] or defaultDeliveryAmount
        --Spring.Echo("Amount: "..(harvestWeaponDef.damages[0] or "nil"))
        local curStorage = spGetUnitHarvestStorage(harvesterID) or 0

        spAddTeamResource (spGetUnitTeam(harvesterID), "metal", math.min(curStorage, amount) ) --eg: curStorage = 3, amount = 5, add 3.
        spSetUnitHarvestStorage (harvesterID, math.max(curStorage - amount, 0))
    end

    --- Delivers resource straight to the pool (it's in range of a tower)
    local function DeliverResourcesRaw(harvesterID, amount)
        spAddTeamResource (spGetUnitTeam(harvesterID), "metal", amount )
    end

    function gadget:UnitIdle(unitID, unitDefID, unitTeam)
        harvestersInAction[unitID] = nil
    end

    ---can't issue attack if the builder is loaded
    ---must set states on the builder_brain (use spSetUnitRuleParams)
    ---must continuously check if an oretower is available, if is loaded

    -- attackerID => harvesterID, for legibility purposes
    function gadget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, harvesterID, harvesterDefID, attackerTeam)
        --Spring.Echo("Damage: "..(damage or "nil").." from: "..(attackerID or "nil"))
        if not IsValidUnit(harvesterID) or loadedHarvesters[harvesterID] then
            return end
        local harvesterDef = UnitDefs[harvesterDefID]
        if not harvesterDef or not canharvest[harvesterDef.name] then
            return end
        local curStorage = spGetUnitHarvestStorage(harvesterID) or 0
        --Spring.Echo("cur Storage: "..curStorage.." damage: "..damage)

        -- Block further usage of the unit's harvest weapon while storage is full
        local maxStorage = harvesterDef and tonumber(harvesterDef.customParams.maxorestorage) or defaultMaxStorage

        harvestersInAction[unitID] = true

        if curStorage < maxStorage then
            if inTowerRange(harvesterID) then
                DeliverResourcesRaw(harvesterID, damage)
            else
                spSetUnitHarvestStorage (harvesterID, math.min(maxStorage, curStorage + damage))
            end
        else
            --spSetUnitWeaponState(attackerID, 1, "range", 0)    --block weapon while it's running?
            --Spring.UnitWeaponHoldFire ( harvesterID, 1) --WeaponDefNames["armck_harvest_weapon"].id )
            spCallCOBScript(harvesterID, "BlockWeapon", 0)

            spEcho("unit ".. harvesterID .." is loaded!!")
            --local nearestTowerID = getNearestTowerID(harvesterID)
            loadedHarvesters[harvesterID] = true
            --spSetUnitRulesParam(unitID, "loadedHarvester", 1)
            SendToUnsynced(LoadedHarvesterEvent, attackerTeam, harvesterID)

            --@ unitai_auto_assist: move it to be in range of closest ore tower
        end
    end

    function gadget:GameFrame(gf)
        if gf % CHECK_FREQ > 0.001 then
            return
        end

        --- Verify if harvesters are partially loaded or not
        for harvesterID, maxStorage in pairs(harvesters) do
            local curStorage = spGetUnitHarvestStorage(harvesterID) or 0
            --spEcho("harv id "..(harvesterID or "nil").." curStorage: "..curStorage.." maxStorage: "..maxStorage)
            --if curStorage >= maxStorage then
            --    partialLoadHarvesters[harvesterID] = nil
            --elseif curStorage > 0 then
            --    partialLoadHarvesters[harvesterID] = true
            --end
            if inTowerRange(harvesterID) then
                DeliverResources(harvesterID)
            end
        end

        for unitID, _ in pairs(loadedHarvesters) do
            --spEcho("load harv id "..(unitID or "nil"))
            if IsValidUnit(unitID) then
                --spEcho("intowerrange: "..tostring(inTowerRange(unitID)))
                    --if inTowerRange(unitID) then --not isHarvesting(unitID) and
                    --    DeliverResources(unitID)
                    --end
                local unitDefID = spGetUnitDefID(unitID)
                local uDef = UnitDefs[unitDefID]
                local maxStorage = uDef and (tonumber(uDef.customParams.maxorestorage) or defaultMaxStorage)
                local curStorage = spGetUnitHarvestStorage(unitID)
                spEcho("harv id "..(unitID or "nil").." curStorage: "..curStorage.." maxStorage: "..maxStorage)
                if (curStorage < maxStorage) then --< maxStorage
                    loadedHarvesters[unitID] = nil
                    spCallCOBScript(unitID, "UnblockWeapon", 0)
                    spEcho("unit ".. unitID .." is no longer loaded")
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
        --- LuaUI event consumed by unitai_autoassist (to set loadedHarvesters[unitID])
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