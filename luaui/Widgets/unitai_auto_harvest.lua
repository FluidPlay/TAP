---------------------------------------------------------------------------------------------------------------------
-- IMPORTANT: Requires unitai_auto_assist.lua to work!
---------------------------------------------------------------------------------------------------------------------

function widget:GetInfo()
    return {
        name = "UnitAI Auto Harvest",
        desc = "Handles the Harvest cycle of Builders in the ai_builder_brain's 'harvest' state",
        author = "MaDDoX",
        date = "Feb 7, 2022",
        license = "GPLv3",
        layer = 16,
        enabled = true,
        handler = true,
    }
end

--- Harvest-cycle Priorities and Logic
---       idle - set to 'Harvest' mode (by unitai_auto_assist.lua) but still not automated
--- #1 :: attack - is NOT fully loaded & can harvest & has chunk nearby => attack nearest chunk
--- #2 :: deliver - is fully loaded, not in range of nearest ore tower => move to nearestOreTower, set current pos to 'returnpos'
--- #3 :: unloading - is on #deliver & has resources (partial or not) & in range of nearest ore tower => define return pos, stay still
--- #4 :: return - is on #unloading & has no resources & has return pos => move to return pos

---What's an "orphan harvester"?
---	- load < maxload & has no parentOretower
---	=> Find nearest ore tower and set parentOretower, new returnPos to it
---	=> Attack nearest ore Chunk
---
---What's an "unloading" harvester? (set by other logic) [ was "await"]
---=> Stay still
---=> Start being watched by game loop until it's unloaded, then set it to 'returning'
---
---What's a "returning" harvester?
---=> was unloading and is now fully unloaded (0 load), has parentOretower & returnPos
---=> Go to returnPos
---=> Once there, attack nearest ore Chunk
---=> if succeed, set it to 'attack'

-- "idle", "attacking", "delivering", "unloading", "returning"

VFS.Include("gamedata/tapevents.lua") --"LoadedHarvestEvent"
VFS.Include("gamedata/taptools.lua")
VFS.Include("gamedata/unitai_functions.lua")

local localDebug = false --|| Enables text state debug messages

local spGetAllUnits = Spring.GetAllUnits
local spGetUnitDefID = Spring.GetUnitDefID
--local spGetFeatureDefID = Spring.GetFeatureDefID
--local spValidFeatureID = Spring.ValidFeatureID
local spGetUnitPosition = Spring.GetUnitPosition
local spGetMyTeamID     = Spring.GetMyTeamID
local spGetMyAllyTeamID     = Spring.GetMyAllyTeamID
--local spGetUnitAllyTeam     = Spring.GetUnitAllyTeam
--local spGetFeaturePosition = Spring.GetFeaturePosition
--local spGetSelectedUnits = Spring.GetSelectedUnits
local spGiveOrderToUnit = Spring.GiveOrderToUnit
local spGetUnitSeparation = Spring.GetUnitSeparation
--local spSetUnitRulesParam = Spring.SetUnitRulesParam
--local spGetUnitHarvestStorage = Spring.GetUnitHarvestStorage
--local spGetTeamResources = Spring.GetTeamResources
local spGetUnitTeam    = Spring.GetUnitTeam
--local spGetUnitsInSphere = Spring.GetUnitsInSphere
--local spGetFeaturesInSphere = Spring.GetFeaturesInSphere
local spGetGameFrame = Spring.GetGameFrame
local spGetCommandQueue = Spring.GetCommandQueue -- 0 => commandQueueSize, -1 = table
local spGetUnitRulesParam = Spring.GetUnitRulesParam
local spSendLuaUIMsg = Spring.SendLuaUIMsg

local glGetViewSizes = gl.GetViewSizes
local myTeamID, myAllyTeamID = -1, -1
local gaiaTeamID = Spring.GetGaiaTeamID()

