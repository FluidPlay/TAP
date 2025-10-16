--
-- User: MaDDoX
-- Date: 05/10/21
-- Time: 20:47
--

--local SIG_STATECHG = {}
--local SIG_REQSTATE = {}

local base_root = piece 'base_root'
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
local barrelBasePiece = { [1] = turretaxis }
local turretPiece = { [1] = turret1 }
---barrel[weapIdx] is a table of the piece num of the barrel, per weapon Idx (eg: [1] = 3)
local barrelPiece = { [1] = turretbase }
local turretSpawner = { [1] = turret1spawner }
---restoreDelay[weapIdx] is a table of restore delays, per weapon Idx (eg: [1] = 1000)
local restoreDelay = { [1] = 3000 }

--VFS.Include("scripts/include/springtweener.lua")  ---### v2.0 springtweener scripts dismisses this include

local scriptEnv = {
    initTween = GG.InitTween, --initTween,
    --
    base_root = base_root,
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
    stdUnitDefName = "bowaspt",
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
    --turretPiece = turretPiece,
    barrelBasePiece = barrelBasePiece,
    barrelPiece = barrelPiece,
    restoreDelay = restoreDelay,
}

-- Eg: PlayAnimation.openadv()
local PlayAnimation = VFS.Include("scripts/animations/bowaspt_anim.lua", scriptEnv)
scriptEnv.PlayAnimation = PlayAnimation

----typically e.g. the turret for AimFromWeapon and the barrel for QueryWeapon.
--function script.AimFromWeapon(weapIdx)  -- the barrel from where it starts aiming from
--    return turretPiece[weapIdx] end
--function script.QueryWeapon(weapIdx)    -- that's the projectile spawn point piece (eg: "flare1")
--    return turretSpawner[weapIdx] end

function script.QueryWeapon1()
    --if flare2 then
    --    if gun1 == 2 then
    --        return flare1
    --    else
    --        return flare2
    --    end
    --else
    --    return flare1
    --end
    return turretSpawner[1]
end

function script.AimFromWeapon1()
    return turretPiece[1] end

function script.AimWeapon1( heading, pitch )
    --Turn (turret, 2, heading, turretYSpeed)
    --Turn (sleeve, 1, (0-pitch),turretXSpeed)
    --WaitForTurn(turret, 2)
    --WaitForTurn(sleeve, 1)
    --return (true)
    Turn(barrelBasePiece[1], z_axis, heading, 8.72)		--TODO: Externalize turret and barrel restore turn speeds
    Turn(barrelPiece[1], x_axis, pitch, 4.36)
    WaitForTurn(barrelBasePiece[1], z_axis)
    WaitForTurn(barrelPiece[1], x_axis)	-- was x_axis
    return true		--Return false if it shouldn't shoot (bad target maybe)
end

function script.FireWeapon1()
    --if gun1 == 1 then
    --    Emit(flare1, firingCEG)
    --    Move(cannon1, 3, kickback)
    --    Move(cannon1, 3, 0, kickbackRestoreSpeed)
    --    gun1 = 2
    --else
    --    Emit(flare2, firingCEG)
    --    Move(cannon2, 3, kickback)
    --    Move(cannon2, 3, 0, kickbackRestoreSpeed)
    --    gun1 = 1
    --end
    PlayAnimation.fireweapon()
end

----typically e.g. the turret for AimFromWeapon and the barrel for QueryWeapon.
--function script.AimFromWeapon(weapIdx)
--    return turretPiece[weapIdx] end
--function script.QueryWeapon(weapIdx)
--    return barrelPiece[weapIdx] end

script_create, script_activate, script_deactivate, script_killed, MorphUp =
            VFS.Include("scripts/include/scriptbase_air.lua", scriptEnv)

function script_fireWeapon(weapIdx, restoreDelay) --script.FireWeapon
    ---UnitScript.StartThread(RestoreAfterDelay(weapIdx), restoreDelay)
    --Spring.Echo("FireWeapon: FireWeapon")
    --EmitSfx (flare, 1024)
end

function PremorphAnimation()
    UnitScript.StartThread(function()
        PlayAnimation.premorphanim()    --deploy, for bowasp_lus.lua
        Spring.SetUnitRulesParam(unitID, "premorphanimdone", 1, { public = true })
    end)
end

function script.Create() end
    --script_create() end     --PlayAnimation.takeoff()
function script.Activate() end
    --script_activate() end   --PlayAnimation.takeoff()
function script.Deactivate() end
    --script_deactivate() end --PlayAnimation.land()
function script.Killed(recentDamage, maxHealth)
    script_killed(recentDamage, maxHealth) end
--function script.AimWeapon(weaponID, heading, pitch)
--    script_aimweapon(weaponID, heading, pitch) end
--function script.FireWeapon(weapIdx)
--    script_fireweapon(weapIdx, restoreDelay[weapIdx]) end
