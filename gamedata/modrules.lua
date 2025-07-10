VFS.Include('init.lua')

-- See: https://springrts.com/wiki/Modrules.lua
local useQTPFS = true -- Script.IsEngineMinVersion(105, 0, 2020)

XPValues = {
  experienceMult = 0.4,
  powerScale = 1, -- Was zero (*MaDD)
  healthScale = 1.1, --2.5 (BAR), 0.7
  reloadScale = 0.7, --1.25 (BAR), 0.4
}

local modrules  = {

  movement = {
    allowUnitCollisionDamage  = false,  -- default: true if using QTPFS pathfinder.  Do unit-unit (skidding) collisions cause damage?
    allowUnitCollisionOverlap = true,   -- can mobile units collision volumes overlap one another? Allows unit movement like this (video http://www.youtube.com/watch?v=mRtePUdVk2o ) at the cost of more 'clumping'.
    allowCrushingAlliedUnits  = false,  -- default: false.  Can allied ground units crush each other during collisions? Units still have to be explicitly set as crushable using the crushable parameter of Spring.SetUnitBlocking.
    allowGroundUnitGravity    = false,

    allowAirPlanesToLeaveMap  = false,   -- default: true.  Are (gunship) aircraft allowed to fly outside the bounds of the map?
    allowAircraftToHitGround  = true,   -- default: true.  Are aircraft allowed to hit the ground whilst manoeuvring?
    allowPushingEnemyUnits    = false,  -- default: false.  Can enemy ground units push each other during collisions?
    allowHoverUnitStrafing    = true,   -- default: true.  Allows hovercraft units to slide in turns.
  },

  construction = {
    constructionDecay      = true,  -- defaults to true
    constructionDecayTime  = 9,     -- defaults to 6.66
    constructionDecaySpeed = 0.03,  -- defaults to 0.03
  },

  reclaim = {
    multiReclaim  = 1,
    reclaimMethod = 0,
    unitMethod    = 1,    -- 0 = gradual, 1 = all reclaimed at the end

    unitEnergyCostFactor    = 0,  -- defaults to 0
    unitEfficiency          = 1,  -- defaults to 1
    featureEnergyCostFactor = 0,  -- defaults to 0
	
    allowEnemies = true,  -- defaults to true
    allowAllies  = false, -- defaults to true (Can allied units be reclaimed?)
  },

  repair = {
    energyCostFactor = 0.5,   -- default: 0
  },

  resurrect = {
    energyCostFactor = 0.75,  -- default: 0.5
  },

  capture = {
    energyCostFactor = 0,  -- default: 0.  How much of the original energy cost it requires to capture something.
  },

  paralyze = {
    paralyzeOnMaxHealth = true,    -- default: true. Are units paralyzed when the level of emp is greater than their current health or their maximum health?
    unitParalysisDeclineScale = 40, -- Time in seconds to go from 100% to 0% emp
    paralyzeDeclineRate = Spring.GetModOptions().emprework==true and 20 or 40,	-- default: 40.
  },

  experience = {
    experienceMult = XPValues.experienceMult, -- Controls the amount of experience gained by units engaging in combat. The formulae used are: xp for damage = 0.1 * experienceMult * damage / target_HP * target_power / attacker_power.  xp for kill = 0.1 * experienceMult * target_power / attacker_power. Where power can be set by the UnitDef tag.
    powerScale = XPValues.powerScale,	    -- Controls how gaining experience changes the relative power of the unit. The formula used is Power multiplier = powerScale * (1 + xp / (xp + 1)).
    healthScale = XPValues.healthScale,	-- Controls how gaining experience increases the maxDamage (total hitpoints) of the unit. The formula used is Health multiplier = healthScale * (1 + xp / (xp + 1)).
    reloadScale = XPValues.reloadScale,	-- Controls how gaining experience decreases the reloadTime of the unit's weapons. The formula used is Rate of fire multiplier = reloadScale * (1 + xp / (xp + 1)).
  },

  flankingBonus = {
    defaultMode = 0,  -- default: 1.  The default flankingBonusMode for units. Can be 0 - No flanking bonus. Mode 1 builds up the ability to move over time, and swings to face attacks, but does not respect the way the unit is facing. Mode 2 also can swing, but moves with the unit as it turns. Mode 3 stays with the unit as it turns and otherwise doesn't move, the ideal mode to simulate something such as tank armour.
  },

  sensors = {
    separateJammers = true,  -- default: true
    requireSonarUnderWater = true,  -- default: true. If true then when underwater, units only get LOS if they also have sonar.
    alwaysVisibleOverridesCloaked = false,  -- default: false.  If true then units will be visible even when cloaked (probably?).

    los = {
      losMipLevel   = 3,  -- default: 1.  Controls the resolution of the LOS calculations. A higher value means lower resolution but increased performance. An increase by one level means half the resolution of the LOS map in both x and y direction. Must be between 0 and 6 inclusive.
      airMipLevel   = 3,  -- default: 1.  Controls the resolution of the LOS vs. aircraft calculations. A higher value means lower resolution but increased performance. An increase by one level means half the resolution of the air-LOS map in both x and y direction. Must be between 0 and 30 inclusive. [1] - jK describe for you what the value means.
      radarMipLevel = 3,  -- default: 2.  Controls the resolution of the radar. See description of airMipLevel for details.
    },
  },

  featureLOS = {
    featureVisibility = 3, -- Can be 0 - no default LOS for features, 1 - Gaia features always visible, 2 - allyteam & Gaia features always visible, or 3 - all features always visible.
  },

  fireAtDead = {
    fireAtKilled   = false,
    fireAtCrashing = false,
  },

  system = {
    allowTake = true,				-- Enables and disables the /take UI command.
    LuaAllocLimit = 1536,			-- default: 1536.  Global Lua alloc limit (in megabytes)
    enableSmoothMesh = true,

    pathFinderSystem = useQTPFS and 1 or 0,			-- Which pathfinder does the game use? Can be 0 - The legacy default pathfinder, 1 - Quad-Tree Pathfinder System (QTPFS) or -1 - disabled.
    pathFinderUpdateRate = 0.005,   -- default 0.007, higher means more updates
    --pathFinderRawDistMult = 1.25,
    pathFinderRawDistMult = 100000,	-- default: 1.25.  Engine does raw move with a limited distance, this multiplier adjusts that
    pfRepathDelayInFrames = 60,		-- default: 60.  How many frames at least must pass between checks for whether a unit is making enough progress to its current waypoint or whether a new path should be requested
    pfRepathMaxRateInFrames = 150,	-- default: 150.  Controls the minimum amount of frames that must pass before a unit is allowed to request a new path. Mostly for rate limiting and prevent excessive CPU wastage
    pfUpdateRateScale = 1,			-- default: 1.  Multiplier for the update rate
    pfRawMoveSpeedThreshold = 0,	-- default: 0.  Controls the speed modifier (which includes typemap boosts and up/down hill modifiers) under which units will never do raw move, regardless of distance etc. Defaults to 0, which means units will not try to raw-move into unpathable terrain (e.g. typemapped lava, cliffs, water). You can set it to some positive value to make them avoid pathable but very slow terrain (for example if you set it to 0.2 then they will not raw-move across terrain where they move at 20% speed or less, and will use normal pathing instead - which may still end up taking them through that path).
    pfHcostMult = 0.2,				-- default: 0.2.  A float value between 0 and 2. Controls how aggressively the pathing search prioritizes nodes going in the direction of the goal. Higher values mean pathing is cheaper, but can start producing degenerate paths where the unit goes straight at the goal and then has to hug a wall.
  },

  transportability = {
    transportGround = true,     -- default: true
    transportAir    = true,    -- default: false
    transportShip   = false,    -- default: false
    transportHover  = true,    -- default: false
    targetableTransportedUnits = false, -- Can transported units be targeted by weapons? true allows both manual and automatic targeting.
  },

  damage = {
    debris = 0, -- body parts flying off dead units
  },

}
--
--if (Spring.GetModOptions) and Spring.GetModOptions().unba and (Spring.GetModOptions().unba == "enabled" or Spring.GetModOptions().unba == "exponly") then
--  modrules.experience.powerScale = 3
--  modrules.experience.healthScale = 1.4
--  modrules.experience.reloadScale = 0.8
--end

return modrules