local startupGracetime = 60 --300        -- Widget won't work at all before those many frames (10s)
local updateRate = 22               -- Global update "tick rate" (always unsync it from unitai_auto_assist

local recheckLatency = 40 -- Delay until a commanded/idle unit checks for automation again
local automatedState = {}

local oretowerShortScanRange = 250 -- Collection-start scan range (not used here, only by auto_assist actually)
local oretowerLongScanRange = 900 -- Return/devolution scan range
local harvestLeashMult = 6        -- chunk search range is the harvest range* multiplied by this  (*attack range of weapon eg. "armck_harvest_weapon")

local vsx, vsy = gl.GetViewSizes()
local widgetScale = (0.50 + (vsx*vsy / 5000000))
local math_random = math.random

---=== Harvest-system related

-- ALERT: uDef.harvestStorage is not working (up to Spring 105)
local harvesters = {} -- { unitID = uDef.customParams.maxorestorage, parentOreTowerID, targetChunkID
--   returnPos = { x = rpx, y = rpy, z = rpz }, recheckFrame = spGetGameFrame + idleRecheckLatency }
--- Attack: actually harvesting; Deliver: going to the nearest ore tower; Unloading: in range of an ore tower, stopped and unloading;
--- Resume: returning to the previous harvest position, after delivery

---local automatedState = {}   -- This is the automated state. It's always there for automatableUnits, after the initial latency period
local harvestState = {}     -- Harvest state. // "idle", "attacking", "delivering", "unloading", "returning"
local oreTowerDefNames = { armmstor = true, cormstor = true, armuwadvms = true, coruwadvms = true,
                           bowhq = true, bowhq2 = true, bowhq3 = true, bowhq4 = true, bowhq5 = true, bowhq6 = true,
                           kernhq = true, kernhq2 = true, kernhq3 = true, kernhq4 = true, kernhq5 = true, kernhq6 = true,
}
local oreTowers = {}        -- { unitID = oreTowerReturnRange, ... }

--- Harvest-cycle state controllers
local oreChunks = {} --TODO
local orphanHarvesters = {}     -- { unitID = true, ... }    -- has no parentOretower assigned, "idle"
-- Post direct order                // { [unitID] = frameToTryReautomation, ... }
-- { [unitID] = frameToAutomate (eg: spGetGameFrame() + recheckUpdateRate), ... }
local automatedHarvesters = {}    -- { unitID = true, ... }    -- Basically the opposite of an 'orphanHarvester'

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
    armck = true, corck = true, armca = true, corca = true,
    armck2 = true, corck2 = true,
    armaca = true, coraca = true,
    armack = true, corack = true,
    armcv = true, corcv = true,
    armacv = true, coracv = true,
    --armcs = true, corcs = true,
    --armacsub = true, coracsub = true,
}

-----

local function spEcho(string)
    if localDebug then --and isCom(unitID) and state ~= "idle"
        Spring.Echo(string) end
end

--- If you left the game this widget has no raison d'etré
function widget:PlayerChanged()
    if Spring.GetSpectatingState() and Spring.GetGameFrame() > 0 then
        widgetHandler:RemoveWidget(self)
    end
end

local function removeAttack(unitID)
    --Spring.Echo("unitai_auto_harvest: removing Cmds")
    spGiveOrderToUnit(unitID, CMD_REMOVE, {CMD_ATTACK}, {"alt"})
end

local function deautomateUnit(unitID)
    removeAttack(unitID)  -- removes Guard, Patrol, Fight and Repair commands
    --spEcho("Deharvesting Unit: "..unitID)
    --harvestersInAction[unitID] = nil
    automatedHarvesters[unitID] = nil
    --spEcho("Auto harvest:: Deautomating Unit: "..unitID..", try re-automation in: "..harvesters[unitID].recheckFrame)
end

