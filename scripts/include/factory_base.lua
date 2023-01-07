--- By MaDDoX, in Jan 7th 2023
--- ### How to use:
--- In your _lus.lua file, setup the scriptEnv table with everything to be used here (check kernap_lus.lua for an example)
--- Then add these lines:
--- 	local PlayAnimation = VFS.Include("scripts/animations/kernap_anim.lua", scriptEnv)
---  	scriptEnv.PlayAnimation = PlayAnimation
---		script_create, script_activate, script_deactivate, script_killed, MorphUp = VFS.Include("scripts/include/factory_base.lua", scriptEnv)
---		function script.Create()
---			script_create() end
---		function script.Activate()
---			script_activate() end
---		function script.Deactivate()
---			script_deactivate() end
---		function script.Killed(recentDamage, maxHealth)
---			script_killed(recentDamage, maxHealth) end

local HeadingAngle, PitchAngle, RestoreDelay, statechg_StateChanging
local state = { build = 0, stop = 1}
local statechg_DesiredState
local isAdvanced = false
local justcreated = false
local sfxBITMAPONLY = 32    --https://github.com/Balanced-Annihilation/Balanced-Annihilation/blob/master/scripts/exptype.h
local sfxBITMAP1 = 256
local sfxBITMAP2 = 512
local sfxBITMAP3 = 1024
local sfxBITMAP4 = 2048
local sfxBITMAP5 = 4096
local sfxShatter = SFX.SHATTER
local sfxFall = SFX.FALL
local sfxFire = SFX.FIRE
local sfxSmoke = SFX.SMOKE
local sfxExplodeOnHit = SFX.EXPLODE_ON_HIT

local function SmokeUnit(healthpercent, sleeptime, smoketype)
	while UnitScript.GetUnitValue(COB.BUILD_PERCENT_LEFT) do
		Sleep (400)
	end
	while true do
		local healthpercent = UnitScript.GetUnitValue(COB.HEALTH)
		if  healthpercent < 66  then
			smoketype = 258 --256 | 2
			if Rand (1, 66) < healthpercent  then
				smoketype = 257 end
			UnitScript.EmitSfx ( base, smoketype )
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

--local function WaitOneFrame()
--	Sleep (1)
--end

-- Eg.: (from kernap_lus.lua)
-- local upgradeOnlyPieces = { left_frontal_upgrade, right_frontal_upgrade, left_arm_advanced, left_head_advanced,
-- 								left_pointer1, left_pointer2, right_arm_advanced, right_head_advanced, right_pointer1, right_pointer2 }
-- local standardOnlyPieces = { left_arm, left_head, left_pointer, right_arm, right_head, right_pointer) }
local function pieceSetup(advanced)
	for _, piece in ipairs(standardOnlyPieces) do
		if (advanced) then
			Hide (piece)
		else
			Show (piece)
		end
	end

	for _, piece in ipairs(upgradeOnlyPieces) do
		if (advanced) then
			Show (piece)
		else
			Hide (piece)
		end
	end
end

local function morphAnimSetup()
	isAdvanced = true
	pieceSetup(true)
	PlayAnimation.morphup()
end

-- This is called by unit_morph, when the 'animationonly' tag is set in the morphData
function MorphUp()
	Spring.SetUnitNanoPieces(unitID, advNanoPieces)
	UnitScript.StartThread(morphAnimSetup)
end

local function Stop()
	--Spring.UnitScript.Signal(SIG_STATECHG)
	--Spring.UnitScript.SetSignalMask(SIG_STATECHG)
	UnitScript.SetUnitValue(COB.INBUILDSTANCE, 0)	--set INBUILDSTANCE to 0
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
	UnitScript.SetUnitValue(COB.INBUILDSTANCE, 1)
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
	if (unitDefName == stdUnitDefName) then
		isAdvanced = false
		Spring.SetUnitNanoPieces(unitID, stdNanoPieces)
	elseif (unitDefName == advUnitDefName) then
		isAdvanced = true
		Spring.SetUnitNanoPieces(unitID, advNanoPieces)
	end
	pieceSetup(isAdvanced)
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

function script_create()
	UnitScript.StartThread(SmokeUnit)
	InitState()
end

function script_activate()
	HeadingAngle = 0
	UnitScript.StartThread(RequestState, state.build)
end

function script_deactivate()
	UnitScript.StartThread(RequestState, state.stop)
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

-- Eg:
--local explodePartsDefault = { left_cover, building_plate_base, left_cover, right_cover }
--local explodePartsStandard = { left_head, right_head, left_arm, right_arm }
--local explodePartsAdvanced = { left_pointer1, right_pointer1, left_pointer2, left_frontal_upgrade }
function script_killed(recentDamage, maxHealth)
	local severity = recentDamage / maxHealth * 100
	local corpsetype, explosionFx1, explosionFx2 = getKilledFx(severity)

	for i, part in ipairs(explodePartsDefault) do
		UnitScript.Explode( part, i == 1 and explosionFx1 or explosionFx2)
	end
	if isAdvanced then
		for i, part in ipairs(explodePartsAdvanced) do
			UnitScript.Explode( part, i == 1 and explosionFx1 or explosionFx2)
		end
	else
		for i, part in ipairs(explodePartsStandard) do
			UnitScript.Explode( part, i == 1 and explosionFx1 or explosionFx2)
		end
	end

	return (corpsetype)
end

return script_create, script_activate, script_deactivate, script_killed, MorphUp