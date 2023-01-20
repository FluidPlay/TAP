--
-- Dev: MaDDoX
-- Date: 16/03/21
-- Time: 12:25
--- Attention: UNUSED, cob being used instead
local SIG_REQSTATE = {}

local base = piece ('base')
local Rad = math.rad
local dead = false

local RotateSpeed = 60
local accelbrakerate = 1
local statechg_DesiredState, statechg_StateChanging
local startPosY


local function Go()
    Spring.UnitScript.Spin ( base , y_axis, Rad(RotateSpeed) )
end

--local function RequestState(requestedstate, currentstate)
--    Spring.UnitScript.Signal(SIG_REQSTATE)
--    Spring.UnitScript.SetSignalMask(SIG_REQSTATE)
--    if statechg_StateChanging  then
--        statechg_DesiredState = requestedstate
--    end
--    statechg_StateChanging = true
--    currentstate = statechg_DesiredState
--    statechg_DesiredState = requestedstate
--    while  statechg_DesiredState ~= currentstate  do
--        if  statechg_DesiredState == 0  then
--            Go()
--            currentstate = 0
--        end
--    end
--    statechg_StateChanging = false
--end

function script.Create()
    --statechg_DesiredState = true
    --statechg_StateChanging = false
    --StartThread(RequestState)
    local x,z
    x, startPosY, z = Spring.UnitScript.GetPieceTranslation(base)
    Go()
end

local function SweetSpot(piecenum)
    piecenum = base
end
--
function script.Killed(recentDamage, maxHealth)
    dead = true
    --local severity = recentDamage / maxHealth * 100
    return 3
--    return 1
end