local function setHarvestState(unitID, state, caller) -- idle, attack, waitforunload, deliver, resume
    if not IsValidUnit(unitID) or not harvesters[unitID] then
        return end
    if state == "idle" then
        deautomateUnit(unitID)
        local randRecheckTime = math_random(1,3) * recheckLatency
        harvesters[unitID].recheckFrame = spGetGameFrame() + randRecheckTime
    end
    harvestState[unitID] = state
    --spEcho("New harvest State: ".. state .." for: "..unitID.." set by function: "..caller)
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
    automatedState = WG.automatedStates             -- Set by unitai_auto_assist
    harvesters = WG.harvesters          -- -- Set by unitai_auto_assist
    WG.harvestState = harvestState      -- This will allow the harvest state to be read and set by other widgets

    -- We do this to re-initialize (after /luaui reload) properly
    myTeamID = spGetMyTeamID()
    myAllyTeamID = spGetMyAllyTeamID
    local allUnits = spGetAllUnits()
    for i = 1, #allUnits do
        local unitID    = allUnits[i]
        local unitDefID = spGetUnitDefID(unitID)
        local unitTeam  = spGetUnitTeam(unitID)
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

function widget:UnitFinished(unitID, unitDefID, unitTeam)
    local unitDef = UnitDefs[unitDefID]
    if not unitDef then
        return end
    if oreTowerDefNames[unitDef.name] then
        oreTowers[unitID] = getOreTowerRange(nil, unitDef) end
    local maxorestorage = tonumber(unitDef.customParams.maxorestorage)
    if maxorestorage and maxorestorage > 0 then
        setHarvestState(unitID, "idle", "UnitFinished")
        --spEcho("Added harvester: "..unitID)
    end
end

function widget:UnitDestroyed(unitID)
    --if not IsValidUnit(unitID) then
    --    return end
    orphanHarvesters[unitID] = nil
    --- if an Ore Tower is destroyed, must go through all harvesters and clear their nearest/parentOreTower
    if oreTowers[unitID] then
        for harvesterID, data in pairs(harvesters) do
            if data.parentOreTowerID == unitID then
                harvesters[harvesterID].parentOreTowerID = nil
            end
        end
        oreTowers[unitID] = nil
    end
end

---returns spot = { x = x, z = z }
local function GetNearestSpotPos(x, z)
    local bestSpot
    local bestDist = math.huge
    local metalSpots = WG.metalSpots
    for i = 1, #metalSpots do
        local spot = metalSpots[i]
        local dx, dz = x - spot.x, z - spot.z
        local dist = dx*dx + dz*dz
        if dist < bestDist then
            bestSpot = spot
            bestDist = dist
        end
    end
    return bestSpot
end

local function checkParentOreTowerID(ud)
    if  ud.parentOreTowerID then
        return end
    local nearestOreTowerID = getNearestOreTowerID (ud, oreTowers, oretowerLongScanRange)
    ud.parentOreTowerID = nearestOreTowerID
    harvesters[ud.unitID].parentOreTowerID = nearestOreTowerID
end

