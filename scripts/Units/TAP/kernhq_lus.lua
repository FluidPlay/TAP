--
-- User: MaDDoX
-- Date: 07/11/22
-- Time: 2:20AM
--
----TODO (from kernhq_lus.lua)

--local SIG_STATECHG = {}
--local SIG_REQSTATE = {}

local base = piece 'base'
local frameL = piece 'frameL'
local extenderFL_root = piece 'extenderFL_root'
local extenderFL = piece 'extenderFL'
local plugFL = piece 'plugFL'
local plugFL2 = piece 'plugFL2'
local extenderBL_root = piece 'extenderBL_root'
local extenderBL = piece 'extenderBL'
local plugBL2 = piece 'plugBL2'
local antenna_base = piece 'antenna_base'
local antenna_axis = piece 'antenna_axis'
local Y_right = piece 'Y_right'
local Y_left = piece 'Y_left'
local antenna_upgrade = piece 'antenna_upgrade'
local plugBL = piece 'plugBL'
local padL_base = piece 'padL_base'
local PadL_top = piece 'PadL_top'
local land2 = piece 'land2'
local toppieceL = piece 'toppieceL'
local upgradeL = piece 'upgradeL'
local upgradeL_door = piece 'upgradeL_door'
local plug_advL = piece 'plug_advL'
local left_arm = piece 'left_arm'
local left_head = piece 'left_head'
local left_pointer = piece 'left_pointer'
local nanoL = piece 'nanoL'
local left_arm_advanced = piece 'left_arm_advanced'
local left_head_advanced = piece 'left_head_advanced'
local left_pointer1 = piece 'left_pointer1'
local left_pointer2 = piece 'left_pointer2'
local frameR = piece 'frameR'
local extenderFR_root = piece 'extenderFR_root'
local extenderFR = piece 'extenderFR'
local plugFR2 = piece 'plugFR2'
local plugFR = piece 'plugFR'
local extenderBR_root = piece 'extenderBR_root'
local extenderBR = piece 'extenderBR'
local plugBR2 = piece 'plugBR2'
local plugBR = piece 'plugBR'
local padR_base = piece 'padR_base'
local PadR_top = piece 'PadR_top'
local land1 = piece 'land1'
local toppieceR = piece 'toppieceR'
local right_arm = piece 'right_arm'
local right_head = piece 'right_head'
local right_pointer = piece 'right_pointer'
local nanoR = piece 'nanoR'
local right_arm_advanced = piece 'right_arm_advanced'
local right_head_advanced = piece 'right_head_advanced'
local right_pointer1 = piece 'right_pointer1'
local right_pointer2 = piece 'right_pointer2'
local upgradeR = piece 'upgradeR'
local upgradeR_door = piece 'upgradeR_door'
local plug_advR = piece 'plug_advR'
local build_pos = piece 'build_pos'

local spCreateUnit  = Spring.CreateUnit
local BLUnitName    = "kernhq_lt"

local pointer = { nanoL, nanoR }
local advpointer = { left_pointer1, right_pointer1, left_pointer2, right_pointer2 }

VFS.Include("scripts/include/springtweener.lua")

