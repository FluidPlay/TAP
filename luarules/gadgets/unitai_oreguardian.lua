-----------------------------------------------
-----------------------------------------------
---
--- author: Breno 'MaDDoX' Azevedo
---
-----------------------------------------------
-----------------------------------------------

function gadget:GetInfo()
    return {
        name      = "UnitAI Ore Guardian",
        desc      = "Defines Ore Guardians' behavior",
        author    = "MaDDoX",
        date      = "Jun, 2023",
        license   = "GNU GPL, v2 or later",
        layer     = 10,
        enabled   = true
    }
end

-- Synced only
if not gadgetHandler:IsSyncedCode() then
    return end

VFS.Include("gamedata/taptools.lua")

local updateRate = 6    -- how Often, in frames, to do updates
local spGetUnitPosition = Spring.GetUnitPosition
local spGiveOrderToUnit = Spring.GiveOrderToUnit
local spGetUnitsInCylinder = Spring.GetUnitsInCylinder
local spGetUnitTeam = Spring.GetUnitTeam

local CMD_FIRE_STATE = CMD.FIRE_STATE
local holdFireState, returnFireState = 0,1
local unitFireState = {}
local guardRadius = 480
local guardiansTeam

local oreGuardianDef = {
    pandoreguard = true,
}

local oreGuardians = {}

function gadget:Initialize()
    for _,unitID in ipairs(Spring.GetAllUnits()) do
        local teamID = Spring.GetUnitTeam(unitID)
        local unitDefID = Spring.GetUnitDefID(unitID)
        gadget:UnitFinished(unitID, unitDefID, teamID)
    end
end

-- Check if a guardian was built, adding it to the table if so
function gadget:UnitFinished(unitID, unitDefID, teamID)
    local ud = UnitDefs[unitDefID]
    if ud == nil then
        return end
    if oreGuardianDef[ud.name] then
        oreGuardians[unitID] = true
        spGiveOrderToUnit(unitID, CMD_FIRE_STATE, holdFireState, 0)
        unitFireState[unitID] = holdFireState
        if not guardiansTeam then
            guardiansTeam = spGetUnitTeam(unitID)
        end
    end
end

function gadget:GameFrame(f)
    --if f % updateRate > 0.0001 then
    --    return end
    --
    --for unitID,_ in pairs(oreGuardians) do
    --    local x,_,z = spGetUnitPosition(unitID)
    --    local unitsNearSpot = spGetUnitsInCylinder(x, z, guardRadius)
    --    for _,unitID in ipairs(unitsNearSpot) do
    --        --local unitDefID = spGetUnitDefID(unitID)
    --
    --        local currentState = unitFireState[unitID]
    --    end
    --end
end

function gadget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer,
                            weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
    --if (attackerTeam == guardiansTeam) then
    --    return
    --end
    for guardianID in pairs(oreGuardians) do
        --Spring.Echo("guardianID: "..(tostring(guardianID) or "nil"))
        local x,_,z = spGetUnitPosition(guardianID)
        local unitsNearSpot = spGetUnitsInCylinder(x, z, guardRadius)
        for _,nearbyUnitID in ipairs(unitsNearSpot) do
            if (nearbyUnitID == unitID) then
                --Spring.Echo("Unit was hit in guarding radius of guardianID: "..(tostring(guardianID) or "nil"))
                spGiveOrderToUnit(guardianID, CMD_FIRE_STATE, returnFireState, 0)
                unitFireState[guardianID] = returnFireState
            end
        end
    end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
    oreGuardians[unitID] = nil
end