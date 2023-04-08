base, pod, stand, head, turretcharger_L, turretcharger_R = piece('base', 'pod', 'stand', 'head', 'turretcharger_L', 'turretcharger_R')
flare_L, flare_R = piece('flare_L', 'flare_R')

VFS.Include("scripts/include/springtweener.lua")

fireSlot = 1

local SIG_AIM = {}

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
				   [stand]={
					   [1]={cmd="move", axis=z_axis, targetValue=15.000000, firstFrame=0, lastFrame=40,},
				   },
		})
	end)
end

--- To restore to the default firing position; generally not used for turrets
local function RestoreAfterDelay()
	Sleep(2000)
	Turn(stand, z_axis, 0, 8.72)
	Turn(head, y_axis, 0, 4.36)
end		

function script.AimFromWeapon(weaponID)
	--Spring.Echo("AimFromWeapon: FireWeapon")
	return head
end

function script.QueryWeapon(weaponID)
	--Spring.Echo("QueryWeapon: FireWeapon")
	fireSlot = (fireSlot+1)%2	-- will alternate between 0 and 1
	return (fireSlot == 1 and flare_L or flare_R)
end

function script.AimWeapon(weaponID, heading, pitch)
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	Turn(stand, z_axis, heading, 8.72)
	Turn(head, x_axis, -pitch, 4.36)
	WaitForTurn(stand, z_axis)
	WaitForTurn(head, x_axis)
	--StartThread(RestoreAfterDelay)
	return true
end

function script.FireWeapon(weaponID)
	UnitScript.StartThread(function ()
		initTween({veryLastFrame=88, sleepTime = 0.066666,
				   [turretcharger_L]={
					   [1]={cmd="move", axis=y_axis, targetValue=2.000000, firstFrame=0, lastFrame=2,},
					   [2]={cmd="move", axis=y_axis, targetValue=0.000000, firstFrame=4, lastFrame=36,},
				   },
				   [turretcharger_R]={
					   [1]={cmd="move", axis=y_axis, targetValue=2.000000, firstFrame=0, lastFrame=2,},
					   [2]={cmd="move", axis=y_axis, targetValue=0.000000, firstFrame=4, lastFrame=36,},
				   },
		})
	end)
	--EmitSfx (flare, 1024)
end

function script.Killed()
		--Explode(base, SFX.SHATTER + SFX.NO_HEATCLOUD)
		Explode(turretcharger_L, SFX.EXPLODE_ON_HIT + SFX.SMOKE + SFX.FIRE + SFX.FALL + SFX.NO_HEATCLOUD)
		Explode(head, SFX.FALL + SFX.NO_HEATCLOUD)
		Explode(turretcharger_R, SFX.EXPLODE_ON_HIT + SFX.SMOKE + SFX.FIRE + SFX.FALL + SFX.NO_HEATCLOUD)
		return 3   -- spawn ARMSTUMP_DEAD corpse / This is the equivalent of corpsetype = 1; in bos
end
