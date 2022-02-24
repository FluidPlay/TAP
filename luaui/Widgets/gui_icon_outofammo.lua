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
local spGetUnitRulesParam = Spring.GetUnitRulesParam

local localDebug = false --|| Enables text and UI state debug messages

local myTeamID = Spring.GetMyTeamID()

local gl_Color = gl.Color
local spGetUnitTeam    = Spring.GetUnitTeam
local vsx, vsy	= gl.GetViewSizes()

local trackedUnits = {} -- { [unitID] = true, ... }
local outOfAmmoPlanes = {} -- { [unitID] = true, ... }

local updateRate = 40;
local DebugMsgs = false; --true;

--local function SetColor(r,g,b,a)
--    gl_Color(r,g,b,a)
--    font:SetTextColor(r,g,b,a)
--end

local function spEcho(msg)
    if DebugMsgs then
        Spring.Echo(msg) end
end

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
end

local function outOfAmmo(unitID)
    local ammo = 1
    local unitammo = spGetUnitRulesParam(unitID, "ammo")
    if unitammo then
        spEcho("ammo: "..(tostring(unitammo) or "nil"))
        unitammo = tonumber(unitammo) end
    return unitammo < 1
end

function widget:UnitFinished(unitID, unitDefID, unitTeam)
    local ud = UnitDefs[unitDefID]
    if ud.customParams and ud.customParams.maxammo then
        trackedUnits[unitID] = true
    --    SpringEcho("Added unit: "..unitID)
    --else
    --    SpringEcho("Not found: "..unitID)
    end
end

function widget:UnitTaken(unitID, unitDefID, unitTeam, newTeam)
    widget:UnitDestroyed(unitID, unitDefID, unitTeam)
end

function widget:UnitDestroyed(unitID, unitDefID, teamID)
    trackedUnits[unitID] = nil
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
        -- [[ for DrawScreen only, disable Billboard then: ]] local sx, sy, sz = spWorldToScreenCoords(x, y, z)
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

function widget:GameFrame(f)
    --if f % updateRate > 0.001 then
    --    return end
    for unitID in pairs(trackedUnits) do
        if IsValidUnit(unitID) then
            local outOfAmmo = outOfAmmo(unitID)
            spEcho("Is Valid: "..unitID.." Out Of Ammo: "..(tostring(outOfAmmo) or "nil"))
            if outOfAmmo then
                if not outOfAmmoPlanes[unitID] then
                    outOfAmmoPlanes[unitID] = true
                end
            else
                if outOfAmmoPlanes[unitID] then
                    outOfAmmoPlanes[unitID] = nil
                end
            end
        end
    end
end

--function widget:TextCommand(command)
--    if command == "aidebug" then
--        localDebug = not localDebug
--        return
--    end
--end