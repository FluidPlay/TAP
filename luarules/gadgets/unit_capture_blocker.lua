function gadget:GetInfo()
    return {
        name      = "D-gun blocker",
        desc      = "Blocks D-gun command for starting commanders",
        author    = "MaDDoX",
        date      = "27 Jul, 2021",
        license   = "GNU GPL, v2 or later",
        layer     = 0,
        enabled   = true  --  Enabled by default?
    }
end

if gadgetHandler:IsSyncedCode() then
    --- SYNCED

    VFS.Include("gamedata/taptools.lua")

    local trackedUnits = {}             -- unitID = true, ... }

    local CMD_MANUALFIRE = CMD.MANUALFIRE
    local spGetUnitDefID = Spring.GetUnitDefID

    local function ist0commander(uDefID)
        local uDef = UnitDefs[uDefID]
        --local cParms = uDef.customParams
        --if cParms and cParms.iscommander and uDef.canManualFire == false then
        if uDefID == UnitDefNames.armcom.id or uDefID == UnitDefNames.corcom.id then
            return true
        end
        return false
    end

    function gadget:AllowCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions, cmdTag, synced)
        if not IsValidUnit(unitID) then
            return end
        if trackedUnits[unitID] and cmdID and cmdID == CMD_MANUALFIRE then
            --SendToUnsynced("CaptureBlockedEvent", unitTeam)
            return false
        end
        return true
    end

    function gadget:UnitCreated(unitID, unitDefID)
        if ist0commander(unitDefID) then
            --Spring.Echo("Found t0 commander")
            trackedUnits[unitID] = true
        end
    end

    function gadget:Initialize()
        for _, unitID in ipairs(Spring.GetAllUnits()) do
            local unitDefID = spGetUnitDefID(unitID)
            gadget:UnitCreated(unitID, unitDefID)
        end
    end

else
    --function HandleCaptureBlockedEvent(cmd, unitTeam)
    --    if Script.LuaUI("CaptureBlockedUIEvent") then
    --        Script.LuaUI.CaptureBlockedUIEvent(unitTeam)
    --    end
    --end
    --
    --function gadget:Initialize()
    --    gadgetHandler:AddSyncAction("CaptureBlockedEvent", HandleCaptureBlockedEvent)
    --end
    --function gadget:Shutdown()
    --    gadgetHandler:RemoveSyncAction("CaptureBlockedEvent")
    --end
end