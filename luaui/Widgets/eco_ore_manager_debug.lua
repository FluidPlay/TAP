---
--- Created by Breno "MaDDoX" Azevedo
--- DateTime: 29/11/2023 10:38 PM
---
function widget:GetInfo()
    return {
        name = "Eco Ore Manager - Debug",
        desc = "Shows visually the seeding power of sprawlers",
        author = "MaDDoX",
        date = "November 29, 2023",
        license = "GPLv3",
        layer = 20,
        enabled = false, --true
    }
end

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
local spGetUnitRulesParam = Spring.GetUnitRulesParam

local localDebug = true
local trackedUnits = {}

--local function isnumber(v) return (type(v)=="number") end

local function SetColor(r,g,b,a)
    gl_Color(r,g,b,a)
    font:SetTextColor(r,g,b,a)
end

local unitDefNamesToTrack = { armmstor = true, cormstor = true, armuwadvms = true, coruwadvms = true, }
local trackedUnits = {}

function widget:UnitFinished(unitID, unitDefID, teamID)
    local unitDef = UnitDefs[unitDefID]
    if unitDef == nil then
        return end
    if unitDefNamesToTrack[unitDef.name] then
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
    if not localDebug or spIsGUIHidden() or trackedUnits == nil then
        return end
    local textSize = 17 --22

    gl_PushMatrix()
    gl_Translate(50, 35, 0)
    gl_BeginText()
    SetColor(0.96,0.625,0,1)
    for unitID in pairs(trackedUnits) do
        if spIsUnitInView(unitID) then
            local val = spGetUnitRulesParam(unitID, "seedingPower")
            local fsmTxt = val or "nil"

            local x, y, z = spGetUnitViewPosition(unitID)
            local sx, sy = spWorldToScreenCoords(x, y, z)

            local text = (unitID or "nil").." | "..(fsmTxt or "nil")
            gl_Text(text, sx, sy, textSize, "ocd")
        end
    end
    gl_EndText()
    gl_PopMatrix()
end

--TODO: Add disable command here