--- Decides and issues orders on what to do around the unit, in this order (1 == higher):
--- 1. If it's not harvesting and there's a chunk nearby, harvest nearest chunk
--- 2. If it's harvesting and a) not fully loaded, just destroyed chunk => go for nearest chunk;
---                           b) fully loaded => go for nearest ore tower.
local automatedFunctions = {
    [1] = { id="delivering",
            condition = function(ud)
                --Spring.Echo("parent ore towerID: "..(ud.parentOreTowerID or "nil").." load perc: "..(harvesters[ud.unitID] and harvesters[ud.unitID].loadPercent or "nil").." harvest state: "..harvestState[ud.unitID])
                local loadPercent = getLoadPercentage(ud.unitID, ud.unitDef)
                return ud.parentOreTowerID and (harvestState[ud.unitID] == "attacking" or harvestState[ud.unitID] == "idle")
                        and ( loadPercent == 1 or ( loadPercent > 0 and not ud.nearestChunkID ) )
            end,
            action = function(ud)
                harvesters[ud.unitID].returnPos = { x = ud.pos.x, y = ud.pos.y, z = ud.pos.z }
                spGiveOrderToUnit(ud.unitID, CMD_REMOVE, {CMD_MOVE}, {"alt"})
                local x,y,z = spGetUnitPosition(ud.parentOreTowerID)
                spGiveOrderToUnit(ud.unitID, CMD_MOVE, {x, y, z}, { "" })
                return "delivering"
            end
    },
    [2] = { id="deliveringandaway", -- was delivering, somehow couldn't get to target
            condition = function(ud)
                return ud.parentOreTowerID and harvestState[ud.unitID] == "delivering" and ud.farFromOreTower and (spGetCommandQueue(ud.unitID, 0) < 1)
            end,
            action = function(ud)
                spGiveOrderToUnit(ud.unitID, CMD_REMOVE, {CMD_MOVE}, {"alt"})
                local x,y,z = spGetUnitPosition(ud.parentOreTowerID)
                spGiveOrderToUnit(ud.unitID, CMD_MOVE, {x, y, z}, { "" })
                --Spring.Echo("HARVESTER: Re-issued Command MOVE")
                return "delivering"
            end
    },
    [3] = { id="unloading",
            condition = function(ud) -- delivering => unloading
                return harvestState[ud.unitID] == "delivering"
                        and ud.parentOreTowerID and not ud.farFromOreTower
            end,
            action = function(ud)
                --spEcho("**2** Unloading Actions")
                spGiveOrderToUnit(ud.unitID, CMD_STOP, {} , CMD_OPT_RIGHT )
                return "unloading"
            end
    },
    [4] = { id="unloadingandpushed",
            condition = function(ud) -- delivering => unloading
                return harvestState[ud.unitID] == "unloading"
                        and ud.parentOreTowerID and ud.farFromOreTower
            end,
            action = function(ud)
                --spEcho("**2** Move back to range Actions")
                local x,y,z = spGetUnitPosition(ud.parentOreTowerID)
                spGiveOrderToUnit(ud.unitID, CMD_MOVE, {x, y, z}, { "" })
                return "delivering"
            end
    },
    [5] = { id="returning", -- Going back to returnPos (the start position before delivering)
            condition = function(ud)
                return harvestState[ud.unitID] == "unloading" -- has no resources & has return pos
                        and getUnitHarvestStorage(ud.unitID) <= 0 and ud.returnPos
            end,
            action = function(ud) --unitData
                --spEcho("**3** Returning Actions")
                local rp = ud.returnPos
                if rp.x then
                    ---TODO: Check if it's valid position, otherwise pick another recursively, closer to the oreTower
                    spGiveOrderToUnit(ud.unitID, CMD_MOVE, { rp.x, rp.y, rp.z }, { "" })
                    return "returning"
                end
            end
    },
    [6] = { id="returningandstuck",
            condition = function(ud)
                local rp = ud.returnPos
                local hasReturned = rp and rp.x and (sqrDistance(ud.pos.x, ud.pos.z, rp.x, rp.z) <= 140)
                return (harvestState[ud.unitID] == "returning")
                        and (not hasReturned) and (spGetCommandQueue(ud.unitID, 0) < 1)
            end,
            action = function(ud)
                --spEcho("**4** Return Unstucking Actions")
                local rp = ud.returnPos
                if rp and rp.x then
                    spGiveOrderToUnit(ud.unitID, CMD_MOVE, { rp.x, rp.y, rp.z }, { "" })
                end
                return "returning"
            end
    },
    [7] = { id="returned",
            condition = function(ud)
                local rp = ud.returnPos
                --Spring.Echo("*** returning dist: "..(sqrDistance(ud.pos.x, ud.pos.z, rp.x, rp.z) or "nil"))
                local hasReturned = rp and rp.x and (sqrDistance(ud.pos.x, ud.pos.z, rp.x, rp.z) <= 140) --was: 140
                return (harvestState[ud.unitID] == "returning") and hasReturned  -- distance to returnPos <= 40 (sqr)
            end,
            action = function(ud)
                --spEcho("**4** Returned Actions")
                harvesters[ud.unitID].returnPos = nil
                return "returned"
            end
    },
    [8] = { id="attacking",
            condition = function(ud)
                local loadPercent = getLoadPercentage(ud.unitID, ud.unitDef)
                return ud.nearestChunkID and (harvestState[ud.unitID] == "idle" or harvestState[ud.unitID] == "returned")
                        and canharvest[ud.unitDef.name]
                        and loadPercent < 1
            end,
            action = function(ud)
                --Spring.Echo("**5** Attacking actions - nearest chunk: "..(ud.nearestChunkID or "nil"))
                local dist = spGetUnitSeparation(ud.unitID, ud.nearestChunkID, true, false)
                --local x, y, z = spGetUnitPosition(ud.nearestChunkID)
                if dist > 50 then   --TODO: De-hardcode
                    spGiveOrderToUnit(ud.unitID, CMD_ATTACK, ud.nearestChunkID, { "" }) --"alt" favors reclaiming --Spring.Echo("Farking")
                    harvesters[ud.unitID].targetChunkID = ud.nearestChunkID
                    return "attacking"
                else
                    local unitPosX, unitPosY, unitPosZ = spGetUnitPosition(ud.unitID)
                    local nearestSpot = GetNearestSpotPos(unitPosX, unitPosZ) --spGetUnitPosition(ud.nearestChunkID)
                    local nudgeX = unitPosX - nearestSpot.x
                    local nudgeZ = unitPosZ - nearestSpot.z
                    spGiveOrderToUnit(ud.unitID, CMD_MOVE, { unitPosX + nudgeX, unitPosY, unitPosZ + nudgeZ }, { "" })
                    return "idle"
                end
            end
    },
    [9] = { id="idle",
            condition = function(ud) -- if full and no parent or nearby oreTower
                local nearestOreTowerID = getNearestOreTowerID(ud, oreTowers, oretowerShortScanRange)
                local loadPercent = getLoadPercentage(ud.unitID, ud.unitDef)
                local isReallyIdle = (not HasBuildQueue(ud.unitID)) and (not HasCommandQueue(ud.unitID))
                --spEcho("target Chunk: "..(ud.targetChunkID or "nil"))
                return  harvestState[ud.unitID] == "returningandstuck"
                        or
                        harvestState[ud.unitID] == "returning" and isReallyIdle
                        or
                        (harvestState[ud.unitID] == "attacking" and
                                (   (ud.targetChunkID == nil or not IsValidUnit(ud.targetChunkID)) --and (not nearestChunkID))
                                        --or isReallyIdle
                                        or
                                        (loadPercent >= 1 and (not ud.parentOreTowerID and not nearestOreTowerID))
                                )
                        )
                        or
                        (
                                (harvestState[ud.unitID] == "delivering" or harvestState[ud.unitID] == "unloading")
                                        and (not ud.parentOreTowerID and not nearestOreTowerID )
                        )
                        or
                        (
                                harvestState[ud.unitID] == "returned" and not ud.nearestChunkID
                        )
            end,
            action = function(ud)
                --spEcho("**6** Idle actions")
                harvesters[ud.unitID].parentOreTowerID = nil
                harvesters[ud.unitID].returnPos = nil
                if WG.automatedStates[ud.unitID] ~= "idle" then
                    WG.setAutomateState(ud.unitID, "idle", "autoHarvest")
                end
                --spGiveOrderToUnit(ud.unitID, CMD_STOP, {} , CMD_OPT_RIGHT )
                return "idle"
            end
    },
}

