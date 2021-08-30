--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    unit_kameyes.lua
--  brief:   Destroyes kameyes after some time
--  author:  Breno "MaDDoX" Azevedo
--

function gadget:GetInfo()
    return {
        name      = "Unit Kameyes Self-D",
        desc      = "Self-Ds kameyes after some time",
        author    = "MaDDoX",
        date      = "Jul, 2021",
        license   = "GNU GPL, v2 or later",
        layer     = 10,
        enabled   = true
    }
end

local updateRate = 2
local trackedUnits = {} -- { [unitID]=frameToDestroy, ... }
local fuelPerDrone = 25 * 30 --25s

local spGetUnitVelocity = Spring.GetUnitVelocity
local spDestroyUnit = Spring.DestroyUnit
local spSetUnitRulesParam = Spring.SetUnitRulesParam

--SYNCED

if (gadgetHandler:IsSyncedCode()) then

    local unitsToEdit = {
        [UnitDefNames.armkameyes.id] = true,
        [UnitDefNames.corkameyes.id] = true,
    }

    -- When a unit is completed
    function gadget:UnitFinished(unitID, unitDefID, teamID)
        if unitsToEdit[unitDefID] == nil or type(unitsToEdit[unitDefID]) == nil then
            return end

        trackedUnits[unitID] = fuelPerDrone --Spring.GetGameFrame() + delayInFrames
        spSetUnitRulesParam(unitID, "fuelperc", 1)  -- 100% at time of creation
        --Spring.Echo("Unit to Destroy: "..unitID.." with fuel: "..fuelPerDrone.." fuelPerc: "..1)
    end

    function gadget:GameFrame(gf)
        if gf % updateRate > 0.0001 then
            return end
        for unitID, fuel in pairs(trackedUnits) do
            local _,_,_,unitMoveSpeed = spGetUnitVelocity(unitID)
            if unitMoveSpeed > 0.1 then
                local newFuel = fuel-1
                trackedUnits[unitID] = newFuel
                if newFuel <= 0 then
                    --TODO: If it's not cloaked, blow it up instead
                    spDestroyUnit(unitID, false, true)
                else
                    spSetUnitRulesParam(unitID, "fuelperc", newFuel/fuelPerDrone)
                end
            end
        end
    end

    function gadget:UnitDestroyed(unitID, unitDefID, oldTeamID)
        trackedUnits[unitID] = nil
    end

    --- Below code is probably unneeded.
    --function gadget:UnitGiven(unitID, unitDefID, newTeamID, teamID)
    --    mexBuilder[unitID] = mexBuilderDefs[unitDefID]
    --    if mexDefID[unitDefID] then
    --        local done = select(5, spGetUnitHealth(unitID))
    --        if done == 1 then
    --            widget:UnitFinished(unitID, unitDefID,unitDefID)
    --        end
    --    end
    --end
    --
    --function gadget:UnitTaken(unitID, unitDefID, oldTeamID, teamID)
    --    gadget:UnitDestroyed(unitID, unitDefID, oldTeamID)
    --end

    --else -- UNSYNCED
end