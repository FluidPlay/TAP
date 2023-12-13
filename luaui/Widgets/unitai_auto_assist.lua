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
        handler = true,
    }
end

VFS.Include("gamedata/tapevents.lua") --"LoadedHarvestEvent"
VFS.Include("gamedata/taptools.lua")
VFS.Include("gamedata/unitai_functions.lua")

local localDebug = false --true --|| Enables text state debug messages
local localDebugLight = false   -- for lighter, local debug messages

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
local spGetTeamResources = Spring.GetTeamResources
local spGetUnitTeam    = Spring.GetUnitTeam
local spGetUnitsInSphere = Spring.GetUnitsInSphere
local spGetFeaturesInSphere = Spring.GetFeaturesInSphere
local spGetGameFrame = Spring.GetGameFrame
local spGetUnitsInCylinder = Spring.GetUnitsInCylinder
local spGetFeaturesInCylinder = Spring.GetFeaturesInCylinder
local spGetUnitNearestAlly = Spring.GetUnitNearestAlly
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

local startupGracetime = 60         -- Delay before the commander tries to be automated, after game start
local updateRate = 15               -- Global update "tick rate"
local idleRecheckLatency = 15       -- Delay until an idle unit checks for automation again
local reautomationLatency = 45      -- Delay before re-purposing of automation kicks in
--local repurposeLatency = 160      -- Delay before checking if an automated unit should be doing something else
local reclaimRadius = 20            -- Reclaim commands issued by code apparently only work with a radius (area-reclaim)
local maxOreTowerScanRange = 900
local defaultOreTowerRange = 330
local harvestLeashMult = 2.0          -- chunk search range is the harvest range* multiplied by this  (*attack range of weapon eg. "armck_harvest_weapon")
local recheckLatency = 30             -- Delay until a de-automated unit checks for automation again


-- TODO: Commanders guarding factories, let's use it to stop guarding when we're out of resources
local unitTarget = {} -- The target (if any) of units which can be automated // { [unitID] = targetID|true|false, ... }
local unitData = { } -- unitID = { recheckFrame = spGetGameFrame() + recheckLatency, radius = radius,
                    --    unitDef = unitDef, team = spGetUnitTeam(unitID), harvestRange = nil,
                    -- }
-- targetID might be a chunk being harvested, a feature being reclaimed or ressurected, or an enemy unity being reclaimed
local unitsToAutomate = {}  -- These will be automated, but aren't there yet (on latency); can be interrupted by direct orders
local automatedUnits = {}   -- All units currently automated    // { [unitID] = frameToRecheckAutomation, ... }
local commandedUnits = {} -- Post deautomation (direct order) // { [unitID] = frameToTryReautomation, ... }
local awaitedUnits = {}
--local executingCmd = {}   -- Last command being executed (eg.: reclaim) { [unitID] = cmdID, ... }
local unitIdleEvent = {}    -- { [unitID] = frameToRecheckIdle, ...} // tracks units tagged by widget:unitIdle (requires further verification)
local reallyIdleUnits = {}
local unitFinishedNextFrame = {} -- { [unitID] = frame, ... }
-- { [unitID] = frameToAutomate (eg: spGetGameFrame() + recheckUpdateRate), ... }

local automatedState = {}   -- This is the automated state. It's always there for automatableUnits, after the initial latency period

--local orderRemovalDelay = 10    -- 10 frames of delay before removing commands, to prevent the engine from removing just given orders
--local internalCommandUIDs = {}
local autoassistEnableDelay = 60    -- automation delay, after unit is finished

local vsx, vsy = gl.GetViewSizes()
local widgetScale = (0.50 + (vsx*vsy / 5000000))

local math_random = math.random

---Harvest-system related
local oreTowerDefNames = { armmstor = true, cormstor = true, armuwadvms = true, coruwadvms = true, }

