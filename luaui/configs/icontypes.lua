--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    icontypes.lua
--  brief:   icontypes definitions, used in unit_customicons.lua
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--This file is used by engine, it's just placed here so LuaUI can access it too
--------------------------------------------------------------------------------

local iconsPath = "LuaUI/Icons/"
local format = ".png"

--- iconID, baseIconSize
---- Eg: commanders
--	commander0 = {
--  	bitmap='icons/armcommander.dds',
--  	size=1.9,
-- 		distance=1.0,
--	},

local unitIconTable = {
	air_generic=1.25,
	air_radar=1.1,
	air_bomber=1.75,
	air_empbomber=2,
	air_nukebomber=2,
	air_builder=1.25,
	air_fighter=1.4,
	air_gunshiplaser=1.2,
	air_gunshipmissile=1.2,
	daemon=1.5,
	drone_scout=0.9,
	drone_antibot=1.2,
	drone_missile=1.25,
	def_artillery=1.8,
	def_builder=1.4,
	def_cannon=1.5,
	def_flak=1.4,
	def_generic=0.8,
	def_laser=1.3,
	def_missile=1.4,
	def_plasma=1.5,
	def_nuke=1.6,
	bot_artillery=1.1,
	bot_assault=1,
	bot_builder=1.1,
	bot_explosive=1.1,
	bot_farc=1.1,
	bot_generic=0.8,
	bot_missile=1,
	bot_flak=1,
	bot_rezz=1,
	bot_neutron=1.15,
	bot_antinuke=1.25,
	bot_plasma=1.1,
	bot_radar=1.1,
	bot_rifle=0.9,
	structure_mine=0.5,
	structure_antinuke=1.5,
	structure_energy=1.5,
	structure_factory=1.7,
	structure_generic=0.5,
	structure_metal=1.25,
	structure_nuke=1.95,
	structure_radar=1.1,
	structure_shield=1.1,
	structure_tech=1.5,
	structure_pad=2, --1.25
	structure_hq=2, --1.25
	veh_antibot=1.5,
	veh_artillery=1.4,
	veh_assault=1.5,
	veh_builder=1.5,
	veh_farc=1.25,
	veh_flak=1.5,
	veh_generic=1.5,
	veh_missile=1.5,
	veh_neutron=1.5,
	veh_antinuke=2,
	veh_radar=1.5,
	veh_tank=1.6,
	sea_generic = 1,
	sea_builder = 1,
	sea_assault = 0.9,
	sea_missile = 1,
	sea_flak = 1.05,
	sea_plasma = 1.1,
	sub_generic = 0.9,
	sea_cannon = 1.15,
	sea_neutron = 1.25,
	sub_builder = 0.9,
	sub_rezz = 0.95,
	sub_cannon = 0.9,
	--
	generic_unit=0.5, --1
	standard=1,
}

local tierSizeMult = {
	[0]=1.1,
	[1]=1.25,
	[2]=1.4,
	[3]=1.6,
	[4]=2,
}

-- 'Default' and 'None' standard iconType entries
local default = {
	size = 1.0,
	radiusadjust = 1,
}
local none = {
	size = 0,
	radiusadjust = 0,
}

