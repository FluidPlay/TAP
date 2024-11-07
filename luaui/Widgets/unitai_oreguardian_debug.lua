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

--function widget:DrawScreen()
--    fsm.DrawScreen(fsmId, trackedUnits, localDebug)
--end

local gl_PushMatrix = gl.PushMatrix
local gl_Translate = gl.Translate
local gl_BeginText = gl.BeginText
local gl_EndText = gl.EndText
local gl_PopMatrix = gl.PopMatrix
local gl_Text = gl.Text
local spIsUnitInView = Spring.IsUnitInView
local spGetUnitViewPosition = Spring.GetUnitViewPosition
local spIsGUIHidden = Spring.IsGUIHidden
local spWorldToScreenCoords = Spring.WorldToScreenCoords
local spGetUnitRulesParam    = Spring.GetUnitRulesParam

local FontPath = (VFS.Include("gamedata/configs/fontsettings.lua")).LuaUI
local loadedFontSize = 32
local font = gl.LoadFont(FontPath, loadedFontSize, 24, 1.25)
local gl_Color = gl.Color

local function SetColor(r,g,b,a)
    gl_Color(r,g,b,a)
    font:SetTextColor(r,g,b,a)
end

function widget:DrawScreen()
    if not localDebug or spIsGUIHidden() or trackedUnits == nil then
        return end
    local textSize = 17 --22

    gl_PushMatrix()
    gl_Translate(50, 35, 0)
    gl_BeginText()
    SetColor(0.96,0.625,0,1)
    for unitID in pairs(trackedUnits) do
        if spIsUnitInView(unitID) then
            local val = spGetUnitRulesParam(unitID, "fsmstate_"..fsmId)
            --Spring.Echo("Loading UnitRulesParam: fsmstate_"..fsmId.." || val: "..(val or "nil"))
            local fsmTxt = val or "nil"

            local x, y, z = spGetUnitViewPosition(unitID)
            local sx, sy = spWorldToScreenCoords(x, y, z)   --, sz
            local aggroed = Spring.GetUnitRulesParam(unitID, "aggroed") -- == 1 and "true" or "false"
            local text = "ID: "..(unitID or "nil").." | aggro UID: "..(aggroed or "nil") --(fsmTxt or "nil")
            gl_Text(text, sx, sy, textSize, "ocd")
        end
    end
    gl_EndText()
    gl_PopMatrix()
end

function widget:TextCommand(command)
    if command == fsmId.."debug" then
        localDebug = not localDebug
        return
    end
end