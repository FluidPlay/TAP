VFS.Include("LuaRules/Configs/customcmds.h.lua")

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Order and State Panel Positions

-- Commands are placed in their position, with conflicts resolved by pushing those
-- with less priority (higher number = less priority) along the positions if
-- two or more commands want the same position.
-- The command panel is propagated left to right, top to bottom.
-- The state panel is propagate top to bottom, right to left.
-- * States can use posSimple to set a different position when the panel is in
--   four-row mode.
-- * Missing commands have {pos = 1, priority = 100}

local cmdPosDef = {
	-- Commands
	[CMD.STOP]          = {pos = 1, priority = 1},
	[CMD.FIGHT]         = {pos = 1, priority = 2},
	[CMD_RAW_MOVE]      = {pos = 1, priority = 3},
	[CMD.PATROL]        = {pos = 1, priority = 4},
	[CMD.ATTACK]        = {pos = 1, priority = 5},
	[CMD_JUMP]          = {pos = 1, priority = 6},
	[CMD_AREA_GUARD]    = {pos = 1, priority = 10},
	[CMD.AREA_ATTACK]   = {pos = 1, priority = 11},

	[CMD_MORPH]        	= {pos = 13, priority = 1},
	[CMD_MORPH_STOP] 	= {pos = 13, priority = 2},
	[CMD_MORPH_QUEUE] 	= {pos = 13, priority = 3},
	[CMD_MORPH_PAUSE] 	= {pos = 13, priority = 4},
	[CMD_UPGRADE_UNIT] 	= {pos = 13, priority = 5},
	[CMD_UPGRADE_STOP] 	= {pos = 13, priority = 6},

	[CMD_STOP_NEWTON_FIREZONE] = {pos = 7, priority = -4},
	[CMD_NEWTON_FIREZONE]      = {pos = 7, priority = -3},

	[CMD.MANUALFIRE]      = {pos = 7, priority = 0.1},
	[CMD_PLACE_BEACON]    = {pos = 7, priority = 0.2},
	[CMD_ONECLICK_WEAPON] = {pos = 7, priority = 0.24},
	[CMD.STOCKPILE]       = {pos = 7, priority = 0.25},
	[CMD_ABANDON_PW]      = {pos = 7, priority = 0.3},
	[CMD_GBCANCEL]        = {pos = 7, priority = 0.4},
	[CMD_STOP_PRODUCTION] = {pos = 7, priority = 0.7},

	[CMD_BUILD]         = {pos = 7, priority = 0.8},
	[CMD_AREA_MEX]      = {pos = 7, priority = 1},
	[CMD.REPAIR]        = {pos = 7, priority = 2},
	[CMD.RECLAIM]       = {pos = 7, priority = 3},
	[CMD.RESURRECT]     = {pos = 7, priority = 4},
	[CMD.WAIT]          = {pos = 7, priority = 5},
	[CMD.CAPTURE]       = {pos = 7, priority = 6},
	[CMD_FIND_PAD]      = {pos = 7, priority = 7},

	[CMD.LOAD_UNITS]    = {pos = 7, priority = 7},
	[CMD.UNLOAD_UNITS]  = {pos = 7, priority = 8},
	[CMD_RECALL_DRONES] = {pos = 7, priority = 10},

	[CMD_AREA_TERRA_MEX]= {pos = 13, priority = 1},
	[CMD_UNIT_SET_TARGET_CIRCLE] = {pos = 13, priority = 2},
	[CMD_UNIT_CANCEL_TARGET]     = {pos = 13, priority = 3},
	[CMD_EMBARK]        = {pos = 13, priority = 5},
	[CMD_DISEMBARK]     = {pos = 13, priority = 6},
	[CMD_EXCLUDE_PAD]   = {pos = 13, priority = 7},

	-- States
	[CMD.REPEAT]              = {pos = 1, priority = 1},
	[CMD_RETREAT]             = {pos = 1, priority = 2},

	[CMD.MOVE_STATE]          = {pos = 6, posSimple = 5, priority = 1},
	[CMD.FIRE_STATE]          = {pos = 6, posSimple = 5, priority = 2},
	[CMD_FACTORY_GUARD]       = {pos = 6, posSimple = 5, priority = 3},

	[CMD_SELECTION_RANK]      = {pos = 6, posSimple = 1, priority = 1.5},

	[CMD_PRIORITY]            = {pos = 1, priority = 10},
	[CMD_MISC_PRIORITY]       = {pos = 1, priority = 11},
	[CMD_CLOAK_SHIELD]        = {pos = 1, priority = 11.5},
	[CMD_WANT_CLOAK]          = {pos = 1, priority = 11.6},
	[CMD_WANT_ONOFF]          = {pos = 1, priority = 13},
	[CMD_PREVENT_BAIT]        = {pos = 1, priority = 13.1},
	[CMD_PREVENT_OVERKILL]    = {pos = 1, priority = 13.2},
	[CMD_FIRE_TOWARDS_ENEMY]  = {pos = 1, priority = 13.25},
	[CMD_FIRE_AT_SHIELD]      = {pos = 1, priority = 13.3},
	[CMD.TRAJECTORY]          = {pos = 1, priority = 14},
	[CMD_UNIT_FLOAT_STATE]    = {pos = 1, priority = 15},
	[CMD_TOGGLE_DRONES]       = {pos = 1, priority = 16},
	[CMD_PUSH_PULL]           = {pos = 1, priority = 17},
	[CMD.IDLEMODE]            = {pos = 1, priority = 18},
	[CMD_AP_FLY_STATE]        = {pos = 1, priority = 19},
	[CMD_AUTO_CALL_TRANSPORT] = {pos = 1, priority = 21},
}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Factory Units Panel Positions

