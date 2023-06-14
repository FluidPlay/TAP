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


-- Synced Part:
if not gadgetHandler:IsSyncedCode() then
    return end

VFS.Include("gamedata/taptools.lua")
local fsm = { Spring = Spring, type = type, pairs = pairs, gl=gl, VFS=VFS, tostring=tostring}
VFS.Include("common/include/springfsm.lua", fsm)

local updateRate = 6    -- how Often, in frames, to do updates
local spGiveOrderToUnit = Spring.GiveOrderToUnit
local spGetUnitTeam = Spring.GetUnitTeam
local spGetUnitSeparation = Spring.GetUnitSeparation
local spGetGameFrame = Spring.GetGameFrame
local aggroRecheckDelay = 60

local CMD_FIRE_STATE = CMD.FIRE_STATE
local holdFireState, returnFireState = 0,1
local unitFireState = {}
local guardRadius = 480
local guardiansTeam

local oreGuardianDef = {
    pandoreguard = true,
}

local oreGuardians = {}
local aggroedGuardians = {}     -- { guardianUnitID = nextFrameCheck, ... }

local fsmId = "oreguardian"
local stateIDs = { [1] = "movetoattack", [2] = "attack", [2] = "return", [3] = "idle", }
local fsmBehaviors = {
    [1] = { id=stateIDs[1],             -- COMBAT
            condition = function(ud)    -- What's the condition to transition to this state
                --local exampleVar = exampleFunction(ud.unitID, ud.unitDef)
                return true -- egVar > 2
            end,
            action = function(ud)       -- What to do when entering this state, if condition is satisfied
                print("Activated state "..stateIDs[1]) --.." for: "..ud.unitID)
                return stateIDs[1]
            end
    },
    --...
}

function gadget:Initialize()
    fsm.setup(fsmId, fsmBehaviors, 30, true) --, updateRateNum = 6 (default)
    for _,unitID in ipairs(Spring.GetAllUnits()) do
        local teamID = Spring.GetUnitTeam(unitID)
        local unitDefID = Spring.GetUnitDefID(unitID)
        gadget:UnitFinished(unitID, unitDefID, teamID)
    end
end

-- Check if a guardian was built, adding it to the table if so
function gadget:UnitFinished(unitID, unitDefID, teamID)
    local unitDef = UnitDefs[unitDefID]
    if unitDef == nil then
        return end
    if oreGuardianDef[unitDef.name] then
        oreGuardians[unitID] = { aggro = {}, }
        fsm.UnitFinished(unitID, unitDef)
        --Spring.Echo("Unit added to FSM, next recheck frame: "..tostring(fsm.trackedUnits[unitID].recheckFrame))
        spGiveOrderToUnit(unitID, CMD_FIRE_STATE, holdFireState, 0)
        unitFireState[unitID] = holdFireState
        if not guardiansTeam then
            guardiansTeam = spGetUnitTeam(unitID)
        end
    end
end

function gadget:GameFrame(f)
    if f < 1 then
        return end

    fsm.GameFrame(f)
end

local function insertOrdered(tbl, insertData, param)
    local len = #tbl
    if (len == 0 ) then
        return end
    --eg: {2, 4, 8}
    -- insertVal = 1: [1]=2; 2 > 1; insert @ 1
    -- insertVal = 3: [1]=2; 2 < 3; [2]=4; 4 > 3; insert @ 2
    -- insertVal = 9: [1]=2; 2 < 9; [2]=4; 4 < 3; [3]=8; 4 < 9; insert @ len+1
    for i, data in ipairs(tbl) do
        local thisValue = data[param]
        local newValue = insertData[param]
        if thisValue > newValue then
            table.insert(tbl, i, insertData)
            Spring.Echo("UnitID "..insertData.unitID.." Added to idx: "..i)
            break
        end
        if i == len then
            tbl[len+1] = newValue
        end
    end
end

function gadget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer,
                            weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
    if (attackerTeam == guardiansTeam) then
        return
    end
    for guardianID, data in pairs(oreGuardians) do
        --Spring.Echo("guardianID: "..(tostring(guardianID) or "nil"))
        local dist = spGetUnitSeparation(unitID, guardianID, true, false)
        if dist <= guardRadius then
            Spring.Echo("Unit was hit in guarding radius of guardianID: "..(tostring(guardianID) or "nil"))
            spGiveOrderToUnit(guardianID, CMD_FIRE_STATE, returnFireState, 0)
            unitFireState[guardianID] = returnFireState
            local attackerDef = UnitDefs[attackerDefID]
            local attackerPower = attackerDef.power
            local len = #data.aggro
            local newData = { unitID = attackerID, power = attackerPower }
            if (len == 0) then
                data.aggro = { [1] = newData }
            else
                insertOrdered(data.aggro, newData, "power")
            end
            aggroedGuardians[guardianID] = spGetGameFrame() + aggroRecheckDelay
        end
    end
end

function gadget:UnitDestroyed(unitID, unitDefID, teamID)
    oreGuardians[unitID] = nil
end