-- iconTypes Processor, takes an 'iconTypes' table and initializes it (and found unit icons too)
local iconTypesProc = {
	Initialize = function (iconTypes) --loadUnitIcons
		local function addUnitIcon(iconName, path, size)
			if (path) then
				Spring.AddUnitIcon(iconName, path, size) end
			iconTypes[iconName] = {
				bitmap = path,
				size = size,
			}
		end
		local function tryAddUnitIcon(iconName, fileName, size)
			if VFS.LoadFile(fileName) then
				addUnitIcon(iconName, fileName, size)
			else
				Spring.Echo("Icon file not found: "..fileName)
			end
		end
		iconTypes.default = default
		iconTypes.none = none
		for iconid, baseSize in pairs(unitIconTable) do
			for tier = 0, 4 do  -- eg.: veh_tank_1.png (for a tier 1 tank)
				local calcSize = baseSize * tierSizeMult[tier]
				local fileName = iconsPath..iconid..".png"
				tryAddUnitIcon(iconid.."_"..tier, fileName, calcSize )
			end
		end
		-- Tech Centers (don't change size, just different images)
		local fileName = iconsPath.."structure_techcenter"
		for tier = 0, 4 do  -- eg.: veh_tank_1.png (for a tier 1 tank)
			local fileName = fileName..tier..".png"
			tryAddUnitIcon("structure_techcenter"..tier, fileName, 1.9 )
		end
		-- Outposts (don't change size, just different images)
		fileName = iconsPath.."structure_outpost"
		tryAddUnitIcon("structure_outpost", fileName..".png", 1.6 )
		tryAddUnitIcon( "structure_outpost2", fileName.."2.png", 1.7 )
		tryAddUnitIcon( "structure_outpost3", fileName.."3.png", 1.8 )
		tryAddUnitIcon( "structure_outpost4", fileName.."4.png", 1.9 )

		-- Commanders et al (fixed sizes)
		addUnitIcon("armcom.user", "LuaUI/Icons/armcom.png",2)
		addUnitIcon("corcom.user", "LuaUI/Icons/corcom.png",2)
		addUnitIcon("krogoth.user", "LuaUI/Icons/krogoth.png",3.3)
		addUnitIcon("bantha.user", "LuaUI/Icons/bantha.png",2.6)
		addUnitIcon("corjugg.user", "LuaUI/Icons/juggernaut.png",3.5)
		addUnitIcon("star.user", "LuaUI/Icons/star.png")
		addUnitIcon("blank.user", "LuaUI/Icons/blank.png")

		-- Setup the unitdef icons
		for udid,ud in pairs(UnitDefs) do
			if ud then
				local tier = ud.customParams.tier or 0
				local iconTag = ud.customParams.icontag
				--Spring.Echo(" udid | name: "..udid.." | "..ud.name.." subs: "..ud.name:sub(0,6))
				--      -- Icontag defined
				--      --Spring.Echo("Unit name for icon: "..ud.name)
				if iconTag then
					--Spring.Echo("Set icon: "..iconTag.."_"..tier)
					Spring.SetUnitDefIcon(udid, iconTag.."_"..tier)

				-- #################
				-- Exceptional Cases
				-- #################
				elseif (ud.name=="roost") or (ud.name=="meteor") then
					Spring.SetUnitDefIcon(udid, "star.user")
				elseif string.sub(ud.name, 0, 7) == "critter" then
					Spring.SetUnitDefIcon(udid, "blank.user")
				elseif ud.name == "armcom" or ud.name:sub(0,6)=="armcom" then    -- Tiers 1 through 4
					--Spring.Echo("Commander found")
					Spring.SetUnitDefIcon(udid, "armcom.user")
				elseif ud.name == "corcom" or ud.name:sub(0,6)=="corcom" then    -- Tiers 1 through 4
					--Spring.Echo("Commander found")
					Spring.SetUnitDefIcon(udid, "corcom.user")
				elseif ud.name == "armtech" or ud.name:sub(0,7)=="armtech" or    -- Tiers 1 through 4
						ud.name == "cortech" or ud.name:sub(0,7)=="cortech" then
					Spring.SetUnitDefIcon(udid, "structure_techcenter"..tier)
				elseif ud.name == "armoutpost" or ud.name == "coroutpost" then    -- Tiers 0 (no Tier 1)
					Spring.SetUnitDefIcon(udid, "structure_outpost")
				elseif ud.name:sub(0,10)=="armoutpost" or ud.name:sub(0,10)=="coroutpost" then -- Tiers 2 ~ 4
					Spring.SetUnitDefIcon(udid, "structure_outpost"..tier)
				elseif ud.name=="armbanth" then
					Spring.SetUnitDefIcon(udid, "bantha.user")
				elseif ud.name=="corkrog" then
					Spring.SetUnitDefIcon(udid, "krogoth.user")
				elseif ud.name=="corjugg" then
					Spring.SetUnitDefIcon(udid, "corjugg.user")
					--else
					--  Spring.SetUnitDefIcon(udid, "generic_unit_"..tier)
					--  Spring.Echo("Icontag for "..ud.name.." not found, setting it to generic_unit_"..tier)
				end
			end
		end
	end
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

return iconTypesProc

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

