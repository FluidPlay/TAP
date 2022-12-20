--
-- User: MaDDoX
-- Date: 07/11/22
-- Time: 2:20AM
--

local SIG_STATECHG = {}
local SIG_REQSTATE = {}

local base = piece 'base'
local right_arm1 = piece 'right_arm1'
local right_arm2 = piece 'right_arm2'
local right_arm3 = piece 'right_arm3'
local right_head = piece 'right_head'
local right_pointer = piece 'right_pointer'
local right_arm1_advanced = piece 'right_arm1_advanced'
local right_arm2_advanced = piece 'right_arm2_advanced'
local right_arm3_advanced = piece 'right_arm3_advanced'
local right_head_advanced = piece 'right_head_advanced'
local right_pointer1 = piece 'right_pointer1'
local right_pointer2 = piece 'right_pointer2'
local left_arm1_advanced = piece 'left_arm1_advanced'
local left_arm2_advanced = piece 'left_arm2_advanced'
local left_arm3_advanced = piece 'left_arm3_advanced'
local left_head_advanced = piece 'left_head_advanced'
local left_pointer1 = piece 'left_pointer1'
local left_pointer2 = piece 'left_pointer2'
local right_base = piece 'right_base'
local right_wall = piece 'right_wall'
local right_wall_extension = piece 'right_wall_extension'	-- only used by bowvp
local right_back_extension = piece 'right_back_extension'
local right_back_upgrade = piece 'right_back_upgrade'
local right_front_extension = piece 'right_front_extension'
local right_sign = piece 'right_sign'
local right_cover5 = piece 'right_cover5'
local right_cover4 = piece 'right_cover4'
local right_cover3 = piece 'right_cover3'
local right_cover2 = piece 'right_cover2'
local right_cover1 = piece 'right_cover1'
local back_wall_top = piece 'back_wall_top'
local left_base = piece 'left_base'
local left_wall = piece 'left_wall'
local left_wall_extension = piece 'left_wall_extension' 	-- only used by bowvp
local left_cover5 = piece 'left_cover5'
local left_cover4 = piece 'left_cover4'
local left_cover3 = piece 'left_cover3'
local left_cover2 = piece 'left_cover2'
local left_cover1 = piece 'left_cover1'
local left_back_extension = piece 'left_back_extension'
local left_back_upgrade = piece 'left_back_upgrade'
local left_front_extension = piece 'left_front_extension'
local left_sign = piece 'left_sign'
local left_arm1 = piece 'left_arm1'
local left_arm2 = piece 'left_arm2'
local left_arm3 = piece 'left_arm3'
local left_head = piece 'left_head'
local left_pointer = piece 'left_pointer'

local pointer = { left_pointer, right_pointer }
local advpointer = { left_pointer1, right_pointer1, left_pointer2, right_pointer2 }

VFS.Include("scripts/include/springtweener.lua")

local scriptEnv = { base = base,
					right_arm1 = right_arm1,
					right_arm2 = right_arm2,
					right_arm3 = right_arm3,
					right_head = right_head,
					right_pointer = right_pointer,
					right_arm1_advanced = right_arm1_advanced,
					right_arm2_advanced = right_arm2_advanced,
					right_arm3_advanced = right_arm3_advanced,
					right_head_advanced = right_head_advanced,
					right_pointer1 = right_pointer1,
					right_pointer2 = right_pointer2,
					left_arm1_advanced = left_arm1_advanced,
					left_arm2_advanced = left_arm2_advanced,
					left_arm3_advanced = left_arm3_advanced,
					left_head_advanced = left_head_advanced,
					left_pointer1 = left_pointer1,
					left_pointer2 = left_pointer2,
					right_base = right_base,
					right_wall = right_wall,
					right_back_extension = right_back_extension,
					right_back_upgrade = right_back_upgrade,
					right_front_extension = right_front_extension,
					right_sign = right_sign,
					right_cover5 = right_cover5,
					right_cover4 = right_cover4,
					right_cover3 = right_cover3,
					right_cover2 = right_cover2,
					right_cover1 = right_cover1,
					back_wall_top = back_wall_top,
					left_base = left_base,
					left_wall = left_wall,
					left_cover5 = left_cover5,
					left_cover4 = left_cover4,
					left_cover3 = left_cover3,
					left_cover2 = left_cover2,
					left_cover1 = left_cover1,
					left_back_extension = left_back_extension,
					left_back_upgrade = left_back_upgrade,
					left_front_extension = left_front_extension,
					left_sign = left_sign,
					left_arm1 = left_arm1,
					left_arm2 = left_arm2,
					left_arm3 = left_arm3,
					left_head = left_head,
					left_pointer = left_pointer,
					rad = math.rad,
					x_axis = x_axis,
					y_axis = y_axis,
					z_axis = z_axis,
					Turn = Turn,
					Move = Move,
					Sleep = Sleep,
					initTween = initTween,
}

