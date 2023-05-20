local base, aimfrom, shooter, body = piece('base', 'aimfrom', 'shooter', 'body')

local SIG_AIM = 2
local rad = math.rad

local RotateSpeed, accelbrakerate, statechg_DesiredState, statechg_StateChanging

local function Go()
    Spin( body, y_axis, rad(30.00000) )
    Spin( body , x_axis, rad(60.00000) )
    Spin( body , z_axis, rad(15.00000) )
    return (0)
end

local function InitState()
    statechg_DesiredState = true
    statechg_StateChanging = false
end

local function RequestState(requestedstate, currentstate)
    if  statechg_StateChanging  then
        statechg_DesiredState = requestedstate
        return (0)
    end
    statechg_StateChanging = true
    currentstate = statechg_DesiredState
    statechg_DesiredState = requestedstate
    while  statechg_DesiredState ~= currentstate  do
        if  statechg_DesiredState == 0  then
            Go()
            currentstate = 0
        end
    end
    statechg_StateChanging = false
    return (0)
end

function script.Create()
    RotateSpeed = 50
    accelbrakerate = 1
    InitState()
    RequestState(0)
    return (0)
end

function SweetSpot(piecenum)
    piecenum = body
    return (0)
end

-- Aim starts from this piece
function script.AimFromWeapon(weaponID)
    return aimfrom
end

-- Looking down into this piece
function script.QueryWeapon(weaponID)
    return shooter
end

-- That's the request to aim, animate weapon piece here
function script.AimWeapon(weaponID, heading, pitch)
    Signal(SIG_AIM)
    SetSignalMask(SIG_AIM)
    Turn(aimfrom , y_axis, math.rad(heading ), math.rad(999.00000) )
    Turn(aimfrom , x_axis, 0, math.rad(999.00000) )
    --WaitForTurn(aimfrom, y_axis)  --Not needed when you don't have a visible turret
    --WaitForTurn(aimfrom, x_axis)
    return (1)
end

function script.Killed( severity, corpsetype )
    Explode(body, SFX.EXPLODE_ON_HIT + SFX.SMOKE + SFX.FIRE + SFX.FALL)
    return 1
end