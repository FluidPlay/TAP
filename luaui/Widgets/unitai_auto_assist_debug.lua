---
--- DateTime: 27-Sep-21 4:23 PM
--- You can turn UI debug on/off by '/aidebug' toggle console command
---
function widget:GetInfo()
    return {
        name = "UnitAI Auto Assist - Debug",
        desc = "Shows visually the state of AI-automated builder units",
        author = "MaDDoX",
        date = "Sep 27, 2021",
        license = "GPLv3",
        layer = 0,
        enabled = false, --true,
    }
end

VFS.Include("gamedata/taptools.lua")

local spIsUnitInView = Spring.IsUnitInView
local spGetUnitViewPosition = Spring.GetUnitViewPosition
local spIsGUIHidden = Spring.IsGUIHidden
local spWorldToScreenCoords = Spring.WorldToScreenCoords

local localDebug = true --false --|| Enables text and UI state debug messages

local loadedFontSize = 32
local FontPath = (VFS.Include("gamedata/configs/fontsettings.lua")).LuaUI
local font = gl.LoadFont(FontPath, loadedFontSize, 24, 1.25)
local gl_Color = gl.Color
local gl_PushMatrix = gl.PushMatrix
local gl_Translate = gl.Translate
local gl_BeginText = gl.BeginText
local gl_EndText = gl.EndText
local gl_PopMatrix = gl.PopMatrix
local gl_Text = gl.Text

local function SetColor(r,g,b,a)
    gl_Color(r,g,b,a)
    font:SetTextColor(r,g,b,a)
end

function widget:Initialize()
    if not WG.automatedStates then
        Spring.Echo("<unitai auto assist> This widget requires the 'UnitAI Auto Assist' widget to run.")
        widgetHandler:RemoveWidget(self)
    end
end

function widget:DrawScreen()
    if not localDebug or spIsGUIHidden() then
        return end
    local textSize = 20 --22

    gl_PushMatrix()
    gl_Translate(50, 50, 0)
    gl_BeginText()
    SetColor(1,1,1,1)
    for unitID, state in pairs(WG.automatedStates) do
        if spIsUnitInView(unitID) then
            local x, y, z = spGetUnitViewPosition(unitID)
            local sx, sy, sz = spWorldToScreenCoords(x, y, z)
            local text = (state or "nil") .." | "..unitID
            --local substate = ""
            --if (state == "harvest") then
            --    substate = WG.harvestSubStates[unitID]
            --    if (substate) then
            --        text = text.." : "..substate
            --    end
            --end
            gl_Text(text, sx, sy, textSize, "ocd")
        end
    end
    gl_EndText()
    gl_PopMatrix()
end

function widget:TextCommand(command)
    if command == "aidebug" then
        localDebug = not localDebug
        return
    end
end