local scriptEnv = { base = base,
                    frameL = frameL,
                    extenderFL_root = extenderFL_root,
                    extenderFL = extenderFL,
                    plugFL = plugFL,
                    plugFL2 = plugFL2,
                    extenderBL_root = extenderBL_root,
                    extenderBL = extenderBL,
                    plugBL2 = plugBL2,
                    antenna_base = antenna_base,
                    antenna_axis = antenna_axis,
                    Y_right = Y_right,
                    Y_left = Y_left,
                    antenna_upgrade = antenna_upgrade,
                    plugBL = plugBL,
                    padL_base = padL_base,
                    PadL_top = PadL_top,
                    land2 = land2,
                    toppieceL = toppieceL,
                    upgradeL = upgradeL,
                    upgradeL_door = upgradeL_door,
                    plug_advL = plug_advL,
                    left_arm = left_arm,
                    left_head = left_head,
                    left_pointer = left_pointer,
                    nanoL = nanoL,
                    left_arm_advanced = left_arm_advanced,
                    left_head_advanced = left_head_advanced,
                    left_pointer1 = left_pointer1,
                    left_pointer2 = left_pointer2,
                    frameR = frameR,
                    extenderFR_root = extenderFR_root,
                    extenderFR = extenderFR,
                    plugFR2 = plugFR2,
                    plugFR = plugFR,
                    extenderBR_root = extenderBR_root,
                    extenderBR = extenderBR,
                    plugBR2 = plugBR2,
                    plugBR = plugBR,
                    padR_base = padR_base,
                    PadR_top = PadR_top,
                    land1 = land1,
                    toppieceR = toppieceR,
                    right_arm = right_arm,
                    right_head = right_head,
                    right_pointer = right_pointer,
                    nanoR = nanoR,
                    right_arm_advanced = right_arm_advanced,
                    right_head_advanced = right_head_advanced,
                    right_pointer1 = right_pointer1,
                    right_pointer2 = right_pointer2,
                    upgradeR = upgradeR,
                    upgradeR_door = upgradeR_door,
                    plug_advR = plug_advR,
                    build_pos = build_pos,
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
					standardOnlyPieces = { right_arm, left_arm, right_head, left_head },
					upgradeOnlyPieces = { right_arm_advanced, left_arm_advanced, right_head_advanced, left_head_advanced,
										  left_pointer1, left_pointer2, right_pointer1, right_pointer2, antenna_upgrade,
										  upgradeR, upgradeL, upgradeR_door, upgradeL_door },
					explodePartsDefault = { right_arm, left_arm },
					explodePartsStandard = { left_head, right_head, antenna_axis },
					explodePartsAdvanced = { upgradeR, upgradeL, upgradeR_door, upgradeL_door },
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

script_create, script_activate, script_deactivate, script_killed, MorphUp, MorphUp2, MorphUp3 = VFS.Include("scripts/include/factory_base.lua", scriptEnv)

function SpawnAtBL()
    local x,y,z = Spring.GetUnitPosition(unitID)
    local ofsx,ofsy,ofsz = Spring.GetUnitPiecePosition ( unitID, plugBR )
    local teamID = Spring.GetUnitTeam(unitID)
    --Spring.Echo("Pos x: "..(x+ofsx or "nil").." z: "..(z+ofsz or "nil").." teamID = "..teamID)
    local spawnedUnitID = spCreateUnit(BLUnitName, x+ofsx, y+ofsy, z+ofsz, 0, teamID)
    if not spawnedUnitID then
--        Spring.Echo("Unit not created")
        return end
--    Spring.Echo("Unit CREATED")
    Spring.UnitScript.AttachUnit ( plugBR, spawnedUnitID)
end

function script.Create()
    StartThread(function ()
        initTween({veryLastFrame=36,
                   [antenna_base]={
                       [1]={cmd="move", axis=z_axis, targetValue=15.000000, firstFrame=0, lastFrame=36,},
                   }
        })
    end)
	Spin(antenna_axis, z_axis, 2)
	Spin(Y_right, x_axis, -4)
	Spin(Y_left, x_axis, 4)
	Spin(antenna_upgrade, z_axis, -1)
    SpawnAtBL()
	script_create()
end

function script.Activate()
	--Spin(antenna_axis, z_axis, 90)
    --initTween({veryLastFrame=36,
    --           [antenna_base]={
    --               [1]={cmd="move", axis=z_axis, targetValue=15.000000, firstFrame=0, lastFrame=36,},
    --           }
    --})
	script_activate()
end

function script.Deactivate()
    --initTween({veryLastFrame=20,
    --           [antenna_base]={
    --               [1]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=0, lastFrame=20,},
    --           }
    --})
	--StopSpin(antenna_axis, z_axis)
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
