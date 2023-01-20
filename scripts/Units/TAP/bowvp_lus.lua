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
--
local build_pos = piece 'build_pos'

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
					nanoPieces = { left_pointer, right_pointer },
					advNanoPieces = { left_pointer1, left_pointer2, right_pointer1, right_pointer2 },
					stdUnitDefName = "armvp",
					advUnitDefName = "armavp",
					stdNanoPieces = { left_pointer, right_pointer },
					advNanoPieces = { left_pointer1, left_pointer2, right_pointer1, right_pointer2 },
					standardOnlyPieces = { left_arm1, left_arm2, left_arm3, left_head, left_pointer, right_arm1, right_arm2, right_arm3, right_head, right_pointer, },
					upgradeOnlyPieces = { left_arm1_advanced, left_arm2_advanced, left_arm3_advanced, left_head_advanced,
										  left_pointer1, left_pointer2, right_arm1_advanced, right_arm2_advanced, right_arm3_advanced, right_head_advanced,
										  right_pointer1, right_pointer2, left_back_upgrade, right_back_upgrade, },
					explodePartsDefault = { back_wall_top, right_sign, left_sign, left_cover1 },
					explodePartsStandard = { left_head, right_head, right_pointer, left_arm3 },
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
local PlayAnimation = VFS.Include("scripts/animations/bowvp_anim.lua", scriptEnv)
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