-- == uDef.harvestStorage is not working (105)
local harvesters = {} -- { unitID = { maxorestorage = uDef.customparams.maxorestorage, parentOreTowerID,
                      --    targetChunkID = nil,
                      --    recheckFrame = spGetGameFrame() + recheckLatency,
                      --    harvestWeapon = harvestWeapon, harvestRange = harvestRange,
                      --    unitDef = unitDef, team = spGetUnitTeam(unitID)
                      -- }


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
local CMD_WAIT = CMD.WAIT

--local CMD_MORPH_UPGRADE_INTERNAL = 31207
local CMD_MORPH = 31410
local CMD_MORPH_STOP = 32410
local CMD_MORPH_PAUSE = 33410
local CMD_MORPH_QUEUE = 34410


local CMD_OPT_INTERNAL = CMD.OPT_INTERNAL

----- Type Tables
local canreclaim = {
    armcom = true, armcom1 = true, armcom2 = true, armcom3 = true, armcom4 = true,
    corcom = true, corcom1 = true, corcom2 = true, corcom3 = true, corcom4 = true,
    armfark = true, cormuskrat = true, armconsul = true, bowscrow = true,
    armck = true, corck = true, armcv = true, corcv = true, armca = true, corca = true, armcs = true, corcs = true,
    armck2 = true, corck2 = true,
    armack = true, corack = true, armacv = true, coracv = true, armaca = true, coraca = true, armacsub = true, coracsub = true,
    armoutpost = true, armoutpost2 = true, armoutpost3 = true, armoutpost4 = true,
    coroutpost = true, coroutpost2 = true, coroutpost3 = true, coroutpost4 = true,
    bowdaemon = true, kerndaemon = true, bowadvdaemon = true, kernadvdaemon = true,
}

local canrepair = {
    armcom = true, armcom1 = true, armcom2 = true, armcom3 = true, armcom4 = true,
    corcom = true, corcom1 = true, corcom2 = true, corcom3 = true, corcom4 = true,
    armfark = true, cormuskrat = true, armconsul = true, bowscrow = true,
    armck = true, corck = true, armcv = true, corcv = true, armca = true, corca = true, armcs = true, corcs = true,
    armck2 = true, corck2 = true,
    armack = true, corack = true, armacv = true, coracv = true, armaca = true, coraca = true, armacsub = true, coracsub = true,
    armoutpost = true, armoutpost2 = true, armoutpost3 = true, armoutpost4 = true,
    coroutpost = true, coroutpost2 = true, coroutpost3 = true, coroutpost4 = true,
    armrectr = true, corvrad = true, cornecro = true,
    bowdaemon = true, kerndaemon = true, bowadvdaemon = true, kernadvdaemon = true,
}

local canassist = {
    armcom = true, armcom1 = true, armcom2 = true, armcom3 = true, armcom4 = true,
    corcom = true, corcom1 = true, corcom2 = true, corcom3 = true, corcom4 = true,
    armfark = true, cormuskrat = true, armconsul = true, bowscrow = true,
    armack = true, corack = true, armacv = true, coracv = true, armaca = true, coraca = true, armacsub = true, coracsub = true,
    armoutpost = true, armoutpost2 = true, armoutpost3 = true, armoutpost4 = true,
    coroutpost = true, coroutpost2 = true, coroutpost3 = true, coroutpost4 = true,
    bowdaemon = true, kerndaemon = true, bowadvdaemon = true, kernadvdaemon = true,
}

--local canharvest = {
--    armck = true, corck = true, armcv = true, corcv = true, armca = true, corca = true, armcs = true, corcs = true,
--    armack = true, corack = true, armacv = true, coracv = true, armaca = true, coraca = true, armacsub = true, coracsub = true,
--}

local canresurrect = {
    armrectr = true, corvrad = true, cornecro = true,
}

--local standardbuilder = {
--    armck = true, corck = true, armcv = true, corcv = true, armca = true, corca = true, armcs = true, corcs = true,
--}

--if standardbuilder[unitDef.name] then
--
--end
-----

local function spEcho(string)
    if localDebug then
        Spring.Echo(string) end
end

local function spEchoLight(string)
    if localDebugLight then
        Spring.Echo(string) end
end

--local function isCommander(unitID,unitDefID)
--    if unitID and not unitDefID then
--        unitDefID = spGetUnitDefID(unitID)
--    end
--    return UnitDefs[unitDefID] and UnitDefs[unitDefID].customParams and UnitDefs[unitDefID].customParams.iscommander ~= nil
--end
--
--local function unitIsBeingBuilt(unitID)
--    return select(5, spGetUnitHealth(unitID)) < 1
--end

local function giveInternalOrderToUnit(unitID, cmdID, params, options)
    spGiveOrderToUnit(unitID, cmdID, params, options)
    --internalCmdEvent[unitID] = true
end

local function removeCommands(unitID)
    giveInternalOrderToUnit(unitID, CMD_REMOVE, {CMD_PATROL, CMD_GUARD, CMD_ATTACK, CMD_UNIT_SET_TARGET, CMD_RECLAIM, CMD_FIGHT, CMD_REPAIR}, {"alt"})
    --spGiveOrderToUnit(unitID, CMD_REMOVE, {CMD_PATROL, CMD_GUARD, CMD_ATTACK, CMD_UNIT_SET_TARGET, CMD_RECLAIM, CMD_FIGHT, CMD_REPAIR}, {"alt"})
    --internalCmdEvent[unitID] = true
end

local function DeautomateUnit(unitID, caller)
    ---TODO: Below should only be called if a build order was issued, or if issued by unitai_auto_harvest
    --if caller == "CommandNotifyBuild" then --or caller == "CommandNotify" or caller == "autoHarvest"
    --assureUnitIsIdle(unitID)
    if WG.harvestState then
        WG.harvestState[unitID] = "idle" end   -- Forces unitai_auto_harvest into idle state
    --end
    automatedUnits[unitID] = nil
end

function setAutomateState(unitID, state, caller)
    -- Avoid recursion
    if awaitedUnits[unitID] or automatedState[unitID] == state then
        return end
    local randRecheckTime = math_random(1,3) * idleRecheckLatency
    if state == "idle" then
        DeautomateUnit(unitID, caller)
        commandedUnits[unitID] = nil
        unitsToAutomate[unitID] = spGetGameFrame() + randRecheckTime --idleRecheckLatency     -- That's a key point when unit is set for later reautomation
    else
        if state == "commanded" then
            DeautomateUnit(unitID, caller)  --Does: automatedUnits[unitID] = nil
            --- It'll only get out of commanded if it's idle, that's only the delay to recheck for idle
            commandedUnits[unitID] = spGetGameFrame() + randRecheckTime
            --unitIdleEvent[unitID] = spGetGameFrame() + 45   -- Will recheck after one second and a half, by default
            --spEcho("Autoassist: Commanding Unit: "..unitID.." at frame "..spGetGameFrame()..", try re-automation in: "..spGetGameFrame() + idleRecheckLatency)
            spSendLuaUIMsg("unitCommanded_"..unitID, "allies") --(message, mode)
        else
            commandedUnits[unitID] = nil
            local randReautomationTime = math_random(1,3) * reautomationLatency
            automatedUnits[unitID] = spGetGameFrame() + randReautomationTime
        end
        unitsToAutomate[unitID] = nil
    end
    automatedState[unitID] = state
    --spEchoLight("New automateState: "..state.." for: "..unitID.." set by function: "..caller)
end

function getUnitIdleEvent(unitID)
    return unitIdleEvent[unitID]
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


function widget:UnitIdle(unitID, unitDefID, unitTeam)
    if not unitTarget[unitID] or unitIdleEvent[unitID] then
        return end

    -- On 'commandedUnits' we store the first recheck delay for idle (after entering 'commanded')
    -- If that delay isn't over yet, the unitIdleEvent shouldn't be set, and we bail out of this
    local isCommanded = commandedUnits[unitID]
    if isCommanded and spGetGameFrame() < isCommanded then
        --spEchoLight("widget:UnitIdle blocked")
        unitIdleEvent[unitID] = nil
        return end
    --spEchoLight("widget:UnitIdle fired/confirmed for "..unitID)
    if automatedState[unitID] ~= "harvest" then
        unitIdleEvent[unitID] = spGetGameFrame() + recheckLatency   -- Will confirm after 1 second (30f), by default
    end
end

---- Disable widget if I'm spec
function widget:Initialize()
    WG.automatedStates = automatedState     -- This will allow the state to be read and set by other widgets
    WG.harvesters = harvesters              --- Read by unitai_auto_harvest.lua
    WG.setAutomateState = setAutomateState
    WG.getUnitIdleEvent = getUnitIdleEvent

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

--- If you left the game this widget has no raison d'etré
function widget:PlayerChanged()
    if Spring.GetSpectatingState() and Spring.GetGameFrame() > 0 then
        widgetHandler:RemoveWidget(self)
    end
end

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
    local unitDef = UnitDefs[unitDefID]
    if not unitDef then
        return end
    if not unitDef.isImmobile then
        WIPmobileUnits[unitID] = true
    end
    local harvestRange = nil
    local maxorestorage = tonumber(unitDef.customParams.maxorestorage)
    if maxorestorage and maxorestorage > 0 then
        local harvestWeapon = WeaponDefs[unitDef.name.."_harvest_weapon"]   -- eg: armck_harvest_weapon
        harvestRange = harvestWeapon and (harvestWeapon.range * harvestLeashMult)
                or (160 * harvestLeashMult)
    end
    if canrepair[unitDef.name] or canresurrect[unitDef.name] then
        local radius = (unitDef.isBuilding or unitDef.speed==0)
                and (unitDef.buildDistance or 1)
                or (unitDef.buildDistance or 1) * 1.8
        unitData[unitID] = { recheckFrame = spGetGameFrame() + recheckLatency, radius = radius,
                             unitDef = unitDef, team = teamID, harvestRange = harvestRange, }
    end
end

function widget:UnitFinished(unitID, unitDefID, unitTeam)
    --if myTeamID ~= unitTeam then					--check if unit is mine
    --    return end
    local unitDef = UnitDefs[unitDefID]
    if not unitDef then
        return end

    awaitedUnits[unitID] = false
    -- We use this to track units which can not be assisted by default builders
    if not unitDef.isImmobile then --isBuilding
        WIPmobileUnits[unitID] = false end
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
    --TODO: Optimize, get this from UnitData (set up in UnitCreated)
    local harvestRange = nil
    local maxorestorage = tonumber(unitDef.customParams.maxorestorage)
    if maxorestorage and maxorestorage > 0 then
        local harvestWeapon = WeaponDefs[unitDef.name.."_harvest_weapon"]   -- eg: armck_harvest_weapon
        harvestRange = harvestWeapon and (harvestWeapon.range * harvestLeashMult)
                or (160 * harvestLeashMult)
        harvesters[unitID] = { maxorestorage = maxorestorage, parentOreTowerID = nil, returnPos = {}, targetChunkID = nil,
                               recheckFrame = spGetGameFrame() + recheckLatency,
                               harvestWeapon = harvestWeapon, harvestRange = harvestRange,
                               unitDef = unitDef, team = unitTeam
        }
    end

    if canrepair[unitDef.name] or canresurrect[unitDef.name] then
        unitFinishedNextFrame[unitID] = spGetGameFrame() + autoassistEnableDelay
    end
end

function widget:UnitDestroyed(unitID)
    unitTarget[unitID] = nil
    unitsToAutomate[unitID] = nil
    automatedUnits[unitID] = nil
    commandedUnits[unitID] = nil
    awaitedUnits[unitID] = nil
    unitIdleEvent[unitID] = nil
    reallyIdleUnits[unitID] = nil
    unitFinishedNextFrame[unitID] = nil

    automatedState[unitID] = nil
    harvesters[unitID] = nil

    --Clean up the target of any automatedUnit, if it was destroyed
    for automatedUnit,targetID in pairs(unitTarget) do
        if targetID == unitID then
            automatedUnits[automatedUnit] = nil
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

local function targetIsInRange(unitID, targetID, isFeature)
    --if not IsValidUnit(unitID) then --or not isnumber(targetID)
    --    return false end
    local unitDef = UnitDefs[spGetUnitDefID(unitID)]
    local x, y, z = spGetUnitPosition(unitID)
    local buildDistance = unitDef.buildDistance
    if not isnumber(buildDistance) then
        return false
    end

    if isFeature and IsValidFeature(targetID) then
        local x2, y2, z2 = spGetFeaturePosition(targetID)
        return distance(x,y,z,x2,y2,z2) <= buildDistance
    elseif IsValidUnit(targetID) then
        --return spGetUnitSeparation(unitID, targetID) <= unitDef.buildDistance
        local px, _, pz = spGetUnitPosition(targetID)
        --local volScales = UnitDefs[spGetUnitDefID(targetID)].collisionvolumescales
        local unitRadius = UnitDefs[spGetUnitDefID(unitID)].collisionVolume.boundingRadius
        local tgtRadius = UnitDefs[spGetUnitDefID(targetID)].collisionVolume.boundingRadius --tonumber(Split(volScales," ")[1]) or 0
        --Spring.Echo("taptools::In Range check, dist: "..distance(x,nil,z,px,nil,pz).."; build Dist:"..buildDistance..", radius: ".. tgtRadius)
        return distance(x,nil,z,px,nil,pz) <= (buildDistance*1.1 + tgtRadius + unitRadius)
    end
end

--local function unitNotcommanded(unitID)
--    local unitState = automatedState[unitID]
--    return unitState ~= "commanded" --and unitState ~= "await" and unitState ~= "harvest_return"
--end

--local function inTowerRange(harvesterID)
--    for oreTowerID, range in pairs(oreTowers) do
--        local thisTowerDist = spGetUnitSeparation ( harvesterID, oreTowerID, true) -- [, bool surfaceDist ]] )
--        if thisTowerDist <= range then
--            return true
--        end
--    end
--end

