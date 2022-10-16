--
-- User: MaDDoX
-- Date: 05/10/21
-- Time: 20:47
--

local SIG_STATECHG = {}
local SIG_REQSTATE = {}

--local base, aim, tower1, tower2, tower3, emitnano, headadv = piece('base', 'aim', 'tower1', 'tower2', 'tower3', 'emitnano', 'headadv')

--local base = piece 'base'
--local body = piece 'body'
--local aim = piece 'aim'
--local tower1, tower2, tower3 = piece('tower1', 'tower2', 'tower3')
--local emitnano = piece 'emitnano'

local arm_botlab          = piece 'arm_botlab'
local left_pointer        = piece 'left_pointer'
local right_pointer       = piece 'right_pointer'
local back_connection     = piece 'back_connection'
local left_arm1           = piece 'left_arm1'
local left_arm1_advanced  = piece 'left_arm1_advanced'
local left_back_base      = piece 'left_back_base'
local left_back_wall      = piece 'left_back_wall'
local left_front_base     = piece 'left_front_base'
local left_front_wall     = piece 'left_front_wall'
local left_upgrade        = piece 'left_upgrade'
local right_arm1          = piece 'right_arm1'
local right_arm1_advanced = piece 'right_arm1_advanced'
local right_back_base     = piece 'right_back_base'
local right_back_wall     = piece 'right_back_wall'
local right_front_base    = piece 'right_front_base'
local right_front_wall    = piece 'right_front_wall'
local right_upgrade       = piece 'right_upgrade'
local left_arm2           = piece 'left_arm2'
local left_arm2_advanced  = piece 'left_arm2_advanced'
local left_arm3           = piece 'left_arm3'
local left_arm3_advanced  = piece 'left_arm3_advanced'
local left_cover1         = piece 'left_cover1'
local left_cover2         = piece 'left_cover2'
local left_cover3         = piece 'left_cover3'
local left_front_sign     = piece 'left_front_sign'
local left_head           = piece 'left_head'
local left_head_advanced  = piece 'left_head_advanced'
local right_arm2          = piece 'right_arm2'
local right_arm2_advanced = piece 'right_arm2_advanced'
local right_arm3          = piece 'right_arm3'
local right_arm3_advanced = piece 'right_arm3_advanced'
local right_back_cover1   = piece 'right_back_cover1'
local right_back_cover2   = piece 'right_back_cover2'
local right_front_sign    = piece 'right_front_sign'
local right_head          = piece 'right_head'
local right_head_advanced = piece 'right_head_advanced'
local right_pointer1      = piece 'right_pointer1'
local right_pointer2      = piece 'right_pointer2'
local left_pointer1       = piece 'left_pointer1'
local left_pointer2       = piece 'left_pointer2'

local pointer = { left_pointer, right_pointer }

VFS.Include("scripts/include/springtweener.lua")

local scriptEnv = { back_connection     = back_connection    ,
                    left_back_base      = left_back_base     ,
                    left_back_wall      = left_back_wall     ,
                    left_front_base     = left_front_base    ,
                    left_front_wall     = left_front_wall    ,
                    left_upgrade        = left_upgrade       ,
                    right_back_base     = right_back_base    ,
                    right_back_wall     = right_back_wall    ,
                    right_front_base    = right_front_base   ,
                    right_front_wall    = right_front_wall   ,
                    right_upgrade       = right_upgrade      ,
                    left_arm1           = left_arm1          ,
                    left_arm1_advanced  = left_arm1_advanced ,
                    left_arm2           = left_arm2          ,
                    left_arm2_advanced  = left_arm2_advanced ,
                    left_arm3           = left_arm3          ,
                    left_arm3_advanced  = left_arm3_advanced ,
                    left_cover1         = left_cover1        ,
                    left_front_sign     = left_front_sign    ,
                    left_head           = left_head          ,
                    left_head_advanced  = left_head_advanced ,
                    right_arm1          = right_arm1         ,
                    right_arm1_advanced = right_arm1_advanced,
                    right_arm2          = right_arm2         ,
                    right_arm2_advanced = right_arm2_advanced,
                    right_arm3          = right_arm3         ,
                    right_arm3_advanced = right_arm3_advanced,
                    right_back_cover1   = right_back_cover1  ,
                    right_front_sign    = right_front_sign   ,
                    right_head          = right_head         ,
                    right_head_advanced = right_head_advanced,

                    rad = math.rad,
                    x_axis = x_axis,
                    y_axis = y_axis,
                    z_axis = z_axis,
    --
                    Turn = Turn,
                    Move = Move,
                    Sleep = Sleep,

                    initTween = initTween,
}

local PlayAnimation = VFS.Include("scripts/animations/bowlab_anim.lua", scriptEnv)

local HeadingAngle, PitchAngle, RestoreDelay, statechg_StateChanging
local minPitch, maxPitch = -0.2, 0.84
local state = { build = 0, stop = 1}
local statechg_DesiredState
local isAdvanced = false
local justcreated = false
local Rad = math.rad
local Rand = math.random