-- These positions must be distinct

-- Locally defined intermediate positions to cut down repetitions.
local unitTypes = {
	CONSTRUCTOR     = {order = 1, row = 1, col = 1},
	RAIDER          = {order = 2, row = 1, col = 2},
	SKIRMISHER      = {order = 3, row = 1, col = 3},
	RIOT            = {order = 4, row = 1, col = 4},
	ASSAULT         = {order = 5, row = 1, col = 5},
	ARTILLERY       = {order = 6, row = 1, col = 6},

	-- note: row 2 column 1 purposefully skipped, since
	-- that allows giving facs Attack orders via hotkey
	WEIRD_RAIDER    = {order = 7, row = 2, col = 2},
	ANTI_AIR        = {order = 8, row = 2, col = 3},
	HEAVY_SOMETHING = {order = 9, row = 2, col = 4},
	SPECIAL         = {order = 10, row = 2, col = 5},
	UTILITY         = {order = 11, row = 2, col = 6},
}

-- Add build options to be shown in integral menu here
local factoryUnitPosDef = {
	armoutpost = {
		--armrectr	=unitTypes.RIOT,
		--armca		=unitTypes.RAIDER,
		--armcs		=unitTypes.HEAVY_SOMETHING,
		--armmex		=unitTypes.ANTI_AIR,
		--armtech		=unitTypes.ARTILLERY,
		--armmstor	=unitTypes.RIOT,
		--armestor	=unitTypes.HEAVY_SOMETHING,
		--armsolar	=unitTypes.SKIRMISHER,
		--armwin		=unitTypes.SPECIAL,
		--armmakr		=unitTypes.ARTILLERY,
		--armgate		= unitTypes.HEAVY_SOMETHING, --{order = 3, row = 1, col = 3},
		--armasp		= unitTypes.HEAVY_SOMETHING --{order = 4, row = 1, col = 4},
	},
	armvp = {
		armfav 		= unitTypes.RIOT,
		armflash 	= unitTypes.RAIDER,
		armstump 	= unitTypes.HEAVY_SOMETHING,
		armsam 		= unitTypes.ANTI_AIR,
		armmart 	= unitTypes.ARTILLERY,
		armlatnk 	= unitTypes.RIOT,
		armbull 	= unitTypes.HEAVY_SOMETHING,
		armyork 	= unitTypes.SKIRMISHER,
		armmanni   	= unitTypes.SPECIAL,
		armmerl  	= unitTypes.ARTILLERY,
		armintr  	= unitTypes.RAIDER,
		armjam  	= unitTypes.UTILITY,
	},
	factorycloak = {
		cloakcon          = unitTypes.CONSTRUCTOR,
		cloakraid         = unitTypes.RAIDER,
		cloakheavyraid    = unitTypes.WEIRD_RAIDER,
		cloakriot         = unitTypes.RIOT,
		cloakskirm        = unitTypes.SKIRMISHER,
		cloakarty         = unitTypes.ARTILLERY,
		cloakaa           = unitTypes.ANTI_AIR,
		cloakassault      = unitTypes.ASSAULT,
		cloaksnipe        = unitTypes.HEAVY_SOMETHING,
		cloakbomb         = unitTypes.SPECIAL,
		cloakjammer       = unitTypes.UTILITY,
	},
	factoryshield = {
		shieldcon         = unitTypes.CONSTRUCTOR,
		shieldscout       = unitTypes.WEIRD_RAIDER,
		shieldraid        = unitTypes.RAIDER,
		shieldriot        = unitTypes.RIOT,
		shieldskirm       = unitTypes.SKIRMISHER,
		shieldarty        = unitTypes.ARTILLERY,
		shieldaa          = unitTypes.ANTI_AIR,
		shieldassault     = unitTypes.ASSAULT,
		shieldfelon       = unitTypes.HEAVY_SOMETHING,
		shieldbomb        = unitTypes.SPECIAL,
		shieldshield      = unitTypes.UTILITY,
	},
	factoryveh = {
		vehcon            = unitTypes.CONSTRUCTOR,
		vehscout          = unitTypes.WEIRD_RAIDER,
		vehraid           = unitTypes.RAIDER,
		vehriot           = unitTypes.RIOT,
		vehsupport        = unitTypes.SKIRMISHER, -- Not really but nowhere else to go
		veharty           = unitTypes.ARTILLERY,
		vehaa             = unitTypes.ANTI_AIR,
		vehassault        = unitTypes.ASSAULT,
		vehheavyarty      = unitTypes.HEAVY_SOMETHING,
		vehcapture        = unitTypes.SPECIAL,
	},
	factoryhover = {
		hovercon          = unitTypes.CONSTRUCTOR,
		hoverraid         = unitTypes.RAIDER,
		hoverheavyraid    = unitTypes.WEIRD_RAIDER,
		hoverdepthcharge  = unitTypes.SPECIAL,
		hoverriot         = unitTypes.RIOT,
		hoverskirm        = unitTypes.SKIRMISHER,
		hoverarty         = unitTypes.ARTILLERY,
		hoveraa           = unitTypes.ANTI_AIR,
		hoverassault      = unitTypes.ASSAULT,
	},
	factorygunship = {
		gunshipcon        = unitTypes.CONSTRUCTOR,
		gunshipemp        = unitTypes.WEIRD_RAIDER,
		gunshipraid       = unitTypes.RAIDER,
		gunshipheavyskirm = unitTypes.ARTILLERY,
		gunshipskirm      = unitTypes.SKIRMISHER,
		gunshiptrans      = unitTypes.SPECIAL,
		gunshipheavytrans = unitTypes.UTILITY,
		gunshipaa         = unitTypes.ANTI_AIR,
		gunshipassault    = unitTypes.ASSAULT,
		gunshipkrow       = unitTypes.HEAVY_SOMETHING,
		gunshipbomb       = unitTypes.RIOT,
	},
	factoryplane = {
		planecon          = unitTypes.CONSTRUCTOR,
		planefighter      = unitTypes.RAIDER,
		bomberriot        = unitTypes.RIOT,
		bomberstrike      = unitTypes.SKIRMISHER,
		-- No Plane Artillery
		planeheavyfighter = unitTypes.WEIRD_RAIDER,
		planescout        = unitTypes.UTILITY,
		planelightscout   = unitTypes.ARTILLERY,
		bomberprec        = unitTypes.ASSAULT,
		bomberheavy       = unitTypes.HEAVY_SOMETHING,
		bomberdisarm      = unitTypes.SPECIAL,
	},
	factoryspider = {
		spidercon         = unitTypes.CONSTRUCTOR,
		spiderscout       = unitTypes.RAIDER,
		spiderriot        = unitTypes.RIOT,
		spiderskirm       = unitTypes.SKIRMISHER,
		-- No Spider Artillery
		spideraa          = unitTypes.ANTI_AIR,
		spideremp         = unitTypes.WEIRD_RAIDER,
		spiderassault     = unitTypes.ASSAULT,
		spidercrabe       = unitTypes.HEAVY_SOMETHING,
		spiderantiheavy   = unitTypes.SPECIAL,
	},
	factoryjump = {
		jumpcon           = unitTypes.CONSTRUCTOR,
		jumpscout         = unitTypes.WEIRD_RAIDER,
		jumpraid          = unitTypes.RAIDER,
		jumpblackhole     = unitTypes.RIOT,
		jumpskirm         = unitTypes.SKIRMISHER,
		jumparty          = unitTypes.ARTILLERY,
		jumpaa            = unitTypes.ANTI_AIR,
		jumpassault       = unitTypes.ASSAULT,
		jumpsumo          = unitTypes.HEAVY_SOMETHING,
		jumpbomb          = unitTypes.SPECIAL,
	},
	factorytank = {
		tankcon           = unitTypes. CONSTRUCTOR,
		tankraid          = unitTypes.WEIRD_RAIDER,
		tankheavyraid     = unitTypes.RAIDER,
		tankriot          = unitTypes.RIOT,
		tankarty          = unitTypes.ARTILLERY,
		tankheavyarty     = unitTypes.UTILITY,
		tankaa            = unitTypes.ANTI_AIR,
		tankassault       = unitTypes.ASSAULT,
		tankheavyassault  = unitTypes.HEAVY_SOMETHING,
	},
	factoryamph = {
		amphcon           = unitTypes.CONSTRUCTOR,
		amphraid          = unitTypes.RAIDER,
		amphimpulse       = unitTypes.WEIRD_RAIDER,
		amphriot          = unitTypes.RIOT,
		amphfloater       = unitTypes.SKIRMISHER,
		amphsupport       = unitTypes.ASSAULT,
		amphaa            = unitTypes.ANTI_AIR,
		amphassault       = unitTypes.HEAVY_SOMETHING,
		amphlaunch        = unitTypes.ARTILLERY,
		amphbomb          = unitTypes.SPECIAL,
		amphtele          = unitTypes.UTILITY,
	},
	factoryship = {
		shipcon           = unitTypes.CONSTRUCTOR,
		shiptorpraider    = unitTypes.RAIDER,
		shipriot          = unitTypes.RIOT,
		shipskirm         = unitTypes.SKIRMISHER,
		shiparty          = unitTypes.ARTILLERY,
		shipaa            = unitTypes.ANTI_AIR,
		shipscout         = unitTypes.WEIRD_RAIDER,
		shipassault       = unitTypes.ASSAULT,
		-- No Ship HEAVY_SOMETHING (yet)
		subraider         = unitTypes.SPECIAL,
	},
	pw_bomberfac = {
		bomberriot        = unitTypes.RIOT,
		bomberprec        = unitTypes.ASSAULT,
		bomberheavy       = unitTypes.HEAVY_SOMETHING,
		bomberdisarm      = unitTypes.SPECIAL,
	},
	pw_dropfac = {
		gunshiptrans      = unitTypes.SPECIAL,
		gunshipheavytrans = unitTypes.UTILITY,
	},
}