--local function isFactory(unitID)
--    if not IsValidUnit(unitID) then
--        return end
--    local uDef = UnitDefs[spGetUnitDefID(unitID)]
--    return uDef and uDef.isFactory
--end

local function isFullHealth(unitID)
    if not IsValidUnit(unitID) then
        return nil end
    local health, maxHealth = spGetUnitHealth(unitID)
    return health >= maxHealth
end

local function getLoadPercentage(unitID, unitDef)
    if not unitDef.customParams or not unitDef.customParams.maxorestorage then
        return 0 end
    local maxorestorage = tonumber(unitDef.customParams.maxorestorage)
    return (getUnitHarvestStorage(unitID) or 1) / maxorestorage
end

local function isOutpost(uDef)
    return uDef.customParams and uDef.customParams.tedclass and uDef.customParams.tedclass == "outpost"
end

--- Decides and issues orders on what to do around the unit, in this order (1 == higher):
--- 1. If is not harvesting and there's a chunk nearby, set it to 'harvest' (from there on, ai_harvester_brain takes control, until it's commanded)
--- 2. If has no weapon (outpost, FARK, etc), reclaim enemy units;
--- 3. If can resurrect, resurrect nearest feature (check for economy? might want to reclaim instead)
--- 4. If can assist, guard nearest factory
--- 5. If can repair, repair nearest allied unit with less than 90% maxhealth.
--- 6. Reclaim nearest feature (prioritize metal)
--- 7. Checks if it should become commanded/idle

