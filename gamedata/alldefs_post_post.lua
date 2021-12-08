--
-- Created by IntelliJ IDEA.
-- User: Breno Azevedo
-- Date: 30/05/17
-- Time: 03:51
-- This loads after alldefs_post.lua, as defined in defs.lua
--

VFS.Include("gamedata/taptools.lua")
VFS.Include("gamedata/post_save_to_customparams.lua")

local unitDefs = DEFS.unitDefs
local unitDefsData = VFS.Include("gamedata/configs/unitdefs_data.lua")
local weaponDefsData = VFS.Include("gamedata/configs/weapondefs_data.lua")

--Spring.Echo("Saving PostProcessed Table: "..tablelength(unitDefs))

--TODO: Fix
local function sort_table(tbl)
	local array = {}
	for key, value in pairs(tbl) do
		array[#array + 1] = {key = key, value = value}
	end
	return table.sort(array)
end

local function table_to_string(tbl)
	--local sorttbl = sort_table(tbl)
	local result = "{\n"
	--for _, val in ipairs(sorttbl) do
	for k, v in pairs(tbl) do
		--local k = val.key
		--local v = val.value
		-- Check the key type (ignore any numerical keys - assume its an array)
		if type(k) == "string" then
			result = result.."[\""..k.."\"]".."="
		end
		-- Check the value type
		if type(v) == "table" then
			result = result..table_to_string(v)
		elseif type(v) == "boolean" or type(v) == "number" then
			result = result..tostring(v)
		else
			result = result.."\""..v.."\""
		end
		result = result..",\n"
	end
	-- Remove leading commas from the result
	if result ~= "" then
		result = result:sub(1, result:len()-1)
	end
	return result.."}\n"
end

-- Function to generate a table with all existing units' unitdefs, outputs to infolog.txt
-- Eg.: armfatf = { corpse = "DEAD", description = "Enhan...", }
-- PS: This data is usually only generated *once*, when new engine version fields are added
local function UnitDefsTemplateGenerator()
	local allUnits = {}
	local templateFields = unitDefsData.fields	-- This will be copied for each new unit data
	for udefID, udef in pairs(unitDefs) do
		if (istable(udef)) then
			local newUdef = table.deepcopy(templateFields)
			for key,val in pairs(udef) do
				local keyLower = string.lower(key)
				if (templateFields[keyLower] ~= nil) then
					newUdef[keyLower] = val
				else
					Spring.Echo("Warning: UnitDefKey ".. key .." not found in unitdefs_data.fields")
				end
			end
			table.insert(allUnits, {udefID, newUdef})
		end
	end
	Spring.Echo("##All UnitDefs\n")
	local udtstring = table_to_string(allUnits) --was: table.tosortedstring
	Spring.Echo(udtstring)
end

-- Function to generate a template with default values for all unitdefs_data fields (one-shot usually)
local function PrintUnitDefsTemplate()
	local unitDefTmpt = {}
	for _, udef in pairs(unitDefs) do
		if (istable(udef)) then
			for key,val in pairs(udef) do
				if (unitDefTmpt[key] == nil) then
					local defaultval = {}		-- table by default
					if type(val) == "string" then
						defaultval = ""
					elseif type(val) == "boolean" then
						defaultval = false
					elseif type(val) == "number" then
						defaultval = 0
					end
					unitDefTmpt[key] = defaultval
				end
			end
		end
	end
	local udtstring = table_to_string(unitDefTmpt) --was: table.tosortedstring
	Spring.Echo("##UnitDefs Template\n")
	Spring.Echo(udtstring)
end

-- Function to generate a template with default values for all unitdefs_data fields (one-shot usually)
-- **HOWTO: Run this first, to fill in weapondefs_data 'fields' entry
local function PrintWeaponDefsTemplate()
	local defaultval = {}
	local weaponDefTpt = {}
	for _, wDef in pairs(WeaponDefs) do
		if (istable(wDef)) then
			for key,val in pairs(wDef) do
				if (weaponDefTpt[key] == nil) then
					local defaultval = {}		-- table by default
					if type(val) == "string" then
						defaultval = ""
					elseif type(val) == "boolean" then
						defaultval = false
					elseif type(val) == "number" then
						defaultval = 0
					end
					weaponDefTpt[key] = defaultval
				end
			end
		end
	end
	local wdtstring = table_to_string(weaponDefTpt) --was: table.tosortedstring
	Spring.Echo("##WeaponDefs Template\n")
	Spring.Echo(wdtstring)
	Spring.Echo("##WeaponDefs Template End\n")
end

-- Outputs all Unit data (defs) to infolog.txt, in CSV format
-- Afterwards, unitdefs_data.lua will be re-generated from the spreadsheet
local function OutputUnitDefs()
	local allUnits = unitDefsData.data
	local text,sep = "", "`"
	Spring.Echo("##CSV Start\n")
	-- CSV Header
	local orderedDefsFields = table.csvkeys(unitDefsData.fields, sep)
	text = "UnitID"..sep..orderedDefsFields.."\n"
	-- CSV Body
	
	--Spring.Echo("##Units Count: "..#allUnits)
	for _,unit in ipairs (allUnits) do
		if (istable(unit)) then
			text = text .. tostring(unit[1]) .. sep		-- UnitDefID
			for _,v in pairsByKeys (unit[2]) do			-- Table with UnitDefs
				text = text .. tostringplus(v) .. sep
			end
			text = text .. "\n"
		end
	end
	Spring.Echo(text)
	Spring.Echo("##CSV End\n")
end


-- Function to generate a table with all existing weapondefs, outputs to infolog.txt
local function OutputWeaponDefs()
	local allWeapons = {}
	local text,sep = "", "`"
	Spring.Echo("##CSV Start\n")
	for name,ud in pairs(UnitDefs) do
		if ud.weapondefs then
			for name, wDef in pairs(ud.weapondefs) do
				local baseDamage = tonumber(wDef.damage.default)
				if not baseDamage or baseDamage <= 0 then
					return end
				-- Now let's clear out all previous values (deprecate armor classes) and reassign default damage
				wDef.damage = {}
				wDef.damage.default = baseDamage
				--local allUnits = {}
				--local templateFields = unitDefsData.fields	-- This will be copied for each new unit data
				--for udefID, udef in pairs(unitDefs) do
				if (istable(wDef)) then
					local wDefID = WeaponDefNames[name].id
					local newWdef = {} --table.deepcopy(templateFields)
					for key,val in pairs(wDef) do
						local keyLower = string.lower(key)
						newWdef[keyLower] = val
					end
					table.insert(allWeapons, { wDefID, newWdef }) --Eg: wDefID = { accuacy = 0, ... }
				end
				--end
			end
		end
		Spring.Echo("##All WeaponDefs\n")
		local wdtsstring = table_to_string(allWeapons)
		Spring.Echo(wdtsstring)
	end
end

--## Enable each of the post functions below as needed:

--PrintUnitDefsTemplate()
--UnitDefsTemplateGenerator() --<-- Uncomment to create unitdefs_data header

--PrintWeaponDefsTemplate()
--OutputWeaponDefs() --<-- Uncomment to create weapondefs_data header
--OutputUnitDefs() --<-- Uncomment to output unitdefs to csv format (at infolog.txt)
