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
		key    = "newbie_placer",
		name   = "Newbie Placer",
		desc   = "Chooses a startpoint and a random faction for all rank 1 accounts (online only)",
		type   = "bool",
		def    = false,
		section= "tap_options",
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
    -- Chicken Defense Options
	{
		key    = 'chicken_defense_options',
		name   = 'Chicken Defense Options',
		desc   = 'Various gameplay options that will change how the Chicken Defense is played.',
		type   = 'section',
	},
	{
		key="chicken_chickenstart",
		name="Burrow Placement",
		desc="Control where burrows spawn",
		type="list",
		def="alwaysbox",
		section="chicken_defense_options",
		items={
			{key="anywhere", name="Anywhere", desc="Burrows can spawn anywhere"},
			{key="avoid", name="Avoid Players", desc="Burrows do not spawn on player units"},
			{key="initialbox", name="Initial Start Box", desc="First wave spawns in chicken start box, following burrows avoid players"},
			{key="alwaysbox", name="Always Start Box", desc="Burrows always spawn in chicken start box"},
		}
	},
	{
		key="chicken_queendifficulty",
		name="Queen Difficulty",
		desc="How hard doth the Chicken Queen",
		type="list",
		def="n_chickenq",
		section="chicken_defense_options",
		items={
			{key="ve_chickenq", name="Very Easy", desc="Cakewalk"},
			{key="e_chickenq", name="Easy", desc="Somewhat Challenging"},
			{key="n_chickenq", name="Normal", desc="A Good Challenge"},
			{key="h_chickenq", name="Hard", desc="Serious Business"},
			{key="vh_chickenq", name="Very Hard", desc="Extreme Challenge"},
			{key="epic_chickenq", name="Epic!", desc="Impossible!"},
			{key="asc", name="Ascending", desc="Each difficulty after the next"},
		}
	},
	{
		key    = "chicken_queentime",
		name   = "Max Queen Arrival (Minutes)",
		desc   = "Queen will spawn after given time.",
		type   = "number",
		def    = 40,
		min    = 1,
		max    = 90,
		step   = 1,
		section= "chicken_defense_options",
	},
	{
		key    = "chicken_maxchicken",
		name   = "Chicken Limit",
		desc   = "Maximum number of chickens on map.",
		type   = "number",
		def    = 300,
		min    = 50,
		max    = 5000,
		step   = 25,
		section= "chicken_defense_options",
	},
	{
		key    = "chicken_graceperiod",
		name   = "Grace Period (Seconds)",
		desc   = "Time before chickens become active.",
		type   = "number",
		def    = 300,
		min    = 5,
		max    = 900,
		step   = 5,
		section= "chicken_defense_options",
	},
	{
		key    = "chicken_queenanger",
		name   = "Add Queen Anger",
		desc   = "Killing burrows adds to queen anger.",
		type   = "bool",
		def    = true,
		section= "chicken_defense_options",
    },

-- Chicken Defense Custom Difficulty Settings
	{
		key    = 'chicken_defense_custom_difficulty_settings',
		name   = 'Chicken Defense Custom Difficulty Settings',
		desc   = 'Use these settings to adjust the difficulty of Chicken Defense',
		type   = 'section',
	},
	{
		key    = "chicken_custom_burrowspawn",
		name   = "Burrow Spawn Rate (Seconds)",
		desc   = "Time between burrow spawns.",
		type   = "number",
		def    = 120,
		min    = 1,
		max    = 600,
		step   = 1,
		section= "chicken_defense_custom_difficulty_settings",
	},
	{
		key    = "chicken_custom_chickenspawn",
		name   = "Wave Spawn Rate (Seconds)",
		desc   = "Time between chicken waves.",
		type   = "number",
		def    = 90,
		min    = 10,
		max    = 600,
		step   = 1,
		section= "chicken_defense_custom_difficulty_settings",
	},
	{
		key    = "chicken_custom_minchicken",
		name   = "Min Chickens Per Player",
		desc   = "Minimum Number of chickens before spawn chance kicks in",
		type   = "number",
		def    = 8,
		min    = 1,
		max    = 250,
		step   = 1,
		section= "chicken_defense_custom_difficulty_settings",
	},
	{
		key    = "chicken_custom_spawnchance",
		name   = "Spawn Chance (Percent)",
		desc   = "Percent chance of each chicken spawn once greater thwn the min chickens per player limit",
		type   = "number",
		def    = 33,
		min    = 0,
		max    = 100,
		step   = 1,
		section= "chicken_defense_custom_difficulty_settings",
	},
	{
		key    = "chicken_custom_angerbonus",
		name   = "Burrow Kill Anger (Percent)",
		desc   = "Seconds added per burrow kill.",
		type   = "number",
		def    = 0.15,
		min    = 0,
		max    = 100,
		step   = 0.01,
		section= "chicken_defense_custom_difficulty_settings",
	},
	{
		key    = "chicken_custom_queenspawnmult",
		name   = "Queen Wave Size Mod",
		desc   = "Number of squads spawned by the queen at once.",
		type   = "number",
		def    = 1,
		min    = 0,
		max    = 5,
		step   = 1,
		section= "chicken_defense_custom_difficulty_settings",
	},
	{
		key    = "custom_expstep",
		name   = "Bonus Experience",
		desc   = "Exp each chicken will receive by the end of the game",
		type   = "number",
		def    = 1.5,
		min    = 0,
		max    = 2.5,
		step   = 0.1,
		section= "chicken_defense_custom_difficulty_settings",
	},
	{
		key    = "chicken_custom_lobberemp",
		name   = "Lobber EMP Duration",
		desc   = "Max duration of Lobber EMP artillery",
		type   = "number",
		def    = 4,
		min    = 0,
		max    = 30,
		step   = 0.5,
		section= "chicken_defense_custom_difficulty_settings",
	},
	{
		key    = "chicken_custom_damagemod",
		name   = "Damage Mod",
		desc   = "Percent modifier for chicken damage",
		type   = "number",
		def    = 100,
		min    = 5,
		max    = 250,
		step   = 1,
		section= "chicken_defense_custom_difficulty_settings",
	},