local automatedFunctions = {
    [1] = { id="enemyreclaim",
            condition = function(ud)  -- Commanders shouldn't prioritize enemy-reclaiming
                return automatedState[ud.unitID] ~= "enemyreclaim" -- and automatedState[ud.unitID] ~= "harvest"
                        and automatedState[ud.unitID] ~= "assist"
                        and isOutpost(ud.unitDef)
                        --and ud.unitDef.canMove
                        --and not ud.unitDef.customParams.iscommander

            end,
            action = function(ud) --unitData
                --Spring.Echo("[1] Enemy-reclaim check")
                local nearestEnemy = spGetUnitNearestEnemy(ud.unitID, ud.radius, true) -- useLOS = true ; => nil | unitID
                if nearestEnemy and automatedState[ud.unitID] ~= "enemyreclaim" then
                    local neDefID = UnitDefs[spGetUnitDefID(nearestEnemy)]
                    if not neDefID or not neDefID.canFly then
                        giveInternalOrderToUnit(ud.unitID, CMD_RECLAIM, { nearestEnemy }, {} )
                        unitTarget[ud.unitID] = nearestEnemy
                        return "enemyreclaim"
                    end
                end
                return nil
            end
    },
    [2] = { id="harvest",
            condition = function(ud)
                if harvesters[ud.unitID]
                        --and automatedState[ud.unitID] ~= "enemyreclaim"
                        and automatedState[ud.unitID] ~= "harvest" then
                    --Spring.Echo("has nearest chunk: "..(ud.nearestChunkID or "nil").." load perc: "..(harvesters[ud.unitID] and harvesters[ud.unitID].loadPercent or "nil"))
                    local parentOreTowerID = getParentOreTowerID(ud, harvesters)
                    if not parentOreTowerID then
                        parentOreTowerID = getNearestOreTowerID (ud, oreTowers, maxOreTowerScanRange)
                        harvesters[ud.unitID].parentOreTowerID = parentOreTowerID
                    end
                    local loadPercent = getLoadPercentage(ud.unitID, ud.unitDef)
                    if (ud.nearestChunkID and loadPercent < 1)
                            or (parentOreTowerID and loadPercent > 0)
                            or (harvesters[ud.unitID].returnPos and harvesters[ud.unitID].returnPos.x) then
                        return true end
                end
            end,
            action = function(ud) --
                --Spring.Echo("**5** Harvest check - nearest chunk: "..(nearestChunkID or "nil"))
                --spEcho("Sending message: ".."harvesterAttack_"..ud.unitID.."_"..(ud.nearestChunkID or "nil"))
                if ud.nearestChunkID then
                    spSendLuaUIMsg("harvesterAttack_"..ud.unitID.."_"..ud.nearestChunkID, "allies") --(message, mode)
                    unitTarget[ud.unitID] = ud.nearestChunkID
                end
                return "harvest"
            end
    },
    [3] = { id="assist",
            condition =  function(ud) --
                local hasResources = resourcesCheck()
                --Spring.Echo("Can assist: "..tostring(canassist[ud.unitDef.name]).." has Resources: "..tostring(hasResources))
                return canassist[ud.unitDef.name] --and not ud.orderIssued
                        and automatedState[ud.unitID] ~= "enemyreclaim"
                        and automatedState[ud.unitID] ~= "harvest"
                        and automatedState[ud.unitID] ~= "assist"
                        and hasResources -- must have enough energy and ore to assist things being built
            end,
            action = function(ud)
                --Spring.Echo("[3] Factory-assist check \nAutoassisting factory: "..(nearestFactoryUnitID or "nil").." has eco: "..tostring(enoughEconomy()))
                --TODO: If during 'automation' it's assisting/guarding a factory but factory stopped production, de-automate it
                local nearestFactoryID = getNearestFactoryID(ud)
                if nearestFactoryID then
                    giveInternalOrderToUnit(ud.unitID, CMD_GUARD, { nearestFactoryID }, {} )
                    unitTarget[ud.unitID] = nearestFactoryID
                    return "assist"
                end
                return nil
            end
    },
    [4] = { id="reclaim",
            condition = function(ud) --
                return canreclaim[ud.unitDef.name] --and not ud.orderIssued
                        and automatedState[ud.unitID] ~= "enemyreclaim"
                        and automatedState[ud.unitID] ~= "harvest"
                        and automatedState[ud.unitID] ~= "assist"
                        and automatedState[ud.unitID] ~= "reclaim"
                        and spGetUnitRulesParam(ud.unitID, "loadedHarvester") ~= 1
            end,
            action = function(ud)
                --Spring.Echo("[3] Reclaim check")
                local nearestMetalID = getNearestMetalID(ud)
                local hasMetal = resourcesCheck("m",true)
                if nearestMetalID and not hasMetal then
                    local x,y,z = spGetFeaturePosition(nearestMetalID)
                    giveInternalOrderToUnit(ud.unitID, CMD_INSERT, {-1, CMD_RECLAIM, CMD_OPT_INTERNAL+1,x,y,z,reclaimRadius}, {"alt"})
                    unitTarget[ud.unitID] = nearestMetalID
                    --Spring.Echo("Issuing reclaim")
                    return "reclaim"
                else
                    local nearestEnergyID = getNearestEnergyID(ud)
                    local hasEnergy = resourcesCheck("e")
                    if nearestEnergyID and not hasEnergy then
                        -- If not, we'll check if there's an energy resource nearby and if we're not overflowing energy, reclaim it
                        local x,y,z = spGetFeaturePosition(nearestEnergyID)
                        giveInternalOrderToUnit(ud.unitID, CMD_INSERT, {-1, CMD_RECLAIM, CMD_OPT_INTERNAL+1,x,y,z,reclaimRadius}, {"alt"})
                        unitTarget[ud.unitID] = nearestEnergyID
                        return "reclaim"
                    end
                end
                return nil
            end
    },
    [5] = { id="repair",
            condition = function(ud) --
                local hasEnergy = resourcesCheck("e")
                --Spring.Echo("Has energy: "..(tostring(hasEnergy) or nil))
                return canrepair[ud.unitDef.name]
                        and automatedState[ud.unitID] ~= "enemyreclaim"
                        and automatedState[ud.unitID] ~= "harvest"
                        and automatedState[ud.unitID] ~= "assist"
                        and automatedState[ud.unitID] ~= "reclaim"
                        and automatedState[ud.unitID] ~= "repair" and hasEnergy
            end,
            action = function(ud)
                --Spring.Echo("[3] Repair check - teamID: "..(tostring(ud.team) or "nil"))
                local nearestTargetID
                if canassist[ud.unitDef.name] then
                    local nearestUID = getNearestAnyRepairableID(ud)    -- including factories & WIP/unfinished units
                    nearestTargetID = nearestUID
                else
                    local nearestRepairableID = getNearestRepairableID(ud)
                    nearestTargetID = nearestRepairableID -- only finished units can be targetted then
                end
                if nearestTargetID and automatedState[ud.unitID] ~= "repair" then
                    --spGiveOrderToUnit(unitID, CMD_INSERT, {-1, CMD_REPAIR, CMD_OPT_INTERNAL+1,x,y,z,80}, {"alt"})
                    giveInternalOrderToUnit(ud.unitID, CMD_REPAIR, { nearestTargetID }, {} )
                    unitTarget[ud.unitID] = nearestTargetID
                    return "repair"
                end
                return nil
            end
    },
    [6] = { id="resurrect",
            condition = function(ud)
                local hasEnergy = resourcesCheck("e")
                return canresurrect[ud.unitDef.name] --and not ud.orderIssued
                        and automatedState[ud.unitID] ~= "enemyreclaim"
                        and automatedState[ud.unitID] ~= "harvest"
                        and automatedState[ud.unitID] ~= "assist"
                        and automatedState[ud.unitID] ~= "reclaim"
                        and automatedState[ud.unitID] ~= "repair"
                        and automatedState[ud.unitID] ~= "resurrect"
                        and hasEnergy -- must have enough "E" to resurrect stuff
            end,
            action = function(ud) --
                --Spring.Echo("[2] Ressurect check")
                local nearestFeatureID = getNearestFeatureID(ud)
                if nearestFeatureID then  --and automatedState[ud.unitID] ~= "resurrect"
                    local x,y,z = spGetFeaturePosition(nearestFeatureID)
                    giveInternalOrderToUnit(ud.unitID, CMD_INSERT, {-1, CMD_RESURRECT, CMD_OPT_INTERNAL+1,x,y,z,20}, {"alt"})  --shift
                    unitTarget[ud.unitID] = nearestFeatureID
                    return "resurrect"
                end
                return nil
            end
    },
    [7] = { id="idle",
            condition = function(ud) --
                --local recheckFrame = commandedUnits[ud.unitID]
                local targetID = unitTarget[ud.unitID]
                --if automatedState[ud.unitID] == "repair" then
                --    spEchoLight("TargetID: "..(tostring(targetID) or "nil").." fullHealth: "..(isFullHealth(targetID) and "true" or"false").." in range: "..(targetIsInRange(ud.unitID, targetID, false)and"true"or"false"))
                --end

                if automatedState[ud.unitID] == "idle" then
                    return false end

                if reallyIdleUnits[ud.unitID] and automatedState[ud.unitID] == "harvest" and
                        WG.harvestState and WG.harvestState == "attacking" and
                        isnumber(targetID) then
                    return false end

                if automatedState[ud.unitID] == "harvest" and (WG.harvestState and WG.harvestState == "idle") then
                    return true end

                -- Checks below are all depending on having a target; if none, bail out
                if not isnumber(targetID) then
                    return true end

                return
                        (automatedState[ud.unitID] == "commanded")
                        or
                        --factory guarded but out of queue, Fac destroyed or no buildqueue
                        --TODO: Deautomate assisting units when factory is awaited
                        (automatedState[ud.unitID] == "assist" and
                                (not targetIsInRange(ud.unitID, targetID, false)
                                        or awaitedUnits[targetID]))
                        or
                        -- target unit destroyed or full health
                        (automatedState[ud.unitID] == "repair" and --not IsValidUnit(targetID) or
                                (isFullHealth(targetID) or (not targetIsInRange(ud.unitID, targetID, false))) )
                        or
                        -- reclaimed enemy unit destroyed
                        (automatedState[ud.unitID] == "enemyreclaim" and (not IsValidUnit(targetID) or not targetIsInRange(ud.unitID, targetID, false)) )
                        or
                        (automatedState[ud.unitID] == "reclaim" or automatedState[ud.unitID] == "resurrect")
                                and (not targetIsInRange(ud.unitID, targetID, true)) -- reclaimed feature destroyed or feature was rezzed

            end,
            action = function(ud)
                --forceUnitIdle(ud.unitID) --, automationLatency) | not implemented
                return "idle"
            end
    },
}

