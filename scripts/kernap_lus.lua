--
-- User: MaDDoX
-- Date: 07/11/22
-- Time: 2:20AM
--

local SIG_STATECHG = {}
local SIG_REQSTATE = {}

local base = piece 'base'
local right_back_base = piece 'right_back_base'
local right_back_protection = piece 'right_back_protection'
local right_box = piece 'right_box'
local right_cover = piece 'right_cover'
local right_elevator = piece 'right_elevator'
local right_arm = piece 'right_arm'
local right_head = piece 'right_head'
local right_pointer = piece 'right_pointer'
local right_arm_advanced = piece 'right_arm_advanced'
local right_head_advanced = piece 'right_head_advanced'
local right_pointer2 = piece 'right_pointer2'
local right_pointer1 = piece 'right_pointer1'
local right_frontal_base = piece 'right_frontal_base'
local right_frontal_protection = piece 'right_frontal_protection'
local right_frontal_upgrade = piece 'right_frontal_upgrade'
local building_plate_base = piece 'building_plate_base'
local building_plate_expansion4 = piece 'building_plate_expansion4'
local building_plate_expansion2 = piece 'building_plate_expansion2'
local building_plate_expansion1 = piece 'building_plate_expansion1'
local building_plate_expansion3 = piece 'building_plate_expansion3'
local left_back_base = piece 'left_back_base'
local left_back_protection = piece 'left_back_protection'
local left_box = piece 'left_box'
local left_elevator = piece 'left_elevator'
local left_arm = piece 'left_arm'
local left_head = piece 'left_head'
local left_pointer = piece 'left_pointer'
local left_arm_advanced = piece 'left_arm_advanced'
local left_head_advanced = piece 'left_head_advanced'
local left_pointer1 = piece 'left_pointer1'
local left_pointer2 = piece 'left_pointer2'
local left_cover = piece 'left_cover'
local left_frontal_base = piece 'left_frontal_base'
local left_frontal_protection = piece 'left_frontal_protection'
local left_frontal_upgrade = piece 'left_frontal_upgrade'

local nanoPieces = { left_pointer, right_pointer }
local advNanoPieces = { left_pointer1, left_pointer2, right_pointer1, right_pointer2 }

VFS.Include("scripts/include/springtweener.lua")

local scriptEnv = { base = base,
					right_back_base = right_back_base,
					right_back_protection = right_back_protection,
					right_box = right_box,
					right_cover = right_cover,
					right_elevator = right_elevator,
					right_arm = right_arm,
					right_head = right_head,
					right_pointer = right_pointer,
					right_arm_advanced = right_arm_advanced,
					right_head_advanced = right_head_advanced,
					right_pointer2 = right_pointer2,
					right_pointer1 = right_pointer1,
					right_frontal_base = right_frontal_base,
					right_frontal_protection = right_frontal_protection,
					right_frontal_upgrade = right_frontal_upgrade,
					building_plate_base = building_plate_base,
					building_plate_expansion4 = building_plate_expansion4,
					building_plate_expansion2 = building_plate_expansion2,
					building_plate_expansion1 = building_plate_expansion1,
					building_plate_expansion3 = building_plate_expansion3,
					left_back_base = left_back_base,
					left_back_protection = left_back_protection,
					left_box = left_box,
					left_elevator = left_elevator,
					left_arm = left_arm,
					left_head = left_head,
					left_pointer = left_pointer,
					left_arm_advanced = left_arm_advanced,
					left_head_advanced = left_head_advanced,
					left_pointer1 = left_pointer1,
					left_pointer2 = left_pointer2,
					left_cover = left_cover,
					left_frontal_base = left_frontal_base,
					left_frontal_protection = left_frontal_protection,
					left_frontal_upgrade = left_frontal_upgrade,
					rad = math.rad,
					x_axis = x_axis,
					y_axis = y_axis,
					z_axis = z_axis,
					Turn = Turn,
					Move = Move,
					WaitForMove = WaitForMove,
					WaitForTurn = WaitForTurn,
					Sleep = Sleep,
					initTween = initTween,
}

local PlayAnimation = VFS.Include("scripts/animations/kernap_anim.lua", scriptEnv)

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
			EmitSfx ( base, smoketype )
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
	SetUnitValue(COB.YARD_OPEN, 0);
	while(GetUnitValue(COB.YARD_OPEN) ~= 0) do
		SetUnitValue(COB.BUGGER_OFF, 1);
		Sleep(1500);
		SetUnitValue(COB.YARD_OPEN, 0);
	end
	SetUnitValue(COB.BUGGER_OFF, 0);
end

--local function RestoreAfterDelay()
--	Sleep (RestoreDelay)
--	Turn (aim , y_axis, 0, Rad(100.00000))
--	WaitForTurn (aim, y_axis)
--end

local function WaitOneFrame()
	Sleep (1)
end

