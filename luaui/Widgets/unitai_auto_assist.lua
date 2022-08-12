---------------------------------------------------------------------------------------------------------------------
-- Comments: Sets all idle units that are not selected to fight. That has as effect to reclaim if there is low metal,
--	repair nearby units and assist in building if they have the possibility.
--	New: If you shift+drag a build order it will interrupt the current assist (from auto assist)
---------------------------------------------------------------------------------------------------------------------

function widget:GetInfo()
    return {
        name = "UnitAI Auto Assist",
        desc = "Makes idle construction units and structures reclaim, repair nearby units and assist building",
        author = "MaDDoX, based on Johan Hanssen Seferidis' unit_auto_reclaim_heal_assist",
        date = "Oct 14, 2020",
        license = "GPLv3",
        layer = 0,
        enabled = true,
        handler = false,
    }
end

VFS.Include("gamedata/tapevents.lua") --"LoadedHarvestEvent"
VFS.Include("gamedata/taptools.lua")
VFS.Include("gamedata/unitai_functions.lua")

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
local spGetUnitCommands = Spring.GetUnitCommands
local spGetFullBuildQueue = Spring.GetFullBuildQueue --use this only for factories, to ignore rally points
local spGetUnitRulesParam = Spring.GetUnitRulesParam
local spSendLuaUIMsg = Spring.SendLuaUIMsg

local glGetViewSizes = gl.GetViewSizes
local glPushMatrix	= gl.PushMatrix
local glPopMatrix	= gl.PopMatrix
local glColor		= gl.Color
local glText		= gl.Text
local glBillboard	= gl.Billboard
local glDepthTest        		= gl.DepthTest
local glAlphaTest        		= gl.AlphaTest
local glColor            		= gl.Color
local glTranslate        		= gl.Translate
local glBillboard        		= gl.Billboard
local glDrawFuncAtUnit   		= gl.DrawFuncAtUnit
local GL_GREATER     	 		= GL.GREATER
local GL_SRC_ALPHA				= GL.SRC_ALPHA
local GL_ONE_MINUS_SRC_ALPHA	= GL.ONE_MINUS_SRC_ALPHA
local glBlending          		= gl.Blending
local glScale          			= gl.Scale

local myTeamID, myAllyTeamID = -1, -1
local gaiaTeamID = Spring.GetGaiaTeamID()

local startupGracetime = 60        -- Widget won't work at all before those many frames (1s)
local updateRate = 15               -- Global update "tick rate"
local automationLatency = 60        -- Delay before automation kicks in, or the unit is set to idle
--local repurposeLatency = 160        -- Delay before checking if an automated unit should be doing something else
local deautomatedRecheckLatency = 30 -- Delay until a de-automated unit checks for automation again
local reclaimRadius = 20            -- Reclaim commands issued by code apparently only work with a radius (area-reclaim)
local maxOreTowerScanRange = 900
local defaultOreTowerRange = 330
local harvestLeashMult = 2.0          -- chunk search range is the harvest range* multiplied by this  (*attack range of weapon eg. "armck_harvest_weapon")
local recheckLatency = 30             -- Delay until a de-automated unit checks for automation again


-- TODO: Commanders guarding factories, let's use it to stop guarding when we're out of resources
local automatableUnits = {} -- All units which can be automated // { [unitID] = targetID|true|false, ... }
                            -- targetID might be a chunk being harvested, a feature being reclaimed or ressurected, or an enemy unity being reclaimed
local unitsToAutomate = {}  -- These will be automated, but aren't there yet (on latency); can be interrupted by direct orders
local automatedUnits = {}   -- All units currently automated    // { [unitID] = frameToRecheckAutomation, ... }
local deautomatedUnits = {} -- Post deautomation (direct order) // { [unitID] = frameToTryReautomation, ... }
local executingCmd = {}     -- Last command being executed (eg.: reclaim) { [unitID] = cmdID, ... }
-- { [unitID] = frameToAutomate (eg: spGetGameFrame() + recheckUpdateRate), ... }

local automatedState = {}   -- This is the automated state. It's always there for automatableUnits, after the initial latency period

--local orderRemovalDelay = 10    -- 10 frames of delay before removing commands, to prevent the engine from removing just given orders
--local internalCommandUIDs = {}
--local autoassistEnableDelay = 60

local vsx, vsy = gl.GetViewSizes()
local widgetScale = (0.50 + (vsx*vsy / 5000000))

---Harvest-system related
local oreTowerDefNames = { armmstor = true, cormstor = true, armuwadvms = true, coruwadvms = true, }

