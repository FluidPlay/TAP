--
-- User: MaDDoX
-- Date: 07/11/22
-- Time: 2:20AM
--

local SIG_STATECHG = {}
local SIG_REQSTATE = {}

local base = piece 'base'
local left_building_base = piece 'left_building_base'
local left_box = piece 'left_box'
local left_cover = piece 'left_cover'
local left_elevator = piece 'left_elevator'
local left_arm1_advanced = piece 'left_arm1_advanced'
local left_arm2_advanced = piece 'left_arm2_advanced'
local left_arm3_advanced = piece 'left_arm3_advanced'
local left_head_advanced = piece 'left_head_advanced'
local left_pointer2 = piece 'left_pointer2'
local left_pointer1 = piece 'left_pointer1'
local left_arm1 = piece 'left_arm1'
local left_arm2 = piece 'left_arm2'
local left_arm3 = piece 'left_arm3'
local left_head = piece 'left_head'
local left_pointer = piece 'left_pointer'
local right_building_base = piece 'right_building_base'
local right_box = piece 'right_box'
local right_cover = piece 'right_cover'
local right_elevator = piece 'right_elevator'
local right_arm1 = piece 'right_arm1'
local right_arm2 = piece 'right_arm2'
local right_arm3 = piece 'right_arm3'
local right_head = piece 'right_head'
local right_pointer = piece 'right_pointer'
local right_arm1_advanced = piece 'right_arm1_advanced'
local right_arm2_advanced = piece 'right_arm2_advanced'
local right_arm3_advanced = piece 'right_arm3_advanced'
local right_head_advanced = piece 'right_head_advanced'
local right_pointer2 = piece 'right_pointer2'
local right_pointer1 = piece 'right_pointer1'
local plate_base = piece 'plate_base'
local right_sign = piece 'right_sign'
local left_sign = piece 'left_sign'
local upgrade = piece 'upgrade'
local building_plate = piece 'building_plate'
local plate_back_extension = piece 'plate_back_extension'
local plate_fontal_extension = piece 'plate_fontal_extension'

VFS.Include("scripts/include/springtweener.lua")

local scriptEnv = { base = base,
                    left_building_base = left_building_base,
                    left_box = left_box,
                    left_cover = left_cover,
                    left_elevator = left_elevator,
                    left_arm1_advanced = left_arm1_advanced,
                    left_arm2_advanced = left_arm2_advanced,
                    left_arm3_advanced = left_arm3_advanced,
                    left_head_advanced = left_head_advanced,
                    left_pointer2 = left_pointer2,
                    left_pointer1 = left_pointer1,
                    left_arm1 = left_arm1,
                    left_arm2 = left_arm2,
                    left_arm3 = left_arm3,
                    left_head = left_head,
                    left_pointer = left_pointer,
                    right_building_base = right_building_base,
                    right_box = right_box,
                    right_cover = right_cover,
                    right_elevator = right_elevator,
                    right_arm1 = right_arm1,
                    right_arm2 = right_arm2,
                    right_arm3 = right_arm3,
                    right_head = right_head,
                    right_pointer = right_pointer,
                    right_arm1_advanced = right_arm1_advanced,
                    right_arm2_advanced = right_arm2_advanced,
                    right_arm3_advanced = right_arm3_advanced,
                    right_head_advanced = right_head_advanced,
                    right_pointer2 = right_pointer2,
                    right_pointer1 = right_pointer1,
                    plate_base = plate_base,
                    right_sign = right_sign,
                    left_sign = left_sign,
                    upgrade = upgrade,
                    building_plate = building_plate,
                    plate_back_extension = plate_back_extension,
                    plate_fontal_extension = plate_fontal_extension,
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
                    stdUnitDefName = "armap",
                    advUnitDefName = "armaap",
                    stdNanoPieces = { left_pointer, right_pointer },
                    advNanoPieces = { left_pointer1, left_pointer2, right_pointer1, right_pointer2 },
                    standardOnlyPieces = { left_arm1, left_arm2, left_arm3, left_head, left_pointer, right_arm1, right_arm2, right_arm3, right_head, right_pointer, },
                    upgradeOnlyPieces = { upgrade, left_arm1_advanced, left_arm2_advanced, left_arm3_advanced, left_head_advanced,
                                          left_pointer1, left_pointer2, right_arm1_advanced, right_arm2_advanced, right_arm3_advanced, right_head_advanced,
                                          right_pointer1, right_pointer2 },
                    explodePartsDefault = { left_cover, right_cover, right_sign, left_sign },
                    explodePartsStandard = { left_head, right_head, right_pointer, left_arm3 },
                    explodePartsAdvanced = { left_pointer1, right_pointer2, left_head_advanced, upgrade },
                    --
                    ipairs = ipairs,
                    unitID = unitID,
                    unitDefName = UnitDefs[unitDefID].name,
                    UnitScript = UnitScript,
                    Spring = Spring,
                    COB = COB,
                    SFX = SFX,
}

local PlayAnimation = VFS.Include("scripts/animations/bowap_anim.lua", scriptEnv)
scriptEnv.PlayAnimation = PlayAnimation
local buildPiece = piece 'build_pos' --building_plate

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
