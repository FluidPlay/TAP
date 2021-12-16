---------------------------------------------------------------------------------------------------------------------
-- Comments: Sets all idle units that are not selected to fight. That has as effect to reclaim if there is low metal,
--	repair nearby units and assist in building if they have the possibility.
--	New: If you shift+drag a build order it will interrupt the current assist (from auto assist)
---------------------------------------------------------------------------------------------------------------------

function widget:GetInfo()
    return {
        name = "AI Builder Brain",
        desc = "Makes idle construction units and structures reclaim, repair nearby units and assist building",
        author = "MaDDoX, based on Johan Hanssen Seferidis' unit_auto_reclaim_heal_assist",
        date = "Oct 14, 2020",
        license = "GPLv3",
        layer = 0,
        enabled = true,
    }
end

VFS.Include("gamedata/tapevents.lua") --"LoadedHarvestEvent"
VFS.Include("gamedata/taptools.lua")

local localDebug = false --|| Enables text state debug messages

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

local startupGracetime = 300        -- Widget won't work at all before those many frames (10s)
local updateRate = 15               -- Global update "tick rate"
local automationLatency = 60        -- Delay before automation kicks in, or the unit is set to idle
--local repurposeLatency = 160        -- Delay before checking if an automated unit should be doing something else
local deautomatedRecheckLatency = 30 -- Delay until a de-automated unit checks for automation again
local reclaimRadius = 20            -- Reclaim commands issued by code apparently only work with a radius (area-reclaim)

local automatableUnits = {} -- All units which can be automated // { [unitID] = true|false, ... }
local unitsToAutomate = {}  -- These will be automated, but aren't there yet (on latency); can be interrupted by direct orders
local automatedUnits = {}   -- All units currently automated    // { [unitID] = frameToRecheckAutomation, ... }
local deautomatedUnits = {} -- Post deautomation (direct order) // { [unitID] = frameToTryReautomation, ... }
        -- { [unitID] = frameToAutomate (eg: spGetGameFrame() + recheckUpdateRate), ... }

local automatedState = {}   -- This is the automated state. It's always there for automatableUnits, after the initial latency period
local assistingUnits = {}    -- TODO: Commanders guarding factories, we use it to stop guarding when we're out of resources
--local orderRemovalDelay = 10    -- 10 frames of delay before removing commands, to prevent the engine from removing just given orders
--local internalCommandUIDs = {}
--local autoassistEnableDelay = 60

local vsx, vsy = gl.GetViewSizes()
local widgetScale = (0.50 + (vsx*vsy / 5000000))

---Harvest-system related
local oreTowerDefNames = { armmstor = true, cormstor = true, armuwadvms = true, coruwadvms = true, }
local loadedHarvesters = {}  -- { unitID = { x, y, z [[targetTowerPos]]}, ... }
local unloadingHarvesters = {}
local oreTowers = {}

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
local CMD_MOVE = CMD.MOVE
local CMD_STOP = CMD.STOP
local CMD_INSERT = CMD.INSERT

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
    ---TODO: RemoveCommands is not working here..
    spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_GUARD }, { "alt"})
    spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_PATROL }, { "alt"})
    spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_FIGHT }, { "alt"})
    spGiveOrderToUnit(unitID, CMD_REMOVE, { CMD_REPAIR }, { "alt"})
end

local function stopAssisting(unitID)
    --deautomated (while guarding) => assisting || no chg state
    --assisting => deautomated || doesnt remove guard
    
    --if assistingUnits[unitID] then
        removeCommands(unitID)
        assistingUnits[unitID] = nil
    --end
end

local function setAutomateState(unitID, state, caller)
    if state == "deautomated" then --or state == "idle" then
        automatedUnits[unitID] = nil
        --- It'll only get out of deautomated if it's idle, that's only the delay to recheck idle
        if not deautomatedUnits[unitID] then
            deautomatedUnits[unitID] = spGetGameFrame() + deautomatedRecheckLatency end
        spEcho("To automate in: "..spGetGameFrame() + deautomatedRecheckLatency)
    else
        deautomatedUnits[unitID] = nil
        automatedUnits[unitID] = spGetGameFrame() + automationLatency
    end
    automatedState[unitID] = state
    --Spring.Echo("New automateState: "..state.." for: "..unitID.." set by function: "..caller)