local function morphAnimSetup()

	isAdvanced = true

	Show(left_frontal_upgrade)
	Show(right_frontal_upgrade)

	Show(left_arm_advanced)
		Show(left_head_advanced)
			Show(left_pointer1)
			Show(left_pointer2)

	Show(right_arm_advanced)
		Show(right_head_advanced)
			Show(right_pointer1)
			Show(right_pointer2)

	Hide(left_arm)
		Hide(left_head)
			Hide(left_pointer)
	Hide(right_arm)
		Hide(right_head)
			Hide(right_pointer)

	PlayAnimation.morphup()
end

-- This is called by unit_morph, when the 'animationonly' tag is set in the morphData
function MorphUp()
	Spring.SetUnitNanoPieces(unitID, advNanoPieces)
	StartThread(morphAnimSetup)
end

local function Stop()
	--Spring.UnitScript.Signal(SIG_STATECHG)
	--Spring.UnitScript.SetSignalMask(SIG_STATECHG)
	SetUnitValue(COB.INBUILDSTANCE, 0)	--set INBUILDSTANCE to 0
	--WaitOneFrame()
	---StartThread(RestoreAfterDelay)

	if isAdvanced then
		PlayAnimation.stopbuildadv()
	else
		PlayAnimation.stopbuildstd()
	end
	close_yard()
end

local function Go()
	--Spring.UnitScript.Signal(SIG_STATECHG)
	--Spring.UnitScript.SetSignalMask(SIG_STATECHG)
	--WaitOneFrame()

	if isAdvanced then
		PlayAnimation.buildadv() --'closestd, openadv, closeadv'
	else
		PlayAnimation.buildstd() --'closestd, openadv, closeadv'
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

local function InitState()
	HeadingAngle = nil
	PitchAngle = nil
	RestoreDelay = 5000
	justcreated = true
	statechg_DesiredState = 1
	statechg_StateChanging = false
	local unitDefID = UnitDefs[unitDefID].name
	if (unitDefID == "corlab") then
		isAdvanced = false
		Spring.SetUnitNanoPieces(unitID, nanoPieces)

		Hide(left_arm_advanced)
		Hide(right_arm_advanced)

		Hide(left_head_advanced)
		Hide(right_head_advanced)

		Hide(right_pointer1)
		Hide(right_pointer2)
		Hide(left_pointer1)
		Hide(left_pointer2)

		--Hide(right_upgrade)
		--Hide(left_upgrade)

		----	=> Once bowlab is built insta-move (right/)left_wall_extension to final pos and hide them;
		--Move(left_wall_extension, x_axis, 15.6373)	-- starts at local -15.63, to hide it
		--Move(right_wall_extension, x_axis, -15.6373)
		--Hide(left_wall_extension)
		--Hide(right_wall_extension)
		--
		----	=> Then move (right/)left_back_upgrade to final pos and hide them; (will be shown after upgrade)
		--Move(left_back_upgrade, x_axis, 33.7314)	-- starts at local -23.0491, to hide it
		--Move(right_back_upgrade, x_axis, -33.7314) --56.7805 -23.0491
		--Hide(left_back_upgrade)
		--Hide(right_back_upgrade)

		---TODO
	elseif (unitDefID == "coralab") then
		-- Upgrade()
		isAdvanced = true
		Spring.SetUnitNanoPieces(unitID, advNanoPieces)
	end

	--EnableTowers()
end

--function script.StartBuilding(heading, pitch)
--	HeadingAngle = heading
--	PitchAngle = pitch --  -math.max(minPitch, math.min(pitch, maxPitch))
--	--Spring.Echo("Source pitch: "..pitch)
--	StartThread(RequestState, state.build)
--end
--
--function script.StopBuilding()
--	StartThread(RequestState, state.stop)
--end

--- Replaced by Spring.SetUnitNanoPieces
--function script.QueryNanoPiece(piecenum)
--	if isAdvanced then
--		--piecenum = left_pointer1
--		piecenum = advNanoPieces[math.random(1,4)]
--	else
--		--piecenum = left_pointer
--		piecenum = nanoPieces[math.random(1,2)]
--		--local pointer = { "left_pointer", "right_pointer" }
--	end
--	return piecenum
--end

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

	Explode( left_cover, explosionFx1)
	Explode( building_plate_base, explosionFx2)
	Explode( left_cover			, explosionFx2)
	Explode( right_cover		, explosionFx2)
	if not isAdvanced then
		Explode( left_head	, explosionFx1)
		Explode( right_head	, explosionFx2)
		Explode( left_arm	, explosionFx2)
		Explode( right_arm	, explosionFx2)
	end
	---TODO
	--else
	--	Explode( left_head_advanced		, explosionFx1)
	--	Explode( right_head_advanced	, explosionFx2)
	--	Explode( left_arm2_advanced		, explosionFx2)
	--	Explode( right_arm2_advanced	, explosionFx2)
	--end
	return (corpsetype)
end
