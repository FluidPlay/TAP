function gadget:GetInfo()
    return {
        name      = "Unit - Transport Decelerator",
        desc      = "The heavier the load, the slower the transport moves",
        author    = "MaDDoX",
        date      = "Feb 24, 2021",
        license   = "GNU GPL, v2 or later",
        layer     = -1,
        enabled   = true  --  loaded by default?
    }
end

VFS.Include("gamedata/taptools.lua")

if (not gadgetHandler:IsSyncedCode()) then
    return end


local spGetUnitMoveTypeData = Spring.GetUnitMoveTypeData
local spSetGunshipMoveTypeData = Spring.MoveCtrl.SetGunshipMoveTypeData
local trackedUnits = {} -- Air Transports

local maxspeedReductionFactor = 0.6
local mygravityReductionFactor = 0.85 --unused

function gadget:UnitFinished(unitID, unitDefID, unitTeam, builderID)
    -- Check if it's an air transport
    local uDef = UnitDefs[unitDefID]
    if uDef and uDef.isTransport and uDef.isAirUnit then --unitDef.hoverAttack
        trackedUnits[unitID] = { orgspeed = uDef.speed,
                                 --orgmygravity = UnitDefs[unitDefID].myGravity,
        }
    end
end

local function GetTotalTransportWeight(transportID)
    local passengersIDs = Spring.GetUnitIsTransporting( transportID )
    if not passengersIDs or #passengersIDs < 1 or (not IsValidUnit(transportID)) then
        return 0, 0 end

    local transportDefID = Spring.GetUnitDefID(transportID)
    local transportUDef = UnitDefs[transportDefID]
    local transpMassLimit = 10000
    if transportUDef ~= nil then
        transpMassLimit = transportUDef.transportMass
    end

    local loadedMass = 0
    for _, passengerID in ipairs (passengersIDs) do
        local passengerDefID = Spring.GetUnitDefID(passengerID)
        local passengerUDef = UnitDefs[passengerDefID]
        loadedMass = loadedMass + (passengerUDef.mass or 0)
    end
    return loadedMass, transpMassLimit
end

-- if mass of transportees is > 60% of the transport's mass limit, reduce maxspeed by 40%
function gadget:UnitLoaded(unitID, unitDefID, unitTeam, transportID, transportTeam)
    if not trackedUnits[transportID] then
        return end
    local loadedMass, transpMassLimit = GetTotalTransportWeight(transportID)
    if loadedMass > (transpMassLimit * 0.6) then
        spSetGunshipMoveTypeData(transportID, "maxSpeed", maxspeedReductionFactor * trackedUnits[transportID].orgspeed)

        --local moveTypeData = spGetUnitMoveTypeData(transportID)
        --if moveTypeData.name == "air" then
        --    spSetAirMoveTypeData(transportID, {
        --        maxSpeed = maxspeedReductionFactor * trackedUnits[transportID].orgspeed,
        --        --myGravity = turnrateReductionFactor * trackedUnits[transportID].orgmygravity,
        --    })
        --end
    end
end

-- Restore transport speed, if appropriate
function gadget:UnitUnloaded(unitID, unitDefID, unitTeam, transportID, transportTeam)
    if not trackedUnits[transportID] then
        return end
    local loadedMass, transpMassLimit = GetTotalTransportWeight(transportID)
    if loadedMass <= (transpMassLimit * 0.6) then
        --local moveTypeData = spGetUnitMoveTypeData(transportID)
        --if moveTypeData.name == "air" then
        --    spSetAirMoveTypeData(unitID, {
        --        maxSpeed = trackedUnits[unitID].orgspeed,
        --        --myGravity = trackedUnits[unitID].orgmygravity,
        --    })
        --end
        spSetGunshipMoveTypeData(transportID, "maxSpeed", trackedUnits[transportID].orgspeed)
    end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID, attackerID, attackerDefID, attackerTeamID)
    trackedUnits[unitID] = nil
end

function gadget:UnitTaken(unitID, unitDefID, oldTeamID, teamID)
    self:UnitFinished(unitID, unitDefID, teamID)
end

function gadget:UnitGiven(unitID, unitDefID, newTeamID, oldTeamID)
    self:UnitDestroyed(unitID, unitDefID, oldTeamID)
end
