---------------------------------------------------------------------------------------------------------------------
-- IMPORTANT: Requires ai_builder_brain.lua to work!
---------------------------------------------------------------------------------------------------------------------

function widget:GetInfo()
    return {
        name = "AI Harvester Brain",
        desc = "Handles the Harvest cycle of Builders in the ai_builder_brain's 'harvest' state",
        author = "MaDDoX",
        date = "Feb 7, 2022",
        license = "GPLv3",
        layer = 1,
        enabled = false, --true,
    }
end

--- Harvest-cycle Priorities and Logic
--- #1 :: harvest_deliver - is fully loaded, not in range of nearest ore tower => move to it
--- #2 :: harvest_waitforunload - has resources (partialLoad), in range of nearest ore tower => define return pos, stay still
--- #3 :: harvest_return - has no resources, has return pos => move to return pos
--- #4 :: harvest_attack - has no resources, can harvest, is near chunks => attack nearest chunk

VFS.Include("gamedata/tapevents.lua") --"LoadedHarvestEvent"
VFS.Include("gamedata/taptools.lua")

local localDebug = false --true --|| Enables text state debug messages

local spGetAllUnits = Spring.GetAllUnits
local spGetUnitDefID = Spring.GetUnitDefID
local spGetFeatureDefID = Spring.GetFeatureDefID
local spValidFeatureID = Spring.ValidFeatureID
local spGetUnitPosition = Spring.GetUnitPosition
local spGetUnitHealth   = Spring.GetUnitHealth
local spGetMyTeamID     = Spring.GetMyTeamID
local spGetMyAllyTeamID     = Spring.GetMyAllyTeamID
local spGetUnitAllyTeam     = Spring.GetUnitAllyTeam
local spGetFeatureResources = Spring.GetFeatureResources
local spGetFeaturePosition = Spring.GetFeaturePosition
local spGetSelectedUnits = Spring.GetSelectedUnits
local spGiveOrderToUnit = Spring.GiveOrderToUnit
local spGetUnitHarvestStorage = Spring.GetUnitHarvestStorage
local spGetTeamResources = Spring.GetTeamResources
local spGetUnitTeam    = Spring.GetUnitTeam
local spGetUnitsInSphere = Spring.GetUnitsInSphere
local spGetFeaturesInSphere = Spring.GetFeaturesInSphere
local spGetGameFrame = Spring.GetGameFrame
local spGetUnitsInCylinder = Spring.GetUnitsInCylinder
local spGetFeaturesInCylinder = Spring.GetFeaturesInCylinder
local spGetUnitNearestEnemy = Spring.GetUnitNearestEnemy
local spGetUnitSeparation = Spring.GetUnitSeparation
local spGetFeaturePosition = Spring.GetFeaturePosition
local spGetCommandQueue = Spring.GetCommandQueue -- 0 => commandQueueSize, -1 = table
local spGetFullBuildQueue = Spring.GetFullBuildQueue --use this only for factories, to ignore rally points
local spGetUnitRulesParam = Spring.GetUnitRulesParam

local glGetViewSizes = gl.GetViewSizes


local myTeamID, myAllyTeamID = -1, -1
local gaiaTeamID = Spring.GetGaiaTeamID()

local startupGracetime = 300        -- Widget won't work at all before those many frames (10s)
local updateRate = 15               -- Global update "tick rate"
local automationLatency = 60        -- Delay before automation kicks in, or the unit is set to idle

local deautomatedRecheckLatency = 30 -- Delay until a de-automated unit checks for automation again
local reclaimRadius = 20            -- Reclaim commands issued by code apparently only work with a radius (area-reclaim)

local maxOreTowerScanRange = 900
local defaultOreTowerRange = 330
local harvestLeashMult = 6          -- chunk search range is the harvest range* multiplied by this  (*attack range of weapon eg. "armck_harvest_weapon")

