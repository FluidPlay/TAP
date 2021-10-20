
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

-- mobile units that are excluded from the DRC formula
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
}

local minDRCmult = 0.1
local maxDRCmult = 4
local minWeaponRange = 50 -- minimum attack weapon range to be used in DRC calculations

----------------------------------------------------------------
-- Callins
----------------------------------------------------------------

--TODO: Below might be replaced by the customDef 'maxWeaponRange', but it's not properly set right now

local function GetFastestWeapRange(unitDefID)
    local unitDef = UnitDefs[unitDefID]
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
    -- If damage was not caused by another unit, do nothing
    if weaponDefID < 0 or excluded[attackerDefID] then  -- excluded units always deal full damage
        return damage, 1 end
    --and not UnitDefs[unitDefID].isBuilding and not excluded[unitDefID] then
    if not unitID or not attackerID or not unitDefID or not attackerDefID or not weaponDefID then
        return damage, 1 end

    local attackerWeaponRange = WeaponDefs[weaponDefID].range
    local victimWeapRange = GetFastestWeapRange(unitDefID)

    local DRCmult = clamp((victimWeapRange / attackerWeaponRange), minDRCmult, maxDRCmult) --eg: 200/50 = 4; 50/200 = 0.25
    Spring.Echo("Atk range: "..attackerWeaponRange.." Victim range: ".. victimWeapRange .." DRC mult: "..DRCmult.." original: "..damage.." final: "..(DRCmult * damage))
    damage = DRCmult * damage

    --local max_para_time = WeaponDefs[weaponDefID].damages and WeaponDefs[weaponDefID].damages.paralyzeDamageTime or maxParalysisTime
    --local h,mh,ph = Spring.GetUnitHealth(unitID)
    --local max_para_damage = mh + ((max_para_time<maxTime) and mh or mh*maxTime/max_para_time)
    --damage = math.min(damage, math.max(0,max_para_damage-ph) )

    return damage, 1
end