-- == uDef.harvestStorage is not working (105)
local harvesters = {} -- { unitID = { maxorestorage = uDef.customparams.maxorestorage, parentOreTowerID,
                      --    returnPos = { x = rpx, y = rpy, z = rpz } }
local oreTowers = {}  -- { unitID = oreTowerReturnRange, ... }

local enoughResourcesThreshold = 0.1 -- for 0.1, 'enough' is more than 10% global storage for that resource
---
-- We use this to identify units that can't be build-assisted by basic builders
local WIPmobileUnits = {}     -- { unitID = true, ... }

--local mapsizehalfwidth = Game.mapSizeX/2
--local mapsizehalfheight = Game.mapSizeZ/2

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
local canreclaim = {
    armcom = true, armcom1 = true, armcom2 = true, armcom3 = true, armcom4 = true,
    corcom = true, corcom1 = true, corcom2 = true, corcom3 = true, corcom4 = true,
    armfark = true, cormuskrat = true, armconsul = true, corfast = true,
    armck = true, corck = true, armcv = true, corcv = true, armca = true, corca = true, armcs = true, corcs = true,
    armack = true, corack = true, armacv = true, coracv = true, armaca = true, coraca = true, armacsub = true, coracsub = true,
    armoutpost = true, armoutpost2 = true, armoutpost3 = true, armoutpost4 = true,
    coroutpost = true, coroutpost2 = true, coroutpost3 = true, coroutpost4 = true,
}

local canrepair = {
    armcom = true, armcom1 = true, armcom2 = true, armcom3 = true, armcom4 = true,
    corcom = true, corcom1 = true, corcom2 = true, corcom3 = true, corcom4 = true,
    armfark = true, cormuskrat = true, armconsul = true, corfast = true,
    armck = true, corck = true, armcv = true, corcv = true, armca = true, corca = true, armcs = true, corcs = true,
    armack = true, corack = true, armacv = true, coracv = true, armaca = true, coraca = true, armacsub = true, coracsub = true,
    armoutpost = true, armoutpost2 = true, armoutpost3 = true, armoutpost4 = true,
    coroutpost = true, coroutpost2 = true, coroutpost3 = true, coroutpost4 = true,
}

local canassist = {
    armcom = true, armcom1 = true, armcom2 = true, armcom3 = true, armcom4 = true,
    corcom = true, corcom1 = true, corcom2 = true, corcom3 = true, corcom4 = true,
    armfark = true, cormuskrat = true, armconsul = true, corfast = true,
    armack = true, corack = true, armacv = true, coracv = true, armaca = true, coraca = true, armacsub = true, coracsub = true,
    armoutpost = true, armoutpost2 = true, armoutpost3 = true, armoutpost4 = true,
    coroutpost = true, coroutpost2 = true, coroutpost3 = true, coroutpost4 = true,
}

local canharvest = {
    armck = true, corck = true, armcv = true, corcv = true, armca = true, corca = true, armcs = true, corcs = true,
    armack = true, corack = true, armacv = true, coracv = true, armaca = true, coraca = true, armacsub = true, coracsub = true,
}

local canresurrect = {
    armrectr = true, corvrad = true, cornecro = true,
}

-----

local function spEcho(string)
    if localDebug then --and isCom(unitID) and state ~= "deautomated"
        Spring.Echo(string) end
end

local function isCom(unitID,unitDefID)
    if unitID and not unitDefID then
        unitDefID = spGetUnitDefID(unitID)
    end
    return UnitDefs[unitDefID] and UnitDefs[unitDefID].customParams and UnitDefs[unitDefID].customParams.iscommander ~= nil
end

local function unitIsBeingBuilt(unitID)
    return select(5, spGetUnitHealth(unitID)) < 1
end

local function removeCommands(unitID)
    Spring.Echo("unitai_autoassist: removing cmds")
    spGiveOrderToUnit(unitID, CMD_REMOVE, {CMD_PATROL, CMD_GUARD, CMD_ATTACK, CMD_UNIT_SET_TARGET, CMD_RECLAIM, CMD_FIGHT, CMD_REPAIR}, {"alt"})
end

local function DeautomateUnit(unitID, caller)
    ---TODO: Below should only be called if a build order was issued
    if caller == "CommandNotifyBuild" then
        removeCommands(unitID)  -- removes Guard, Patrol, Fight and Repair commands
    end
    automatedUnits[unitID] = nil
    --- It'll only get out of deautomated if it's idle, that's only the delay to recheck idle
    deautomatedUnits[unitID] = spGetGameFrame() + deautomatedRecheckLatency
    spEcho("Autoassist: Deautomating Unit: "..unitID..", try re-automation in: "..spGetGameFrame() + deautomatedRecheckLatency)
    spSendLuaUIMsg("unitDeautomated_"..unitID, "allies") --(message, mode)
    end

function setAutomateState(unitID, state, caller)
    if state == "deautomated" then
        DeautomateUnit(unitID, caller)
    else
        deautomatedUnits[unitID] = nil
        automatedUnits[unitID] = spGetGameFrame() + automationLatency
    end
    automatedState[unitID] = state
    spEcho("New automateState: "..state.." for: "..unitID.." set by function: "..caller)
end

--function widget.UnitCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOpts, cmdTag)
--    executingCmd[unitID] = cmdID
--    Spring.Echo("Started executing: "..cmdID)
--end
--
--function widget.UnitCmdDone(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOpts, cmdTag)
--    --if executingCmd[unitID] == cmdID then
--        Spring.Echo("Finished executing: "..cmdID)
--        executingCmd[unitID] = nil
--    --end
--end