end

local function hasCommandQueue(unitID)
    local commandQueue = spGetCommandQueue(unitID, 0)
    --spEcho("command queue size: "..(commandQueue or "N/A"))
    --Spring.Echo("command queue size: "..(commandQueue or "N/A"))
    if commandQueue then
        return commandQueue > 0
    else
        return false
    end
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
    spEcho("build queue size: "..(buildqueue and #buildqueue or "N/A"))
    if buildqueue then
        return #buildqueue > 0
    else
        return false
    end
end

--local function isOreChunk(unitDef)
--    if unitDef.customParams and unitDef.customParams.isOreChunk then
--        return true end
--    return false
--end

--- Spring's UnitIdle is just too weird, it fires up when units are transitioning between commands..
--function widget:UnitIdle(unitID, unitDefID, unitTeam)
local function customUnitIdle(unitID, delay)
    if not automatableUnits[unitID] then
        return end
    spEcho("Unit ".. unitID.." is idle.") --UnitDefs[unitDefID].name)
    --if myTeamID == spGetUnitTeam(unitID) then --check if unit is mine
    ---If unit is on "assist" state and its guarded unit has no buildqueue, remove its guard command.
    if assistingUnits[unitID] then
        local assistedUnit = assistingUnits[unitID]
        if IsValidUnit(unitID) and IsValidUnit(assistedUnit) and not hasBuildQueue(assistedUnit) then
            --Spring.Echo("Removing guard")
            stopAssisting(unitID) --- We need to remove Guard commands, otherwise the unit will keep guarding
        end
    end
    setAutomateState(unitID, "deautomated", "customUnitIdle")
end

local function DeautomateUnit(unitID)
    removeCommands(unitID)  -- removes Guard, Patrol, Fight and Repair commands

    --spGiveOrderToUnit(unitID, CMD_STOP, {}, {} )
    spEcho("Deautomating Unit: "..unitID)
    setAutomateState(unitID, "deautomated", "DeautomateUnit")
end

--- If you left the game this widget has no raison d'etré
function widget:PlayerChanged()
    if Spring.GetSpectatingState() and Spring.GetGameFrame() > 0 then
        widgetHandler:RemoveWidget(self)
    end
end

local function setLoadedHarvester(harvesterTeam, unitID, value)
    --Spring.Echo("Harvester team: "..(harvesterTeam or "nil").." my team: "..myTeamID.." unitID: "..unitID.." value: "..tostring(value))
    if (harvesterTeam ~= myTeamID) then
        return end
    loadedHarvesters[unitID] = value
end

---- Disable widget if I'm spec
function widget:Initialize()
    widgetHandler:RegisterGlobal(LoadedHarvesterEvent, setLoadedHarvester)

    WG.automatedStates = automatedState  -- This will allow the state to be read and set by other widgets
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
        --local unitTeam  = spGetUnitTeam(unitID)
        widget:UnitCreated(unitID, unitDefID) --, unitTeam)
        widget:UnitFinished(unitID, unitDefID) --, unitTeam)
    end
end

function widget:UnitCreated(unitID, unitDefID, teamID, builderID)
    -- If unit just created is a mobile unit, add it to array
    local uDef = UnitDefs[unitDefID]
    if not uDef.isImmobile then
        WIPmobileUnits[unitID] = true
    end
    local unitDef = UnitDefs[unitDefID]
    if canrepair[unitDef.name] or canresurrect[unitDef.name] then
        spEcho("Registering unit "..unitID.." as automatable: "..unitDef.name)--and isCom(unitID)
        automatableUnits[unitID] = true
    end
end

function widget:UnitFinished(unitID, unitDefID, unitTeam)
    if myTeamID==unitTeam then					--check if unit is mine
        local unitDef = UnitDefs[unitDefID]
        if oreTowerDefNames[unitDef.name] then
            --Spring.Echo("Widget: Ore Tower added: "..unitID)
            oreTowers[unitID] = unitDef.buildDistance or 330 -- 330 is lvl1 outpost build range
        end
        if not unitDef.isBuilding then
            WIPmobileUnits[unitID] = false
        end
        if canrepair[unitDef.name] or canresurrect[unitDef.name] then
            setAutomateState(unitID, "deautomated", "DeautomateUnit")
            --unitsToAutomate[unitID] = spGetGameFrame() + automationLatency --that's the frame it'll try automation
            --customUnitIdle(unitID)
        end
    end