local Explode = Spring.UnitScript.Explode
local sfxShatter = SFX.SHATTER
local sfxBITMAPONLY = 32    --https://github.com/Balanced-Annihilation/Balanced-Annihilation/blob/master/scripts/exptype.h
local sfxBITMAP1 = 256
local sfxBITMAP2 = 512
local sfxBITMAP3 = 1024
local sfxBITMAP4 = 2048
local sfxBITMAP5 = 4096
local sfxFall = SFX.FALL
local sfxFire = SFX.FIRE
local sfxSmoke = SFX.SMOKE
local sfxExplodeOnHit = SFX.EXPLODE_ON_HIT

local function SmokeUnit(healthpercent, sleeptime, smoketype)
	while GetUnitValue(COB.BUILD_PERCENT_LEFT) do
		Sleep (400)
	end
	while true do
		local healthpercent = GetUnitValue(COB.HEALTH)
		if  healthpercent < 66  then
			smoketype = 258 --256 | 2
			if Rand (1, 66) < healthpercent  then
				smoketype = 257 end
			EmitSfx ( aim, smoketype )
		end
		sleeptime = healthpercent * 50
		if  sleeptime < 200  then
			sleeptime = 200
		end
		Sleep (sleeptime)
	end
end

local function RestoreAfterDelay()
	Sleep (RestoreDelay)
	Turn (aim , y_axis, 0, Rad(100.00000))
	WaitForTurn (aim, y_axis)
end

local function WaitOneFrame()
	Sleep (1)
end

--local function EnableTowers()
--	-- If we just morphed into this guy, insta-set pieces below the current level
--	-- Why? A.: Those pieces have been raised before
--	if (justcreated) then
--		justcreated = false
--        if level >=2 then
--            Show (headadv)
--            Hide (outpost5)
--            Hide (outpostwing1)
--            Hide (outpostwing2)
--        end
--		if level >= 3 then
--			Move ( tower1, y_axis, 48.200000)
--		end
--		if level == 4 then
--			Move ( tower2, y_axis, 48.200000)
--		end
--	end
--	if level >= 2 then
--		Move ( tower1, y_axis, 48.200000, 18.03424 )
--	end
--end
--
--local function DisableTowers()
--    if level >= 2 then
--        Move ( tower1, y_axis, 0.00000, 8.00000)
--    end
--end

local function Stop()
    Spring.UnitScript.Signal(SIG_STATECHG)
    Spring.UnitScript.SetSignalMask(SIG_STATECHG)
    --Spring.Echo("armoutpost_lus: Stopping")
    SetUnitValue(COB.INBUILDSTANCE, 0)	--set INBUILDSTANCE to 0
	--DisableTowers() :: Removed to prevent 'bouncing towers' after building etc
    ---WaitOneFrame()
    ---StartThread(RestoreAfterDelay)
    if isAdvanced then
        PlayAnimation.closeadv()
    else
        PlayAnimation.closestd()
    end
end

local function Go()
    Spring.UnitScript.Signal(SIG_STATECHG)
    Spring.UnitScript.SetSignalMask(SIG_STATECHG)
    --if PitchAngle == nil or HeadingAngle == nil then
    --    Stop() end
    --Spring.Echo("armoutpost_lus: Going")
	---EnableTowers()
	---WaitOneFrame()
	--Turn( aim , y_axis, HeadingAngle, Rad(160.00000) )
    --if PitchAngle then
     --   Turn( aim , x_axis, PitchAngle, Rad(90.00000) ) end
	--WaitForTurn(aim, y_axis)
    --WaitForTurn(aim, x_axis)
    if isAdvanced then
        PlayAnimation.openadv() --'closestd, openadv, closeadv'
    else
        PlayAnimation.openstd() --'closestd, openadv, closeadv'
    end
    SetUnitValue(COB.INBUILDSTANCE, 1)
end

local function RequestState(requestedstate, currentstate)
    Spring.UnitScript.Signal(SIG_REQSTATE)
    Spring.UnitScript.SetSignalMask(SIG_REQSTATE)
	if  statechg_StateChanging  then
		statechg_DesiredState = requestedstate
		return (0)
	end
	statechg_StateChanging = true
	currentstate = statechg_DesiredState
	statechg_DesiredState = requestedstate
	while statechg_DesiredState ~= currentstate  do
		if statechg_DesiredState == state.build then
			StartThread(Go)
			currentstate = state.build
		elseif statechg_DesiredState == state.stop then
      --Spring.Echo("Stop now")
			StartThread(Stop)
			currentstate = 1
		end
	end
	statechg_StateChanging = false
end