-- Factory plates copy their parents.
factoryUnitPosDef.platecloak   = Spring.Utilities.CopyTable(factoryUnitPosDef.factorycloak)
factoryUnitPosDef.plateshield  = Spring.Utilities.CopyTable(factoryUnitPosDef.factoryshield)
factoryUnitPosDef.plateveh     = Spring.Utilities.CopyTable(factoryUnitPosDef.factoryveh)
factoryUnitPosDef.platehover   = Spring.Utilities.CopyTable(factoryUnitPosDef.factoryhover)
factoryUnitPosDef.plategunship = Spring.Utilities.CopyTable(factoryUnitPosDef.factorygunship)
factoryUnitPosDef.plateplane   = Spring.Utilities.CopyTable(factoryUnitPosDef.factoryplane)
factoryUnitPosDef.platespider  = Spring.Utilities.CopyTable(factoryUnitPosDef.factoryspider)
factoryUnitPosDef.platejump    = Spring.Utilities.CopyTable(factoryUnitPosDef.factoryjump)
factoryUnitPosDef.platetank    = Spring.Utilities.CopyTable(factoryUnitPosDef.factorytank)
factoryUnitPosDef.plateamph    = Spring.Utilities.CopyTable(factoryUnitPosDef.factoryamph)
factoryUnitPosDef.plateship    = Spring.Utilities.CopyTable(factoryUnitPosDef.factoryship)

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Construction Panel Structure Positions