local automatableUnits = {} -- All units which can be automated // { [unitID] = true|false, ... }
local unitsToAutomate = {}  -- These will be automated, but aren't there yet (on latency); can be interrupted by direct orders
local automatedUnits = {}   -- All units currently automated    // { [unitID] = frameToRecheckAutomation, ... }
local deautomatedUnits = {} -- Post deautomation (direct order) // { [unitID] = frameToTryReautomation, ... }
        -- { [unitID] = frameToAutomate (eg: spGetGameFrame() + recheckUpdateRate), ... }

local vsx, vsy = gl.GetViewSizes()
local widgetScale = (0.50 + (vsx*vsy / 5000000))

--- Attack: actually harvesting; Deliver: going to the nearest ore tower; Wait For Unload: in range of an ore tower, stopped and unloading;
--- Resume: returning to the previous harvest position, after delivery
---local automatedState = {}   -- This is the automated state. It's always there for automatableUnits, after the initial latency period
local harvestState = {}     -- Substate for harvest state. // "none", "attack", "deliver", "waitforunload", "resume"

---Harvest-system related
local oreTowerDefNames = { armmstor = true, cormstor = true, armuwadvms = true, coruwadvms = true, }
local oreTowers = {}        -- { unitID = oreTowerReturnRange, ... }

local harvesters = {} -- { unitID = uDef.customparams.maxorestorage, parentOreTowerID, returnPos = { x = rpx, y = rpy, z = rpz } } -- <== uDef.harvestStorage is not working (105)

--- Harvest-cycle state controllers
local workingHarvesters = {}    -- { unitID = true, ... }
local partialLoadHarvesters = {}-- { unitID = true, ... }    -- Harvesters with ore load > 0% and < 100%
local loadedHarvesters = {}     -- { unitID = true, ... }

local orphanHarvesters = {}     -- { unitID = true, ... }    -- has no parentOretower assigned
local returningHarvesters = {}  -- { unitID = true, ... }    -- fully loaded, returning to returnPos
local unloadingHarvesters = {}  -- { unitID = true, ... }    -- at returnPos, waiting for unload to finish

local CMD_FIGHT = CMD.FIGHT
local CMD_PATROL = CMD.PATROL
local CMD_REPAIR = CMD.REPAIR
local CMD_GUARD = CMD.GUARD
local CMD_RESURRECT = CMD.RESURRECT --125
local CMD_REMOVE = CMD.REMOVE
local CMD_RECLAIM = CMD.RECLAIM
local CMD_ATTACK = CMD.ATTACK
local CMD_UNIT_SET_TARGET = 34923
local CMD_MOVE = CMD.MOVE
local CMD_STOP = CMD.STOP
local CMD_INSERT = CMD.INSERT
local CMD_OPT_RIGHT = CMD.OPT_RIGHT

local CMD_OPT_INTERNAL = CMD.OPT_INTERNAL

----- Type Tables

local canharvest = {
    armck = true, corck = true, armcv = true, corcv = true, armca = true, corca = true, armcs = true, corcs = true,
    armack = true, corack = true, armacv = true, coracv = true, armaca = true, coraca = true, armacsub = true, coracsub = true,
}

-----

local function spEcho(string)
    if localDebug then --and isCom(unitID) and state ~= "deautomated"
        Spring.Echo(string) end
end

local function removeCommands(unitID)
    spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_GUARD }, { "alt"})
    spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_PATROL }, { "alt"})
    spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_ATTACK }, { "" })
    spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_UNIT_SET_TARGET }, { "alt"})
    spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_FIGHT }, { "alt"})
    spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_REPAIR }, { "alt"})
end

local function setHarvestState(unitID, state, caller) -- none, attack, waitforunload, deliver, resume
    harvestState[unitID] = state
    spEcho("New harvest State: ".. state .." for: "..unitID.." set by function: "..caller)
end

local function DeharvestUnit(unitID)
    removeCommands(unitID)  -- removes Guard, Patrol, Fight and Repair commands

    spEcho("Deharvesting Unit: "..unitID)
    setHarvestState(unitID, "none", "DeautomateUnit")
end