local function InitState()
	HeadingAngle = nil
    PitchAngle = nil
	RestoreDelay = 5000
	justcreated = true
	statechg_DesiredState = 1
	statechg_StateChanging = false
	local unitDefID = UnitDefs[unitDefID].name
	if (unitDefID == "armlab") then
		isAdvanced = false
        Hide(left_upgrade)
        Hide(right_upgrade)

        Hide(left_arm1_advanced)
        Hide(left_arm2_advanced)
        Hide(left_arm3_advanced)
        Hide(right_arm1_advanced)
        Hide(right_arm2_advanced)
        Hide(right_arm3_advanced)

        Hide(left_head_advanced)
        Hide(right_head_advanced)

        Hide(right_pointer1)
        Hide(right_pointer2)
        Hide(left_pointer1)
        Hide(left_pointer2)

    elseif (unitDefID == "armalab") then
        --Show(left_upgrade)
        --Show(right_upgrade)
        Hide(left_arm1)
        Hide(left_arm2)
        Hide(left_arm3)
        Hide(right_arm1)
        Hide(right_arm3)
        Hide(right_arm2)
        Hide(right_head)
        Hide(left_head)

        Hide(right_pointer)
        Hide(left_pointer)
		isAdvanced = true
	end

	--EnableTowers()
end

function script.StartBuilding(heading, pitch)
	HeadingAngle = heading
    --Spring.Echo("Source pitch: "..pitch)
    PitchAngle = pitch --  -math.max(minPitch, math.min(pitch, maxPitch))
	StartThread(RequestState, state.build)
end

function script.StopBuilding()
	StartThread(RequestState, state.stop)
end

function script.QueryNanoPiece(piecenum)
    if isAdvanced then
        piecenum = left_pointer1
    else
        --piecenum = left_pointer
        piecenum = pointer[math.random(1,2)]
        --local pointer = { "left_pointer", "right_pointer" }
    end
	return piecenum
end

local function SweetSpot(piecenum)
	piecenum = arm_botlab
end

function script.Create()
	StartThread(SmokeUnit)
	InitState()
end

function script.Activate()
    HeadingAngle = 0
	StartThread(RequestState, state.build)
end

function script.Deactivate()
	StartThread(RequestState, state.stop)
end

function script.Killed(recentDamage, maxHealth)
	local corpsetype = 3
	local severity = recentDamage / maxHealth * 100

	if  severity <= 25  then
		corpsetype = 1
		Explode( back_connection, sfxBITMAPONLY + sfxBITMAP1)
		Explode( left_cover1, sfxBITMAPONLY + sfxBITMAP3)
        Explode( left_cover2, sfxBITMAPONLY + sfxBITMAP3)
        Explode( left_cover3, sfxBITMAPONLY + sfxBITMAP3)
        Explode( right_back_cover1, sfxBITMAPONLY + sfxBITMAP3)
        Explode( right_back_cover2, sfxBITMAPONLY + sfxBITMAP3)
		return (corpsetype)
	end
	if  severity <= 50  then
		corpsetype = 2
		Explode( back_connection, sfxFall + sfxBITMAP1)
		Explode( left_cover1, sfxFall + sfxBITMAP3)
        Explode( left_cover2, sfxFall + sfxBITMAP3)
        Explode( left_cover3, sfxFall + sfxBITMAP3)
        Explode( right_back_cover1, sfxFall + sfxBITMAP3)
        Explode( right_back_cover2, sfxFall + sfxBITMAP3)
		return (corpsetype)
	end
	if  severity <= 99  then
		corpsetype = 3
		Explode( back_connection, sfxFall + sfxSmoke + sfxFire + sfxExplodeOnHit + sfxBITMAP1)
		Explode( left_cover1, sfxFall + sfxSmoke + sfxFire + sfxExplodeOnHit + sfxBITMAP3)
        Explode( left_cover2, sfxFall + sfxSmoke + sfxFire + sfxExplodeOnHit + sfxBITMAP3)
        Explode( left_cover3, sfxFall + sfxSmoke + sfxFire + sfxExplodeOnHit + sfxBITMAP3)
        Explode( right_back_cover1, sfxFall + sfxSmoke + sfxFire + sfxExplodeOnHit + sfxBITMAP3)
        Explode( right_back_cover2, sfxFall + sfxSmoke + sfxFire + sfxExplodeOnHit + sfxBITMAP3)
		return (corpsetype)
	end
	Explode( back_connection, sfxFall + sfxSmoke + sfxFire + sfxExplodeOnHit + sfxBITMAP1)
	Explode( left_cover1, sfxShatter + sfxExplodeOnHit + sfxBITMAP3)
    Explode( left_cover2, sfxShatter + sfxExplodeOnHit + sfxBITMAP3)
    Explode( left_cover3, sfxShatter + sfxExplodeOnHit + sfxBITMAP3)
    Explode( right_back_cover1, sfxShatter + sfxExplodeOnHit + sfxBITMAP3)
    Explode( right_back_cover2, sfxShatter + sfxExplodeOnHit + sfxBITMAP3)

	return (corpsetype)
end