-- End Chicken Defense Settings

	-----------------------------------------------------------------------------------------------------------------------------------------
	{
		key="options_scavengers",
		name="Scavengers",
		desc="Gameplay options for Scavengers gamemode",
		type="section",
	},
	
	{
		key    = 'scavdifficulty',
		name   = 'Difficulty',
		desc   = 'Scavengers Difficulty Level',
		type   = 'list',
		section = 'options_scavengers',
		def  = "easy",
		items={
			{key="noob", name="Noob", desc="Noob"},
			{key="easy", name="Easy", desc="Easy"},
			{key="medium", name="Medium", desc="Medium"},
			{key="hard", name="Hard", desc="Hard"},
			{key="veryhard", name="Very Hard", desc="Very Hard"},
			{key="brutal", name="Brutal", desc="You'll die"},
			{key="insane", name="Insane", desc="You'll die, but harder."},
			{key="impossible", name="Impossible", desc="You can't win this... seriously."},
		}
	},
	
	-- {
		-- key    = 'scavtechdifficulty',
		-- name   = 'Scavengers Tech Difficulty',
		-- desc   = 'Determines how fast scav tech ramps up. Adaptive will adjust to players skill',
		-- type   = 'list',
		-- section = 'options_scavengers',
		-- def  = "adaptive",
		-- items={
			-- {key="adaptive", name="Adaptive", desc="Adapts to players skill"},
			-- {key="easy", name="Easy", desc="Slow ramp up for newbies and noobs"},
			-- {key="medium", name="Medium", desc="Normal ramp up for slightly experienced players"},
			-- {key="hard", name="Hard", desc="Hard ramp up for experienced players"},
			-- {key="brutal", name="Brutal", desc="You'll die"},
		-- }
	-- },
	
	{
		key    = 'scavtechcurve',
		name   = 'Tech Curve',
		desc   = 'Modifies how fast Scavengers tech up',
		type   = 'list',
		section = 'options_scavengers',
		def  = "normal",
		items={
			{key="normal", name="Normal", desc="x1"},
			{key="fast", name="Fast", desc="x0.5"},
			{key="slow", name="Slow", desc="x1.5"},
		}
	},
	
	{
		key    = 'scavendless',
		name   = 'Endless Mode',
		desc   = 'Disables final boss fight, turning Scavengers into an endless survival mode',
		type   = 'list',
		section = 'options_scavengers',
		def  = "disabled",
		items={
			{key="disabled", name="Disabled", desc="Final Boss Enabled"},
			{key="enabled", name="Enabled", desc="Final Boss Disabled"},
		}
	},
	
	{
		key    = 'scavbosshealth',
		name   = 'Boss Health Modifier',
		desc   = 'Modifies Final Boss maximum health points',
		type   = 'list',
		section = 'options_scavengers',
		def  = "normal",
		items={
			{key="normal", name="Normal", desc="x1"},
			{key="lower", name="Lower", desc="x0.5"},
			{key="higher", name="Higher", desc="x1.5"},
			{key="high", name="High", desc="x2"},
		}
	},
	
	{
		key    = 'scavevents',
		name   = 'Random Events',
		desc   = 'Random Events System',
		type   = 'list',
		section = 'options_scavengers',
		def  = "enabled",
		items={
			{key="enabled", name="Enabled", desc="Random Events Enabled"},
			{key="disabled", name="Disabled", desc="Random Events Disabled"},
		}
	},
	
	{
		key    = 'scaveventsamount',
		name   = 'Random Events Amount',
		desc   = 'Modifies frequency of random events',
		type   = 'list',
		section = 'options_scavengers',
		def  = "normal",
		items={
			{key="normal", name="Normal", desc="Normal"},
			{key="lower", name="Lower", desc="Halved"},
			{key="higher", name="Higher", desc="Doubled"},
		}
	},
	
	-----------------------------------------------------------------------------------------------------------------------------------------
}
return options