local function setLoadedHarvester(harvesterTeam, unitID, value)
    --Spring.Echo("Harvester team: "..(harvesterTeam or "nil").." my team: "..myTeamID.." unitID: "..unitID.." value: "..tostring(value))
    if (harvesterTeam ~= myTeamID) then
        return end
    local rpx, rpy, rpz = spGetUnitPosition(unitID) -- "previous harvest"
    loadedHarvesters[unitID] = { nearestOreTowerID = nil, returnPos = { x = rpx, y = rpy, z = rpz } }
end

local function hasBuildQueue(unitID)
    local buildqueue = spGetFullBuildQueue(unitID) -- => nil | buildOrders = { [1] = { [number unitDefID] = number count }, ... } }
    --spEcho("build queue size: "..(buildqueue and #buildqueue or "N/A"))
    if buildqueue then
        return #buildqueue > 0
    else
        return false
    end
end

--- If you left the game this widget has no raison d'etré
function widget:PlayerChanged()
    if Spring.GetSpectatingState() and Spring.GetGameFrame() > 0 then
        widgetHandler:RemoveWidget(self)
    end
end

---- Disable widget if I'm spec
function widget:Initialize()
    if not WG.automatedStates then
        Spring.Echo("<AI Builder Brain> This widget requires the 'AI Builder Brain' widget to run.")
        widgetHandler:RemoveWidget(self)
    end
    if Spring.IsReplay() or Spring.GetGameFrame() > 0 then
        widget:PlayerChanged() end
    local _, _, spec = Spring.GetPlayerInfo(Spring.GetMyPlayerID(), false)
    if spec then
        widgetHandler:RemoveWidget()
        return false
    end
    local automatedState = WG.automatedStates -- Set by ai_builder_brain
    WG.harvestState = harvestState            -- This will allow the harvest state to be read and set by other widgets

    -- We do this to re-initialize (after /luaui reload) properly
    myTeamID = spGetMyTeamID()
    myAllyTeamID = spGetMyAllyTeamID
    local allUnits = spGetAllUnits()
    for i = 1, #allUnits do
        local unitID    = allUnits[i]
        local unitDefID = spGetUnitDefID(unitID)
        local unitTeam  = spGetUnitTeam(unitID)
        widget:UnitCreated(unitID, unitDefID) --, unitTeam)
        widget:UnitFinished(unitID, unitDefID, unitTeam)
    end
end

--function widget:UnitCreated(unitID, unitDefID, teamID, builderID)
    --local unitDef = UnitDefs[unitDefID]
    --if canrepair[unitDef.name] or canresurrect[unitDef.name] then
    --    spEcho("Registering unit "..unitID.." as automatable: "..unitDef.name)--and isCom(unitID)
    --    automatableUnits[unitID] = true
    --end
--end

local function getOreTowerRange(oreTowerID, unitDef)
    if not oreTowerID and not unitDef then
        return defaultOreTowerRange end
    if not unitDef then
        local unitDefID = spGetUnitDefID(oreTowerID)
        unitDef = UnitDefs[unitDefID]
    end
    if not unitDef.buildDistance then
        return defaultOreTowerRange
    end
    return unitDef.buildDistance
end

function widget:UnitFinished(unitID, unitDefID, unitTeam)
    local unitDef = UnitDefs[unitDefID]
    if oreTowerDefNames[unitDef.name] then
        oreTowers[unitID] = getOreTowerRange(nil, unitDef) end
    local maxorestorage = tonumber(unitDef.customParams.maxorestorage)
    if maxorestorage and maxorestorage > 0 then
        harvesters[unitID] = { maxorestorage = maxorestorage, parentOreTowerID = nil, returnPos = {} }
        spEcho("ai_harvester_brain: added harvester: "..unitID.." storage: "..maxorestorage)
        orphanHarvesters[unitID] = true -- newborns are orphan. Usually not for long.
    end
end

function widget:UnitDestroyed(unitID)
    automatableUnits[unitID] = nil
    unitsToAutomate[unitID] = nil
    automatedUnits[unitID] = nil
    deautomatedUnits[unitID] = nil

    oreTowers[unitID] = nil
    partialLoadHarvesters[unitID] = nil
    loadedHarvesters[unitID] = nil

    orphanHarvesters[unitID] = nil
    unloadingHarvesters[unitID] = nil
    returningHarvesters[unitID] = nil
    harvesters[unitID] = nil
end

--local function inTowerRange(harvesterID)
--    for oreTowerID, range in pairs(oreTowers) do
--        local thisTowerDist = spGetUnitSeparation ( harvesterID, oreTowerID, true) -- [, bool surfaceDist ]] )
--        if thisTowerDist <= range then
--            return true
--        end
--    end
--end