end

function widget:UnitDestroyed(unitID)
    automatableUnits[unitID] = nil
    unitsToAutomate[unitID] = nil
    automatedUnits[unitID] = nil
    deautomatedUnits[unitID] = nil
    automatedState[unitID] = nil
    assistingUnits[unitID] = nil

    oreTowers[unitID] = nil
    loadedHarvesters[unitID] = nil
    unloadingHarvesters[unitID] = nil
end

---- Initialize the unit when received (shared)
function widget:UnitGiven(unitID, unitDefID, unitTeam)
    widget:UnitFinished(unitID, unitDefID, unitTeam)
end

function widget:UnitTaken(unitID, unitDefID, oldTeamID, teamID)
    widget:UnitDestroyed(unitID, unitDefID, oldTeamID)
end

local enoughResourcesThreshold = 0.1 -- for 0.1, 'enough' is more than 10% storage

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

local function getNearest (originUID, targets, isFeature)
    local nearestSqrDistance = 999999
    local nearestItemID = #targets > 0 and targets[1] or nil    --safe check

    local ox,oy,oz = spGetUnitPosition(originUID)
    local origin = {x = ox, y = oy, z = oz}
    for targetID in pairs(targets) do
        local x,y,z
        if isFeature then
            x,y,z = spGetFeaturePosition(targetID)
        else
            x,y,z = spGetUnitPosition(targetID) end
        local target = { x = x, y = y, z = z }
        local thisSqrDist = sqrDistance(origin.x, origin.z, target.x, target.z)
        if isnumber(thisSqrDist) and isnumber(nearestSqrDistance)
                and (thisSqrDist < nearestSqrDistance) then
            nearestItemID = targetID
            nearestSqrDistance = thisSqrDist
        end
    end
    return nearestItemID
end

-- typeCheck is a function (checking for true), if not defined it just returns the nearest unit
-- idCheck is a function (checking for true), checks the targetID to see if it fits a certain criteria
local function nearestItemAround(unitID, pos, unitDef, radius, uDefCheck, uIDCheck, isFeature, teamID, allyTeamID)
    if teamID == nil then
        teamID = myTeamID end

    --TODO: Add "ally", "enemy", "neutral"; or finish processing allyTeamID
    local itemsAround = isFeature
            and spGetFeaturesInCylinder(pos.x, pos.z, radius)
            or spGetUnitsInCylinder(pos.x, pos.z, radius, teamID)
    if not istable(itemsAround) then
        return nil end
    local targets = {}
    --- Get list of valid targets
    for _,targetID in pairs(itemsAround) do
        if isFeature and spValidFeatureID(targetID) then
            local targetDefID = spGetFeatureDefID(targetID)
            local targetDef = (targetDefID ~= nil) and FeatureDefs[targetDefID] or nil
            --if targetDef and targetDef.isFactory then ==> eg.: function(x) return x.isFactory end
            if targetDef and (uDefCheck == nil or uDefCheck(targetDef))
                and (uIDCheck == nil or uIDCheck(targetID)) then
                targets[targetID] = true
            end
        elseif IsValidUnit(targetID) and targetID ~= unitID then
            local targetDefID = spGetUnitDefID(targetID)
            local targetDef = (targetDefID ~= nil) and UnitDefs[targetDefID] or nil
            if targetDef and (uDefCheck == nil or uDefCheck(targetDef))
                and (uIDCheck == nil or uIDCheck(targetID)) then
                targets[targetID] = true
            end
        end
    end
    return getNearest (unitID, targets, isFeature)
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
--- 4. If has no weapon (outpost, FARK, etc), reclaim enemy units;
--- 5. If can resurrect, resurrect nearest feature (check for economy? might want to reclaim instead)
--- 6. If can assist, guard nearest factory
--- 7. If can repair, repair nearest allied unit with less than 90% maxhealth.
--- 8. Reclaim nearest feature (prioritize metal)

