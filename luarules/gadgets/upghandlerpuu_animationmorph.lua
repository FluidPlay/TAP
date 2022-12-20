---
--- Created by Breno "MaDDoX" Azevedo.
--- DateTime: 14-Nov-18 9:19 AM
--- Check gui_multi_tech for a system architecture description

function gadget:GetInfo()
    return {
        name      = "Per-unit Upgrade Handler - Animation-only Morph",
        desc      = "Disables-enables advanced buttons of animation-morphed units",
        author    = "MaDDoX",
        date      = "14 December 2022",
        license   = "GNU GPL, v2 or later",
        layer     = 0,
        enabled   = true,
    }
end

if not gadgetHandler:IsSyncedCode() then
    return end


VFS.Include("gamedata/taptools.lua")
--VFS.Include("LuaRules/Configs/upgradedata_perunit.lua")
-----------------
---- SYNCED
-----------------

local spGetGameFrame = Spring.GetGameFrame
local spGetUnitTeam  = Spring.GetUnitTeam
local spGetUnitRulesParam = Spring.GetUnitRulesParam
local spGetUnitDefID = Spring.GetUnitDefID

local trackedUnits = {}     -- { unitID = true, ...} | who'll get the speed improved once upgrade done

local upgradableDefIDs = {} -- { UnitDefID = {}, ..}
local upgData = {}          -- { [UnitDefNames["armstump"].id] = true, ... }

local updateRate = 2        -- How often to check for pending-research techs
--local reductionFactor = 0.7

local unitRulesCompletedParamName = "morphedinto"

local animMorphLockedOptions = { "cormando", "coraak", "corcan", "corsktl", "cordefiler", }

function gadget:Initialize()
    --upgData = UnitUpgrades.hover
    --upgradableDefIDs = upgData.upgradableDefIDs
end

--local function ApplyHover(unitID)
--    local unitDef = UnitDefs[spGetUnitDefID(unitID)]
--    local orgMoveDef = unitDef.moveDef and unitDef.moveDef.name or nil
--    if orgMoveDef then
--        Spring.MoveCtrl.SetMoveDef(unitID, string.lower(orgMoveDef).."hover")
--        --NOTE: string moveDefName needs to be in lowercase, notwithstanding the fact that it may be in another case in the movedef table.
--    end
--end

local function SetDisableButtons(unitID, disable)
    local cmdDescs = Spring.GetUnitCmdDescs(unitID)
    for ct, cmdDescData in pairs(cmdDescs) do
        --if cmdDescData.id < 0 and not hasPrint then
        --end
        for i = 1, #animMorphLockedOptions do
            if cmdDescData.name == animMorphLockedOptions[i] then
                local cmdIdx = Spring.FindUnitCmdDesc(unitID, cmdDescData.id)
                cmdDescData.disabled = disable
                Spring.EditUnitCmdDesc(unitID, cmdIdx, cmdDescData)
            end
        end
    end
end

-- Adds unit of interest to trackedUnits table
function gadget:UnitCreated(unitID, unitDefID, unitTeam)
    local unitDef = UnitDefs[unitDefID]
    if not unitDef or not unitDef.customParams or not unitDef.customParams.morphdef__animationonly then
        return end
    if tonumber(unitDef.customParams.morphdef__animationonly) == 1 then
        trackedUnits[unitID] = unitDef
        SetDisableButtons(unitID, true)
    end
end

-- Constantly poll to check if per-unit upgrade is done (processed by upgrade_perunit.lua)
local function Update()
    for unitID, unitDef in pairs(trackedUnits) do
        local completedParam = spGetUnitRulesParam(unitID, unitRulesCompletedParamName)
        if completedParam and (tonumber(completedParam) == 1) then
            --Spring.Echo("Morph-animation upgrade detected")
            trackedUnits[unitID] = nil
            SetDisableButtons(unitID, false)
        end
    end
end

function gadget:GameFrame()
    local frame = spGetGameFrame()
    if frame % updateRate > 0.001 then
        return end
    Update()
end

function gadget:UnitDestroyed(unitID)
    trackedUnits[unitID] = nil
end

function gadget:UnitGiven(unitID, unitDefID, teamID)
    gadget:UnitCreated(unitID, unitDefID, teamID)
end
