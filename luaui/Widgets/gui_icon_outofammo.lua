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
        enabled = true,
    }
end

VFS.Include("gamedata/taptools.lua")

local spIsUnitInView = Spring.IsUnitInView
local spGetUnitViewPosition = Spring.GetUnitViewPosition
local spIsGUIHidden = Spring.IsGUIHidden
local spGetAllUnits = Spring.GetAllUnits
local spWorldToScreenCoords = Spring.WorldToScreenCoords

local localDebug = false --|| Enables text and UI state debug messages

local myTeamID = Spring.GetMyTeamID()

local gl_Color = gl.Color
local spGetUnitTeam    = Spring.GetUnitTeam
local vsx, vsy	= gl.GetViewSizes()

local outOfAmmoPlanes = {} -- { [unitID] = true, ... }

--local function SetColor(r,g,b,a)
--    gl_Color(r,g,b,a)
--    font:SetTextColor(r,g,b,a)
--end

local function clamp(min,max,num)
    if (num<min) then
        return min
    elseif (num>max) then
        return max
    end
    return num
end

function widget:Initialize()
    myTeamID = Spring.GetMyTeamID()
    local units = spGetAllUnits()
    for i=1, #units do
        local unitID = units[i]
        if spGetUnitTeam(unitID) == myTeamID then
            local unitDefID = Spring.GetUnitDefID(unitID)
            local unitTeam = spGetUnitTeam
            widget:UnitFinished(unitID, unitDefID, unitTeam)
        end
    end
    vsx, vsy = gl.GetViewSizes()
--    if not WG.automatedStates then
--        Spring.Echo("<AI Builder Brain> This widget requires the 'AI Builder Brain' widget to run.")
--        widgetHandler:RemoveWidget(self)
--    end
end

function widget:UnitFinished(unitID, unitDefID, unitTeam)
    local ud = UnitDefs[unitDefID]
    if ud.customParams and ud.customParams.maxammo then
        outOfAmmoPlanes[unitID] = true
    end
end

function widget:UnitDestroyed(unitID, unitDefID, teamID)
    outOfAmmoPlanes[unitID] = nil
end

function widget:DrawScreen()
--function widget:DrawWorld()
    if spIsGUIHidden() then --not localDebug or
        return end
    --local textSize = 22

    gl_Color( 1.0, 1.0, 1.0, 1.0)

    for unitID in pairs(outOfAmmoPlanes) do
        gl.PushMatrix()
        --local cx,cy,cz = Spring.GetCameraPosition()

        gl.Texture(0,"luaui/icons/outofammo.png")
        -- [[ for DrawScreen only, disable Billboard them]] local sx, sy, sz = spWorldToScreenCoords(x, y, z)
        local x,y,z = Spring.GetUnitViewPosition(unitID)
        --gl.Translate(x, y, z)
        local sx, sy, sz = spWorldToScreenCoords(x, y, z)
        gl.Translate(sx, sy, sz)

        --gl.Billboard()

        gl.TexRect( -12, -12, 12, 12)
        --gl.TexRect(-1-0.25/vsx,1+0.25/vsy,1+0.25/vsx,-1-0.25/vsy)

        gl.PopMatrix()
    end

    --gl.MatrixMode(GL.MODELVIEW)
    --gl.PushMatrix()
    --gl.LoadIdentity()
    --
    --gl.MatrixMode(GL.PROJECTION)
    --gl.PushMatrix()
    --gl.LoadIdentity()
    --
    --DoDrawSSAO(false)
    --
    --gl.MatrixMode(GL.PROJECTION)
    --gl.PopMatrix()
    --
    --gl.MatrixMode(GL.MODELVIEW)
    --gl.PopMatrix()
end

--function widget:TextCommand(command)
--    if command == "aidebug" then
--        localDebug = not localDebug
--        return
--    end
--end