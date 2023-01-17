--
-- User: MaDDoX
-- Date: 07/11/22
-- Time: 2:20AM
--

local SIG_STATECHG = {}
local SIG_REQSTATE = {}

local base = piece 'base'
local left_base = piece 'left_base'
local left_wall = piece 'left_wall'
local left_upgrade = piece 'left_upgrade'
local left_back_expansion = piece 'left_back_expansion'
local left_frontal_expension = piece 'left_frontal_expension'
local left_box = piece 'left_box'
local left_boxcover = piece 'left_boxcover'
local left_elevator = piece 'left_elevator'
local left_arm_advanced = piece 'left_arm_advanced'
local left_head_advanced = piece 'left_head_advanced'
local left_pointer1 = piece 'left_pointer1'
local left_pointer2 = piece 'left_pointer2'
local left_arm = piece 'left_arm'
local left_head = piece 'left_head'
local left_pointer = piece 'left_pointer'
local back_base = piece 'back_base'
local back_wall = piece 'back_wall'
local conver = piece 'conver'
local cover_extension = piece 'cover_extension'
local right_barrier = piece 'right_barrier'
local left_barrier = piece 'left_barrier'
local right_base = piece 'right_base'
local right_wall = piece 'right_wall'
local right_back_expansion = piece 'right_back_expansion'
local right_upgrade = piece 'right_upgrade'
local right_frontal_expansion = piece 'right_frontal_expansion'
local right_box = piece 'right_box'
local right_elevator = piece 'right_elevator'
local right_arm_advanced = piece 'right_arm_advanced'
local right_head_advanced = piece 'right_head_advanced'
local right_pointer2 = piece 'right_pointer2'
local right_pointer1 = piece 'right_pointer1'
local right_arm = piece 'right_arm'
local right_head = piece 'right_head'
local right_pointer = piece 'right_pointer'
local right_boxcover = piece 'right_boxcover'
--
local build_pos = piece 'build_pos'

local nanoPieces = { left_pointer, right_pointer }
local advNanoPieces = { left_pointer1, left_pointer2, right_pointer1, right_pointer2 }

VFS.Include("scripts/include/springtweener.lua")

local scriptEnv = { base = base,
					left_base = left_base,
					left_wall = left_wall,
					left_upgrade = left_upgrade,
					left_back_expansion = left_back_expansion,
					left_frontal_expension = left_frontal_expension,
					left_box = left_box,
					left_boxcover = left_boxcover,
					left_elevator = left_elevator,
					left_arm_advanced = left_arm_advanced,
					left_head_advanced = left_head_advanced,
					left_pointer1 = left_pointer1,
					left_pointer2 = left_pointer2,
					left_arm = left_arm,
					left_head = left_head,
					left_pointer = left_pointer,
					back_base = back_base,
					back_wall = back_wall,
					conver = conver,
					cover_extension = cover_extension,
					right_barrier = right_barrier,
					left_barrier = left_barrier,
					right_base = right_base,
					right_wall = right_wall,
					right_back_expansion = right_back_expansion,
					right_upgrade = right_upgrade,
					right_frontal_expansion = right_frontal_expansion,
					right_box = right_box,
					right_elevator = right_elevator,
					right_arm_advanced = right_arm_advanced,
					right_head_advanced = right_head_advanced,
					right_pointer2 = right_pointer2,
					right_pointer1 = right_pointer1,
					right_arm = right_arm,
					right_head = right_head,
					right_pointer = right_pointer,
					right_boxcover = right_boxcover,
					---
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
					nanoPieces = { left_pointer, right_pointer },
					advNanoPieces = { left_pointer1, left_pointer2, right_pointer1, right_pointer2 },
					stdUnitDefName = "corlab",
					advUnitDefName = "coralab",
					stdNanoPieces = { left_pointer, right_pointer },
					advNanoPieces = { left_pointer1, left_pointer2, right_pointer1, right_pointer2 },
					standardOnlyPieces = { left_arm, left_head, left_pointer, right_arm, right_head, right_pointer, },
					upgradeOnlyPieces = { left_arm_advanced, left_head_advanced,
										  left_pointer1, left_pointer2, right_arm_advanced, right_head_advanced,
										  right_pointer1, right_pointer2, left_back_upgrade, right_back_upgrade, },
					explodePartsDefault = { back_wall_top, right_sign, left_sign, left_cover1 },
					explodePartsStandard = { left_head, right_head, right_pointer, left_arm },
					explodePartsAdvanced = { left_pointer1, right_pointer2, left_head_advanced, left_back_upgrade },
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
local PlayAnimation = VFS.Include("scripts/animations/kernlab_anim.lua", scriptEnv)
scriptEnv.PlayAnimation = PlayAnimation

script_create, script_activate, script_deactivate, script_killed, MorphUp = VFS.Include("scripts/include/factory_base.lua", scriptEnv)

function script.Create()
	script_create()
end

function script.Activate()
	script_activate()
end

function script.Deactivate()
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