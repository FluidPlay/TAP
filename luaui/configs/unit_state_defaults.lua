local alwaysHoldPos = {
	[UnitDefNames["armpw"].id] = true,
    [UnitDefNames["corak"].id] = true,
	[UnitDefNames["armmart"].id] = true,
    [UnitDefNames["cormort"].id] = true,
}

local holdPosException = {
	[UnitDefNames["armoutpost"].id] = true,
	[UnitDefNames["coroutpost"].id] = true,
}

local dontFireAtRadarUnits = {
	[UnitDefNames["armsnipe"].id] = true,
	--[UnitDefNames["hoverarty"].id] = true,
	--[UnitDefNames["turretantiheavy"].id] = true,
	--[UnitDefNames["vehheavyarty"].id] = true,
	--[UnitDefNames["shieldfelon"].id] = false,
	--[UnitDefNames["jumpskirm"].id] = false,
}

local factoryDefs = { -- Standard factories
	[UnitDefNames["armlab"].id] = 0,
	[UnitDefNames["corlab"].id] = 0,

	--[UnitDefNames["factorycloak"].id] = 0,
	--[UnitDefNames["factoryshield"].id] = 0,
	--[UnitDefNames["factoryspider"].id] = 0,
	--[UnitDefNames["factoryjump"].id] = 0,
	--[UnitDefNames["factoryveh"].id] = 0,
	--[UnitDefNames["factoryhover"].id] = 0,
	--[UnitDefNames["factoryamph"].id] = 0,
	--[UnitDefNames["factorytank"].id] = 0,
	--[UnitDefNames["factoryplane"].id] = 0,
	--[UnitDefNames["factorygunship"].id] = 0,
	--[UnitDefNames["factoryship"].id] = 0,
	--[UnitDefNames["platecloak"].id] = 0,
	--[UnitDefNames["plateshield"].id] = 0,
	--[UnitDefNames["platespider"].id] = 0,
	--[UnitDefNames["platejump"].id] = 0,
	--[UnitDefNames["plateveh"].id] = 0,
	--[UnitDefNames["platehover"].id] = 0,
	--[UnitDefNames["plateamph"].id] = 0,
	--[UnitDefNames["platetank"].id] = 0,
	--[UnitDefNames["plateplane"].id] = 0,
	--[UnitDefNames["plategunship"].id] = 0,
	--[UnitDefNames["plateship"].id] = 0,
}

return alwaysHoldPos, holdPosException, dontFireAtRadarUnits, factoryDefs
