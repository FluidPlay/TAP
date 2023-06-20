---
--- Created by Breno "MaDDoX" Azevedo
--- DateTime: 6/10/2023 1:19 PM
---
--- HOW-TO: Include it in your widget; Add this:
--  VFS.Include("gamedata/taptools.lua")
--  local fsm = { Spring = Spring, type = type, pairs = pairs, gl=gl, VFS=VFS}
--  VFS.Include("common/include/springfsm.lua", fsm)
--
--  function gadget:DrawScreen()
--      fsm.DrawScreen()
--  end
--============================

local spIsUnitInView = Spring.IsUnitInView
local spGetUnitViewPosition = Spring.GetUnitViewPosition
local spIsGUIHidden = Spring.IsGUIHidden
local spWorldToScreenCoords = Spring.WorldToScreenCoords

local gl_PushMatrix = gl.PushMatrix
local gl_Translate = gl.Translate
local gl_BeginText = gl.BeginText
local gl_EndText = gl.EndText
local gl_PopMatrix = gl.PopMatrix
local gl_Text = gl.Text

local FontPath = (VFS.Include("gamedata/configs/fontsettings.lua")).LuaUI
local loadedFontSize = 32
local font = gl.LoadFont(FontPath, loadedFontSize, 24, 1.25)
local gl_Color = gl.Color
local spGetUnitRulesParam    = Spring.GetUnitRulesParam

--local function isnumber(v) return (type(v)=="number") end

local function SetColor(r,g,b,a)
    gl_Color(r,g,b,a)
    font:SetTextColor(r,g,b,a)
end

function DrawScreen(fsmId, trackedUnits, localDebug)
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
            --TODO: Add externally set-able custom function for 'text' here
            local text = (unitID or "nil").." | "..(fsmTxt or "nil")
            gl_Text(text, sx, sy, textSize, "ocd")
        end
    end
    gl_EndText()
    gl_PopMatrix()
end