local function hasCommandQueue(unitID)
    --local commandQueue = spGetCommandQueue(unitID, 0)
    local unitCommands = spGetUnitCommands(unitID, 20)

    --spEcho("command queue size: "..(commandQueue or "N/A"))
    --Spring.Echo("has command queue: "..((unitCommands and #unitCommands > 0) and "YES" or "NO"))
    if executingCmd[unitID] then
        return false
    end
    if unitCommands then
        return #unitCommands > 0
    end
    return false
end

----- We use this to make sure patrol works, issuing two nearby patrol points
--local function patrolOffset (x, y, z)
--    local ofs = 50
--    x = (x > mapsizehalfwidth ) and x-ofs or x+ofs   -- x ? a : b, in lua notation
--    z = (z > mapsizehalfheight) and z-ofs or z+ofs
--
--    return { x = x, y = y, z = z }
--end

--local function sqrDistance (pos1, pos2)
--    if not istable(pos1) or not istable(pos2) or not pos1.x or not pos1.z or not pos2.x or not pos2.z then
--        return 999999   -- keeping this huge so it won't affect valid nearest-distance calculations
--    end
--    return (pos2.x - pos1.x)^2 + (pos2.z - pos1.z)^2
--end

local function hasBuildQueue(unitID)
    local buildqueue = spGetFullBuildQueue(unitID) -- => nil | buildOrders = { [1] = { [number unitDefID] = number count }, ... } }
    --spEcho("build queue size: "..(buildqueue and #buildqueue or "N/A"))
    if buildqueue then
        return #buildqueue > 0
    else
        return false
    end
end

---- Disable widget if I'm spec
function widget:Initialize()

    --local harvestWeapDefID = WeaponDefNames["armck_harvest_weapon"].id --unitDef.name..
    --Spring.Echo("Harv weap def ID: "..harvestWeapDefID)
    --for id,weaponDef in pairs(WeaponDefs) do
    --    Spring.Echo("weaponDefID: "..id)
    --    if id == harvestWeapDefID then
    --        --DebugTable(weaponDef.damages)
    --        Spring.Echo("Default dmg: "..tostring(weaponDef.damages[0]))
    --        --for name,param in ipairs(weaponDef.damages) do
    --        --    Spring.Echo(name.." | "..tostring(param))
    --        --end
    --        Spring.Echo("\n\n====")
    --    end
    --end


    WG.automatedStates = automatedState     -- This will allow the state to be read and set by other widgets
    WG.harvesters = harvesters              --- Read by unitai_auto_harvest.lua
    WG.setAutomateState = setAutomateState

    --WG.SetAutomateState = setAutomateState --TODO: Set automatedFunctions here
    ---
    if Spring.IsReplay() or Spring.GetGameFrame() > 0 then
        widget:PlayerChanged()
    end
    local _, _, spec = Spring.GetPlayerInfo(Spring.GetMyPlayerID(), false)
    if spec then
        widgetHandler:RemoveWidget()
        return false
    end
    -- We do this to re-initialize (after /luaui reload) properly
    myTeamID = spGetMyTeamID()
    myAllyTeamID = spGetMyAllyTeamID
    local allUnits = spGetAllUnits()
    for i = 1, #allUnits do
        local unitID    = allUnits[i]
        local unitDefID = spGetUnitDefID(unitID)

        local unitTeam  = spGetUnitTeam(unitID)
        widget:UnitCreated(unitID, unitDefID, unitTeam)
        widget:UnitFinished(unitID, unitDefID, unitTeam)
    end
end

--- Spring's UnitIdle is just too weird, it fires up when units are transitioning between commands..
--function widget:UnitIdle(unitID, unitDefID, unitTeam)
local function customUnitIdle(unitID, delay)
    if not automatableUnits[unitID] then
        return end
    removeCommands(unitID)
    spGiveOrderToUnit(unitID, CMD_STOP, {} , CMD_OPT_RIGHT )
    setAutomateState(unitID, "deautomated", "customUnitIdle")
    automatableUnits[unitID] = nil
    WG.harvestState[unitID] = "idle"    -- Forces unitai_auto_harvest into idle state
end

--- If you left the game this widget has no raison d'etré
function widget:PlayerChanged()
    if Spring.GetSpectatingState() and Spring.GetGameFrame() > 0 then
        widgetHandler:RemoveWidget(self)
    end
end

--local function setLoadedHarvester(harvesterTeam, unitID, value)
--    --Spring.Echo("Harvester team: "..(harvesterTeam or "nil").." my team: "..myTeamID.." unitID: "..unitID.." value: "..tostring(value))
--    if (harvesterTeam ~= myTeamID) then
--        return end
--    local rpx, rpy, rpz = spGetUnitPosition(unitID) -- "return position" x,y,z
--    loadedHarvesters[unitID] = true
--    harvesters[unitID].nearestOreTowerID = nil
--    harvesters[unitID].returnPos = { x = rpx, y = rpy, z = rpz }
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

local function isOreTower(unitDef)
    return oreTowerDefNames[unitDef.name]
end

function widget:UnitCreated(unitID, unitDefID, teamID, builderID)
    -- If unit just created is a mobile unit, add it to array
    local uDef = UnitDefs[unitDefID]
    if not uDef then
        return end
    if not uDef.isImmobile then
        WIPmobileUnits[unitID] = true
    end
end

function widget:UnitFinished(unitID, unitDefID, unitTeam)
    if myTeamID ~= unitTeam then					--check if unit is mine
        return end
    local unitDef = UnitDefs[unitDefID]
    if not unitDef then
        return end
    if isOreTower(unitDef) then
        oreTowers[unitID] = getOreTowerRange(nil, unitDef)
        -- go through harvesters and see if a new parentOreTower should be assigned
        for harvesterID,data in pairs(harvesters) do
            if IsValidUnit(harvesterID) and data.parentOreTowerID == nil then
                local x,y,z = spGetUnitPosition(harvesterID)
                local ud = { unitID = harvesterID, pos = {x=x,y=y,z=z}, unitDef=uDef }
                local nearestOreTowerID = getNearestOreTowerID(ud, oreTowers, maxOreTowerScanRange)
                harvesters[harvesterID].parentOreTowerID = nearestOreTowerID
                --newOreTowerAssigned = true
            end
        end
    end
    if not unitDef.isBuilding then
        WIPmobileUnits[unitID] = false end
    if canrepair[unitDef.name] or canresurrect[unitDef.name] then
        setAutomateState(unitID, "deautomated", "DeautomateUnit")
    end
    local maxorestorage = tonumber(unitDef.customParams.maxorestorage)
    if maxorestorage and maxorestorage > 0 then
        local harvestWeapon = WeaponDefs[unitDef.name.."_harvest_weapon"]   -- eg: armck_harvest_weapon
        local harvestRange = harvestWeapon and (harvestWeapon.range * harvestLeashMult)
                                            or (160 * harvestLeashMult)
        --loadPercent = (spGetUnitHarvestStorage(unitID) or 1)/maxorestorage,
        harvesters[unitID] = { maxorestorage = maxorestorage, parentOreTowerID = nil, returnPos = {}, targetChunkID = nil,
                               recheckFrame = spGetGameFrame() + recheckLatency,
                               harvestWeapon = harvestWeapon, harvestRange = harvestRange,
                               unitDef = UnitDefs[unitDefID]
                             }
        spEcho("unitai_autoharvest: added harvester: "..unitID.." storage: "..maxorestorage)
        --orphanHarvesters[unitID] = true -- newborns are orphan. Usually not for long.
    end
    local unitDef = UnitDefs[unitDefID]
    if canrepair[unitDef.name] or canresurrect[unitDef.name] then
        spEcho("Registering unit "..unitID.." as automatable: "..unitDef.name)--and isCom(unitID)
        automatableUnits[unitID] = true
    end
end

function widget:UnitDestroyed(unitID)
    ---Dont. That is done by deautomation
    --for autoID, targetID in pairs(automatableUnits) do
    --    if targetID == unitID then
    --        automatableUnits[autoID] = nil
    --    end
    --end
    automatableUnits[unitID] = nil
    unitsToAutomate[unitID] = nil
    automatedUnits[unitID] = nil
    deautomatedUnits[unitID] = nil
    automatedState[unitID] = nil
    harvesters[unitID] = nil

    --Clean up the target of any automatedUnit, if it was destroyed
    for automatedUnit,targetID in pairs(automatableUnits) do
        if targetID == unitID then
            automatableUnits[automatedUnit] = nil
        end
    end

    -- If parentOreTower has been destroyed, clear it up within the harvesters table
    for harvesterID,data in pairs(harvesters) do
        if data.parentOreTowerID == unitID then
            harvesters[harvesterID].parentOreTowerID = nil
        end
    end

    oreTowers[unitID] = nil
end


--- resourceType:: "e" (energy), "m" (metal), nil (must have enough of both types)
--- flood:: false/nil == "enough" resources; true = check for flooding resources (above 90%, or 1-enoughThreshold)
local function resourcesCheck(resourceType, flood)
    local thresholdToCheck = flood and (1 - enoughResourcesThreshold) or enoughResourcesThreshold
    local currentM, currentMstorage, currentE, currentEstorage
    if resourceType == "m" or resourceType == nil then
        currentM, currentMstorage = spGetTeamResources(myTeamID, "metal") --currentLevel, storage, pull, income, expense
        if not isnumber(currentM) then
            return false end
    end
    if resourceType == "e" or resourceType == nil then
        currentE, currentEstorage = spGetTeamResources(myTeamID, "energy")
        if not isnumber(currentE) then
            return false end
    end
    if resourceType == nil then
        return currentM > (currentMstorage * thresholdToCheck) and currentE > (currentEstorage * thresholdToCheck)
    elseif resourceType == "m" then
        return currentM > (currentMstorage * thresholdToCheck)
    elseif resourceType == "e" then
        return currentE > (currentEstorage * thresholdToCheck)
    end
end

local function isReallyIdle(unitID)
    local result = false
    if automatedState[unitID] == "harvest" and WG.harvestState[unitID] == "idle" then
        result = true
    end
    -- commandqueue with guard => not idle
    --TODO: Cache last command and check cmdDone callin
    if (not hasBuildQueue(unitID)) and (not hasCommandQueue(unitID)) then
        result = true
    end
    --spEcho("IsReallyIdle: "..tostring(result).." | has command queue: "..hasCommandQueue(unitID))
    return result
end

--function widget:UnitIdle(unitID, unitDefID, unitTeam)
--    idledUnits[unitID] = true
--end

local function targetIsInRange(unitID, targetID)
    if not IsValidUnit(unitID) then --or not isnumber(targetID)
        return false end
    local unitDef = UnitDefs[spGetUnitDefID(unitID)]
    local x, y, z = spGetUnitPosition(unitID)

    if IsValidUnit(targetID) then
        return spGetUnitSeparation(unitID, targetID) <= unitDef.buildDistance end
    if IsValidFeature(targetID) then
        local x2, y2, z2 = spGetFeaturePosition(targetID)
        return distance(x,y,z,x2,y2,z2) <= unitDef.buildDistance
    end
end

--local function unitNotDeautomated(unitID)
--    local unitState = automatedState[unitID]
--    return unitState ~= "deautomated" --and unitState ~= "await" and unitState ~= "harvest_return"
--end

--local function inTowerRange(harvesterID)
--    for oreTowerID, range in pairs(oreTowers) do
--        local thisTowerDist = spGetUnitSeparation ( harvesterID, oreTowerID, true) -- [, bool surfaceDist ]] )
--        if thisTowerDist <= range then
--            return true
--        end
--    end
--end

local function isFactory(unitID)
    if not IsValidUnit(unitID) then
        return end
    local uDef = UnitDefs[spGetUnitDefID(unitID)]
    return uDef and uDef.isFactory
end

local function isFullHealth(unitID)
    if not IsValidUnit(unitID) then
        return end
    local health, maxHealth = spGetUnitHealth(unitID)
    return health >= maxHealth
end

local function getLoadPercentage(unitID, unitDef)
    if not unitDef.customParams or not unitDef.customParams.maxorestorage then
        return 0 end
    local maxorestorage = tonumber(unitDef.customParams.maxorestorage)
    return (spGetUnitHarvestStorage(unitID) or 1) / maxorestorage
end

--- Decides and issues orders on what to do around the unit, in this order (1 == higher):
--- 1. If is not harvesting and there's a chunk nearby, set it to 'harvest' (from there on, ai_harvester_brain takes control, until it's deautomated)
--- 2. If has no weapon (outpost, FARK, etc), reclaim enemy units;
--- 3. If can resurrect, resurrect nearest feature (check for economy? might want to reclaim instead)
--- 4. If can assist, guard nearest factory
--- 5. If can repair, repair nearest allied unit with less than 90% maxhealth.
--- 6. Reclaim nearest feature (prioritize metal)
--- 7. Checks if it should become deautomated/idle

local automatedFunctions = {
    [1] = { id="enemyreclaim",
            condition = function(ud)  -- Commanders shouldn't prioritize enemy-reclaiming
                return automatedState[ud.unitID] ~= "enemyreclaim"
                        and not ud.unitDef.customParams.iscommander
            end,
            action = function(ud) --unitData
                --Spring.Echo("[1] Enemy-reclaim check")
                local nearestEnemy = spGetUnitNearestEnemy(ud.unitID, ud.radius, false) -- useLOS = false ; => nil | unitID
                if nearestEnemy and automatedState[ud.unitID] ~= "enemyreclaim" then
                    spGiveOrderToUnit(ud.unitID, CMD_RECLAIM, { nearestEnemy }, {} )
                    automatableUnits[ud.unitID] = nearestEnemy
                    return "enemyreclaim"
                end
                return nil
            end
    },
    [2] = { id="harvest",
            condition = function(ud)
                --Spring.Echo("has nearest chunk: "..(ud.nearestChunkID or "nil").." load perc: "..(harvesters[ud.unitID] and harvesters[ud.unitID].loadPercent or "nil"))
                local nearestChunkID = getNearestChunkID(ud)
                local parentOreTowerID = getParentOreTowerID(ud, harvesters)
                if harvesters[ud.unitID]
                        and automatedState[ud.unitID] ~= "enemyreclaim"
                        and automatedState[ud.unitID] ~= "harvest" then
                    if not parentOreTowerID then
                        parentOreTowerID = getNearestOreTowerID (ud, oreTowers, maxOreTowerScanRange)
                        harvesters[ud.unitID].parentOreTowerID = parentOreTowerID
                    end
                    local loadPercent = getLoadPercentage(ud.unitID, ud.unitDef)
                    if (nearestChunkID and loadPercent < 1)
                       or (parentOreTowerID and loadPercent > 0)
                       or (harvesters[ud.unitID].returnPos and harvesters[ud.unitID].returnPos.x) then
                        return true end
                end
            end,
            action = function(ud) --unitData
                local nearestChunkID = getNearestChunkID(ud)
                spEcho("**5** Harvest check - nearest chunk: "..(nearestChunkID or "nil"))
                spEcho("Sending message: ".."harvesterAttack_"..ud.unitID.."_"..(nearestChunkID or "nil"))
                if nearestChunkID then
                    spSendLuaUIMsg("harvesterAttack_"..ud.unitID.."_"..nearestChunkID, "allies") --(message, mode)
                    --automatableUnits[ud.unitID] = nearestChunkID
                end
                return "harvest"
            end
    },
    [3] = { id="reclaim",
            condition = function(ud) --unitData
                return canreclaim[ud.unitDef.name] --and not ud.orderIssued
                        and automatedState[ud.unitID] ~= "enemyreclaim"
                        and automatedState[ud.unitID] ~= "harvest"
                        and automatedState[ud.unitID] ~= "reclaim"
                        and spGetUnitRulesParam(ud.unitID, "loadedHarvester") ~= 1
            end,
            action = function(ud)
                --Spring.Echo("[3] Reclaim check")
                local nearestMetalID = getNearestMetalID(ud)
                local hasMetal = resourcesCheck("m",true)
                if nearestMetalID and not hasMetal then
                    local x,y,z = spGetFeaturePosition(nearestMetalID)
                    spGiveOrderToUnit(ud.unitID, CMD_INSERT, {-1, CMD_RECLAIM, CMD_OPT_INTERNAL+1,x,y,z,reclaimRadius}, {"alt"})
                    automatableUnits[ud.unitID] = nearestMetalID
                    return "reclaim"
                else
                    local nearestEnergyID = getNearestEnergyID(ud)
                    local hasEnergy = resourcesCheck("e")
                    if nearestEnergyID and not hasEnergy then
                        -- If not, we'll check if there's an energy resource nearby and if we're not overflowing energy, reclaim it
                        local x,y,z = spGetFeaturePosition(nearestEnergyID)
                        spGiveOrderToUnit(ud.unitID, CMD_INSERT, {-1, CMD_RECLAIM, CMD_OPT_INTERNAL+1,x,y,z,reclaimRadius}, {"alt"})
                        automatableUnits[ud.unitID] = nearestEnergyID
                        return "reclaim"
                    end
                end
                return nil
            end
    },
    [4] = { id="repair",
            condition = function(ud) --unitData
                local hasEnergy = resourcesCheck("e")
                return canrepair[ud.unitDef.name] --and not ud.orderIssued
                        and automatedState[ud.unitID] ~= "enemyreclaim"
                        and automatedState[ud.unitID] ~= "reclaim"
                        and automatedState[ud.unitID] ~= "harvest"
                        and automatedState[ud.unitID] ~= "repair" and hasEnergy
            end,
            action = function(ud)
                --Spring.Echo("[3] Repair check")
                local nearestTargetID
                if canassist[ud.unitDef.name] then
                    local nearestUID = getNearestUID(ud)
                    nearestTargetID = nearestUID
                else
                    local nearestRepairableID = getNearestRepairableID(ud)
                    nearestTargetID = nearestRepairableID -- only finished units can be targetted then
                end
                if nearestTargetID and automatedState[ud.unitID] ~= "repair" then
                    --spGiveOrderToUnit(unitID, CMD_INSERT, {-1, CMD_REPAIR, CMD_OPT_INTERNAL+1,x,y,z,80}, {"alt"})
                    spGiveOrderToUnit(ud.unitID, CMD_REPAIR, { nearestTargetID }, {} )
                    automatableUnits[ud.unitID] = nearestTargetID
                    return "repair"
                end
                return nil
            end
    },
    [5] = { id="assist",
            condition =  function(ud) --unitData
                --Spring.Echo("Can assist: "..tostring(canassist[ud.unitDef.name]).." order Issued: "..tostring(ud.orderIssued).." has Resources: "..tostring(ud.hasResources))
                local hasResources = resourcesCheck()
                return canassist[ud.unitDef.name] --and not ud.orderIssued
                        and automatedState[ud.unitID] ~= "enemyreclaim"
                        and automatedState[ud.unitID] ~= "reclaim"
                        and automatedState[ud.unitID] ~= "harvest"
                        and automatedState[ud.unitID] ~= "repair"
                        and automatedState[ud.unitID] ~= "assist"
                        and hasResources -- must have enough energy and ore to assist things being built
                end,
            action = function(ud)
               --Spring.Echo("[3] Factory-assist check")
               --TODO: If during 'automation' it's guarding a factory but factory stopped production, remove it
               --Spring.Echo ("Autoassisting factory: "..(nearestFactoryUnitID or "nil").." has eco: "..tostring(enoughEconomy()))
               local nearestFactoryID = getNearestFactoryID(ud)
               if nearestFactoryID then
                   spGiveOrderToUnit(ud.unitID, CMD_GUARD, { nearestFactoryID }, {} )
                   automatableUnits[ud.unitID] = nearestFactoryID
                   return "assist"
               end
               return nil
            end
    },
    [6] = { id="resurrect",
            condition = function(ud)
                local hasEnergy = resourcesCheck("e")
                return canresurrect[ud.unitDef.name] --and not ud.orderIssued
                        and automatedState[ud.unitID] ~= "enemyreclaim"
                        and automatedState[ud.unitID] ~= "reclaim"
                        and automatedState[ud.unitID] ~= "harvest"
                        and automatedState[ud.unitID] ~= "repair"
                        and automatedState[ud.unitID] ~= "assist"
                        and automatedState[ud.unitID] ~= "resurrect"
                        and hasEnergy -- must have enough "E" to resurrect stuff
            end,
            action = function(ud) --unitData
                --Spring.Echo("[2] Ressurect check")
                local nearestFeatureID = getNearestFeatureID(ud)
                if nearestFeatureID and automatedState[ud.unitID] ~= "resurrect" then
                    local x,y,z = spGetFeaturePosition(nearestFeatureID)
                    spGiveOrderToUnit(ud.unitID, CMD_INSERT, {-1, CMD_RESURRECT, CMD_OPT_INTERNAL+1,x,y,z,20}, {"alt"})  --shift
                    automatableUnits[ud.unitID] = nearestFeatureID
                    return "resurrect"
                end
                return nil
            end
    },
    [7] = { id="deautomated",
            condition = function(ud) --unitData
                local recheckFrame = deautomatedUnits[ud.unitID]
                local targetID = automatableUnits[ud.unitID]
                return automatedState[ud.unitID] ~= "deautomated" and
                       (
                        (recheckFrame and ud.frame > recheckFrame and isReallyIdle(ud.unitID))
                        or
                        --factory guarded but out of queue
                        (isnumber(targetID) and
                            (   -- Harvest => deautomated is taken care of by unitai_auto_harvest
                             (not targetIsInRange(ud.unitID, targetID)) -- unit or target were pushed away from each other
                             or
                             --TODO: Deautomate assisting units when factory is awaited
                             (automatedState[ud.unitID] == "assist" and ((not IsValidUnit(targetID)) or not hasBuildQueue(targetID))) --Fac destroyed or no buildqueue
                             or
                             (automatedState[ud.unitID] == "repair" and ((not IsValidUnit(targetID)) or isFullHealth(targetID))) -- target unit destroyed or full health
                             or
                             (automatedState[ud.unitID] == "enemyreclaim" and (not IsValidUnit(targetID)) ) -- reclaimed enemy unit destroyed
                             or
                             ((automatedState[ud.unitID] == "reclaim" or automatedState[ud.unitID] == "resurrect")
                                     and (not IsValidFeature(targetID)) ) -- reclaimed feature destroyed or feature was rezzed
                            )
                        )
                       )
            end,
            action = function(ud)
                customUnitIdle(ud.unitID, automationLatency)
                return "deautomated"
            end
    },
}

--- Goes through all the automatedFunctions, in order, and returns the new state, if the state-change succeeds
local function automateCheck(unitID, unitDef, caller)
    if not unitDef or not IsValidUnit(unitID) then
        return end
    local x, y, z = spGetUnitPosition(unitID)
    local pos = { x = x, y = y, z = z }

    local radius = (unitDef.isBuilding or unitDef.speed==0)
            and (unitDef.buildDistance or 1)
            or (unitDef.buildDistance or 1) * 1.8
    --if unitDef.canFly then               -- Air units need that extra oomph || obsolete, now uses "2D" range
    --    radius = radius * 1.3
    --end

--  local harvestWeapon = WeaponDefs[UnitDefs[unitDef.id].name.."_harvest_weapon"] -- eg: armck_harvest_weapon
    local harvestRange = harvesters[unitID] and harvesters[unitID].harvestRange

    local ud = { unitID = unitID, unitDef = unitDef, pos = pos, radius = radius, harvestRange = harvestRange, orderIssued = nil,
                 frame = spGetGameFrame() }

    -- Will try and (if condition succeeds) execute each automatedFunction, in order. #1 is highest priority, etc.
    for i = 1, #automatedFunctions do
        local autoFunc = automatedFunctions[i]
        if autoFunc.condition(ud) then
            ud.orderIssued = autoFunc.action(ud)
            --Spring.Echo("order issued: "..(ud.orderIssued or "nil"))
        end
        if ud.orderIssued then
            break end
    end
    --Spring.Echo("Can assist: "..tostring(canassist[ud.unitDef.name]).." order Issued: "..tostring(ud.orderIssued).." has Resources: "..tostring(ud.hasResources))
    if ud.orderIssued then
        spEcho ("New order Issued: "..ud.orderIssued)
        unitsToAutomate[unitID] = nil
        setAutomateState(unitID, ud.orderIssued, caller.."> automateCheck")
    end
    return ud.orderIssued
end

function widget:CommandNotify(cmdID, params, options)
    spEcho("CommandID registered: "..(cmdID or "nil"))
    ---TODO: If guarding, interrupt what's doing, otherwise don't
    -- User commands are tracked here, check what unit(s) is/are selected and remove it from automatedUnits
    local selUnits = spGetSelectedUnits()  --() -> { [1] = unitID, ... }
    for _, unitID in ipairs(selUnits) do
        if automatableUnits[unitID] and IsValidUnit(unitID) then
            if (cmdID == CMD_ATTACK or cmdID == CMD_UNIT_SET_TARGET) then
                spEcho("CMD_ATTACK, params #: "..#params)
                if #params == 1 then -- and isOreChunk(params[1]) then
                    --setAutomateState(unitID, "harvest", "CommandNotify")
                    automatableUnits[unitID] = params[1]    -- set Target
                end
            end
            if automatedState[unitID] ~= "deautomated" then -- if it's working, don't touch it
                ---We do this to check if remove commands should be issued or not, down the pipe
                --if options and options.shift then
                if cmdID and cmdID < 0 then
                    setAutomateState(unitID, "deautomated", "CommandNotifyBuild")
                else
                    setAutomateState(unitID, "deautomated", "CommandNotify")
                end
            end
        end
    end
end

function widget:UnitCmdDone(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOpts, cmdTag)
    spEcho("CmdDone for "..(unitID or "nil").." cmdID: "..(cmdID or "nil"))
end

--- Frame-based Update
function widget:GameFrame(f)
    if f < startupGracetime or f % updateRate > 0.001 then
        return
    end

    --spEcho("This frame: "..f.." deauto'ed unit #: "..(pairs_len(deautomatedUnits) or "nil").." toAutomate #: "..(pairs_len(unitsToAutomate) or "nil"))

    --- What to do with units just set to "deautomated". 1st pass, there's a lag before the actual re-automation attempt below
    --- Set units to "deautomated" when it's really idle. There's a delay before the actual re-automation attempt below
    for unitID, recheckFrame in pairs(deautomatedUnits) do
        if IsValidUnit(unitID) and f >= recheckFrame then
            spEcho("unitai_auto_assit: Deautomated units check")
            --Spring.Echo(" is really idle: "..tostring(isReallyIdle(unitID)).." automated State: "..automatedState[unitID].." units to Automate: "..(unitsToAutomate[unitID] or "nil"))
            if isReallyIdle(unitID) then
                if automatedState[unitID] ~= "deautomated" then
                    customUnitIdle(unitID, 0)
                elseif not unitsToAutomate[unitID] then
                    unitsToAutomate[unitID] = spGetGameFrame() + deautomatedRecheckLatency --schedule next check
                end
                --if not hasBuildQueue(guardedUnit) then -- builders assisting *do* have a commandqueue (guard)
                --    deassistCheck(unitID) end --- We need to remove Guard commands, otherwise the unit will keep guarding
            else
                unitsToAutomate[unitID] = nil
            end
        end
    end

    --- Check if it's time to actually try to automate an unit (after idle or creation)
    for unitID, automateFrame in pairs(unitsToAutomate) do
        if IsValidUnit(unitID) and f >= automateFrame then
            local unitDef = UnitDefs[spGetUnitDefID(unitID)]
            --- PS: we only un-set unitsToAutomate[unitID] down the pipe, if automation is successful
            if unitDef then
                local orderIssued = automateCheck(unitID, unitDef, "unitsToAutomate")
                if not orderIssued and not automatedState[unitID] and automatedState[unitID]~="deautomated" then
                    --spEcho("1.5")
                    setAutomateState(unitID, "deautomated", "GameFrame: deautomate")
                end
            end
        end
    end

    --- Check if the automated unit should be doing something else instead of what's doing
    for unitID, recheckFrame in pairs(automatedUnits) do
        if IsValidUnit(unitID) and f >= recheckFrame then
            local unitDef = UnitDefs[spGetUnitDefID(unitID)]
            automateCheck(unitID, unitDef, "repurposeCheck")
        end
    end
end

---- Initialize the unit when received (through sharing)
function widget:UnitGiven(unitID, unitDefID, unitTeam)
    widget:UnitFinished(unitID, unitDefID, unitTeam)
end

---- Decomissions the unit data when given away
function widget:UnitTaken(unitID, unitDefID, oldTeamID, teamID)
    widget:UnitDestroyed(unitID, unitDefID, oldTeamID)
end

----From unitai_auto_assist: Spring.SendLuaRulesMsg("harvestersToAutomate_"..ud.unitID,"allies")
function widget:RecvLuaMsg(msg, playerID)
    if msg:sub(1, 13) == 'harvesterIdle' then --"harvesterIdle_"..unitID
        local data = Split(msg, '_')
        local unitID = tonumber(data[2])
        spEcho("Autoassist :: Idle Harvester: "..(unitID or "nil"))
        if unitID then --and isReallyIdle(unitID) then
            setAutomateState(unitID, "deautomated", "RecvLuaMsg")
        end
    end
end

function widget:ViewResize(n_vsx,n_vsy)
    vsx, vsy = glGetViewSizes()
    widgetScale = (0.50 + (vsx*vsy / 5000000))
end