--
-- User: MaDDoX
-- Date: 07/11/22
-- Time: 2:20AM
--

--local SIG_STATECHG = {}
--local SIG_REQSTATE = {}

local base = piece 'base'
local back_base = piece 'back_base'
local back_wall = piece 'back_wall'
local left_base = piece 'left_base'
local left_wall = piece 'left_wall'
local left_front_extension = piece 'left_front_extension'
local left_back_upgrade = piece 'left_back_upgrade'
local left_cover = piece 'left_cover'
local left_extension = piece 'left_extension'
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
local right_base = piece 'right_base'
local right_wall = piece 'right_wall'
local right_back_upgrade = piece 'right_back_upgrade'
local right_cover = piece 'right_cover'
local right_extension = piece 'right_extension'
local right_box = piece 'right_box'
local right_boxcover = piece 'right_boxcover'
local right_elevator = piece 'right_elevator'
local right_arm_advanced = piece 'right_arm_advanced'
local right_head_advanced = piece 'right_head_advanced'
local right_pointer2 = piece 'right_pointer2'
local right_pointer1 = piece 'right_pointer1'
local right_arm = piece 'right_arm'
local right_head = piece 'right_head'
local right_pointer = piece 'right_pointer'
local right_front_extension = piece 'right_front_extension'
--
local build_pos = piece 'build_pos'

VFS.Include("scripts/include/springtweener.lua")

local scriptEnv = { base = base,
                    back_base = back_base,
                    back_wall = back_wall,
                    left_base = left_base,
                    left_wall = left_wall,
                    left_front_extension = left_front_extension,
                    left_back_upgrade = left_back_upgrade,
                    left_cover = left_cover,
                    left_extension = left_extension,
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
                    right_base = right_base,
                    right_wall = right_wall,
                    right_back_upgrade = right_back_upgrade,
                    right_cover = right_cover,
                    right_extension = right_extension,
                    right_box = right_box,
                    right_boxcover = right_boxcover,
                    right_elevator = right_elevator,
                    right_arm_advanced = right_arm_advanced,
                    right_head_advanced = right_head_advanced,
                    right_pointer2 = right_pointer2,
                    right_pointer1 = right_pointer1,
                    right_arm = right_arm,
                    right_head = right_head,
                    right_pointer = right_pointer,
                    right_front_extension = right_front_extension,
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
                    stdUnitDefName = "corvp",
                    advUnitDefName = "coravp",
                    stdNanoPieces = { left_pointer, right_pointer },
                    advNanoPieces = { left_pointer1, left_pointer2, right_pointer1, right_pointer2 },
                    standardOnlyPieces = { left_arm, left_head, left_pointer, right_arm, right_head, right_pointer, },
                    upgradeOnlyPieces = { left_back_upgrade, right_back_upgrade, left_arm_advanced, left_head_advanced,
                                          left_pointer1, left_pointer2, right_arm_advanced, right_head_advanced,
                                          right_pointer1, right_pointer2 },
                    explodePartsDefault = { left_cover, right_cover, left_extension, },
                    explodePartsStandard = { left_head, right_head, left_arm, right_arm },
                    explodePartsAdvanced = { left_pointer1, right_pointer1, left_pointer2, right_back_upgrade },
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
local PlayAnimation = VFS.Include("scripts/animations/kernvp_anim.lua", scriptEnv)
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
