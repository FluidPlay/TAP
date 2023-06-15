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
local spGetUnitPosition = Spring.GetUnitPosition
local spGetUnitTeam = Spring.GetUnitTeam
local spGetUnitSeparation = Spring.GetUnitSeparation
local spGetGameFrame = Spring.GetGameFrame
local aggroRecheckDelay = 60

local CMD_FIRE_STATE = CMD.FIRE_STATE
local holdFireState, returnFireState = 0,1
local unitFireState = {}
local guardRadius = 480     -- TODO: de-hard-couple this
local guardiansTeam

local CMD_ATTACK = CMD.ATTACK
local CMD_MOVE = CMD.MOVE

local oreGuardianDef = {
    pandoreguard = true,
}

local oreGuardians = {}
local aggressors = {}           -- Everyone who fired an attack from within any guardian def range
local aggroedGuardians = {}     -- { guardianUnitID = nextFrameCheck, ... }

local fsmId = "oreguardian"
local stateIDs = { [1] = "movetoattack", [2] = "combat", [2] = "return", [3] = "idle", }
local fsmBehaviors = {
    [1] = { id="combat",
            condition = function(ud)    -- What's the condition to transition to this state (if not there yet)
                ud.targetID = oreGuardians[ud.unitID].targetID
                return aggroedGuardians[ud.unitID] and fsm.state ~= "combat" and IsValidUnit(ud.targetID)
            end,
            action = function(ud)       -- What to do when entering this state, if condition is satisfied
                print("Activated state "..stateIDs[1]) --.." for: "..ud.unitID)
                spGiveOrderToUnit(ud.unitID, CMD_FIRE_STATE, returnFireState, 0)
                unitFireState[ud.unitID] = returnFireState
                spGiveOrderToUnit(ud.unitID, CMD_ATTACK, ud.targetID, { "alt" })
                return "combat"
            end
    },
    [2] = { id="idle",
            condition = function(ud)    -- What's the condition to transition to this state (if not there yet)
                local targetID = oreGuardians[ud.unitID].targetID
                return (not aggroedGuardians[ud.unitID] or not IsValidUnit(targetID)) and fsm.state ~= "idle"
            end,
            action = function(ud)       -- What to do when entering this state, if condition is satisfied
                --print("Activated state "..stateIDs[1]) --.." for: "..ud.unitID)
                local pos = oreGuardians[ud.unitID].idlePos
                spGiveOrderToUnit(ud.unitID, CMD_FIRE_STATE, holdFireState, 0)
                unitFireState[ud.unitID] = holdFireState
                spGiveOrderToUnit(ud.unitID, CMD_MOVE, { pos.x, pos.y, pos.z }, {""})
                return "idle"
            end
    },
    --...
}

function gadget:Initialize()
    fsm.setup(fsmId, fsmBehaviors, 30, false) --, updateRateNum = 6 (default)
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
        local x,y,z = spGetUnitPosition(unitID)
        oreGuardians[unitID] = { idlePos = { x=x,y=y,z=z }, targetID = nil, targetPower = 0, targetUpdated = nil, }
        fsm.UnitFinished(unitID, unitDef)
        --Spring.Echo("Unit added to FSM, next recheck frame: "..tostring(fsm.trackedUnits[unitID].recheckFrame))
        spGiveOrderToUnit(unitID, CMD_FIRE_STATE, holdFireState, 0)
        unitFireState[unitID] = holdFireState
        if not guardiansTeam then
            guardiansTeam = spGetUnitTeam(unitID)
        end
    end
end

function gadget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer,
                            weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
    if (attackerTeam == guardiansTeam) then
        return
    end
    for guardianID, data in pairs(oreGuardians) do      --{ targetID = {}, idlePos = { x=x,y=y,z=z } }
        --Spring.Echo("guardianID: "..(tostring(guardianID) or "nil"))
        if IsValidUnit(attackerID) and IsValidUnit(guardianID) then
            local dist = spGetUnitSeparation(attackerID, guardianID, true, false)
            if dist <= guardRadius then
                --Spring.Echo("Unit has attacked within guarding radius of guardianID: "..(tostring(guardianID) or "nil"))
                local nextCheckFrame = spGetGameFrame() + aggroRecheckDelay
                aggressors[attackerID] = nextCheckFrame * 2
                --spGiveOrderToUnit(guardianID, CMD_FIRE_STATE, returnFireState, 0)
                unitFireState[guardianID] = returnFireState
                local attackerDef = UnitDefs[attackerDefID]
                local attackerPower = attackerDef.power
                -- If new nearby aggressor is not there, or has a stronger power, aim it instead
                if (not data.targetID) or (not IsValidUnit(data.targetID)) or attackerPower > data.targetPower then
                    data.targetPower = attackerPower
                    data.targetID = attackerID
                    data.targetUpdated = true
                end
                aggroedGuardians[guardianID] = nextCheckFrame
            end
        end
    end
end

function gadget:GameFrame(f)
    if f < 1 then
        return end

    fsm.GameFrame(f)

    for aggressorID, nextCheckFrame in pairs(aggressors) do
        if IsValidUnit(aggressorID) then
            if f >= nextCheckFrame then
                aggressors[aggressorID] = nil       -- Aggression Expired
            end
            -- Go through guardians and see if there's any of them around, if so, update its 'aggroed' check timer
            for guardianID, nextGuardCheckFrame in pairs(aggroedGuardians) do
                if IsValidUnit(guardianID) and f >= nextGuardCheckFrame then
                    if spGetUnitSeparation(guardianID, aggressorID) < guardRadius then
                        aggroedGuardians[guardianID] = spGetGameFrame() + aggroRecheckDelay
                    end
                    local idlePos = oreGuardians[guardianID].idlePos
                    local x,y,z = spGetUnitPosition(guardianID)
                    if distance(x,y,z,idlePos.x,idlePos.y,idlePos.z) > (guardRadius/2) then
                        aggroedGuardians[guardianID] = nil
                    end
                end
            end
        end
    end

end

function gadget:UnitDestroyed(unitID) --, unitDefID, teamID)
    oreGuardians[unitID] = nil
    aggressors[unitID] = nil
    aggroedGuardians[unitID] = nil
end

--local function insertOrdered(tbl, insertData, param)
--    local len = #tbl
--    if (len == 0 ) then
--        tbl[1] = insertData
--        return end
--    --eg: {2, 4, 8}
--    -- insertVal = 1: [1]=2; 2 > 1; insert @ 1
--    -- insertVal = 3: [1]=2; 2 < 3; [2]=4; 4 > 3; insert @ 2
--    -- insertVal = 9: [1]=2; 2 < 9; [2]=4; 4 < 3; [3]=8; 4 < 9; insert @ len+1
--    for i, data in ipairs(tbl) do
--        local thisValue = data[param]
--        local newValue = insertData[param]
--        if thisValue > newValue then
--            table.insert(tbl, i, insertData)
--            Spring.Echo("UnitID "..insertData.unitID.." Added to idx: "..i)
--            break
--        end
--        if i == len then
--            tbl[len+1] = newValue
--        end
--    end
--end
