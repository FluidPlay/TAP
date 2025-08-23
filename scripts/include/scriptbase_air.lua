--- By MaDDoX, in Oct 22 2025
--- ### How to use:
--- In your _lus.lua file, setup the scriptEnv table with everything to be used here (check bowasp_lus.lua for an example)
--- Then add these lines (eg):
--- 	local PlayAnimation = VFS.Include("scripts/animations/bowasp_anim.lua", scriptEnv)
---  	scriptEnv.PlayAnimation = PlayAnimation
---		script_create, script_activate, script_deactivate, script_killed,
---      	script_queryweapon, script_aimfromweapon, script_aimweapon, MorphUp = VFS.Include("scripts/include/scriptbase_air.lua", scriptEnv)
---		function script.Create()
---			script_create() end
---		function script.Activate()
---			script_activate() end
---		function script.Deactivate()
---			script_deactivate() end
---		function script.Killed(recentDamage, maxHealth)
---			script_killed(recentDamage, maxHealth) end
---		function script.QueryWeapon()
---			script_queryweapon(weaponID) end
---		function script.AimFromWeapon(weaponID)
---			script_aimfromweapon(weaponID) end
---		function script_aimweapon(weaponID, heading, pitch)
---			script.AimWeapon(weaponID, heading, pitch) end

local HeadingAngle, PitchAngle, RestoreDelay, statechg_StateChanging
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
local SIG_AIM = 1001

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

-- This is called by unit_morph, when the 'animationonly' tag is set in the morphData
-- The first morph-up animation is always the "advanced" mode one, thus it requires additional setup
function MorphUp()
	isAdvanced = true
	pieceSetup(true)
	Spring.SetUnitNanoPieces(unitID, advNanoPieces)
	UnitScript.StartThread(function()
		PlayAnimation.morphup()
	end)
end

-- Below are the subsequent morph-up animations; here we support up to 6 morph-up animations, but unit_morph might
-- need to be edited
function MorphUp2()
	UnitScript.StartThread(function ()
		PlayAnimation.morphup2()
	end)
end

function MorphUp3()
	UnitScript.StartThread(function ()
		PlayAnimation.morphup3()
	end)
end

function MorphUp4()
	UnitScript.StartThread(function ()
		PlayAnimation.morphup4()
	end)
end

function MorphUp5()
	UnitScript.StartThread(function ()
		PlayAnimation.morphup5()
	end)
end

function MorphUp6()
	UnitScript.StartThread(function ()
		PlayAnimation.morphup6()
	end)
end

local function Stop()
	--Spring.UnitScript.Signal(SIG_STATECHG)
	--Spring.UnitScript.SetSignalMask(SIG_STATECHG)
	if isAdvanced then
		PlayAnimation.landadv()
	else
		PlayAnimation.land()
	end
end

-- ** Actual "Takeoff" animation
local function Go()
	--UnitScript.Signal(SIG_STATECHG)
	--UnitScript.SetSignalMask(SIG_STATECHG)
	if isAdvanced then
		PlayAnimation.takeoffadv() --'closestd, openadv, closeadv'
	else
		PlayAnimation.takeoff() --'closestd, openadv, closeadv'
	end
end

--local function RequestState(requestedstate, currentstate)
--	--Spring.Echo("Requesting State: "..(requestedstate==0 and "build" or "stop"))
--	--	Spring.UnitScript.Signal(SIG_REQSTATE)
--	--	Spring.UnitScript.SetSignalMask(SIG_REQSTATE)
--	if  statechg_StateChanging  then
--		statechg_DesiredState = requestedstate
--		return (0)
--	end
--	statechg_StateChanging = true
--	currentstate = statechg_DesiredState
--	statechg_DesiredState = requestedstate
--	while statechg_DesiredState ~= currentstate  do
--		if statechg_DesiredState == state.build then
--			--Spring.Echo("scriptbaseair_lus: Go now")
--			Go()
--			currentstate = state.build
--		elseif statechg_DesiredState == state.stop then
--			--Spring.Echo("scriptbaseair_lus: Stop now")
--			Stop()
--			currentstate = state.stop
--		end
--	end
--	statechg_StateChanging = false
--end

local function InitState()
	HeadingAngle = nil
	PitchAngle = nil
	justcreated = true
	--RestoreDelay = 5000
	--statechg_DesiredState = 1
	--statechg_StateChanging = false

	pieceSetup(isAdvanced)
end

local function SweetSpot(piecenum)
	piecenum = base
end

function script_create()
	InitState()
	UnitScript.StartThread(SmokeUnit)
	UnitScript.StartThread(Stop)	--MaDD: test
end

-- Takeoff
function script_activate()
	--HeadingAngle = 0
	--UnitScript.StartThread(RequestState, state.build)
	--UnitScript.StartThread(Go)
end

-- Landing
function script_deactivate()
	--UnitScript.StartThread(RequestState, state.stop)
	--UnitScript.StartThread(Stop)
end

----========= Weapon Scripting ========----

--TODO
local function RestoreAfterDelay(weapIdx)
	Turn(turretPiece[weapIdx], y_axis, 0, 8.72)
	Turn(barrelPiece[weapIdx], x_axis, 0, 4.36)
end

---turret[weapIdx] is a table of the piece num of the turret, per weapon Idx (eg: [1] = 5)
---barrel[weapIdx] is a table of the piece num of the barrel, per weapon Idx (eg: [1] = 3)
---RestoreDelay[weapIdx] is a table of restore delays, per weapon Idx (eg: [1] = 1000)

function script_aimweapon(weapIdx, heading, pitch) --idx, piecenum)
	UnitScript.Signal(SIG_AIM)
	UnitScript.SetSignalMask(SIG_AIM)
	Turn(turretPiece[weapIdx], y_axis, heading, 8.72)		--TODO: Externalize turret and barrel restore turn speeds
	Turn(barrelPiece[weapIdx], x_axis, -pitch, 4.36)
	WaitForTurn(turretPiece[weapIdx], y_axis)
	WaitForTurn(barrelPiece[weapIdx], x_axis)
	return true		--Return false if it shouldn't shoot (bad target maybe)
end

--TODO: Implement & make restoreDelay work
function script_fireWeapon(weapIdx, restoreDelay) --script.FireWeapon
	---UnitScript.StartThread(RestoreAfterDelay(weapIdx), restoreDelay)
	PlayAnimation.fireweapon()
	--Spring.Echo("FireWeapon: FireWeapon")
	--EmitSfx (flare, 1024)
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

return script_create, script_activate, script_deactivate, script_killed, script_aimweapon, script_fireweapon, MorphUp, MorphUp2, MorphUp3, MorphUp4, MorphUp5, MorphUp6