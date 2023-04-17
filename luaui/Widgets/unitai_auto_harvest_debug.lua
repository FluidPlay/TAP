---
--- DateTime: 27-Sep-21 4:23 PM
--- You can turn UI debug on/off by '/aidebug' toggle console command
---
function widget:GetInfo()
    return {
        name = "UnitAI Auto Harvest - Debug",
        desc = "Shows visually the state of AI-automated builder units",
        author = "MaDDoX",
        date = "Feb 15, 2022",
        license = "GPLv3",
        layer = 20,
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
local font = gl.LoadFont(FontPath, loadedFontSize, 24, 1.25)
local gl_Color = gl.Color

local function SetColor(r,g,b,a)
    gl_Color(r,g,b,a)
    font:SetTextColor(r,g,b,a)
end

local harvesters = WG.harvesters

function widget:Initialize()
    if not WG.harvestState then
        Spring.Echo("<AI Harvester Brain> This widget requires the 'UnitAI Auto Harvest' widget to run.")
        widgetHandler:RemoveWidget(self)
    end
    harvesters = WG.harvesters
end

function widget:DrawScreen()
    if not localDebug or spIsGUIHidden() then
        return end
    local textSize = 17 --22

    gl.PushMatrix()
    gl.Translate(50, 35, 0)
    gl.BeginText()
    SetColor(0.96,0.625,0,1)
    for unitID, state in pairs(WG.harvestState) do
        if spIsUnitInView(unitID) then
            local x, y, z = spGetUnitViewPosition(unitID)
            local sx, sy, sz = spWorldToScreenCoords(x, y, z)
            local text = state
            local harvester = harvesters[unitID]
            if harvesters[unitID] then
                local secondItem = (harvester.parentOreTowerID or "nil")
                local thirdItem = (harvester.returnPos and harvester.returnPos.x or "nil")
                if text == "attacking" then
                    secondItem = (harvester.targetChunkID or "nil")
                    thirdItem = ""
                end
                text = text .." | "..secondItem.." | "..thirdItem
            end
            gl.Text(text, sx, sy, textSize, "ocd")
        end
    end
    gl.EndText()
    gl.PopMatrix()
end

function widget:TextCommand(command)
    if command == "harvesterdebug" then
        localDebug = not localDebug
        return
    end
end