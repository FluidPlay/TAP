---
--- DateTime: 27-Sep-21 4:23 PM
--- You can turn UI debug on/off by '/aidebug' toggle console command
---
function widget:GetInfo()
    return {
        name = "UnitAI Ore Guardian - Debug",
        desc = "Shows visually the state of AI-automated Guardians",
        author = "MaDDoX",
        date = "May 13, 2023",
        license = "GPLv3",
        layer = 20,
        enabled = false, --true,
    }
end
local localDebug = true --|| Enables text and UI state debug messages
local fsmId = "oreguardian"

VFS.Include("gamedata/taptools.lua")
local fsm = { Spring = Spring, type = type, pairs = pairs, gl=gl, VFS=VFS}
VFS.Include("luaui/widgets/Include/springfsm_debug.lua", fsm)

local unitDefNameToTrack = { guardsml = true, }
local trackedUnits = {}

function widget:UnitFinished(unitID, unitDefID, teamID)
    local unitDef = UnitDefs[unitDefID]
    if unitDef == nil then
        return end
    if unitDefNameToTrack[unitDef.name] then
        trackedUnits[unitID] = true
    end
end

function widget:Initialize()
    for _,unitID in ipairs(Spring.GetAllUnits()) do
        local teamID = Spring.GetUnitTeam(unitID)
        local unitDefID = Spring.GetUnitDefID(unitID)
        widget:UnitFinished(unitID, unitDefID, teamID)
    end
end

function widget:UnitDestroyed(unitID)
    trackedUnits[unitID] = nil
end

function widget:DrawScreen()
    fsm.DrawScreen(fsmId, trackedUnits, localDebug)
end

function widget:TextCommand(command)
    if command == fsmId.."debug" then
        localDebug = not localDebug
        return
    end
end