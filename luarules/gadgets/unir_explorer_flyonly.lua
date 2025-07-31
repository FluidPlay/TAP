function gadget:GetInfo()
    return {
        name      = "Explorer fly-mode only",
        desc      = "Sets any built explorer to fly mode and removes land command option",
        author    = "MaDDoX",
        date      = "31 Jul 2025",
        license   = "GNU GPL, v2 or later",
        layer     = 0,
        enabled   = true  --  loaded by default?
    }
end

if (not gadgetHandler:IsSyncedCode()) then
    return
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local removeCommands = {
    CMD.IDLEMODE,
    35430, --CMD_LAND_AT_AIRBASE
    35431, --CMD_LAND_AT_SPECIFIC_AIRBASE
    CMD.LOAD_UNITS,
    CMD.UNLOAD_UNITS,
    CMD.LOAD_ONTO,
    CMD.UNLOAD_UNIT,
}

local spGiveOrderToUnit = Spring.GiveOrderToUnit
local spRemoveUnitCmdDesc = Spring.RemoveUnitCmdDesc
local spFindUnitCmdDesc = Spring.FindUnitCmdDesc

local trackedUnits = {
    [UnitDefNames["kernexplorer"].id] = true,
}

function gadget:UnitCreated(unitID, unitDefID, unitTeam)
    if trackedUnits[unitDefID] then
        --local uDefID = spGetUnitDefID(unitID)
        --local uDef = UnitDefs[uDefID]
        spGiveOrderToUnit(unitID, CMD.IDLEMODE, { 0 }, { }) --fly
        for i = 1, #removeCommands do
            local cmdDesc = spFindUnitCmdDesc(unitID, removeCommands[i])
            if cmdDesc then
                spRemoveUnitCmdDesc(unitID, cmdDesc)
            end
        end
    end
end