--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
  return {
    name      = "Daemon Repair Pulse",
    desc      = "Every 10s, repairs 100 health from all units in a small area around the daemon",
    author    = "Bluestone, updated by MaDDoX",
    date      = "May 2023",
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


VFS.Include("gamedata/taptools.lua")
VFS.Include("gamedata/unitai_functions.lua")

local spGetUnitPosition = Spring.GetUnitPosition
local spGetUnitTeam = Spring.GetUnitTeam
local spGetUnitsInCylinder = Spring.GetUnitsInCylinder
local spSetUnitHealth = Spring.SetUnitHealth
local spGetUnitDefID = Spring.GetUnitDefID
local spGetUnitRulesParam = Spring.GetUnitRulesParam
local spGetAllUnits = Spring.GetAllUnits
local spValidUnitID = Spring.ValidUnitID
local updateRate = 10*30    -- every 10 seconds
local spGetUnitHealth = Spring.GetUnitHealth

local math_min = math.min

local DAEMON = {
    [UnitDefNames["bowdaemon"].id] = true,
    [UnitDefNames["kerndaemon"].id] = true,
    --TODO: Add more health for Advanced Daemons
    [UnitDefNames["bowadvdaemon"].id] = true,
    [UnitDefNames["kernadvdaemon"].id] = true,
}

local activeDaemons = {} --{ [unitID] = true, ...}

function gadget:Initialize()
end

local function istable(v)
    return (type(v)=="table")
end

local function isnumber(v)
    return (type(v)=="number")
end

function gadget:UnitFinished(unitID, unitDefID, unitTeam)
    if DAEMON[unitDefID] and spValidUnitID(unitID) then
        activeDaemons[unitID] = UnitDefs[unitDefID]
    end
end

function gadget:Initialize()
    local allUnits = spGetAllUnits()
    for i = 1, #allUnits do
        local unitID    = allUnits[i]
        local unitDefID = spGetUnitDefID(unitID)
        --local unitTeam  = spGetUnitTeam(unitID)
        --gadget:UnitCreated(unitID, unitDefID) --, unitTeam)
        gadget:UnitFinished(unitID, unitDefID) --, unitTeam)
    end
end


function gadget:UnitDestroyed(unitID, unitDefID, teamID, attackerID, attackerDefID, attackerTeam)
    activeDaemons[unitID] = nil
end

function gadget:GameFrame(f)
    if f%updateRate > 0.0001 then
        return end

    for unitID, unitDef in pairs(activeDaemons) do
        if isnumber(unitDef.buildDistance) then
            local repairRange = unitDef.buildDistance / 1.5
            local pos = {}
            pos.x, pos.y, pos.z = spGetUnitPosition(unitID)
            local daemonTeam = spGetUnitTeam(unitID)
            --local ud = { unitID=unitID, pos=pos, unitDef=unitDef, radius=repairRange }
            --local nearest = getNearestRepairableID (ud)
            local unitsAround = spGetUnitsInCylinder(pos.x, pos.z, repairRange)
            if not istable(unitsAround) then
                return nil end
            --- Get list of valid targets
            for _,targetID in pairs(unitsAround) do
                local nearbyUnitTeam = spGetUnitTeam(targetID)
                if IsValidUnit(targetID) and targetID ~= unitID and nearbyUnitTeam == daemonTeam then
                    local health, maxHealth = spGetUnitHealth(targetID)   --health, number maxHealth, number paralyzeDamage, number captureProgress, number buildProgress
                    local newHealth = math_min(maxHealth, health+100)
                    spSetUnitHealth (targetID, newHealth) --, [ capture = number capture ], [ paralyze = number paralyze ], [ build = number build ] } )
                    --Spring.Echo("adding health to: "..targetID)
                end
            end
        end
    end

end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Enable Weapon?
--Spring.UnitWeaponFire(unitID, WeaponDefNames['commanderexplosionemp'].id)