--- Goes through all the automatedFunctions, in order, and returns the new state, if the state-change succeeds
local function automateCheck(unitID, unitData, gameFrame, caller)
    --Spring.Echo("Checkpoint #2")

    if not unitData.unitDef or not IsValidUnit(unitID) or awaitedUnits[unitID] or automatedState[unitID] == "commanded" then
        return end

    --Spring.Echo("Checkpoint #3")

    local x, y, z = spGetUnitPosition(unitID)
    local pos = { x = x, y = y, z = z }

    --local radius = (unitDef.isBuilding or unitDef.speed==0)
    --        and (unitDef.buildDistance or 1)
    --        or (unitDef.buildDistance or 1) * 1.8

    --if unitDef.canFly then               -- Air units need that extra oomph || obsolete, now uses "2D" range
    --    radius = radius * 1.3
    --end

    --  local harvestWeapon = WeaponDefs[UnitDefs[unitDef.id].name.."_harvest_weapon"] -- eg: armck_harvest_weapon
    --local harvestRange = harvesters[unitID] and harvesters[unitID].harvestRange
    --local team = spGetUnitTeam(unitID)

    local ud = { unitID = unitID, unitDef = unitData.unitDef, pos = pos, radius = unitData.radius, harvestRange = unitData.harvestRange, orderIssued = nil,
                 team = unitData.team, frame = gameFrame }
    ud.nearestChunkID = getNearestChunkID(ud)

    -- Will try and (if condition succeeds) execute each automatedFunction, in order. #1 is highest priority, etc.
    for i = 1, #automatedFunctions do
        local autoFunc = automatedFunctions[i]
        if autoFunc.condition(ud) then
            ud.orderIssued = autoFunc.action(ud)
        end
        if ud.orderIssued then
            --Spring.Echo("Interrupting unitIdleEvent by orderIssued")
            unitIdleEvent[unitID] = nil
            break
        end
    end
    --Spring.Echo("Can assist: "..tostring(canassist[ud.unitDef.name]).." order Issued: "..tostring(ud.orderIssued).." has Resources: "..tostring(ud.hasResources))
    if ud.orderIssued then
        --Spring.Echo ("New order Issued: "..ud.orderIssued)
        unitsToAutomate[unitID] = nil
        setAutomateState(unitID, ud.orderIssued, caller.."> automateCheck")
        reallyIdleUnits[unitID] = nil
    --else
    --    automatedUnits[unitID] = spGetGameFrame() + reautomationLatency
    end
    return ud.orderIssued
