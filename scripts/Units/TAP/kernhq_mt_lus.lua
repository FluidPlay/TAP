base, mt_base, pole, head, aim_origin, missileprop_bot, missileprop_top = piece('base', 'mt_base', 'pole', 'head', 'aim_origin', 'missileprop_bot', 'missileprop_top')
flare_bot, flare_top = piece('missilespawn_bot', 'missilespawn_top')

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
				   [pole]={
					   [1]={cmd="move", axis=z_axis, targetValue=16.000000, firstFrame=0, lastFrame=40,},
				   },
		})
	end)
end

--- To restore to the default firing position; generally not used for turrets
local function RestoreAfterDelay()
	Sleep(2000)
	Turn(pole, z_axis, 0, 8.72)
	Turn(head, y_axis, 0, 4.36)
end

function script.AimFromWeapon(weaponID)
	--Spring.Echo("AimFromWeapon: FireWeapon")
	return aim_origin
end

function script.QueryWeapon(weaponID)
	--Spring.Echo("QueryWeapon: FireWeapon")
	fireSlot = (fireSlot+1)%2	-- will alternate between 0 and 1
	return (fireSlot == 1 and flare_bot or flare_top)
end

function script.AimWeapon(weaponID, heading, pitch)
	Signal(SIG_AIM)
	SetSignalMask(SIG_AIM)
	Turn(pole, z_axis, heading, 8.72)
	Turn(head, x_axis, -pitch, 4.36)
	WaitForTurn(pole, z_axis)
	WaitForTurn(head, x_axis)
	--StartThread(RestoreAfterDelay)
	return true
end

function script.FireWeapon(weaponID)
	local pieceToHide = (fireSlot == 1 and missileprop_top or missileprop_bot)
	UnitScript.StartThread(function ()
		Hide(pieceToHide)
		Move(pieceToHide, y_axis, 2.5)
		Sleep(500)
		Show(pieceToHide)
		--UnitScript.StartThread(function ()
		initTween({veryLastFrame=24, sleepTime = 0.066666,
				   [pieceToHide]={
					   [1]={cmd="move", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=24,},
				   },
		})
		--end)
	end)
end

function script.Killed()
	--Explode(base, SFX.SHATTER + SFX.NO_HEATCLOUD)
	Explode(missileprop_top, SFX.EXPLODE_ON_HIT + SFX.SMOKE + SFX.FIRE + SFX.FALL + SFX.NO_HEATCLOUD)
	Explode(pole, SFX.FALL + SFX.NO_HEATCLOUD)
	Explode(head, SFX.EXPLODE_ON_HIT + SFX.SMOKE + SFX.FIRE + SFX.FALL + SFX.NO_HEATCLOUD)
	return 3   -- spawn ARMSTUMP_DEAD corpse / This is the equivalent of corpsetype = 1; in bos
end