-- These positions must be distinct

---HOWTO: Build options not assigned to the category tables below, will go to "Units" (N shortcut by default)


local factory_commands = {
	--BOWHQ / ARMMSTOR (ore tower)
	armck     	= {order = 1, row = 1, col = 1},
    armcv     	= {order = 2, row = 1, col = 2},
	armca     	= {order = 3, row = 1, col = 3},
	armcs     	= {order = 4, row = 1, col = 4},
    armfark		= {order = 5, row = 1, col = 5},
	bowdaemon	= {order = 6, row = 2, col = 1},
	-- BUILDER EXCLUSIVE
	armsonar	= {order = 1, row = 2, col = 4},
	armoutpost	= {order = 2, row = 1, col = 5},
	--ARMOUTPOST
	armlab		= {order = 1, row = 1, col = 1},
	armvp 		= {order = 2, row = 1, col = 2},
	armap		= {order = 3, row = 1, col = 3},
	armsy 		= {order = 4, row = 1, col = 4},
	armtech 	= {order = 5, row = 2, col = 1},
	armrad		= {order = 6, row = 2, col = 2},
	armjamt		= {order = 7, row = 2, col = 3},
	armpad		= {order = 8, row = 2, col = 4},
	---armoutpost	= {order = 1, row = 2, col = 4},	--Outpost2
	--ARMLAB
    armpw		= {order = 1, row = 1, col = 1},
    armrock		= {order = 2, row = 1, col = 2},
    armham		= {order = 3, row = 1, col = 3},
	armrectr	= {order = 4, row = 1, col = 4},
    armwar		= {order = 5, row = 2, col = 1},
    armmark		= {order = 6, row = 2, col = 2},
	-- ARMVP
	armfav 		= {order = 1, row = 1, col = 1},
	armflash 	= {order = 3, row = 1, col = 2},
	armstump 	= {order = 5, row = 1, col = 3},
	armsam 		= {order = 7, row = 1, col = 4},
	armmart		= {order = 9, row = 1, col = 5},
	-- ARMAP
	armkam		= {order = 1, row = 1, col = 1},
	armfig		= {order = 2, row = 1, col = 2},
	armthund	= {order = 3, row = 1, col = 3},
	armanac		= {order = 4, row = 1, col = 4},
	armbrawl	= {order = 5, row = 1, col = 5},
	armkameyes	= {order = 6, row = 1, col = 6},
	armatlas	= {order = 7, row = 2, col = 1},
	-- ARMSY
	armpt		= {order = 1, row = 1, col = 1},
	armpship	= {order = 2, row = 1, col = 2},
	armsjam		= {order = 3, row = 1, col = 3},
	armtship	= {order = 4, row = 1, col = 4},
	armroy		= {order = 5, row = 2, col = 1},
	armsub		= {order = 6, row = 2, col = 2},
	armcrus		= {order = 7, row = 2, col = 3},
	--========
	-- KERN
	--========
	-- KERNHQ / CORMSTOR (ore tower)
	corck		= {order = 1, row = 1, col = 1},
	corcv		= {order = 2, row = 1, col = 2},
	corca		= {order = 3, row = 1, col = 3},
	corcs		= {order = 4, row = 1, col = 4},
	cormuskrat	= {order = 5, row = 1, col = 5},
	kerndaemon	= {order = 6, row = 2, col = 1},
	-- BUILDER EXCLUSIVE
	coroutpost	= {order = 1, row = 1, col = 5},
	-- COROUTPOST
	corlab		= {order = 1, row = 1, col = 1},
	corvp		= {order = 2, row = 1, col = 2},
	corap		= {order = 3, row = 1, col = 3},
	corsy		= {order = 4, row = 1, col = 4},
	cortech		= {order = 5, row = 2, col = 1},
	corrad		= {order = 6, row = 2, col = 2},
	corjamt		= {order = 7, row = 2, col = 3},
	corpad		= {order = 8, row = 2, col = 4},

	-- CORLAB
	corak		= {order = 1, row = 1, col = 1},
	corstorm	= {order = 2, row = 1, col = 2},
	corthud		= {order = 3, row = 1, col = 3},
	cornecro	= {order = 4, row = 1, col = 4},
	corpyro		= {order = 5, row = 2, col = 1},
	cormort		= {order = 6, row = 2, col = 2},
	-- CORVP
	corlevlr 	= {order = 2, row = 1, col = 1},
	corgator 	= {order = 4, row = 1, col = 2},
	corraid 	= {order = 6, row = 1, col = 3},
	cormist 	= {order = 8, row = 1, col = 4},
	corvrad 	= {order = 10, row = 1, col = 5},
	-- CORAP
	corbw		= {order = 1, row = 1, col = 1},
	corveng		= {order = 2, row = 1, col = 2},
	corshad		= {order = 3, row = 1, col = 3},
	corsnap		= {order = 4, row = 1, col = 4},
	corape		= {order = 5, row = 1, col = 5},
	corkameyes	= {order = 6, row = 1, col = 6},
	corvalk		= {order = 7, row = 2, col = 1},
	-- CORSY
	corpt			= {order = 1, row = 1, col = 1},
	corpship		= {order = 2, row = 1, col = 2},
	corroy			= {order = 3, row = 1, col = 3},
	cortship		= {order = 4, row = 1, col = 4},
	corshark		= {order = 5, row = 2, col = 1},
	correcl			= {order = 6, row = 2, col = 2},
	corcrus			= {order = 7, row = 2, col = 3},

	[CMD_BUILD_PLATE] = {order = 13, row = 3, col = 4},
}

