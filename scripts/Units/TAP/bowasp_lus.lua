--
-- User: MaDDoX
-- Date: 05/10/21
-- Time: 20:47
--

--local SIG_STATECHG = {}
--local SIG_REQSTATE = {}

local base = piece 'base'
local turretaxis = piece 'turretaxis'
local turretbase = piece 'turretbase'
local turret1 = piece 'turret1'
local turret1spawner = piece 'turret1spawner'
local turret3 = piece 'turret3'
local turret3spawner = piece 'turret3spawner'
local turret2 = piece 'turret2'
local turret2spawner = piece 'turret2spawner'
local wingFR = piece 'wingFR'
local wingBL = piece 'wingBL'
local wingBR = piece 'wingBR'
local wingFL = piece 'wingFL'
---turret[weapIdx] is a table of the piece num of the turret, per weapon Idx (eg: [1] = 5)
local turretPiece = { [1] = turretbase }
---barrel[weapIdx] is a table of the piece num of the barrel, per weapon Idx (eg: [1] = 3)
local barrelPiece = { [1] = turret1 }
---restoreDelay[weapIdx] is a table of restore delays, per weapon Idx (eg: [1] = 1000)
local restoreDelay = { [1] = 3000 }

--VFS.Include("scripts/include/springtweener.lua")  ---### v2.0 springtweener scripts dismisses this include

local scriptEnv = {
    initTween = GG.InitTween, --initTween,
    --
    base = base,
    turretaxis = turretaxis,
    turretbase = turretbase,
    turret1 = turret1,
    turret1spawner = turret1spawner,
    turret3 = turret3,
    turret3spawner = turret3spawner,
    turret2 = turret2,
    turret2spawner = turret2spawner,
    wingFR = wingFR,
    wingBL = wingBL,
    wingBR = wingBR,
    wingFL = wingFL,
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
    ---
    Rand = math.random,
    Explode = Spring.UnitScript.Explode,
    sfxShatter = SFX.SHATTER,
    sfxFall = SFX.FALL,
    sfxFire = SFX.FIRE,
    sfxSmoke = SFX.SMOKE,
    sfxExplodeOnHit = SFX.EXPLODE_ON_HIT,
    ---
    stdUnitDefName = "bowasp",
    advUnitDefName = "",    -- None, for now.
    standardOnlyPieces = {  },
    upgradeOnlyPieces = {  },
    explodePartsDefault = { wingFR, wingBL, turretbase },
    explodePartsStandard = { wingFR, wingFL, wingBR, wingBL },
    explodePartsAdvanced = { wingFR, wingFL, wingBR, wingBL, base },
    --
    ipairs = ipairs,
    unitID = unitID,
    unitDefName = UnitDefs[unitDefID].name,
    UnitScript = UnitScript,
    Spring = Spring,
    COB = COB,
    SFX = SFX,
    --
    turretPiece = turretPiece,
    barrelPiece = barrelPiece,
    restoreDelay = restoreDelay,
}

-- Eg: PlayAnimation.openadv()
local PlayAnimation = VFS.Include("scripts/animations/bowasp_anim.lua", scriptEnv)
scriptEnv.PlayAnimation = PlayAnimation

--typically e.g. the turret for AimFromWeapon and the barrel for QueryWeapon.
function script.AimFromWeapon(weapIdx)
    return turretPiece[weapIdx] end
function script.QueryWeapon(weapIdx)
    return barrelPiece[weapIdx] end

script_create, script_activate, script_deactivate, script_killed, script_aimweapon, script_fireweapon, MorphUp =
            VFS.Include("scripts/include/scriptbase_air.lua", scriptEnv)

function script_fireWeapon(weapIdx, restoreDelay) --script.FireWeapon
    ---UnitScript.StartThread(RestoreAfterDelay(weapIdx), restoreDelay)
    --Spring.Echo("FireWeapon: FireWeapon")
    --EmitSfx (flare, 1024)
end

function script.Create()
    script_create() end
function script.Activate()
    script_activate() end
function script.Deactivate()
    script_deactivate() end
function script.Killed(recentDamage, maxHealth)
    script_killed(recentDamage, maxHealth) end
function script.AimWeapon(weaponID, heading, pitch)
    script_aimweapon(weaponID, heading, pitch) end
--function script.FireWeapon(weapIdx)
--    script_fireweapon(weapIdx, restoreDelay[weapIdx]) end