--- Decides and issues orders on what to do around the unit, in this order (1 == higher):
--- 1. If is not harvesting and there's a chunk nearby, harvest nearest chunk
--- 2. If is harvesting and a) not fully loaded, just destroyed chunk => go for nearest chunk;
---                         b) fully loaded => go for nearest ore tower.

local automatedFunctions = {
    harvest_deliver = { condition = function(ud) -- Only for fully loaded harvesters (including Comms this time)
        return harvestState[ud.unitID] ~= "deliver"
                and (loadedHarvesters[ud.unitID] or partialLoadHarvesters[ud.unitID])
                and ud.nearestOreTowerID -- and separation is > oreTower build/deliver distance?
                and ud.farFromOreTower
    end,
                        action = function(ud) --unitData
                            spEcho("**2** Delivery check")
                            --Spring.Echo("1; nearestOreTowerID: "..(ud.nearestOreTowerID or "nil"))
                            if ud.nearestOreTowerID and automatedState[ud.unitID] ~= "harvest" then
                                local x,y,z = spGetUnitPosition(ud.nearestOreTowerID)
                                spGiveOrderToUnit(ud.unitID, CMD_REMOVE, {CMD_MOVE}, {"alt"})
                                spGiveOrderToUnit(ud.unitID, CMD_MOVE, {x, y, z }, { "" })
                                harvesters[ud.unitID].returnPos = { x = x, y = y, z = z }
                                return "harvest"
                            end
                            return nil
                        end
    },
    harvest_await = { condition = function(ud) -- Only for fully loaded harvesters (including Comms this time)
        return harvestState[ud.unitID] ~= "deliver"
                and partialLoadHarvesters[ud.unitID]
                and ud.nearestOreTowerID and not ud.farFromOreTower --TODO: Check
    end,
                      action = function(ud) --unitData
                          spEcho("**3** Await check")
                          --Spring.Echo("1; nearestOreTowerID: "..(ud.nearestOreTowerID or "nil"))
                          spGiveOrderToUnit(ud.unitID, CMD_STOP, {} , CMD_OPT_RIGHT )
                          return "harvest"
                          --return nil
                      end
    },
    harvest_return = { condition = function(ud) -- Commanders shouldn't prioritize harvesting; harvester can't be fully loaded
        --spEcho(" ud.returnPos.x: "..(ud.returnPos and ud.returnPos.x or "nil"))
        return harvestState[ud.unitID] == "await" -- <= it *should* be on await subState
                and spGetUnitHarvestStorage(ud.unitID) <= 0 and ud.returnPos
    end,
                       action = function(ud) --unitData
                           spEcho("**4** Return check")
                           if ud.returnPos then
                               local rp = ud.returnPos
                               spGiveOrderToUnit(ud.unitID, CMD_MOVE, { rp.x, rp.y, rp.z }, { "" })
                               return "harvest"
                           end
                           return nil
                       end
    },
    harvest_attack = { condition = function(ud) -- Commanders shouldn't prioritize harvesting; harvester can't be fully loaded
        return harvestState[ud.unitID] ~= "deliver"
                and harvestState[ud.unitID] ~= "await"
                and harvestState[ud.unitID] ~= "return"
                and harvestState[ud.unitID] ~= "attack"
                and canharvest[ud.unitDef.name]
                and not loadedHarvesters[ud.unitID] and ud.nearestChunkID
    end,
                       action = function(ud) --unitData
                           spEcho("**5** Harvest attack - nearest chunk: "..(ud.nearestChunkID or "nil"))
                           if ud.nearestChunkID then
                               --local x, y, z = spGetUnitPosition(ud.nearestChunkID)
                               spGiveOrderToUnit(ud.unitID, CMD_ATTACK, ud.nearestChunkID, { "alt" }) --"alt" favors reclaiming --Spring.Echo("Farking")
                               return "harvest"
                           end
                           return nil
                       end
    },
}