---ADVANCED
local special_commands = {
	--- ARMOUTPOST2
	armalab		= {order = 1, row = 1, col = 1},
	armavp		= {order = 2, row = 1, col = 2},
	armaap		= {order = 3, row = 1, col = 3},
	armasy		= {order = 4, row = 1, col = 4},
	armoutpost2	= {order = 5, row = 1, col = 5},
	armtech2 	= {order = 6, row = 2, col = 1},
	armarad		= {order = 7, row = 2, col = 2},
	armveil		= {order = 8, row = 2, col = 3},
	armasp		= {order = 9, row = 2, col = 4},
	armshltx_stub= {order = 10, row = 3, col = 1},
	armshltx	= {order = 10, row = 3, col = 1},
	--- BOWHQ4
	armack     	= {order = 1, row = 1, col = 1},
	armacv     	= {order = 2, row = 1, col = 2},
	armaca     	= {order = 3, row = 1, col = 3},
	armacsub    = {order = 4, row = 1, col = 4},
	bowscrow  	= {order = 5, row = 1, col = 5},
	--- ARMALAB
	armmav		= {order = 1, row = 1, col = 1},
	armaak		= {order = 2, row = 1, col = 2},
	armfboy		= {order = 3, row = 1, col = 3},
	armsptk		= {order = 4, row = 1, col = 4},
	armsnipe	= {order = 5, row = 2, col = 1},
	armscab		= {order = 6, row = 2, col = 2},
	--- ARMAVP
	armlatnk		= {order = 1, row = 1, col = 1},
	armbull			= {order = 2, row = 1, col = 2},
	armyork			= {order = 3, row = 1, col = 3},
	armmanni		= {order = 4, row = 1, col = 4},
	armmerl			= {order = 5, row = 2, col = 1},
	armintr			= {order = 6, row = 2, col = 2},
	armjam			= {order = 7, row = 2, col = 3},
	--- ARMAAP
	armhawk			= {order = 1, row = 1, col = 1},
	armpnix			= {order = 2, row = 1, col = 2},
	armblade		= {order = 3, row = 1, col = 3},
	armawac			= {order = 4, row = 1, col = 4},
	armdfly			= {order = 5, row = 2, col = 1},
	armliche		= {order = 6, row = 2, col = 2},
	--- ARMASY
	armaas			= {order = 1, row = 1, col = 1},
	armbats			= {order = 2, row = 1, col = 2},
	armmship		= {order = 3, row = 1, col = 3},
	armcarry		= {order = 4, row = 1, col = 4},
	armepoch		= {order = 5, row = 2, col = 1},
	armrecl			= {order = 6, row = 2, col = 2},
	--- ARMUWADVMS
	armmls		= {order = 9, row = 2, col = 5},
	--- ARMSHLTX (experimental)
	armbanth	= {order = 1, row = 1, col = 1},
	armraz		= {order = 2, row = 1, col = 2},
	corjugg		= {order = 3, row = 1, col = 3},
	--- KERNHQ4
	corack		= {order = 1, row = 1, col = 1},
	coracv		= {order = 2, row = 1, col = 2},
	coraca		= {order = 3, row = 1, col = 3},
	--coracs
	armconsul	= {order = 4, row = 1, col = 5},
	--kerndaemon	= {order = 9, row = 3, col = 1},
	--- COROUTPOST2
	coralab		= {order = 1,  row = 1, col = 1},
	coravp		= {order = 2,  row = 1, col = 2},
	corap		= {order = 3,  row = 1, col = 3},
	coraap		= {order = 4,  row = 1, col = 4},
	coroutpost2	= {order = 5, row = 1, col = 5},
	cortech2 	= {order = 6, row = 2, col = 1},
	corasy		= {order = 7,  row = 2, col = 2},
	corarad		= {order = 8,  row = 2, col = 3},
	corgant		= {order = 9, row = 3, col = 1},
	corgant_stub= {order = 10,  row = 2, col = 2},
	corasp		= {order = 10, row = 2, col = 4},
	--- CORALAB
	cormando	= {order = 1, row = 1, col = 1},
	coraak		= {order = 2, row = 1, col = 2},
	corcan		= {order = 3, row = 1, col = 3},
	corsktl		= {order = 4, row = 1, col = 4},
	cordefiler	= {order = 5, row = 2, col = 1},
	--- CORAVP
	correap 		= {order = 1, row = 1, col = 1},
	corsent 		= {order = 2, row = 1, col = 2},
	corgol 			= {order = 3, row = 1, col = 3},
	corban 			= {order = 4, row = 1, col = 4},
	corst 			= {order = 5, row = 2, col = 1},
	cortrem 		= {order = 6, row = 2, col = 2},
	cormabm 		= {order = 7, row = 2, col = 3},
	--- CORAAP
	corvamp		= {order = 1, row = 1, col = 1},
	corhurc		= {order = 2, row = 1, col = 2},
	corawac		= {order = 3, row = 1, col = 3},
	corcrw		= {order = 4, row = 1, col = 4},
	corstil		= {order = 5, row = 2, col = 1},
	corseah		= {order = 6, row = 2, col = 2},
	--- CORASY
	corbow			= {order = 1, row = 1, col = 1},
	cormship		= {order = 2, row = 1, col = 2},
	corbats			= {order = 3, row = 1, col = 3},
	corssub			= {order = 4, row = 1, col = 4},
	corcarry		= {order = 5, row = 2, col = 1},
	corsjam			= {order = 6, row = 2, col = 2},
	corblackhy		= {order = 7, row = 2, col = 3},
	--- CORGANT (experimental)
	corkrog		= {order = 1, row = 1, col = 1},
	corkarg		= {order = 2, row = 1, col = 2},
	corcat		= {order = 3, row = 1, col = 3},
	--- TODO

	coracsub	= {order = 12, row = 3, col = 3},
	--cortech2	= {order = 13, row = 3, col = 4},

	--[CMD_RAMP]        = {order = 16, row = 3, col = 1},
	--[CMD_LEVEL]       = {order = 17, row = 3, col = 2},
	--[CMD_RAISE]       = {order = 18, row = 3, col = 3},
	--[CMD_RESTORE]     = {order = 19, row = 3, col = 4},
	--[CMD_SMOOTH]      = {order = 20, row = 3, col = 5},
	[CMD_BUILD_PLATE] = {order = 13, row = 3, col = 4},
}

