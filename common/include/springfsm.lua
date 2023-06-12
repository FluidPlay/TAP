---
--- Created by Breno "MaDDoX" Azevedo
--- DateTime: 6/10/2023 1:19 PM
---
--- HOW-TO: Include it in your gadget or widget; Use the setupFSM function; Check for example code at the bottom
--============================

local spValidUnitID = Spring.ValidUnitID
local spGetUnitDefID = Spring.GetUnitDefID
local spGetUnitIsDead = Spring.GetUnitIsDead
local spSendLuaUIMsg = Spring.SendLuaUIMsg
local spGetGameFrame = Spring.GetGameFrame
local spEcho = Spring.Echo

local function isnumber(v) return (type(v)=="number") end
trackedUnits = {}

fsmState = {}
fsmBehavior = {}

automatedUnits = {}
idleUnits = {}

debug = false                 -- By default this is false, but can be turned on selectively by the fsmCheck call option
recheckLatency = 30           -- Delay until a "commanded" or "idle" unit checks for automation again
updateRate = 6

local function dbgEcho(msg)
    if (debug) then
        spEcho(msg)
    end
end

-- Local version from taptools, to make things lighter
local function IsValidUnit(unitID)
    if not isnumber(unitID) then
        return false end
    local unitDefID = spGetUnitDefID(unitID)
    if unitDefID and spValidUnitID(unitID) and not spGetUnitIsDead(unitID) then
        return true
    end
    return false
end

local function setUnitAutomated(unitID, enabled)
    if automatedUnits[unitID] == enabled then
        return end
    automatedUnits[unitID] = enabled and true or nil    -- let's assure we never use 'false' on these guys
    idleUnits[unitID] = enabled and nil or true
    local msg = "SpringFSM:: Unit "..unitID.." automation: "..tostring(enabled)
    if not enabled then
        trackedUnits[unitID].recheckFrame = spGetGameFrame() + recheckLatency
        msg = msg .. ", will try re-automation in: "..trackedUnits[unitID].recheckFrame
    end
    spEcho(msg)
end

--//--------------------------------------
--// Global/Externally-Callable Functions
--//--------------------------------------

function setup(fsmBehaviorTbl, recheckLatencyNum, debugBool, updateRateNum)
    fsmBehavior = fsmBehaviorTbl
    if (type(recheckLatencyNum)=="number") then
        recheckLatency = recheckLatencyNum
    end
    if (type(debugBool)=="boolean") then
        debug = debugBool
    end
    if (type(updateRateNum)=="number") then
        updateRate = updateRateNum
    end
end

--- Sets the FSM state, as long as the unit is not already in it
-- "idle" is reserved, will always remove all existing unit actions
function setState(unitID, state, caller)
    if state == fsmState[unitID] then
        return end
    setUnitAutomated(unitID, state ~= "idle")
    fsmState[unitID] = state
    spEcho("New harvest State: ".. state .." for: "..unitID.." set by function: "..caller)
end

function UnitFinished(unitID, unitDef)
    trackedUnits[unitID] = { recheckFrame = spGetGameFrame() + recheckLatency, unitDef = unitDef }
end

function Check(unitID, ud, caller, showEcho)
    if not IsValidUnit(unitID) or fsmBehavior == nil then
        return end

    debug = showEcho    -- if ommitted in the call, won't show Spring.Echo messages

    -- Will try and (if condition succeeds) execute each automatedFunction, in order. #1 is highest priority, etc.
    for i = 1, #fsmBehavior do
        local fsmFunc = fsmBehavior[i]
        if fsmFunc.condition(ud) then
            ud.stateSet = fsmFunc.action(ud)
            setState(unitID, ud.stateSet, caller.."> fsmCheck")
            break
        end
    end
    --- If any automation attempt above was successful, set new harvest state
    if ud.orderIssued then
        --if ud.orderIssued == "idle" then
        --    --Spring.Echo ("Auto harvest:: Sending message: harvesterIdle_"..unitID)
        --    spSendLuaUIMsg("harvesterIdle_"..unitID, "allies") --(message, mode)
        --end
        dbgEcho ("Auto harvest:: New order Issued: "..ud.orderIssued)
        setState(unitID, ud.orderIssued, caller.."> automateCheck")
    end
    return ud.orderIssued
end

function GameFrame(f)
    --local f = frameNum
    --if f % updateRate > 0.001 then
    --    return end
    for unitID, data in pairs(trackedUnits) do
        if IsValidUnit(unitID) and f >= data.recheckFrame then
            Check(unitID, ud, "fsm:gameFrame")
            -- Queue up the next fsm-automation test
            trackedUnits[unitID].recheckFrame = spGetGameFrame() + recheckLatency
            Spring.Echo("Rechecking unit: "..unitID.." at frame: "..trackedUnits[unitID].recheckFrame)
        end
    end
end


--==== @caller, example:

--local updateRate = 30
--function widget:GameFrame(f)
--    --if f < startupGracetime then
--    --    return end    -- If you want some delay before the FSM starts working
--    if f % updateRate < 0.001 then
--        for unitID, data in pairs(trackedUnits) do
--            if IsValidUnit(unitID) and f >= data.recheckFrame then
--                local ud = { unitID = unitID, unitDef = data.unitDef }
--                fsmCheck(unitID, ud, "GameFrame")
--                trackedUnits[unitID].recheckFrame = spGetGameFrame() + recheckLatency
--            end
--        end
--    end
--end
--
------ ud = { unitID = unitID, unitDef = unitDef, }
--local stateIDs = { [1] = "state1", [2] = "state2", }
--local fsmBehaviors = {
--    [1] = { id=stateIDs[1],             -- state1
--            condition = function(ud)    -- What's the condition to transition to this state
--                local exampleVar = exampleFunction(ud.unitID, ud.unitDef)
--                return exampleVar > 2
--            end,
--            action = function(ud)       -- What to do when entering this state, if condition is satisfied
--                print("Activated state "..stateIDs[1].." for: "..ud.unitID)
--                return stateIDs[1]
--            end
--    },
--    --...
--}
