--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "Commander and Daemon Blasts",
    desc      = "Spawns commander & Daemon's blast CEG according to skillclass, adds EMP explosion",
    author    = "Bluestone, updated by MaDDoX",
    date      = "June 2014",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true,  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

if (not gadgetHandler:IsSyncedCode()) then
	return false
end


local COMMANDER_EXPLOSION = "COMMANDER_EXPLOSION"
local DAEMON_EXPLOSION = "DAEMON_EXPLOSION"
--local COMMANDER_EXPLOSION_YELLOW = "COMMANDER_EXPLOSION_YELLOW"
--local COMMANDER_EXPLOSION_BLUE = "COMMANDER_EXPLOSION_BLUE"

local COM_BLAST = WeaponDefNames['commander_blast'].id
local COM_BLAST2 = WeaponDefNames['commander_blast2'].id
local COM_EMPTRIGGER_WEAP = WeaponDefNames['commander_emptrigger'].id
local DAEMON_EMPTRIGGER_WEAP = WeaponDefNames['daemon_emptrigger'].id

local COM_EMPEXPLOSION_WEAP = WeaponDefNames['armcom_empexplosion'].id
local DAEMON_EMPEXPLOSION_WEAP = WeaponDefNames['armcom_empexplosion'].id

local spGetUnitRulesParam = Spring.GetUnitRulesParam
local spValidUnitID = Spring.ValidUnitID

local COMMANDER = {
  [UnitDefNames["corcom"].id] = true,
  [UnitDefNames["corcom1"].id] = true,
  [UnitDefNames["corcom2"].id] = true,
  [UnitDefNames["corcom3"].id] = true,
  [UnitDefNames["corcom4"].id] = true,
  [UnitDefNames["armcom"].id] = true,
  [UnitDefNames["armcom1"].id] = true,
  [UnitDefNames["armcom2"].id] = true,
  [UnitDefNames["armcom3"].id] = true,
  [UnitDefNames["armcom4"].id] = true,
}

local DAEMON = {
    [UnitDefNames["bowdaemon"].id] = true,
    [UnitDefNames["kerndaemon"].id] = true,
    [UnitDefNames["bowadvdaemon"].id] = true,
    [UnitDefNames["kernadvdaemon"].id] = true,
}

--local METEOR_EXPLOSION = WeaponDefNames["meteor_weapon"].id

local commanderExplosionEMPparams = {
                                    --damage = { default=999999, paralyzeDamageTime = 20 },
                                    weaponDef = COM_EMPTRIGGER_WEAP,
                                    hitUnit = 1,
                                    hitFeature = 1,
                                    craterAreaOfEffect = 50,
                                    damageAreaOfEffect = 720,
                                    edgeEffectiveness = 1,
                                    explosionSpeed = 900,
                                    impactOnly = false,
                                    ignoreOwner = false,
                                    damageGround = true,
                                    }

local daemonExplosionEMPparams = {
    --damage = { default=999999, paralyzeDamageTime = 20 },
    weaponDef = DAEMON_EMPTRIGGER_WEAP,
    hitUnit = 1,
    hitFeature = 1,
    craterAreaOfEffect = 50,
    damageAreaOfEffect = 360,
    edgeEffectiveness = 1,
    explosionSpeed = 900,
    impactOnly = false,
    ignoreOwner = false,
    damageGround = true,
}

local finishedDaemons = {} --{ [unitID] = true, ...}

local teamCEG = {} --teamCEG[tID] = cegID of commander blast for that team

function gadget:Initialize()
    --- OBSOLETE
    -- give each team the CEG corresponding to the player with the lowest skillClass in that team
    --local gaiaTeamID = Spring.GetGaiaTeamID()
    --local teamList = Spring.GetTeamList()
    --for _,tID in pairs(teamList) do
    --    teamCEG[tID] = COMMANDER_EXPLOSION
        --if tID==gaiaTeamID then
        --    teamCEG[tID] = COMMANDER_EXPLOSION
        --else
        --    local playerList = Spring.GetPlayerList(tID)
        --    local teamSkillClass = 5
        --    for _,pID in pairs(playerList) do
        --        local customtable = select(10, Spring.GetPlayerInfo(pID))
        --        if type(customtable) == "table" then
        --            local skillClass = customtable.skillclass -- 1 (1st), 2 (top5), 3 (top10), 4 (top20), 5 (other)
        --            teamSkillClass = math.min(teamSkillClass, skillClass or 5)
        --        end
        --    end
        --    if teamSkillClass >= 5 then
        --        teamCEG[tID] = COMMANDER_EXPLOSION
        --    elseif teamSkillClass >= 3 then
        --        teamCEG[tID] = COMMANDER_EXPLOSION_YELLOW
        --    else
        --        teamCEG[tID] = COMMANDER_EXPLOSION_BLUE
        --    end
        --end
    --end
end

function gadget:UnitFinished(unitID, unitDefID, unitTeam)
    if DAEMON[unitDefID] and spValidUnitID(unitID) then
        finishedDaemons[unitID] = true
    end
end


function gadget:UnitDestroyed(unitID, unitDefID, teamID, attackerID, attackerDefID, attackerTeam)
    local isCommander = COMMANDER[unitDefID]
    local isDaemon = DAEMON[unitDefID]
    if (not isCommander and not isDaemon) or (not spValidUnitID(unitID))then
        return end
    -- Canceled in-production daemons shouldn't blow up and paralyze the whole base, right? doh..
    if isDaemon and not finishedDaemons[unitID] then
        return end

    local x,y,z = Spring.GetUnitBasePosition(unitID)
    -- If it was simply morphed into => No explosion FX, just "level up" fx.
    if spGetUnitRulesParam(unitID, "justmorphed") == 1 then
        Spring.SpawnCEG("commander-levelup", x,y,z, 0,0,0, 0, 0)
        return
    end

    -- If it was actually killed/selfD-ed, spawn CEG and EMP explosion
    if isCommander then
        Spring.SpawnCEG(COMMANDER_EXPLOSION, x,y,z, 0,0,0, 0, 0) --teamCEG[teamID]
        --This will be intercepted by UnitDamaged to actually apply damage
        Spring.SpawnExplosion (x,y,z, 0, 0, 0, commanderExplosionEMPparams)
    elseif isDaemon then
        Spring.SpawnCEG(DAEMON_EXPLOSION, x,y,z, 0,0,0, 0, 0) --teamCEG[teamID]
        --This will be intercepted by UnitDamaged to actually apply damage
        Spring.SpawnExplosion (x,y,z, 0, 0, 0, daemonExplosionEMPparams)
    end

end

function gadget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer,
                            weaponDefID, attackerID, attackerDefID, attackerTeam)
    if (weaponDefID == COM_EMPTRIGGER_WEAP) then --and Spring.ValidUnitID(attackerID)
        --unitID, damage, paralyze = 0, attackerID = -1, weaponID = -1
        Spring.AddUnitDamage ( unitID, math.huge, 17, attackerID, COM_EMPEXPLOSION_WEAP )
    elseif (weaponDefID == DAEMON_EMPTRIGGER_WEAP) then --and Spring.ValidUnitID(attackerID)
        Spring.AddUnitDamage ( unitID, 999, 17, attackerID, DAEMON_EMPEXPLOSION_WEAP)
    end

end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Enable Weapon?
--Spring.UnitWeaponFire(unitID, WeaponDefNames['commanderexplosionemp'].id)
