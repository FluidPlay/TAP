base, pole_base, pole_top, panelL_upgrade, panelR_upgrade, flare = piece('base', 'pole_base', 'pole_top', 'panelL_upgrade', 'panelR_upgrade', 'flare')

VFS.Include("scripts/include/springtweener.lua")

fireSlot = 1

local SIG_AIM = {}

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
local topSpinAngle = 35

local explosionFx1 = sfxFall + sfxSmoke + sfxFire + sfxExplodeOnHit
local explosionFx2 = sfxFall + sfxSmoke + sfxFire + sfxExplodeOnHit + sfxBITMAP3

--- For units which emit smoke when damaged, fired up from script.Create
function SmokeUnit(healthPercent, sleepTime, smokeType)
--SmokeUnit(healthpercent, sleeptime, smoketype)
--{
--	while( get BUILD_PERCENT_LEFT )
--	{
--		sleep 500;
--	}
--	while( TRUE )
--	{
--		healthpercent = get HEALTH;
--		if( healthpercent < 66 )
--		{
--			smoketype = 258;
--			if( Rand( 1, 66 ) < healthpercent )
--			{
--				smoketype = 257;
--			}
--			emit-sfx smoketype from base;
--		}
--		sleeptime = healthpercent * 50;
--		if( sleeptime < 200 )
--		{
--			sleeptime = 200;
--		}
--		sleep sleeptime;
--	}
--}
end

function script.Create()
	--StartThread(EnemyDetect)
	UnitScript.StartThread(function ()
		initTween({veryLastFrame=40,
				   [pole_top]={
					   [1]={cmd="move", axis=z_axis, targetValue=0.750000, firstFrame=0, lastFrame=40,},
					   [2]={cmd="move", axis=y_axis, targetValue=0.750000, firstFrame=0, lastFrame=40,},
				   },
		})
	end)
end

local function RotateAnim()
	if not GetUnitValue(COB.ACTIVATION) then
		return
	end
	initTween({ veryLastFrame = 4*30, --sleepTime = sleepTime,
				[base] = { [1] = { cmd = "turn", targetValue = math.rad(topSpinAngle),
								  axis = z_axis, easingFunction = "inOutCubic", firstFrame = 0, lastFrame = 120,}
				},
	} )
	initTween({ veryLastFrame = 4*30, --sleepTime = sleepTime,
				[base] = { [1] = { cmd = "turn", targetValue = math.rad(-topSpinAngle),
								  axis = z_axis, easingFunction = "inOutCubic", firstFrame = 0, lastFrame = 120,}
				},
	} )

	RotateAnim()
end

function script.Activate()
	StartThread(RotateAnim, true)
end

--- To restore to the default firing position; generally not used for turrets
local function RestoreAfterDelay()
	Sleep(2000)
	Turn(pole_top, z_axis, 0, 4.72)
	Turn(pole_base, y_axis, 0, 2.36)
end		

function script.AimFromWeapon(weaponID)
	--Spring.Echo("AimFromWeapon: FireWeapon")
	return pole_top
end

function script.QueryWeapon(weaponID)
	--Spring.Echo("QueryWeapon: FireWeapon")
	return flare
end

function script.AimWeapon(weaponID, heading, pitch)
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	Turn(pole_top, z_axis, heading, 8.72)
	Turn(pole_base, x_axis, -pitch, 4.36)
	WaitForTurn(pole_top, z_axis)
	WaitForTurn(pole_base, x_axis)
	StartThread(RestoreAfterDelay)
	return true
end

function script.FireWeapon(weaponID)
	--UnitScript.StartThread(function ()
	--	initTween({veryLastFrame=88, sleepTime = 0.066666,
	--			   [turretcharger_L]={
	--				   [1]={cmd="move", axis=y_axis, targetValue=2.000000, firstFrame=0, lastFrame=2,},
	--				   [2]={cmd="move", axis=y_axis, targetValue=0.000000, firstFrame=4, lastFrame=36,},
	--			   },
	--			   [turretcharger_R]={
	--				   [1]={cmd="move", axis=y_axis, targetValue=2.000000, firstFrame=0, lastFrame=2,},
	--				   [2]={cmd="move", axis=y_axis, targetValue=0.000000, firstFrame=4, lastFrame=36,},
	--			   },
	--	})
	--end)
	--EmitSfx (flare, 1024)
end

function script.Killed()
		--Explode(base, SFX.SHATTER + SFX.NO_HEATCLOUD)
		Explode(pole_top, explosionFx1)
		Explode(panelL_upgrade, explosionFx2)
		Explode(panelR_upgrade, explosionFx1)
		return 3   -- spawn ARMSTUMP_DEAD corpse / This is the equivalent of corpsetype = 1; in bos
end