local econ_commands = {
	armmex			= {order = 1,  row = 1, col = 1},
	armsolar		= {order = 2,  row = 1, col = 2},
	armwin 			= {order = 3,  row = 1, col = 3},
	armmakr 		= {order = 4,  row = 1, col = 4},
	armmstor 		= {order = 5,  row = 1, col = 5},
	armestor 		= {order = 6,  row = 1, col = 6},

	armmoho			= {order = 7,  row = 2, col = 1},
	armfus			= {order = 8,  row = 2, col = 2},
	armmmkr			= {order = 9,  row = 2, col = 4},
	armuwadves		= {order = 10,  row = 2, col = 5},
	armuwadvms		= {order = 11,  row = 2, col = 6},

	armawin			= {order = 12,  row = 3, col = 1},
	armfort			= {order = 13,  row = 3, col = 3},
	armtide			= {order = 14, row = 3, col = 4},
	--armuwmex		= {order = 15, row = 3, col = 5},

	cormex		= {order = 1,  row = 1, col = 1},
	corsolar	= {order = 2,  row = 1, col = 2},
	corwin		= {order = 3,  row = 1, col = 3},
	cormakr		= {order = 4,  row = 1, col = 4},
	cormstor	= {order = 5,  row = 1, col = 5},
	corestor	= {order = 6,  row = 1, col = 6},
	cortide		= {order = 7,  row = 2, col = 1},
	coruwmex	= {order = 8,  row = 2, col = 2},

	corawin			= {order = 6,  row = 3, col = 1},
	corfort			= {order = 13,  row = 3, col = 3},
	cortide			= {order = 14, row = 3, col = 4},
	--coruwmex		= {order = 15, row = 3, col = 5},

	cormoho		= {order = 9,  row = 2, col = 3},
	cormmkr		= {order = 10, row = 2, col = 4},
	corfus		= {order = 16, row = 3, col = 4},
	coruwadves	= {order = 15, row = 3, col = 2},
	coruwadvms	= {order = 15, row = 3, col = 3},
}