local PlayAnimation = VFS.Include("scripts/animations/bowvp_anim.lua", scriptEnv)

local HeadingAngle, PitchAngle, RestoreDelay, statechg_StateChanging
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

local function open_yard()
	UnitScript.SetUnitValue(COB.YARD_OPEN, 1);
	while (UnitScript.GetUnitValue(COB.YARD_OPEN) == 0) do
		UnitScript.SetUnitValue(COB.BUGGER_OFF, 1);
		Sleep(1500);
		UnitScript.SetUnitValue(COB.YARD_OPEN, 1);
	end
	UnitScript.SetUnitValue(COB.BUGGER_OFF, 0);
end

local function close_yard()
	UnitScript.SetUnitValue(COB.YARD_OPEN, 0);
	while(UnitScript.GetUnitValue(COB.YARD_OPEN) ~= 0) do
		UnitScript.SetUnitValue(COB.BUGGER_OFF, 1);
		Sleep(1500);
		UnitScript.SetUnitValue(COB.YARD_OPEN, 0);
	end
	UnitScript.SetUnitValue(COB.BUGGER_OFF, 0);
end

--local function RestoreAfterDelay()
--	Sleep (RestoreDelay)
--	Turn (aim , y_axis, 0, Rad(100.00000))
--	WaitForTurn (aim, y_axis)
--end

--
--local function WaitOneFrame()
--	Sleep (1)
--end

local function Stop()
	--Spring.UnitScript.Signal(SIG_STATECHG)
	--Spring.UnitScript.SetSignalMask(SIG_STATECHG)
	SetUnitValue(COB.INBUILDSTANCE, 0)	--set INBUILDSTANCE to 0
	--WaitOneFrame()
	---StartThread(RestoreAfterDelay)
	if isAdvanced then
		PlayAnimation.closeadv()
	else
		PlayAnimation.closestd()
	end
	close_yard()
end

local function Go()
	--Spring.UnitScript.Signal(SIG_STATECHG)
	--Spring.UnitScript.SetSignalMask(SIG_STATECHG)
	--WaitOneFrame()
	if isAdvanced then
		PlayAnimation.openadv() --'closestd, openadv, closeadv'
	else
		PlayAnimation.openstd() --'closestd, openadv, closeadv'
	end
	open_yard()
	SetUnitValue(COB.INBUILDSTANCE, 1)
end

local function RequestState(requestedstate, currentstate)
	--Spring.Echo("Requesting State: "..(requestedstate==0 and "build" or "stop"))
--	Spring.UnitScript.Signal(SIG_REQSTATE)
--	Spring.UnitScript.SetSignalMask(SIG_REQSTATE)
	if  statechg_StateChanging  then
		statechg_DesiredState = requestedstate
		return (0)
	end
	statechg_StateChanging = true
	currentstate = statechg_DesiredState
	statechg_DesiredState = requestedstate
	while statechg_DesiredState ~= currentstate  do
		if statechg_DesiredState == state.build then
			--Spring.Echo("bowvp_lus: Go now")
			Go()
			currentstate = state.build
		elseif statechg_DesiredState == state.stop then
			--Spring.Echo("bowvp_lus: Stop now")
			Stop()
			currentstate = state.stop
		end
	end
	statechg_StateChanging = false
end

local function Upgrade()
	--- Showing pieces at start is actually not needed; remove this after morphing tests are complete
	Show(left_wall_extension)
	Show(right_wall_extension)
	Show(left_back_upgrade)
	Show(right_back_upgrade)

	Show(left_arm1_advanced)
	Show(left_arm2_advanced)
	Show(left_arm3_advanced)
	Show(right_arm1_advanced)
	Show(right_arm2_advanced)
	Show(right_arm3_advanced)

	Show(left_head_advanced)
	Show(right_head_advanced)

	Show(right_pointer1)
	Show(right_pointer2)
	Show(left_pointer1)
	Show(left_pointer2)

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
end

