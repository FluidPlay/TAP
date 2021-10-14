---
--- DateTime: 27-Sep-21 4:23 PM
--- You can turn UI debug on/off by '/aidebugon' and '/aidebugoff' console commands
---
function widget:GetInfo()
    return {
        name = "GUI Icon Out-of-ammo",
        desc = "Shows icons on top of out-of-ammo planes",
        author = "MaDDoX",
        date = "Oct 11, 2021",
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

local localDebug = false --|| Enables text and UI state debug messages

local loadedFontSize = 32
local font = gl.LoadFont(FontPath, loadedFontSize, 24, 1.25)
local gl_Color = gl.Color

local outOfAmmoPlanes = {} -- { [unitID] = true, ... }

--local function SetColor(r,g,b,a)
--    gl_Color(r,g,b,a)
--    font:SetTextColor(r,g,b,a)
--end

--function widget:Initialize()
--    if not WG.automatedStates then
--        Spring.Echo("<AI Builder Brain> This widget requires the 'AI Builder Brain' widget to run.")
--        widgetHandler:RemoveWidget(self)
--    end
--end

function widget:UnitFinished(unitID, unitDefID, unitTeam, builderID)
    local ud = UnitDefs[unitDefID]
    if ud.customParams and ud.customParams.maxammo then
        outOfAmmoPlanes[unitID] = true
    end
end

function widget:DrawScreen()
    if not localDebug or spIsGUIHidden() then
        return end
    --local textSize = 22

    gl.PushMatrix()
    gl.Color( 1.0, 1.0, 1.0, 1.0)
    for unitID in pairs(outOfAmmoPlanes) do
        gl.Texture(0,"luaui/icons/outofammo.png")
        local x,y,z = Spring.GetUnitViewPosition(unitID)
        gl.Translate(x, y, z)
        --gl.Rotate( 90, 1, 0, 0 )
        gl.TexRect( -64/2, -64/2, 64/2, 64/2 )
        --gl.Translate( x, y, z )
    end
    gl.PopMatrix()
end

--function widget:TextCommand(command)
--    if command == "aidebug" then
--        localDebug = not localDebug
--        return
--    end
--end