local function automateCheck(unitID, unitDef, caller)
    local x, y, z = spGetUnitPosition(unitID)
    local pos = { x = x, y = y, z = z }

    local radius = unitDef.buildDistance * 1.8
    if unitDef.canFly then               -- Air units need that extra oomph
        radius = radius * 1.3
    end

    local harvestWeapon = WeaponDefs[UnitDefs[unitDef.id].name.."_harvest_weapon"] -- eg: armck_harvest_weapon

    local harvestrange = harvestWeapon and (harvestWeapon.range * harvestLeashMult) or (radius * harvestLeashMult) -- eg: armck_harvest_weapon

    local nearestUID = NearestItemAround(unitID, pos, unitDef, radius, nil,
                                 function(x)
                                            --local isAllied = spGetUnitAllyTeam(unitID) == myAllyTeamID
                                            local health,maxHealth = spGetUnitHealth(x)
                                            return (health < (maxHealth * 0.99)) end)
    local nearestRepairableID = NearestItemAround(unitID, pos, unitDef, radius, nil,
                                    function(x)
                                                local health,maxHealth,_,_,done = spGetUnitHealth(x)
                                                return (done and health < (maxHealth * 0.99)) end )
    local nearestFeatureID = NearestItemAround(unitID, pos, unitDef, radius, nil, nil, true)
    local nearestChunkID = NearestItemAround(unitID, pos, unitDef, harvestrange,
                                            function(x) return (x.customParams and x.customParams.isorechunk) end, --unitDef check
                                            nil, false, gaiaTeamID)
    local nearestOreTowerID = NearestItemAround(unitID, pos, unitDef, maxOreTowerScanRange, nil,
                                        function(x) return (oreTowers and oreTowers[x] or nil) end) --,
                                        --nil, false, nil, spGetUnitAllyTeam(unitID))
    local nearestFactoryID = NearestItemAround(unitID, pos, unitDef, radius,
                                                    function(x) return x.isFactory end,     --We're only interested in factories currently producing
                                                    function(x) return hasBuildQueue(x) end)
    local nearestMetalID = NearestItemAround(unitID, pos, unitDef, radius, nil,
                                                    function(x)
                                                        local remainingMetal,_,remainingEnergy = spGetFeatureResources(x) --feature
                                                        return remainingMetal and remainingEnergy and remainingMetal > remainingEnergy end,
                                             true)
    local nearestEnergyID = NearestItemAround(unitID, pos, unitDef, radius, nil, nil,true)

    local ud = { unitID = unitID, unitDef = unitDef, pos = pos, radius = radius, orderIssued = nil,
                 nearestUID = nearestUID, nearestRepairableID = nearestRepairableID, nearestFactoryID = nearestFactoryID,
                 nearestFeatureID = nearestFeatureID, nearestChunkID = nearestChunkID, nearestOreTowerID=nearestOreTowerID, --nearestDeliveryPos = nearestDeliveryPos,
                 nearestEnergyID = nearestEnergyID, nearestMetalID = nearestMetalID,
               }

    ---=== 0. HARVEST Section
    --- 0.2. harvest : deliver => If it's a loaded harvester and is near an ore tower, go to it
    if automatedFunctions["delivering"].condition(ud) then
        ud.orderIssued = automatedFunctions["delivering"].action(ud)
        harvestState[unitID] = "delivering"
        local rpx, rpy, rpz = spGetUnitPosition(unitID) -- "previous harvest"
        if (nearestOreTowerID) then
            loadedHarvesters[unitID] = { nearestOreTowerID = nearestOreTowerID, returnPos = { x = rpx, y = rpy, z = rpz } }
        else
            loadedHarvesters[unitID] = { nearestOreTowerID = nil, returnPos = { x = rpx, y = rpy, z = rpz } }
        end
    end
    --- 0.1. harvest : attack => If it's a non-loaded harvester and is near an ore chunk, attack it;
    if automatedFunctions["attacking"].condition(ud) then
        ud.orderIssued = automatedFunctions["attack"].action(ud)
        harvestState[unitID] = "attacking"
    end
    ----- 0.2. harvest : partialdeliver => If it's a partially-loaded harvester and is near an ore tower (but not in range), go for it;
    --if automatedFunctions["harvest_partialdeliver"].condition(ud) then
    --    ud.orderIssued = automatedFunctions["harvest_partialdeliver"].action(ud)
    --    automatedState[unitID] = "harvest"
    --    harvestState[unitID] = "partialdeliver"
    --    local rpx, rpy, rpz = spGetUnitPosition(unitID) -- "previous harvest"
    --    if (nearestOreTowerID) then
    --        --local otx, oty, otz = spGetUnitPosition(nearestOreTowerID)  -- "ore tower"
    --        loadedHarvesters[unitID] = { nearestOreTowerID = nearestOreTowerID, returnPos = { x = rpx, y = rpy, z = rpz } }
    --    else
    --        loadedHarvesters[unitID] = { nearestOreTowerID = nil, returnPos = { x = rpx, y = rpy, z = rpz } }
    --    end
    --    --else
    --    --    Spring.Echo("Deliver condition not met ... State: "..automatedState[unitID].." loadedHarvester: "..(tostring(loadedHarvesters[unitID]) or "nil"))
    --end

    --- If any automation attempt above was successful, set new harvest state
    if ud.orderIssued then
        spEcho ("New order Issued")
        unitsToAutomate[unitID] = nil
        setHarvestState(unitID, ud.orderIssued, caller.."> automateCheck")
    end
    return ud.orderIssued
