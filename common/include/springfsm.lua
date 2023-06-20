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
local spIsUnitInView = Spring.IsUnitInView
local spGetUnitViewPosition = Spring.GetUnitViewPosition
local spIsGUIHidden = Spring.IsGUIHidden
local spWorldToScreenCoords = Spring.WorldToScreenCoords
local spSetUnitRulesParam = Spring.SetUnitRulesParam

local function isnumber(v) return (type(v)=="number") end
local trackedUnits = {}

fsmId = "def"
fsmState = {}
fsmBehavior = {}

automatedUnits = {}
idleUnits = {}

--|| Enables text and UI state debug messages
debugMsgs = false                 -- By default this is false, but can be turned on selectively by the fsmCheck call option
recheckLatency = 30           -- Delay until a "commanded" or "idle" unit checks for automation again
updateRate = 6

local function dbgEcho(msg)
    if (debugMsgs) then
        spEcho(msg)
    end
end

local function SetColor(r,g,b,a)
    gl_Color(r,g,b,a)
    font:SetTextColor(r,g,b,a)
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
    local msg = "SpringFSM:: Unit "..unitID.." automation: "..(tostring(enabled))
    if not enabled then
        trackedUnits[unitID].recheckFrame = spGetGameFrame() + recheckLatency
        msg = msg .. ", will try re-automation in: "..trackedUnits[unitID].recheckFrame
    end
    dbgEcho(msg)
end

--//--------------------------------------
--// Global/Externally-Callable Functions
--//--------------------------------------

function setup(fsmIdStr, fsmBehaviorTbl, recheckLatencyNum, debugBool, updateRateNum)
    if (type(fsmIdStr) == "string") then
        fsmId = fsmIdStr
    end
    fsmBehavior = fsmBehaviorTbl
    if (type(recheckLatencyNum)=="number") then
        recheckLatency = recheckLatencyNum
    end
    if (type(debugBool)=="boolean") then
        debugMsgs = debugBool
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
    setUnitAutomated(unitID, not (state == "idle"))
    fsmState[unitID] = state
    spSetUnitRulesParam(unitID, "fsmstate_"..fsmId, state, { public = true } )
    --Spring.Echo("Setting UnitRulesParam: ".."fsmstate_"..fsmId.." || val: "..(state or "nil"))
    --Spring.Echo("New harvest State: ".. state .." for: "..unitID.." set by function: "..caller.." paramID: fsmstate_"..fsmId)
end

function UnitFinished(unitID, unitDef)
    --Spring.Echo("Added "..(unitID or "nil"))
    trackedUnits[unitID] = { recheckFrame = spGetGameFrame() + recheckLatency, unitDef = unitDef }
    setState(unitID, "idle", "UnitFinished")
end

function Check(unitID, ud, caller, showEcho)
    if not IsValidUnit(unitID) or fsmBehavior == nil then
        return end

    --Spring.Echo("Check for unitID: "..unitID)
    debugMsgs = showEcho    -- if ommitted in the call, won't show Spring.Echo messages
    local curState = fsmState[unitID]

    --local ud = { unitID = unitID }
    -- Will try and (if condition succeeds) execute each automatedFunction, in order. #1 is highest priority, etc.
    for i = 1, #fsmBehavior do
        local fsmFunc = fsmBehavior[i]
        if curState ~= fsmFunc.id then
            if fsmFunc.condition(ud) then
                ud.stateSet = fsmFunc.action(ud)
                setState(unitID, ud.stateSet, caller.."> fsmCheck")
                break
            end
        end
    end
    --- If any automation attempt above was successful, set new harvest state
    if ud.stateSet then
        --if ud.orderIssued == "idle" then
        --    --Spring.Echo ("Auto harvest:: Sending message: harvesterIdle_"..unitID)
        --    spSendLuaUIMsg("harvesterIdle_"..unitID, "allies") --(message, mode)
        --end
        dbgEcho ("Auto harvest:: New order Issued: "..ud.stateSet)
        setState(unitID, ud.stateSet, caller.."> automateCheck")
    end
    return ud.orderIssued
end

function GameFrame(f)
    --local f = frameNum
    --if f % updateRate > 0.001 then
    --    return end
    for unitID, data in pairs(trackedUnits) do
        if IsValidUnit(unitID) and f >= data.recheckFrame then
            local ud = { unitID = unitID }
            Check(unitID, ud, "fsm:gameFrame")
            -- Queue up the next fsm-automation test
            trackedUnits[unitID].recheckFrame = spGetGameFrame() + recheckLatency
            ---TODO: Remove (TEMP)
            --Spring.Echo("Rechecking unit: "..unitID.." at frame: "..trackedUnits[unitID].recheckFrame)
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
