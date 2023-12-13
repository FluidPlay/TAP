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

GG.AggroedGuardians = {}

VFS.Include("gamedata/taptools.lua")
local fsm = { Spring = Spring, type = type, pairs = pairs, gl=gl, VFS=VFS, tostring=tostring}
VFS.Include("common/include/springfsm.lua", fsm)

local updateRate = 6    -- how Often, in frames, to do updates
local spGiveOrderToUnit = Spring.GiveOrderToUnit
local spSetUnitNeutral = Spring.SetUnitNeutral
local spGetUnitPosition = Spring.GetUnitPosition
local spGetUnitTeam = Spring.GetUnitTeam
local spGetUnitSeparation = Spring.GetUnitSeparation
local spGetGameFrame = Spring.GetGameFrame
local deaggroCheckDelay = 80

local CMD_FIRE_STATE = CMD.FIRE_STATE
local holdFireState, returnFireState, fireAtWillState = 0,1,2
local unitFireState = {}
local guardRadius = 480     -- TODO: de-hard-couple this
local guardiansTeam

local CMD_ATTACK = CMD.ATTACK
local CMD_MOVE = CMD.MOVE

local oreGuardianDef = {
    guardsml = true, guardmed = true, guardlrg = true, guarduber = true,
}

--{ idlePos = { x=x,y=y,z=z }, targetID = nil, targetPower = 0, targetUpdated = nil, }
local oreGuardians = {}         -- { idlePos = { x=x,y=y,z=z }, targetID = {}, targetPower = 0, targetUpdated = nil, nextCheckFrame = n }
local aggroedGuardians = {}     -- { guardianUnitID = true|false, ... }
local guardianAttackers = {}    -- { unitID = true, ... }

local fsmId = "oreguardian"
--local stateIDs = { [1] = "movetoattack", [2] = "combat", [2] = "return", [3] = "idle", }

local function issueStateOrders(unitID, state)
    spGiveOrderToUnit(unitID, CMD_FIRE_STATE, state, 0) --holdFireState or returnFireState
    spSetUnitNeutral(unitID, (state == holdFireState))
    unitFireState[unitID] = state
end

local fsmBehaviors = {
    [1] = { id="combat",
            condition = function(ud)    -- What's the condition to transition to this state (if not there yet)
                ud.targetID = oreGuardians[ud.unitID].targetID
                return aggroedGuardians[ud.unitID] and IsValidUnit(ud.targetID) --fsm.state ~= "combat" and
            end,
            action = function(ud)       -- What to do when entering this state, if condition is satisfied
                --print("Activated state "..stateIDs[1]) --.." for: "..ud.unitID)
                issueStateOrders(ud.unitID, returnFireState) --fireAtWillState
                spGiveOrderToUnit(ud.unitID, CMD_ATTACK, ud.targetID, { "alt" })
                return "combat"
            end
    },
    [2] = { id="idle",
            condition = function(ud)    -- What's the condition to transition to this state (if not there yet)
                ud.oreGuardian = oreGuardians[ud.unitID]
                local nextCheckFrame = ud.oreGuardian.nextCheckFrame
                local f = spGetGameFrame()
                --Spring.Echo("next Check Frame: "..(nextCheckFrame or "nil"))
                if nextCheckFrame and (f < nextCheckFrame) then
                    return false end
                local targetID = ud.oreGuardian.targetID
                local hasTarget = IsValidUnit(targetID)
                local isAway
                if hasTarget then
                    local ax,ay,az = spGetUnitPosition(targetID)
                    local ip = ud.oreGuardian.idlePos
                    isAway = distance(ax,ay,az, ip.x,ip.y,ip.z) > (guardRadius/2)
                end
                --Spring.Echo("hasTarget: "..tostring(hasTarget).." isAway: "..tostring(isAway))
                return (not hasTarget) or isAway -- and fsm.state ~= "idle"
            end,
            action = function(ud)       -- What to do when entering this state, if condition is satisfied
                --print("Activated state "..stateIDs[1]) --.." for: "..ud.unitID)
                local pos = ud.oreGuardian.idlePos
                issueStateOrders(ud.unitID, holdFireState)
                spGiveOrderToUnit(ud.unitID, CMD_MOVE, { pos.x, pos.y, pos.z }, {""})
                ud.oreGuardian.targetID = nil
                ud.oreGuardian.nextCheckFrame = nil
                aggroedGuardians[ud.unitID] = nil
                return "idle"
            end
    },
    --...
}

function gadget:Initialize()
    GG.AggroedGuardians = aggroedGuardians  -- Used by unit_avoidshootingguardians.lua
    GG.GuardianAttackers = guardianAttackers
    fsm.setup(fsmId, fsmBehaviors, 30, false) -- recheckLatency (idle->whatever), debug, updateRate = 6 (default)
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
    if (oreGuardians[attackerID]) then
        return
    end
    -- This will trigger 'combat' state for all guardians within guard range (from their idlepos);
    -- What will set back the idle state are the FSM conditions
    for guardianID, data in pairs(oreGuardians) do     -- { idlePos = { x=x,y=y,z=z }, targetID = {}, targetPower = 0, targetUpdated = nil, nextCheckFrame = n }
        --Spring.Echo("guardianID: "..(tostring(guardianID) or "nil"))
        if IsValidUnit(attackerID) and IsValidUnit(guardianID) then
            --local dist = spGetUnitSeparation(attackerID, guardianID, true, false)
            local ax,ay,az = spGetUnitPosition(unitID)
            local ip = data.idlePos
            local isInGuardRange = distance(ax,ay,az, ip.x,ip.y,ip.z) <= guardRadius/2
            if isInGuardRange then
                --Spring.Echo("Unit has attacked within guarding radius of guardianID: "..(tostring(guardianID) or "nil"))
                --unitFireState[guardianID] = returnFireState

                local attackerDef = UnitDefs[attackerDefID]
                local attackerPower = attackerDef.power
                -- If new nearby aggressor is not there, or has a stronger power, aim at it instead
                if (not IsValidUnit(data.targetID)) or attackerPower > data.targetPower then
                    data.targetPower = attackerPower
                    data.targetID = attackerID
                    data.targetUpdated = true
                end
                aggroedGuardians[guardianID] = true
                if not guardianAttackers[guardianID] then
                    guardianAttackers[guardianID] = {}
                end
                guardianAttackers[guardianID][attackerID] = true
                data.nextCheckFrame = spGetGameFrame() + deaggroCheckDelay      --Won't de-aggro before this long
            end
        end
    end
end

function gadget:GameFrame(f)
    if f < 1 then
        return end

    fsm.GameFrame(f)

end

function gadget:UnitDestroyed(unitID) --, unitDefID, teamID)
    oreGuardians[unitID] = nil
    aggroedGuardians[unitID] = nil
    --TODO: Clear up guardianAttackers table
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
