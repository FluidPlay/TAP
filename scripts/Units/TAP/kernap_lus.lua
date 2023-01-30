--
-- User: MaDDoX
-- Date: 07/11/22
-- Time: 2:20AM
--

local SIG_STATECHG = {}
local SIG_REQSTATE = {}

local base = piece 'base'
local right_back_base = piece 'right_back_base'
local right_back_protection = piece 'right_back_protection'
local right_box = piece 'right_box'
local right_cover = piece 'right_cover'
local right_elevator = piece 'right_elevator'
local right_arm = piece 'right_arm'
local right_head = piece 'right_head'
local right_pointer = piece 'right_pointer'
local right_arm_advanced = piece 'right_arm_advanced'
local right_head_advanced = piece 'right_head_advanced'
local right_pointer2 = piece 'right_pointer2'
local right_pointer1 = piece 'right_pointer1'
local right_frontal_base = piece 'right_frontal_base'
local right_frontal_protection = piece 'right_frontal_protection'
local right_frontal_upgrade = piece 'right_frontal_upgrade'
local building_plate_base = piece 'building_plate_base'
local building_plate_expansion4 = piece 'building_plate_expansion4'
local building_plate_expansion2 = piece 'building_plate_expansion2'
local building_plate_expansion1 = piece 'building_plate_expansion1'
local building_plate_expansion3 = piece 'building_plate_expansion3'
local left_back_base = piece 'left_back_base'
local left_back_protection = piece 'left_back_protection'
local left_box = piece 'left_box'
local left_elevator = piece 'left_elevator'
local left_arm = piece 'left_arm'
local left_head = piece 'left_head'
local left_pointer = piece 'left_pointer'
local left_arm_advanced = piece 'left_arm_advanced'
local left_head_advanced = piece 'left_head_advanced'
local left_pointer1 = piece 'left_pointer1'
local left_pointer2 = piece 'left_pointer2'
local left_cover = piece 'left_cover'
local left_frontal_base = piece 'left_frontal_base'
local left_frontal_protection = piece 'left_frontal_protection'
local left_frontal_upgrade = piece 'left_frontal_upgrade'

VFS.Include("scripts/include/springtweener.lua")

local scriptEnv = { base = base,
                    right_back_base = right_back_base,
                    right_back_protection = right_back_protection,
                    right_box = right_box,
                    right_cover = right_cover,
                    right_elevator = right_elevator,
                    right_arm = right_arm,
                    right_head = right_head,
                    right_pointer = right_pointer,
                    right_arm_advanced = right_arm_advanced,
                    right_head_advanced = right_head_advanced,
                    right_pointer2 = right_pointer2,
                    right_pointer1 = right_pointer1,
                    right_frontal_base = right_frontal_base,
                    right_frontal_protection = right_frontal_protection,
                    right_frontal_upgrade = right_frontal_upgrade,
                    building_plate_base = building_plate_base,
                    building_plate_expansion4 = building_plate_expansion4,
                    building_plate_expansion2 = building_plate_expansion2,
                    building_plate_expansion1 = building_plate_expansion1,
                    building_plate_expansion3 = building_plate_expansion3,
                    left_back_base = left_back_base,
                    left_back_protection = left_back_protection,
                    left_box = left_box,
                    left_elevator = left_elevator,
                    left_arm = left_arm,
                    left_head = left_head,
                    left_pointer = left_pointer,
                    left_arm_advanced = left_arm_advanced,
                    left_head_advanced = left_head_advanced,
                    left_pointer1 = left_pointer1,
                    left_pointer2 = left_pointer2,
                    left_cover = left_cover,
                    left_frontal_base = left_frontal_base,
                    left_frontal_protection = left_frontal_protection,
                    left_frontal_upgrade = left_frontal_upgrade,
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
                    stdUnitDefName = "corap",
                    advUnitDefName = "coraap",
                    stdNanoPieces = { left_pointer, right_pointer },
                    advNanoPieces = { left_pointer1, left_pointer2, right_pointer1, right_pointer2 },
                    standardOnlyPieces = { left_arm, left_head, left_pointer, right_arm, right_head, right_pointer, },
                    upgradeOnlyPieces = { left_frontal_upgrade, right_frontal_upgrade, left_arm_advanced, left_head_advanced,
                                          left_pointer1, left_pointer2, right_arm_advanced, right_head_advanced,
                                          right_pointer1, right_pointer2 },
                    explodePartsDefault = { left_cover, building_plate_base, left_cover, right_cover },
                    explodePartsStandard = { left_head, right_head, left_arm, right_arm },
                    explodePartsAdvanced = { left_pointer1, right_pointer1, left_pointer2, left_frontal_upgrade },
                    --
                    ipairs = ipairs,
                    unitID = unitID,
                    unitDefName = UnitDefs[unitDefID].name,
                    UnitScript = UnitScript,
                    Spring = Spring,
                    COB = COB,
                    SFX = SFX,
}

local PlayAnimation = VFS.Include("scripts/animations/kernap_anim.lua", scriptEnv)
scriptEnv.PlayAnimation = PlayAnimation
local buildPiece = piece 'build_pos'

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