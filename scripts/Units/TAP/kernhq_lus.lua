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
local advpointer = { nanoL, nanoR } -- left_pointer1, right_pointer1, left_pointer2, right_pointer2 }

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
					nanoPieces = { nanoL, nanoR },
					advNanoPieces = { nanoL, nanoR }, --left_pointer1, left_pointer2, right_pointer1, right_pointer2 },
					stdUnitDefName = "kernhq",
					advUnitDefName = "kernhq4",
					stdNanoPieces = { nanoL, nanoR },
					advNanoPieces = { nanoL, nanoR }, --{ left_pointer1, left_pointer2, right_pointer1, right_pointer2 },
					standardOnlyPieces = { },
					upgradeOnlyPieces = { antenna_upgrade, upgradeR, upgradeL },
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