end

--- Frame-based Update
function widget:GameFrame(f)
    for unitID, frame in pairs(unitFinishedNextFrame) do
        if f >= frame then
            unitTarget[unitID] = true
            setAutomateState(unitID, "commanded", "UnitFinished")
            --spEchoLight("unit "..unitID.." HasBuildQueue: "..tostring(HasBuildQueue(unitID) or "nil").." has commandQueue: "..tostring(HasCommandQueue(unitID) or "nil") )
            if (not HasBuildQueue(unitID)) and (not HasCommandQueue(unitID)) then
                -- This prevents widget:idle from blocking idle from ever being fired after the unit is built
                --spEchoLight("scheduling idle event")
                unitIdleEvent[unitID] = spGetGameFrame() + recheckLatency   -- Will confirm after 1 second (30f), by default
            end
            unitFinishedNextFrame[unitID] = nil
        end
    end

    if f % updateRate > 0.001 then
        return end

    --Spring.Echo("This frame: "..f.." deauto'ed unit #: "..(pairs_len(commandedUnits) or "nil").." toAutomate #: "..(pairs_len(unitsToAutomate) or "nil"))
    --Spring.Echo("Size of: unitIdleEvent = "..tablelength(unitIdleEvent)..", unitsToAutomate = "..tablelength(unitIdleEvent)..", automatedUnits = "..tablelength(automatedUnits))

    --- First let's verify if units tagged by widget:unitIdle are still idle, one second after the fact
    for unitID, recheckFrame in pairs(unitIdleEvent) do
        --Spring.Echo("Checking idleEvent for: "..(unitID or "nil")..", frame: "..f..", recheck fr: "..(recheckFrame or "nil")..", state: "..(automatedState[unitID] or "nil"))
        if f >= recheckFrame then
            if automatedState[unitID] ~= "harvest" then   -- while on harvest state, only unitai_auto_harvest can say if it's idle or not
                reallyIdleUnits[unitID] = true
                setAutomateState(unitID, "idle", "GameFrame")
                --    Spring.Echo("Setting idle state for: "..unitID)
                --else
                --    Spring.Echo("Wont set idle, "..unitID.." is harvesting.")
            end
            unitIdleEvent[unitID] = nil
        end
    end

    --- Check if it's time to actually try to automate an unit (after idle or creation)
    local i = 10
    for unitID, automateFrame in pairs(unitsToAutomate) do
        if i <= 0 then
            break end
        if IsValidUnit(unitID) and f >= automateFrame then
            --- PS: we only un-set unitsToAutomate[unitID] down the pipe, if automation is successful
            local orderIssued = automateCheck(unitID, unitData[unitID], f, "unitsToAutomate")
            if not orderIssued then --and automatedState[unitID] ~= "idle" then
                setAutomateState(unitID, "idle", "GameFrame: deautomate")   -- won't work if it's already idle
            end
        end
        i = i-1
    end

    --- Check if the automated unit should be doing something else instead of what's doing
    for unitID, recheckFrame in pairs(automatedUnits) do
        if IsValidUnit(unitID) and f >= recheckFrame then
            --Spring.Echo("rechecking "..unitID)
            if unitData[unitID] then
                automateCheck(unitID, unitData[unitID], f, "repurposeCheck")
            end
            --automatedUnits[unitID] = spGetGameFrame() + reautomationLatency
        end
    end