local defense_commands = {
	armllt		= {order = 1, row = 1, col = 1},
	armrl		= {order = 2, row = 1, col = 2},
	armpb		= {order = 3, row = 1, col = 3},
	armguard	= {order = 4, row = 1, col = 4},
	armptl		= {order = 5, row = 1, col = 5},
	armdrag		= {order = 6, row = 1, col = 6},
	armdeva			= {order = 7, row = 2, col = 1},
	armanni_stub	= {order = 8, row = 2, col = 2},
	armanni			= {order = 8, row = 2, col = 2},
	armbrtha_stub	= {order = 9, row = 2, col = 3},
	armbrtha		= {order = 9, row = 2, col = 3},
	armamd			= {order = 10, row = 2, col = 4},
	armcir			= {order = 11, row = 2, col = 5},
	armsilo_stub	= {order = 12, row = 2, col = 5},
	armsilo			= {order = 12, row = 2, col = 5},
	armamb			= {order = 13, row = 2, col = 6},
	armemp			= {order = 14, row = 3, col = 1},
	--armshltx_stub	= {order = 15, row = 3, col = 2},
	--armshltx		= {order = 15, row = 3, col = 2},
	armgate			= {order = 15, row = 3, col = 2},
--
	--- KERN
	corllt		= {order = 1, row = 1, col = 1},
	corrl		= {order = 2, row = 1, col = 2},
	corvipe		= {order = 3, row = 1, col = 3},
	corpun		= {order = 4, row = 1, col = 4},
	corptl		= {order = 5, row = 1, col = 5},
	cordrag		= {order = 6, row = 1, col = 6},
	corshred	= {order = 7, row = 2, col = 1},
	cordoom_stub = {order = 8, row = 2, col = 2},
	cordoom		= {order = 10, row = 2, col = 2},
	corint_stub = {order = 11, row = 2, col = 3},
	corint		= {order = 12, row = 2, col = 3},
	corfmd		= {order = 13, row = 2, col = 4},
	corsilo_stub = {order = 14, row = 2, col = 5},
	corsilo		= {order = 14, row = 2, col = 5},
	corgate		= {order = 15, row = 2, col = 6},
	cortoast	= {order = 17, row = 3, col = 2},
	cortron		= {order = 18, row = 3, col = 3},
	corsonar	= {order = 7, row = 3, col = 4},
	corshroud	= {order = 8, row = 2, col = 5},
	corerad		= {order = 9, row = 2, col = 6},


--,        "",        "",        "",        "",        "coralab",        "coravp",        "corap",        "coraap",        "corasy",        "corgate",        "corasp",        "cortoast",        "cortron",        "corgant_stub",}
--
}


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Commands, units types on factory, factory tab unit,
return cmdPosDef, factoryUnitPosDef, factory_commands, econ_commands, defense_commands, special_commands

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