local function automateCheck(unitID, caller)
    if not IsValidUnit(unitID) then
        return end
    local unitDef = harvesters[unitID].unitDef
    if not unitDef then
        return end
    local x, y, z = spGetUnitPosition(unitID)
    local pos = { x = x, y = y, z = z }

    local radius = unitDef.buildDistance * 1.8
    if unitDef.canFly then               -- Air units need that extra oomph
        radius = radius * 1.3
    end

    -- During automation we check if the parentOreTowerID was destroyed and update it accordingly
    --- TODO: Move to destroy() maybe? One less thing to do every automateCheck update..
    local parentOreTowerID = harvesters[unitID].parentOreTowerID
    if not parentOreTowerID or not IsValidUnit(parentOreTowerID) then
        local nearestOreTowerID = NearestItemAround(unitID, pos, unitDef, oretowerShortScanRange, nil,
                function(x) return (oreTowers and oreTowers[x] or nil) end)
        parentOreTowerID = nearestOreTowerID
    end

    local ud = { unitID = unitID, unitDef = unitDef, pos = pos, radius = radius, orderIssued = nil,
                 returnPos = harvesters[unitID].returnPos, targetChunkID = harvesters[unitID].targetChunkID,
                 parentOreTowerID = parentOreTowerID, harvestRange = harvesters[unitID].harvestRange,
    }
    ud.nearestChunkID = getNearestChunkID(ud)

    checkParentOreTowerID(ud)
    ud.farFromOreTower = getFarFromOreTower(ud.unitID, oreTowers[ud.parentOreTowerID], ud.parentOreTowerID)

    -- Will try and (if condition succeeds) execute each automatedFunction, in order. #1 is highest priority, etc.
    for i = 1, #automatedFunctions do
        local autoFunc = automatedFunctions[i]
        if autoFunc.condition(ud) then
            ud.orderIssued = autoFunc.action(ud)
            break
        end
    end
    --- If any automation attempt above was successful, set new harvest state
    if ud.orderIssued then
        if ud.orderIssued == "idle" then
            --Spring.Echo ("Auto harvest:: Sending message: harvesterIdle_"..unitID)
            spSendLuaUIMsg("harvesterIdle_"..unitID, "allies") --(message, mode)
        end
        --spEcho ("Auto harvest:: New order Issued: "..ud.orderIssued)
        setHarvestState(unitID, ud.orderIssued, caller.."> automateCheck")
    end
    return ud.orderIssued
