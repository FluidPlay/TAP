--see engineoptions.lua for explanantion
local options={
	{
	   key    = "StartingResources",
	   name   = "Starting Resources",
	   desc   = "Sets storage and amount of resources that players will start with",
	   type   = "section",
	},
    {
       key="tap_modes",
       name="TA Prime - Game Modes",
       desc="TA Prime - Game Modes",
       type="section",
    },
    {
       key="tap_options",
       name="TA Prime - Options",
       desc="TA Prime - Options",
       type="section",
    },

	{
		key    = 'mo_chiliold',
		name   = 'Use Chili Old',
		desc   = 'Should it use Chili Old?',
		type   = 'number',
		section= 'tap_options',
		def    = 1,
		min    = 0,
		max    = 1,
		step   = 1,
	},
	{
        key    = 'ai_incomemultiplier',
        name   = 'AI Income Multiplier',
        desc   = 'Multiplies AI resource income',
        type   = 'number',
        section= 'tap_options',
        def    = 1,
        min    = 1,
        max    = 10,
        step   = 0.1,
    },
	{
		key="deathmode",
		name="Game End Mode",
		desc="What it takes to eliminate a team",
		type="list",
		def="com",
		section="tap_modes",
		items={
			{key="neverend", name="None", desc="Teams are never eliminated"},
			{key="com", name="Kill all enemy Commanders", desc="When a team has no Commanders left, it loses"},
			{key="killall", name="Kill everything", desc="Every last unit must be eliminated, no exceptions!"},
		}
	},
    {
        key    = 'armageddontime',
        name   = 'Armageddon time (minutes)',
        desc   = 'At armageddon every immobile unit is destroyed and you fight to the death with what\'s left! (0=off)',
        type   = 'number',
        section= 'tap_modes',
        def    = 0,
        min    = 0,
        max    = 120,
        step   = 1,
    },
    {
		key    = "ffa_mode",
		name   = "FFA Mode",
		desc   = "Units with no player control are removed/destroyed \nUse FFA spawning mode",
		type   = "bool",
		def    = false,
		section= "tap_modes",
    },
	{
		key="map_terraintype",
		name="Map TerrainTypes",
		desc="Allows to cancel the TerrainType movespeed buffs of a map.",
		type="list",
		def="enabled",
		section="tap_options",
		items={
			{key="disabled", name="Disabled", desc="Disable TerrainTypes related MoveSpeed Buffs"},
			{key="enabled", name="Enabled", desc="Enable TerrainTypes related MoveSpeed Buffs"},
		}
	},
	
	{
		key="map_waterlevel",
		name="Water Level",
		desc=" <0 = Decrease water level, >0 = Increase water level",
		type="number",
        def    = 0,
        min    = -10000,
        max    = 10000,
        step   = 1,
		section="tap_options",
	},	
	
	{
		key="map_tidal",
		name="Tidal Strength",
		desc="Unchanged = map setting, low = 13e/sec, medium = 18e/sec, high = 23e/sec.",
		type="list",
		def="unchanged",
		section="tap_options",
		items={
			{key="unchanged", name="Unchanged", desc="Use map settings"},
			{key="low", name="Low", desc="Set tidal incomes to 13 energy per second"},
			{key="medium", name="Medium", desc="Set tidal incomes to 18 energy per second"},
			{key="high", name="High", desc="Set tidal incomes to 23 energy per second"},
		}
	},

	--{
	--	key="unba",
	--	name="Unbalanced Commanders",
	--	desc="Defines if commanders level up with xp and gain more power or not",
	--	type="list",
	--	def="disabled",
	--	section="tap_modes",
	--	items={
	--		{key="disabled", name="Disabled", desc="Disable Unbalanced Commanders"},
	--		{key="enabled", name="Enabled", desc="Enable Unbalanced Commanders"},
	--		{key="exponly", name="ExperienceOnly", desc="Enable Unbalanced Commanders experience to power, health and reload multipliers"},
	--	}
	--},
	
    {
        key    = 'coop',
        name   = 'Cooperative mode',
        desc   = 'Adds extra commanders to id-sharing teams, 1 com per player',
        type   = 'bool',
        def    = false,
        section= 'tap_modes',
    },
	{
		key    = 'CARTS',
		name   = 'CARTS mode',
		desc   = 'Cooperative-Action-RTS mode: Id-sharing teams will split commander (even Id) and daemon (odd Id) functions',
		type   = 'bool',
		def    = false,
		section= 'tap_modes',
	},
    {
      key    = "shareddynamicalliancevictory",
      name   = "Dynamic Ally Victory",
      desc   = "Ingame alliance should count for game over condition.",
      type   = "bool",
	  section= 'tap_modes',
      def    = false,
    },
	
    {
		key="transportenemy",
		name="Enemy Transporting",
		desc="Toggle which enemy units you can kidnap with an air transport",
		type="list",
		def="notcoms",
		section="tap_options",
		items={
			{key="notcoms", name="All But Commanders", desc="Only commanders are immune to napping"},
			{key="none", name="Disallow All", desc="No enemy units can be napped"},
		}
	},
	{
		key    = "allowuserwidgets",
		name   = "Allow user widgets",
		desc   = "Allow custom user widgets or disallow them",
		type   = "bool",
		def    = true,
		section= 'tap_others',
	},
	{
		key    = "allowmapmutators",
		name   = "Allow map mutators",
		desc   = "Allows maps to overwrite files from the game",
		type   = "bool",
		def    = true,
		section= 'tap_others',
	},
    {
        key    = 'FixedAllies',
        name   = 'Fixed ingame alliances',
        desc   = 'Disables the possibility of players to dynamically change alliances ingame',
        type   = 'bool',
        def    = true,
        section= "tap_others",
    },
    {
        key    = 'critters',
        name   = 'How many cute amimals? (0 is disabled)',
        desc   = 'This multiplier will be applied on the amount of critters a map will end up with',
        type   = 'number',
        section= 'tap_others',
        def    = 0.6,
        min    = 0,
        max    = 2,
        step   = 0.2,
    },

--###############################

    {
       key="tap_gameplay_options",
       name="TA Prime - Gameplay Options",
       desc="TA Prime - Gameplay Options",
       type="section",
    },
    {
        key    = "harvest_eco",
        name   = "Harvest Economy Mode",
        desc   = "Spawn ore chunks and enables harvesting from builders / ore towers\nBuild spires on top of ore spots to speed up respawn of chunks.",
        type   = "number",
        def    = 0,
        section= "tap_gameplay_options",
    },
	{
		key    = 'comm_wreck_metal',
		name   = 'Commander Wreck Metal',
		desc   = 'Sets the amount of metal left by a destroyed Commander.',
		type   = 'number',
		section= 'tap_gameplay_options',
		def    = 2500,
		min    = 0,
		max    = 5000,
		step   = 1,
	},
	{
		key = 'globallos',
		name = 'Full visibility',
		desc = 'No fog of war, everyone can see the entire map.',
		type = 'bool',
		section = 'tap_gameplay_options',
		def = false,
	},

}
return options