local function InitState()
	HeadingAngle = nil
	PitchAngle = nil
	RestoreDelay = 5000
	justcreated = true
	statechg_DesiredState = 1
	statechg_StateChanging = false
	local unitDefID = UnitDefs[unitDefID].name
	if (unitDefID == "armvp") then
		isAdvanced = false

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

		--	=> Once bowlab is built insta-move (right/)left_wall_extension to final pos and hide them;
		Move(left_wall_extension, x_axis, 15.6373)	-- starts at local -15.63, to hide it
		Move(right_wall_extension, x_axis, -15.6373)
		Hide(left_wall_extension)
		Hide(right_wall_extension)

		--	=> Then move (right/)left_back_upgrade to final pos and hide them; (will be shown after upgrade)
		Move(left_back_upgrade, x_axis, 33.7314)	-- starts at local -23.0491, to hide it
		Move(right_back_upgrade, x_axis, -33.7314) --56.7805 -23.0491
		Hide(left_back_upgrade)
		Hide(right_back_upgrade)

	elseif (unitDefID == "armavp") then
		-- Upgrade()
		isAdvanced = true
		-- PlayAnimation.testanim()
	end

	--EnableTowers()
end

--function script.StartBuilding(heading, pitch)
--	HeadingAngle = heading
--	PitchAngle = pitch --  -math.max(minPitch, math.min(pitch, maxPitch))
--	--Spring.Echo("Source pitch: "..pitch)
--	StartThread(RequestState, state.build)
--end

--function script.StopBuilding()
--	StartThread(RequestState, state.stop)
--end

function script.QueryNanoPiece(piecenum)
	if isAdvanced then
		--piecenum = left_pointer1
		piecenum = advpointer[math.random(1,4)]
	else
		--piecenum = left_pointer
		piecenum = pointer[math.random(1,2)]
		--local pointer = { "left_pointer", "right_pointer" }
	end
	return piecenum
end

local function SweetSpot(piecenum)
	piecenum = base
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

local function getKilledFx(severity)
	local corpsetype = 3

	-- Maximum damage (severity > 99) effects
	local explosionFx1 = sfxFall + sfxSmoke + sfxFire + sfxExplodeOnHit + sfxBITMAP1
	local explosionFx2 = sfxShatter + sfxExplodeOnHit + sfxBITMAP3

	if severity <= 25  then
		corpsetype = 1
		explosionFx1 = sfxBITMAPONLY + sfxBITMAP1
		explosionFx2 = sfxBITMAPONLY + sfxBITMAP3
		return corpsetype, explosionFx1, explosionFx2 end
	if  severity <= 50  then
		corpsetype = 2
		explosionFx1 = sfxFall + sfxBITMAP1
		explosionFx2 = sfxFall + sfxBITMAP3
		return corpsetype, explosionFx1, explosionFx2 end
	if  severity <= 99  then
		corpsetype = 3
		explosionFx1 = sfxFall + sfxSmoke + sfxFire + sfxExplodeOnHit + sfxBITMAP1
		explosionFx2 = sfxFall + sfxSmoke + sfxFire + sfxExplodeOnHit + sfxBITMAP3
		return corpsetype, explosionFx1, explosionFx2 end
	-- > 99:
	return corpsetype, explosionFx1, explosionFx2
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage / maxHealth * 100

	local corpsetype, explosionFx1, explosionFx2 = getKilledFx(severity)

	Explode( left_sign			, explosionFx1)
	Explode( right_sign			, explosionFx2)
	Explode( back_wall_top		, explosionFx2)
	Explode( left_cover4		, explosionFx2)
	if not isAdvanced then
		Explode( left_head	, explosionFx1)
		Explode( right_head	, explosionFx2)
		Explode( left_arm2	, explosionFx2)
		Explode( right_arm2	, explosionFx2)
	else
		Explode( left_head_advanced		, explosionFx1)
		Explode( right_head_advanced	, explosionFx2)
		Explode( left_arm2_advanced		, explosionFx2)
		Explode( right_arm2_advanced	, explosionFx2)
	end
	return (corpsetype)
end
