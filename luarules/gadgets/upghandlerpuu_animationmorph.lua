---
--- Created by Breno "MaDDoX" Azevedo.
--- DateTime: 14-Nov-18 9:19 AM
--- Check gui_multi_tech for a system architecture description

function gadget:GetInfo()
    return {
        name      = "Per-unit Upgrade Handler - Animation-only Morph",
        desc      = "Generic local upgrades parser",
        author    = "MaDDoX",
        date      = "14 December 2022",
        license   = "GNU GPL, v2 or later",
        layer     = 550,
        enabled   = true,
    }
end

--- What's this for?
---     In some cases, you don't want the morph to replace the unit for a new one. When there are weapon changes,
---     replacement is usually the best option. But for factories, for instance, you might get units under production
---     stuck due to different yardmaps, and/or lose whatever was being produced while the morph finished. That's what
---     "animation-only" morphs are for, you just play an animation (defined in the script) and unlocks buildoptions
---     if needed (usually "advanced" units)
--- How to use it?
---     1. To your morphdef customParams table, at the source unit, add an "animationonly = 1" entry
---     2. For the unitdefs which should be locally (factory-specific) unlocked with morph, add a requiretech
---        customParam with "local:advanced"
---     3. In the unit's animation script, add a function MorphUp() (case-sensitive) which will be fired when
---        morph is complete [handled by unit_morph.lua]

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
local spSetUnitRulesParam = Spring.SetUnitRulesParam
local spGetUnitDefID = Spring.GetUnitDefID

local trackedUnits = {}     -- { unitID = true, ...} | who'll get the speed improved once upgrade done

local upgradableDefIDs = {} -- { UnitDefID = {}, ..}
local upgData = {}          -- { [UnitDefNames["armstump"].id] = true, ... }

local updateRate = 2        -- How often to check for pending-research techs
--local reductionFactor = 0.7

local unitRulesCompletedParamName = "morphedinto"
local techname = "advanced"
local removeMorphButtons = _G.removeMorphButtons

--local animMorphLockedOptions = { "cormando", "coraak", "corcan", "corsktl", "cordefiler", }

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

---OBSOLETE: Will be carried out by cmd_multi_tech instead, to unify the blocking/prereqs
--local function SetDisableButtons(unitID, disable)
--    local cmdDescs = Spring.GetUnitCmdDescs(unitID)
--    for ct, cmdDescData in pairs(cmdDescs) do
--        --if cmdDescData.id < 0 and not hasPrint then
--        --end
--        for i = 1, #animMorphLockedOptions do
--            if cmdDescData.name == animMorphLockedOptions[i] then
--                local cmdIdx = Spring.FindUnitCmdDesc(unitID, cmdDescData.id)
--                cmdDescData.disabled = disable
--                Spring.EditUnitCmdDesc(unitID, cmdIdx, cmdDescData)
--            end
--        end
--    end
--end

-- Initialize local:techname unitRulesParam (with value 0) to 'animationonly' == 1 cparams/morphdef units
function gadget:UnitCreated(unitID, unitDefID, unitTeam)
    local unitDef = UnitDefs[unitDefID]
    if unitDef == nil or unitDef.customParams == nil then
        return end
    if tonumber(unitDef.customParams.morphdef__animationonly) == 1 then
        --Spring.Echo("Started tracking animation-only for "..unitID)
        trackedUnits[unitID] = unitDef
        --TODO: Generalize/Move to upgrade_perunit
        spSetUnitRulesParam(unitID,"local:"..techname, 0)	-- 0 = initializes, 1 == awarded
    end
end

-- Constantly poll to check if per-unit upgrade is done (processed by upgrade_perunit.lua)
local function Update()
    for unitID, unitDef in pairs(trackedUnits) do
        local completedAnimID = spGetUnitRulesParam(unitID, unitRulesCompletedParamName)
        --Spring.Echo("upgradehandler: morph-completed param = "..(completedParam or "nil"))
        if isnumber(completedAnimID) and completedAnimID > 0 then
            trackedUnits[unitID] = nil
            spSetUnitRulesParam(unitID,"local:"..techname, completedAnimID) --TODO/WIP: Support sequential morphs
            GG.RefreshTechReqs(unitID, unitDef)
            --Spring.Echo("Morph-animation local upgrade assigned")
            --SetDisableButtons(unitID, false)

            GG.removeMorphButtons(unitID, "upghandlerpuu_animationmorph") --(unitID, unitDefID)
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