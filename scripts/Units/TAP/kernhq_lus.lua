--
-- User: MaDDoX
-- Date: 07/11/22
-- Time: 2:20AM
--
----TODO (from kernhq_lus.lua)

local SIG_STATECHG = {}
local SIG_REQSTATE = {}

local base = piece 'base'
local right_arm = piece 'right_arm'
local left_arm = piece 'left_arm'
local right_head = piece 'right_head'
local nanoL = piece 'nanoL'
local left_head = piece 'left_head'
local nanoR = piece 'nanoR'
local antenna_upgrade = piece 'antenna_upgrade'
local Y_right = piece 'Y_right'
local Y_left = piece 'Y_left'

local right_arm_advanced = piece 'right_arm_advanced'
local left_arm_advanced = piece 'left_arm_advanced'
local right_head_advanced = piece 'right_head_advanced'
local left_head_advanced = piece 'left_head_advanced'
local left_pointer1 = piece 'left_pointer1'
local left_pointer2 = piece 'left_pointer2'
local right_pointer1 = piece 'right_pointer1'
local right_pointer2 = piece 'right_pointer2'

--
local build_pos = piece 'build_pos'
local upgradeR  = piece 'upgradeR'
local upgradeL  = piece 'upgradeL'
local antenna_axis = piece 'antenna_axis'

local land1 = piece 'land1'
local land2 = piece 'land2'
local plugFL = piece 'plugFL'
local plugFL2 = piece 'plugFL2'
local plugBL = piece 'plugBL'
local plugBL2 = piece 'plugBL2'
local plugFR = piece 'plugFR'
local plugFR2 = piece 'plugFR2'
local plugBR = piece 'plugBR'
local plugBR2 = piece 'plugBR2'

local pointer = { nanoL, nanoR }
local advpointer = { left_pointer1, right_pointer1, left_pointer2, right_pointer2 }

VFS.Include("scripts/include/springtweener.lua")

local scriptEnv = { base = base,
					right_head = right_head,
					left_head = left_head,
					left_pointer = nanoL,
					right_pointer = nanoR,
					land1 = land1,
					land2 = land2,
					plugFL = plugFL,
					plugFL2 = plugFL2,
					plugBL = plugBL,
					plugBL2 = plugBL2,
					plugFR = plugFR,
					plugFR2 = plugFR2,
					plugBR = plugBR,
					plugBR2	= plugBR2,
					right_arm_advanced = right_arm_advanced,
					left_arm_advanced = left_arm_advanced,
					right_head_advanced = right_head_advanced,
					left_head_advanced = left_head_advanced,
					left_pointer1 = left_pointer1,
					left_pointer2 = left_pointer2,
					right_pointer1 = right_pointer1,
					right_pointer2 = right_pointer2,
						--
					rad = math.rad,
					x_axis = x_axis,
					y_axis = y_axis,
					z_axis = z_axis,
					Turn = Turn,
					Move = Move,
					WaitForMove = WaitForMove,
					WaitForTurn = WaitForTurn,
					Sleep = Sleep,
					Show = Show,
					Hide = Hide,
					initTween = initTween,
					---
					Rand = math.random,
					Explode = Spring.UnitScript.Explode,
					sfxShatter = SFX.SHATTER,
					sfxFall = SFX.FALL,
					sfxFire = SFX.FIRE,
					sfxSmoke = SFX.SMOKE,
					sfxExplodeOnHit = SFX.EXPLODE_ON_HIT,
					---
					stdUnitDefName = "kernhq",
					advUnitDefName = "kernhq4",
					stdNanoPieces = pointer,
					advNanoPieces = advpointer,
					standardOnlyPieces = { },
					upgradeOnlyPieces = { right_arm_advanced, left_arm_advanced, right_head_advanced, left_head_advanced,
										  left_pointer1, left_pointer2, right_pointer1,	right_pointer2, antenna_upgrade,
										  upgradeR, upgradeL },
					explodePartsDefault = { right_arm, left_arm },
					explodePartsStandard = { left_head, right_head, antenna_axis },
					explodePartsAdvanced = { upgradeR, upgradeL },
	--
					ipairs = ipairs,
					unitID = unitID,
					unitDefName = UnitDefs[unitDefID].name,
					UnitScript = UnitScript,
					Spring = Spring,
					COB = COB,
					SFX = SFX,
}

local buildPiece = build_pos --building_plate
local PlayAnimation = VFS.Include("scripts/animations/kernhq_anim.lua", scriptEnv)
scriptEnv.PlayAnimation = PlayAnimation

script_create, script_activate, script_deactivate, script_killed, MorphUp = VFS.Include("scripts/include/factory_base.lua", scriptEnv)

function script.Create()
	Spin(antenna_axis, z_axis, 2)
	Spin(Y_right, x_axis, -1)
	Spin(Y_left, x_axis, 1)
	Spin(antenna_upgrade, z_axis, -1)
	script_create()
end

function script.Activate()
	--Spin(antenna_axis, z_axis, 90)
	script_activate()
end

function script.Deactivate()
	StopSpin(antenna_axis, z_axis)
	script_deactivate()
end

function script.Killed(recentDamage, maxHealth)
	script_killed(recentDamage, maxHealth)
end

-- Assign the desired buildpiece to the variable above
function script.QueryBuildInfo()
	if buildPiece then
		return buildPiece
	else
		return base
	end
end