end

--- Frame-based Update
function widget:GameFrame(f)
    --if f < startupGracetime then
    --    return
    --end
    if f % updateRate < 0.001 then
        for harvesterID, data in pairs(harvesters) do
            --local maxStorage = data.maxorestorage
            --local curStorage = getUnitHarvestStorage(harvesterID) or 0
            --Spring.Echo("Harvester id: "..harvesterID.." state: "..automatedState[harvesterID].." recheckFrame: "..data.recheckFrame.." this Frame: "..f)
            if IsValidUnit(harvesterID) and automatedState[harvesterID] == "harvest" and f >= data.recheckFrame then
                --- Check/Update harvest Automation
                --local unitDef = UnitDefs[spGetUnitDefID(harvesterID)]
                automateCheck(harvesterID, "harvesters")
                -- Queue up the next automation test
                local randRecheckTime = math_random(1,3) * recheckLatency
                harvesters[harvesterID].recheckFrame = spGetGameFrame() + randRecheckTime
            end
        end
    end
    --- TODO: Orphans processing
    --- load < maxload & has no parentOretower
    --- => Find nearest ore tower and set parentOretower, new returnPos to it
    --- => Attack nearest ore Chunk
end

----From unitai_auto_assist or eco_ore_manager: Spring.SendLuaRulesMsg("msgKey_"..value, "allies")
function widget:RecvLuaMsg(msg, playerID)
    --if not playerID == myTeamID then
    --    return end
    --Spring.Echo("Message Received: "..msg)
    local data = Split(msg, '_')
    if data[1] == 'unitCommanded' then
        local unitID = tonumber(data[2])
        --Spring.Echo("Harvester To Deautomate: "..(unitID or "nil"))
        if unitID and harvesters[unitID] then
            setHarvestState(unitID, "idle", "RcvLuaMsg")
            --harvestersToAutomate[unitID] = true
        end
    end
    if data[1] == 'chunkDestroyed' then
        local thisChunkID = tonumber(data[2])
        --Spring.Echo("Chunk destroyed message received: "..(thisChunkID or "nil"))
        if thisChunkID then
            for harvesterID, data in pairs(harvesters) do
                if data.targetChunkID == thisChunkID then
                    harvesters[harvesterID].targetChunkID = nil
                    --local unitDef = UnitDefs[spGetUnitDefID(harvesterID)]
                    --automateCheck(harvesterID, "chunkDestroyed") --not needed
                end
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