end

---- Initialize the unit when received (through sharing)
function widget:UnitGiven(unitID, unitDefID, unitTeam)
    widget:UnitCreated(unitID, unitDefID, unitTeam)
    widget:UnitFinished(unitID, unitDefID, unitTeam)
end

---- Decomissions the unit data when given away
function widget:UnitTaken(unitID, unitDefID, oldTeamID, teamID)
    widget:UnitDestroyed(unitID, unitDefID, oldTeamID)
end

local MAX_MORPH = 1024

function widget:CommandNotify(cmdID, params, options)
    if cmdID == CMD_WAIT then   -- prevents wait-state changes from inadvertently exiting wait status
        return end              -- awaitedUnits is set below, in widget:UnitCommand
    ---TODO: Fix, not working atm
    --local morphCmd
    --if (cmdID > 31410 and cmdID < 31410+MAX_MORPH)  or cmdID == CMD_MORPH_STOP or cmdID == CMD_MORPH_PAUSE or cmdID == CMD_MORPH_QUEUE then
    --    --Spring.Echo("Morph Command detected!")
    --    morphCmd = true
    --    return end
    local selUnits = spGetSelectedUnits()  --() -> { [1] = unitID, ... }
    for _, unitID in ipairs(selUnits) do
        --if morphCmd then
        --    --local x,y,z = spGetUnitPosition(unitID)
        --    --spGiveOrderToUnit(unitID, CMD_MOVE, {x+20, y, z+20}, { "" })
        --    setAutomateState(unitID, "idle", "UnitCommandNotify")
        --else
            if unitTarget[unitID] and IsValidUnit(unitID) then
                --Spring.Echo("Valid automatable unit got a user command "..unitID)
                if (cmdID == CMD_ATTACK or cmdID == CMD_UNIT_SET_TARGET) then
                    --spEcho("CMD_ATTACK, params #: "..#params)
                    if #params == 1 then -- and isOreChunk(params[1]) then
                        unitTarget[unitID] = params[1]    -- set Target
                    end
                end
                --- if it's working, don't touch it; also, check for area-move, area-repair, and area-reclaim here
                if automatedState[unitID] ~= "commanded" then
                    --and (cmdID == CMD_MOVE or cmdID == CMD_REPAIR or cmdID == CMD_RECLAIM) then
                    --Spring.Echo("Valid automatable unit got a move command "..unitID)
                    ---We do this to check if remove commands should be issued or not, down the pipe
                    if cmdID and cmdID < 0 then
                        --unitIdleEvent[unitID] = nil
                        --unitsToAutomate[unitID] = nil
                        removeCommands(unitID)
                        setAutomateState(unitID, "commanded", "UnitCommandBuild")
                    else
                        setAutomateState(unitID, "commanded", "UnitCommand")
                    end
                end
                if unitIdleEvent[unitID] then
                    --Spring.Echo("IdleEvent cancelled for "..(unitID or "nil"))
                    unitIdleEvent[unitID] = nil
                end
            end
    end
end

function widget:UnitCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOpts, cmdTag)
    if not IsValidUnit(unitID) or not unitTarget[unitID] then
        return end
    if cmdID == 2 then -- ugly hack to prevent state changes from inadvertently exiting wait status
        return end
    -- This is a condition/filter used by automateCheck
    if cmdID == CMD_WAIT then
        awaitedUnits[unitID] = not awaitedUnits[unitID]
        return
    end
    --if internalCmdEvent[unitID] then    -- may be removeCmds, or some delayed automation order
    --    internalCmdEvent[unitID] = nil
    --    unitIdleEvent[unitID] = nil
    --    return
    --end
    ----- if it's working, don't touch it; also, check for area-move, area-repair, and area-reclaim here
    --if automatedState[unitID] ~= "commanded" and not internalCmdEvent[unitID]
    --        and (cmdID == CMD_MOVE or cmdID == CMD_REPAIR or cmdID == CMD_RECLAIM) then
    --    --Spring.Echo("Valid automatable unit got a move command "..unitID)
    --    ---We do this to check if remove commands should be issued or not, down the pipe
    --    if cmdID and cmdID < 0 then
    --        setAutomateState(unitID, "commanded", "UnitCommandBuild")
    --    else
    --        setAutomateState(unitID, "commanded", "UnitCommand")
    --    end
    --end
    --Spring.Echo("IdleEvent cancelled for "..(unitID or "nil"))
end

----From unitai_auto_assist: Spring.SendLuaRulesMsg("harvestersToAutomate_"..ud.unitID,"allies")
function widget:RecvLuaMsg(msg, playerID)
    if msg:sub(1, 13) == 'harvesterIdle' then --"harvesterIdle_"..unitID
        local data = Split(msg, '_')
        local unitID = tonumber(data[2])
        --spEcho("Autoassist :: Idle Harvester: "..(unitID or "nil"))
        if IsValidUnit(unitID) then
            setAutomateState(unitID, "idle", "RecvLuaMsg")
        end
    end
end

function widget:ViewResize(n_vsx,n_vsy)
    vsx, vsy = glGetViewSizes()
    widgetScale = (0.50 + (vsx*vsy / 5000000))
end