local automatedFunctions = {
                            harvest = { condition = function(ud) -- Commanders shouldn't prioritize harvesting; harvester can't be fully loaded
                                                            return automatedState[ud.unitID] ~= "harvest" and canharvest[ud.unitDef.name]
                                                                and not loadedHarvesters[ud.unitID]
                                                            end,
                                           action = function(ud) --unitData
                                               spEcho("**1** Harvest - nearest chunk: "..(ud.nearestChunkID or "nil"))
                                               if ud.nearestChunkID and automatedState[ud.unitID] ~= "harvest" then
                                                   local x, y, z = spGetUnitPosition(ud.nearestChunkID)
                                                   --spGiveOrderToUnit(ud.unitID, CMD_ATTACK, ud.nearestChunkID, {} ) --{ x, y, z, 50 } <= requires attack ground
                                                   spGiveOrderToUnit(ud.unitID, CMD_ATTACK, ud.nearestChunkID, {}) --"alt" favors reclaiming --Spring.Echo("Farking")
                                                   return "harvest"
                                               end
                                               return nil
                                           end
                            },
                            deliver = { condition = function(ud) -- Only for fully loaded harvesters (including Comms this time)
                                                        return automatedState[ud.unitID] == "harvest" and automatedState[ud.unitID] ~= "deliver"
                                                            and loadedHarvesters[ud.unitID]
                                                        end,
                                            action = function(ud) --unitData
                                                spEcho("**2** Delivery check")
                                                --Spring.Echo("1; nearestOreTowerID: "..(ud.nearestOreTowerID or "nil"))
                                                if ud.nearestOreTowerID and automatedState[ud.unitID] ~= "deliver" then
                                                    local x,y,z = spGetUnitPosition(ud.nearestOreTowerID)
                                                    spGiveOrderToUnit(ud.unitID, CMD_REMOVE, {CMD_MOVE}, {"alt"})
                                                    spGiveOrderToUnit(ud.unitID, CMD_MOVE, {x, y, z }, { "" })
                                                    return "deliver"
                                                end
                                                return nil
                                            end
                            },
                            enemyreclaim = { condition = function(ud)  -- Commanders shouldn't prioritize enemy-reclaiming
                                                                return automatedState[ud.unitID] ~= "harvest" and automatedState[ud.unitID] ~= "deliver"
                                                                        and automatedState[ud.unitID] ~= "enemyreclaim" and not ud.unitDef.customParams.iscommander
                                                          end,
                                              action = function(ud) --unitData
                                                  --Spring.Echo("[1] Enemy-reclaim check")
                                                          local nearestEnemy = spGetUnitNearestEnemy(ud.unitID, ud.radius, false) -- useLOS = false ; => nil | unitID
                                                          if nearestEnemy and automatedState[ud.unitID] ~= "enemyreclaim" then
                                                              spGiveOrderToUnit(ud.unitID, CMD_RECLAIM, { nearestEnemy }, {} )
                                                              return "enemyreclaim"
                                                          end
                                                          return nil
                                                       end
                            },
                            resurrect = { condition =  function(ud)
                                                            return canresurrect[ud.unitDef.name] and not ud.orderIssued
                                                                    and automatedState[ud.unitID] ~= "harvest" and automatedState[ud.unitID] ~= "enemyreclaim"
                                                                    and automatedState[ud.unitID] ~= "deliver" and automatedState[ud.unitID] ~= "resurrect"
                                                                    and ud.hasEnergy -- must have enough "E" to resurrect stuff
                                                        end,
                                           action = function(ud) --unitData
                                               --Spring.Echo("[2] Ressurect check")
                                               if ud.nearestFeatureID and automatedState[ud.unitID] ~= "resurrect" then
                                                   local x,y,z = spGetFeaturePosition(ud.nearestFeatureID)
                                                   spGiveOrderToUnit(ud.unitID, CMD_INSERT, {-1, CMD_RESURRECT, CMD_OPT_INTERNAL+1,x,y,z,20}, {"alt"})  --shift
                                                   return "resurrect"
                                               end
                                               return nil
                                           end
                            },
                            assist = { condition =  function(ud) --unitData
                                                         return canassist[ud.unitDef.name] and not ud.orderIssued
                                                                 and automatedState[ud.unitID] ~= "harvest" and automatedState[ud.unitID] ~= "deliver"
                                                                 and automatedState[ud.unitID] ~= "enemyreclaim" and automatedState[ud.unitID] ~= "resurrect"
                                                                 and automatedState[ud.unitID] ~= "assist" and ud.hasResources
                                                     end,
                                        action = function(ud)
                                                     --Spring.Echo("[3] Factory-assist check")
                                                     --TODO: If during 'automation' it's guarding a factory but factory stopped production, remove it
                                                     --Spring.Echo ("Autoassisting factory: "..(nearestFactoryUnitID or "nil").." has eco: "..tostring(enoughEconomy()))
                                                     if ud.nearestFactoryID then
                                                         spGiveOrderToUnit(ud.unitID, CMD_GUARD, { ud.nearestFactoryID }, {} )
                                                         assistingUnits[ud.unitID] = ud.nearestFactoryID    -- guardedUnit
                                                         return "assist"
                                                     end
                                                     return nil
                                                 end
                            },
                            repair = { condition = function(ud) --unitData
                                                         return canrepair[ud.unitDef.name] and not ud.orderIssued
                                                                 and automatedState[ud.unitID] ~= "harvest" and automatedState[ud.unitID] ~= "deliver"
                                                                 and automatedState[ud.unitID] ~= "enemyreclaim" and automatedState[ud.unitID] ~= "resurrect"
                                                                 and automatedState[ud.unitID] ~= "assist" and automatedState[ud.unitID] ~= "repair" and ud.hasEnergy
                                                    end,
                                        action = function(ud)
                                            --Spring.Echo("[3] Repair check")
                                            local nearestTargetID
                                            if canassist[ud.unitDef.name] then
                                                nearestTargetID = ud.nearestUID
                                            else
                                                nearestTargetID = ud.nearestRepairableID -- only finished units can be targetted then
                                            end
                                            if nearestTargetID and automatedState[ud.unitID] ~= "repair" then
                                                --spGiveOrderToUnit(unitID, CMD_INSERT, {-1, CMD_REPAIR, CMD_OPT_INTERNAL+1,x,y,z,80}, {"alt"})
                                                spGiveOrderToUnit(ud.unitID, CMD_REPAIR, { nearestTargetID }, {} )
                                                return "repair"
                                            end
                                            return nil
                                        end
                            },
                            reclaim = { condition = function(ud) --unitData
                                                        return canreclaim[ud.unitDef.name] and not ud.orderIssued
                                                            and automatedState[ud.unitID] ~= "harvest" and automatedState[ud.unitID] ~= "deliver"
                                                            and automatedState[ud.unitID] ~= "enemyreclaim" and automatedState[ud.unitID] ~= "resurrect"
                                                            and automatedState[ud.unitID] ~= "assist" and automatedState[ud.unitID] ~= "repair"
                                                            and automatedState[ud.unitID] ~= "reclaim"
                                                     end,
                                        action = function(ud)
                                            --Spring.Echo("[3] Reclaim check")
                                            if ud.nearestMetalID and not ud.hasMetal then
                                                local x,y,z = spGetFeaturePosition(ud.nearestMetalID)
                                                spGiveOrderToUnit(ud.unitID, CMD_INSERT, {-1, CMD_RECLAIM, CMD_OPT_INTERNAL+1,x,y,z,reclaimRadius}, {"alt"})
                                                return "reclaim"
                                            elseif ud.nearestEnergyID and not ud.hasEnergy then
                                                -- If not, we'll check if there's an energy resource nearby and if we're not flooding energy, reclaim it
                                                local x,y,z = spGetFeaturePosition(ud.nearestEnergyID)
                                                spGiveOrderToUnit(ud.unitID, CMD_INSERT, {-1, CMD_RECLAIM, CMD_OPT_INTERNAL+1,x,y,z,reclaimRadius}, {"alt"})
                                                return "reclaim"
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

    local nearestUID = nearestItemAround(unitID, pos, unitDef, radius, nil,
                                 function(x)
                                            --local isAllied = spGetUnitAllyTeam(unitID) == myAllyTeamID
                                            local health,maxHealth = spGetUnitHealth(x)
                                            return (health < (maxHealth * 0.99)) end)
    local nearestRepairableID = nearestItemAround(unitID, pos, unitDef, radius, nil,
                                    function(x)
                                                local health,maxHealth,_,_,done = spGetUnitHealth(x)
                                                return (done and health < (maxHealth * 0.99)) end )
    local nearestFeatureID = nearestItemAround(unitID, pos, unitDef, radius, nil, nil, true)
    local nearestChunkID = nearestItemAround(unitID, pos, unitDef, radius,
                                            function(x) return (x.customParams and x.customParams.isorechunk) end, --unitDef check
                                            nil, false, gaiaTeamID)

    --TODO (WIP): 0. If it's fully loaded, go to the nearest ore tower
        --- Else, if it's harvesting and the harvested unit got destroyed (get from eco_builder_harvest), search a nearby done
        --- If none found, do nothing (Should search for other automated states)
    local nearestOreTowerID = nearestItemAround(unitID, pos, unitDef, 900, nil, --TODO: De-hardcode search range
                                        function(x) return (oreTowers and oreTowers[x] or nil) end) --,
                                        --nil, false, nil, spGetUnitAllyTeam(unitID))

    --local nearestDeliveryPos
    --if (nearestOreTowerID) then
    --    local oreTowerx, _, oreTowerz = spGetUnitPosition(nearestOreTowerID)
    --    local offset = tonumber(spGetUnitRulesParam(nearestOreTowerID, "oretowerrange"))-25 or 200
    --    local xsign = sign(oreTowerx - x)
    --    local zsign = sign(oreTowerz - z)
    --    nearestDeliveryPos = { x = oreTowerx-(xsign*offset), y = y, z = oreTowerz-(zsign*offset) }
    --end

    local nearestFactoryID = nearestItemAround(unitID, pos, unitDef, radius,
                                                    function(x) return x.isFactory end,     --We're only interested in factories currently producing
                                                    function(x) return hasBuildQueue(x) end)
    local nearestMetalID = nearestItemAround(unitID, pos, unitDef, radius, nil,
                                                    function(x)
                                                        local remainingMetal,_,remainingEnergy = spGetFeatureResources(x) --feature
                                                        return remainingMetal and remainingEnergy and remainingMetal > remainingEnergy end,
                                             true)
    local nearestEnergyID = nearestItemAround(unitID, pos, unitDef, radius, nil, nil,true)

    local ud = { unitID = unitID, unitDef = unitDef, pos = pos, radius = radius, orderIssued = nil,
                 hasEnergy = resourcesCheck("e"), hasResources = resourcesCheck(), hasMetal = resourcesCheck("m",true),
                 nearestUID = nearestUID, nearestRepairableID = nearestRepairableID, nearestFactoryID = nearestFactoryID,
                 nearestFeatureID = nearestFeatureID, nearestChunkID = nearestChunkID, nearestOreTowerID=nearestOreTowerID, --nearestDeliveryPos = nearestDeliveryPos,
                 nearestEnergyID = nearestEnergyID, nearestMetalID = nearestMetalID,
               }

    --- 0. If it's a harvester, harvest nearby ore chunk;
    if automatedFunctions["harvest"].condition(ud) then
        ud.orderIssued = automatedFunctions["harvest"].action(ud)
        automatedState[unitID] = "harvest"
    --else
    --    spEcho("Harvest condition not met")
    end
    if automatedFunctions["deliver"].condition(ud) then
        ud.orderIssued = automatedFunctions["deliver"].action(ud)
        automatedState[unitID] = "deliver"
        local pos
        if (nearestOreTowerID) then
            x,y,z = spGetUnitPosition(nearestOreTowerID)
            loadedHarvesters[unitID] = { x = x, y = y, z = z } --loadedHarvesters is set to true first, then tower pos
        else
            loadedHarvesters[unitID] = true
        end
    --else
    --    Spring.Echo("Deliver condition not met ... State: "..automatedState[unitID].." loadedHarvester: "..(tostring(loadedHarvesters[unitID]) or "nil"))
    end
    --- 1. If has no weapon (outpost, FARK, etc), reclaim enemy units;
    if automatedFunctions["enemyreclaim"].condition(ud) then
        ud.orderIssued = automatedFunctions["enemyreclaim"].action(ud)
    end
    --- 2. If can resurrect, resurrect nearest feature
    if automatedFunctions["resurrect"].condition(ud) then
        ud.orderIssued = automatedFunctions["resurrect"].action(ud)
    end
    --- 3. If can assist (and has enough resources), guard nearest factory
    if automatedFunctions["assist"].condition(ud) then
        ud.orderIssued = automatedFunctions["assist"].action(ud)
    end
    --- 4. If can repair, repair nearest allied unit with less than 90% maxhealth.
    if automatedFunctions["repair"].condition(ud) then
        ud.orderIssued = automatedFunctions["repair"].action(ud)
    end
    --- 5. Reclaim nearest feature
    ---(TODO: prioritize metal) A metal feature has metal amount > energy, similar logic for an "energy" feature
    if automatedFunctions["reclaim"].condition(ud) then
        ud.orderIssued = automatedFunctions["reclaim"].action(ud)
    end

    if ud.orderIssued then
        spEcho ("New order Issued")
        unitsToAutomate[unitID] = nil
        setAutomateState(unitID, ud.orderIssued, caller.."> automateCheck")
    end
    return ud.orderIssued
end

function widget:CommandNotify(cmdID, params, options)
    -- spEcho("CommandID registered: "..(cmdID or "nil"))
    ---TODO: If guarding, interrupt what's doing, otherwise don't
    -- User commands are tracked here, check what unit(s) is/are selected and remove it from automatedUnits
    local selUnits = spGetSelectedUnits()  --() -> { [1] = unitID, ... }
    for _, unitID in ipairs(selUnits) do
        if automatableUnits[unitID] and IsValidUnit(unitID) then
            if automatedState[unitID] ~= "deautomated" then -- if it's working, don't touch it
               --guardingUnits[unitID] then --options.shift and
                DeautomateUnit(unitID)
            end
            --deassistCheck(unitID) --- We need to remove Guard commands, otherwise the unit will keep guarding
        end
    end
end

local function isReallyAssisting(unitID)
    if not IsValidUnit(unitID) then
        return false end
    local assistedUnit = assistingUnits[unitID]
    if not assistedUnit or not IsValidUnit(assistedUnit)
        or not hasBuildQueue(assistedUnit) then
           return false end
    return true
end

local function isReallyIdle(unitID)
    local result = true
    -- commandqueue with guard => not idle
    if hasBuildQueue(unitID) then
        result = false end
    if hasCommandQueue(unitID) then
        --if isReallyAssisting(unitID) then
        result = false
        --end
    end
    --Spring.Echo("IsReallyIdle: "..tostring(result))
    return result
end

--- Frame-based Update
function widget:GameFrame(f)
    if f < startupGracetime or f % updateRate > 0.001 then
        return
    end

    spEcho("This frame: "..f.." deauto'ed unit #: "..(pairs_len(deautomatedUnits) or "nil").." toAutomate #: "..(pairs_len(unitsToAutomate) or "nil"))

    for unitID, nearestOreTowerID in pairs(loadedHarvesters) do
        if IsValidUnit(unitID) and IsValidUnit(nearestOreTowerID) and spGetUnitSeparation(unitID, nearestOreTowerID, false) < 250 then
            loadedHarvesters[unitID] = nil
            spGiveOrderToUnit(unitID, CMD_STOP)
            unloadingHarvesters[unitID] = nearestOreTowerID
            setAutomateState(unitID, "waitforunload", "GameFrame")
        end
    end

    for unitID, nearestOreTowerID in pairs(unloadingHarvesters) do
        --If harvestLoad == 0, set it to idle again
        if spGetUnitHarvestStorage(unitID) <= 0 then
            setAutomateState(unitID, "deautomated", "GameFrame")
            unloadingHarvesters[unitID] = nil
        end
    end

    ----- Deautomated units check || Done by unitsToAutomate / idle above
    for unitID, recheckFrame in pairs(deautomatedUnits) do
        if IsValidUnit(unitID) and f >= recheckFrame then --and not unitsToAutomate[unitID] then
            spEcho("0")
            if isReallyIdle(unitID) then
                stopAssisting(unitID)
                if automatedState[unitID] ~= "deautomated" then
                   customUnitIdle(unitID, 0)
                elseif not unitsToAutomate[unitID] then
                   unitsToAutomate[unitID] = spGetGameFrame() + deautomatedRecheckLatency
                end
                --if not hasBuildQueue(guardedUnit) then -- builders assisting *do* have a commandqueue (guard)
                --    deassistCheck(unitID) end --- We need to remove Guard commands, otherwise the unit will keep guarding
            else
                unitsToAutomate[unitID] = nil
            end
        end
    end

    -- Check if it's time to actually try to automate an unit (after idle or creation)
    --spEcho(pairs_len(unitsToAutomate).." unit(s) to automate")
    for unitID, automateFrame in pairs(unitsToAutomate) do
        if IsValidUnit(unitID) and f >= automateFrame then
            spEcho("1")
            --Spring.Echo("1")
            local unitDef = UnitDefs[spGetUnitDefID(unitID)]
            --- We only un-set unitsToAutomate[unitID] down the pipe, if automation is successful
            local orderIssued = automateCheck(unitID, unitDef, "unitsToAutomate")
            if not orderIssued and not automatedState[unitID] then
                --spEcho("1.5")
                --automatedState[unitID] = "scanning" -- While it doesn't find a chance to be automated, it'll be "automating"
                --unitsToAutomate[unitID] = spGetGameFrame() + automationLatency
                setAutomateState(unitID, "deautomated", "DeautomateUnit")
            end
        end
    end

    for unitID, recheckFrame in pairs(automatedUnits) do
        spEcho("2")
        local unitState = automatedState[unitID]
        if IsValidUnit(unitID) and f >= recheckFrame then
            --- Checking for Idle (let's dodge Spring's default idle, its event fires in unwanted situations)
            spEcho("[automated] Checking "..unitID.." for idle; automatedState: "..(automatedState[unitID] or "nil"))
            if isReallyIdle(unitID) then
                customUnitIdle(unitID, automationLatency)
            else
                automatedUnits[unitID] = spGetGameFrame() + automationLatency
            end

            ----- Rechecking if a repairing/building unit has better things to do (like assist or resurrect)
            if unitState ~= "deautomated" then
                local unitDef = UnitDefs[spGetUnitDefID(unitID)]    --TODO: Optimization - cache this within automatableUnits
                spEcho("[automated] Rechecking automation of unitID: "..unitID)
                automateCheck(unitID, unitDef, "repurposeCheck")
            end
            --- We need to remove Guard commands, otherwise the unit will keep guarding
            if assistingUnits[unitID] and not isReallyAssisting(unitID) then
                stopAssisting(unitID) end
        end
    end
end

function widget:ViewResize(n_vsx,n_vsy)
    vsx, vsy = glGetViewSizes()
    widgetScale = (0.50 + (vsx*vsy / 5000000))
end


--
--function widget:DrawScreen()
--    if not localDebug then
--        return end
--    local textSize = 22
--
--    gl.PushMatrix()
--    gl.Translate(50, 50, 0)
--    gl.BeginText()
--    for unitID, state in pairs(automatedState) do
--        if spIsUnitInView(unitID) then
--            --local sx, sy = 1000, 500
--            local x, y, z = spGetUnitViewPosition(unitID)
--            --            local x, y, z = spGetUnitPosition(unitID)
--            local sx, sy, sz = Spring.WorldToScreenCoords(x, y, z)
--            gl.Text(state, sx, sy, textSize, "ocd")
--        end
--    end
--    gl.EndText()
--    gl.PopMatrix()
--end

--function widget:DrawScreen()
--    if not glDebugStates or Spring.IsGUIHidden() then
--        return end
--    local textSize = 14
--    gl.PushMatrix()
--    for unitID, state in pairs(automatedUnits) do
--        if spIsUnitInView(unitID) then
--            spEcho("unitid/state: "..unitID..", "..state)
--
--            --local x, y, z = spGetUnitViewPosition(unitID)
--            local x, y, z = spGetUnitPosition(unitID)
--            local sx, sy, sz = Spring.WorldToScreenCoords(x, y, z)
--            --glTranslate(50, 50, 0)
--            --glBillboard()
--            --font:SetOutlineColor(outlineColor)
--            --font:Print(state, sx, sy, loadedFontSize, "con")
--            --glText(state, 0, 0, 28, 'ocd')
--
--            SetColor(1.0, 1.0, 0.7, 1.0)
--            glText(""..(state or "nil"), sx, sy, textSize, "ocd")
--        end
--    end
--    gl.PopMatrix()
--end