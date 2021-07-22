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

local unitsToDestroy = {} -- { [unitID]=frameToDestroy, ... }
local delayInFrames = 25 * 30

--SYNCED

if (gadgetHandler:IsSyncedCode()) then

    local unitsToEdit = {
        [UnitDefNames.armkameyes.id] = true,
        [UnitDefNames.corkameyes.id] = true,
    }

    -- When a unit is completed
    function gadget:UnitFinished(unitID, unitDefID, teamID)
        if type(unitsToEdit[unitDefID]) == nil or unitsToEdit[unitDefID] == nil then
            return end

        unitsToDestroy[unitID] = Spring.GetGameFrame()+delayInFrames
        --Spring.Echo("Unit to Destroy: "..unitID.." in frame: "..Spring.GetGameFrame()+delayInFrames)
    end

    function gadget:GameFrame(gf)
        for unitID, frameToDestroy in pairs(unitsToDestroy) do
            --Spring.Echo("unit: "..unitID.." frame: "..frameToDestroy.." gf: "..gf)
            if gf >= frameToDestroy then
                --Spring.Echo("Game Frame: "..gf)
                Spring.DestroyUnit(unitID, false, true)
                --TODO: If it's not cloaked, blow it up instead
                unitsToDestroy[unitID] = nil
            end
        end
    end

    --- Below code is probably unneeded. 
    --function gadget:UnitDestroyed(unitID, unitDefID, oldTeamID)
    --    unitsToDestroy[unitID] = nil
    --end
    --
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