
function gadget:GetInfo()
    return {
        name      = 'Unit Damage Range Compensation (DRC) System',
        desc      = 'Reduces projectile damage according to range difference between units',
        author    = 'MaDDoX',
        version   = '0.9',
        date      = 'October 20, 2021',
        license   = 'GNU GPL, v3 or later',
        layer     = 0,
        enabled   = true,
    }
end

----------------------------------------------------------------
-- Synced only
----------------------------------------------------------------
if not gadgetHandler:IsSyncedCode() then
    return false
end

VFS.Include("gamedata/taptools.lua")

----------------------------------------------------------------
-- Vars
----------------------------------------------------------------

local maxTime = 20 -- in seconds

-- mobile units that, when *attacking*, are excluded from the DRC formula
local excluded = {
    --TODO: Exclude bombers, check for defenses
    [UnitDefNames.armcom.id] = true,
    [UnitDefNames.armcom1.id] = true,
    [UnitDefNames.armcom2.id] = true,
    [UnitDefNames.armcom3.id] = true,
    [UnitDefNames.armcom4.id] = true,
    [UnitDefNames.corcom.id] = true,
    [UnitDefNames.corcom1.id] = true,
    [UnitDefNames.corcom2.id] = true,
    [UnitDefNames.corcom3.id] = true,
    [UnitDefNames.corcom4.id] = true,
    -- Bombers
    [UnitDefNames.armthund.id] = true,
    [UnitDefNames.corshad.id] = true,
    [UnitDefNames.armpnix.id] = true,
    [UnitDefNames.corhurc.id] = true,
    [UnitDefNames.cortitan.id] = true,
    [UnitDefNames.corstil.id] = true,
    [UnitDefNames.armliche.id] = true,
    -- Long range stuff
    --TODO: Review a proper list of excluded units here
    [UnitDefNames.armsnipe.id] = true,
}

local minDRCmult = 0.1
local maxDRCmult = 4
local minWeaponRange = 50 -- minimum attack weapon range to be used in DRC calculations

----------------------------------------------------------------
-- Callins
----------------------------------------------------------------

--TODO: Below might be replaced by the customDef 'maxWeaponRange', but it's not properly set right now

local function GetFastestWeapRange(unitDef)
    --local unitShieldRange,fastWeaponRange =-1, -1 --assume unit has no shield and no weapon

    local fastestWeapRange = minWeaponRange -- minimum range we want for calculations
    local fastestReloadTime = 999

    --reference: gui_contextmenu.lua by CarRepairer
    for _, weapons in ipairs(unitDef["weapons"]) do
        local weaponsID = weapons["weaponDef"]
        local weaponsDef = WeaponDefs[weaponsID]
        -- Weapons with 'fake' or 'noweapon' in their name should be ignored
        if weaponsDef["name"] and not (weaponsDef["name"]:find('fake') or weaponsDef["name"]:find('noweapon')) then
            if not weaponsDef["isShield"] then -- it's a conventional weapon
                local reloadTime = weaponsDef["reload"]
                if reloadTime < fastestReloadTime then
                    fastestReloadTime = reloadTime
                    fastestWeapRange = weaponsDef["range"]
                end
            end
            -- else: unitShieldRange = weaponsDef["shieldRadius"] --remember the shield radius of this unit
        end
    end
    return fastestWeapRange
end

function gadget:UnitPreDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID,
                               attackerID, attackerDefID, attackerTeam)
    local unitDef = UnitDefs[unitDefID]
    local attackerDef = UnitDefs[attackerDefID]
    if not unitID or not attackerID or not unitDefID or not attackerDefID or not weaponDefID then
        return damage, 1 end
    -- If damage was not caused by another unit, do nothing; defenses are also buildings, will be bypassed too
    if weaponDefID < 0 or excluded[attackerDefID] or attackerDef.isBuilding or unitDef.isBuilding then  -- excluded units always deal & take full damage
        return damage, 1 end

    local attackerWeaponRange = WeaponDefs[weaponDefID] and WeaponDefs[weaponDefID].range or 200
    --if attackerWeaponRange > 745 then --really long range units are immune to DRC
    --    return damage, 1 end

    local victimWeapRange = GetFastestWeapRange(unitDef)

    local DRCmult = math_clamp(minDRCmult, maxDRCmult, (victimWeapRange / attackerWeaponRange)) --eg: 200/50 = 4; 50/200 = 0.25
    --Spring.Echo("Atk range: "..attackerWeaponRange.." Victim range: ".. victimWeapRange .." DRC mult: "..DRCmult.." original: "..damage.." final: "..(DRCmult * damage))
    damage = DRCmult * damage

    return damage, 1
end
