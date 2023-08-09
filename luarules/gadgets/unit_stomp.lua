function gadget:GetInfo()
  return {
    name      = "Experimental Bots Steps Damages",
    desc      = "Controls damages done by exp units footsteps",
    author    = "Doo",
    date      = "July 2017",
    license   = "Whatever you want, lua will make it",
    layer     = 0,
    enabled   = true
  }
end

local spAreTeamsAllied = Spring.AreTeamsAllied

if (not gadgetHandler:IsSyncedCode()) then return end
-- Exhaustive list of all units that will take damages from krog's footsteps (must be completed)
local StompedUnits = {
    [UnitDefNames["armfav"].id] = true,
    [UnitDefNames["corak"].id] = true,
    [UnitDefNames["armpw"].id] = true,
}

function gadget:UnitPreDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
	if WeaponDefs[weaponDefID] then
	if WeaponDefs[weaponDefID].name == "corkrog_krogkick" then 
		if (unitTeam) and (attackerTeam) then
		if spAreTeamsAllied(unitTeam, attackerTeam) == false then

			if StompedUnits[unitDefID] then	
				return 2000, 0
			else
				return 0, 0
			end
		else
			return 0, 0
		end
		end		
    end
	if WeaponDefs[weaponDefID].name == "corkarg_kargkick" then 
		return 0, 0
    end
	end
	return damage, nil
end