end

local function setHarvestState(unitID, state, caller)
    if state == "deautomated" then --or state == "idle" then
        automatedUnits[unitID] = nil
        --- It'll only get out of deautomated if it's idle, that's only the delay to recheck idle
        deautomatedUnits[unitID] = spGetGameFrame() + deautomatedRecheckLatency
        spEcho("To automate in: "..spGetGameFrame() + deautomatedRecheckLatency)
    else
        deautomatedUnits[unitID] = nil
        automatedUnits[unitID] = spGetGameFrame() + automationLatency
    end
    harvestState[unitID] = state
    spEcho("New automateState: "..state.." for: "..unitID.." set by function: "..caller)
end

function widget:CommandNotify(cmdID, params, options)
     spEcho("CommandID registered: "..(cmdID or "nil"))
    ---TODO: If guarding, interrupt what's doing, otherwise don't
    -- User commands are tracked here, check what unit(s) is/are selected and remove it from automatedUnits
    local selUnits = spGetSelectedUnits()  --() -> { [1] = unitID, ... }
    for _, unitID in ipairs(selUnits) do
        if workingHarvesters[unitID] and (cmdID == CMD_ATTACK or cmdID == CMD_UNIT_SET_TARGET) then
            spEcho("CMD_ATTACK, params #: "..#params)
            if #params == 1 then
                setHarvestState(unitID, "attack", "CommandNotify") -- none, attack, waitforunload, deliver, resume
            end
        end
    end
end

--local function nearestOreTowerID(unitID)
--    local unitDef = UnitDefs[spGetUnitDefID(unitID)]
--    local x, y, z = spGetUnitPosition(unitID)
--    local pos = { x = x, y = y, z = z }
--    local nearestOreTowerID = NearestItemAround(unitID, pos, unitDef, maxOreTowerScanRange, nil,
--            function(x) return (oreTowers and oreTowers[x] or nil) end)
--    --Spring.Echo("Nearest Ore Tower: "..(nearestOreTowerID or "nil").."; loaded: "..tostring(loadedHarvesters[unitID]))
--    return nearestOreTowerID
--end

--- Frame-based Update
function widget:GameFrame(f)
    if f < startupGracetime or f % updateRate > 0.001 then
        return
    end

    --- Check if it's time to actually try to automate an unit (after idle or creation)
    for unitID, automateFrame in pairs(unitsToAutomate) do
        if IsValidUnit(unitID) and f >= automateFrame then
            local unitDef = UnitDefs[spGetUnitDefID(unitID)]
            --- PS: we only un-set unitsToAutomate[unitID] down the pipe, if automation is successful
            local orderIssued = automateCheck(unitID, unitDef, "unitsToAutomate")
            if not orderIssued and not harvestState[unitID] and harvestState[unitID]~="deautomated" then
                --spEcho("1.5")
                setHarvestState(unitID, "none", "GameFrame: unitsToAutomate")
            end
        end
    end    

    --- Check/Update: if harvesters are partially loaded or not
    for harvesterID, data in pairs(harvesters) do
        local maxStorage = data.maxorestorage
        local curStorage = spGetUnitHarvestStorage(harvesterID) or 0
        if curStorage >= maxStorage or curStorage == 0 then
            partialLoadHarvesters[harvesterID] = nil
        elseif curStorage > 0 then
            partialLoadHarvesters[harvesterID] = true
        end
    end

    --- TODO: Orphans processing
    --- load < maxload & has no parentOretower
    --- => Find nearest ore tower and set parentOretower, new returnPos to it
    --- => Attack nearest ore Chunk


    --- Set "harvest : unloading" state on loaded harvesters which have reached their destination
    for unitID in pairs(loadedHarvesters) do
        local data = harvesters[unitID]
        local nearestOreTowerID = data.nearestOreTowerID
        local oreTowerRange = getOreTowerRange(nearestOreTowerID)

        if IsValidUnit(unitID) and IsValidUnit(nearestOreTowerID) and spGetUnitSeparation(unitID, nearestOreTowerID, false) < (oreTowerRange - 20) then
            loadedHarvesters[unitID] = nil
            spGiveOrderToUnit(unitID, CMD_STOP, {} , CMD_OPT_RIGHT )
            returningHarvesters[unitID] = true
            setHarvestState(unitID, "unloading", "gameFrame: loadedHarvesters loop") -- none, attack, await, deliver, return
        end
    end

    --- Set "harvest : returning" on just-unloaded harvesters to return to their previous harvest point
    for unitID in pairs(unloadingHarvesters) do
        local data = harvesters[unitID]
        if spGetUnitHarvestStorage(unitID) <= 0 then                            --If harvestLoad == 0, set it to idle again
            spGiveOrderToUnit(unitID, CMD_REMOVE, {CMD_MOVE}, {"alt"})
            local rp = data.returnPos
            --Spring.Echo("ai_builder_brain: trying return")
            spGiveOrderToUnit(unitID, CMD_MOVE, { rp.x, rp.y, rp.z }, { "" })
            setHarvestState(unitID, "returning", "gameFrame: unloadingHarvesters loop") -- none, attack, await, deliver, return
            unloadingHarvesters[unitID] = true
            returningHarvesters[unitID] = nil
        else    -- if it still has a load but the destination ore tower is destroyed, or it's too far from it (was pushed), deautomate it
            local oreTowerRange = oreTowers[data.parentOreTowerID]
            local isFarFromTower = spGetUnitSeparation(unitID, data.nearestOreTowerID, false) > (oreTowerRange or defaultOreTowerRange) - 5
            if not IsValidUnit(data.parentOreTowerID) or isFarFromTower then
                DeharvestUnit(unitID)
                returningHarvesters[unitID] = nil
            end
        end
    end

end

---- Initialize the unit when received (shared)
function widget:UnitGiven(unitID, unitDefID, unitTeam)
    widget:UnitFinished(unitID, unitDefID, unitTeam)
end

function widget:UnitTaken(unitID, unitDefID, oldTeamID, teamID)
    widget:UnitDestroyed(unitID, unitDefID, oldTeamID)
end

function widget:ViewResize(n_vsx,n_vsy)
    vsx, vsy = glGetViewSizes()
    widgetScale = (0.50 + (vsx*vsy / 5000000))
end