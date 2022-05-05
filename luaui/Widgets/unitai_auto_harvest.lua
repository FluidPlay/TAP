---------------------------------------------------------------------------------------------------------------------
-- IMPORTANT: Requires unitai_auto_assist.lua to work!
---------------------------------------------------------------------------------------------------------------------

function widget:GetInfo()
    return {
        name = "UnitAI Auto Harvest",
        desc = "Handles the Harvest cycle of Builders in the ai_builder_brain's 'harvest' state",
        author = "MaDDoX",
        date = "Feb 7, 2022",
        license = "GPLv3",
        layer = 16,
        enabled = true,
        handler = false,
    }
end

--- Harvest-cycle Priorities and Logic
---       idle - set to 'Harvest' mode (by unitai_auto_assist.lua) but still not automated
--- #1 :: attack - is NOT fully loaded & can harvest & has chunk nearby => attack nearest chunk
--- #2 :: deliver - is fully loaded, not in range of nearest ore tower => move to nearestOreTower, set current pos to 'returnpos'
--- #3 :: unloading - is on #deliver & has resources (partial or not) & in range of nearest ore tower => define return pos, stay still
--- #4 :: return - is on #unloading & has no resources & has return pos => move to return pos

---What's an "orphan harvester"?
---	- load < maxload & has no parentOretower
---	=> Find nearest ore tower and set parentOretower, new returnPos to it
---	=> Attack nearest ore Chunk
---
---What's an "unloading" harvester? (set by other logic) [ was "await"]
---=> Stay still
---=> Start being watched by game loop until it's unloaded, then set it to 'returning'
---
---What's a "returning" harvester?
---=> was unloading and is now fully unloaded (0 load), has parentOretower & returnPos
---=> Go to returnPos
---=> Once there, attack nearest ore Chunk
---=> if succeed, set it to 'attack'

-- "idle", "attacking", "delivering", "unloading", "returning"

VFS.Include("gamedata/tapevents.lua") --"LoadedHarvestEvent"
VFS.Include("gamedata/taptools.lua")
VFS.Include("gamedata/unitai_functions.lua")

local localDebug = false --|| Enables text state debug messages

local spGetAllUnits = Spring.GetAllUnits
local spGetUnitDefID = Spring.GetUnitDefID
local spGetFeatureDefID = Spring.GetFeatureDefID
local spValidFeatureID = Spring.ValidFeatureID
local spGetUnitPosition = Spring.GetUnitPosition
local spGetMyTeamID     = Spring.GetMyTeamID
local spGetMyAllyTeamID     = Spring.GetMyAllyTeamID
local spGetUnitAllyTeam     = Spring.GetUnitAllyTeam
local spGetFeaturePosition = Spring.GetFeaturePosition
local spGetSelectedUnits = Spring.GetSelectedUnits
local spGiveOrderToUnit = Spring.GiveOrderToUnit
local spSetUnitRulesParam = Spring.SetUnitRulesParam
local spGetUnitHarvestStorage = Spring.GetUnitHarvestStorage
local spGetTeamResources = Spring.GetTeamResources
local spGetUnitTeam    = Spring.GetUnitTeam
local spGetUnitsInSphere = Spring.GetUnitsInSphere
local spGetFeaturesInSphere = Spring.GetFeaturesInSphere
local spGetGameFrame = Spring.GetGameFrame
local spGetCommandQueue = Spring.GetCommandQueue -- 0 => commandQueueSize, -1 = table
local spGetUnitRulesParam = Spring.GetUnitRulesParam
local spSendLuaUIMsg = Spring.SendLuaUIMsg

local glGetViewSizes = gl.GetViewSizes
local myTeamID, myAllyTeamID = -1, -1
local gaiaTeamID = Spring.GetGaiaTeamID()

local startupGracetime = 300        -- Widget won't work at all before those many frames (10s)
local updateRate = 15               -- Global update "tick rate"

local recheckLatency = 30 -- Delay until a de-automated unit checks for automation again
local automatedState = {}

local oretowerShortScanRange = 250 -- Collection-start scan range (not used here, only by auto_assist actually)
local oretowerLongScanRange = 900 -- Return/devolution scan range
local harvestLeashMult = 6        -- chunk search range is the harvest range* multiplied by this  (*attack range of weapon eg. "armck_harvest_weapon")

local vsx, vsy = gl.GetViewSizes()
local widgetScale = (0.50 + (vsx*vsy / 5000000))

---=== Harvest-system related

-- ALERT: uDef.harvestStorage is not working (up to Spring 105)
local harvesters = {} -- { unitID = uDef.customparams.maxorestorage, parentOreTowerID, targetChunkID
                      --   returnPos = { x = rpx, y = rpy, z = rpz }, recheckFrame = spGetGameFrame + idleRecheckLatency }
--- Attack: actually harvesting; Deliver: going to the nearest ore tower; Unloading: in range of an ore tower, stopped and unloading;
--- Resume: returning to the previous harvest position, after delivery

---local automatedState = {}   -- This is the automated state. It's always there for automatableUnits, after the initial latency period
local harvestState = {}     -- Harvest state. // "idle", "attacking", "delivering", "unloading", "returning"
local oreTowerDefNames = { armmstor = true, cormstor = true, armuwadvms = true, coruwadvms = true, }
local oreTowers = {}        -- { unitID = oreTowerReturnRange, ... }

--- Harvest-cycle state controllers
local oreChunks = {} --TODO
local orphanHarvesters = {}     -- { unitID = true, ... }    -- has no parentOretower assigned, "idle"
-- Post direct order                // { [unitID] = frameToTryReautomation, ... }
                                    -- { [unitID] = frameToAutomate (eg: spGetGameFrame() + recheckUpdateRate), ... }
local automatedHarvesters = {}    -- { unitID = true, ... }    -- Basically the opposite of an 'orphaHarvester'

local CMD_FIGHT = CMD.FIGHT
local CMD_PATROL = CMD.PATROL
local CMD_REPAIR = CMD.REPAIR
local CMD_GUARD = CMD.GUARD
local CMD_RESURRECT = CMD.RESURRECT --125
local CMD_REMOVE = CMD.REMOVE
local CMD_RECLAIM = CMD.RECLAIM
local CMD_ATTACK = CMD.ATTACK
local CMD_UNIT_SET_TARGET = 34923
local CMD_MOVE = CMD.MOVE
local CMD_STOP = CMD.STOP
local CMD_INSERT = CMD.INSERT
local CMD_OPT_RIGHT = CMD.OPT_RIGHT

local CMD_OPT_INTERNAL = CMD.OPT_INTERNAL

----- Type Tables

local canharvest = {
    armck = true, corck = true, armca = true, corca = true,
    armaca = true, coraca = true,
    armack = true, corack = true,
    armcv = true, corcv = true,
    armacv = true, coracv = true,
    --armcs = true, corcs = true,
    --armacsub = true, coracsub = true,
}

-----

local function spEcho(string)
    if localDebug then --and isCom(unitID) and state ~= "idle"
        Spring.Echo(string) end
end

local function removeCommands(unitID)
    spGiveOrderToUnit(unitID, CMD_REMOVE, {CMD_PATROL, CMD_GUARD, CMD_ATTACK, CMD_UNIT_SET_TARGET, CMD_RECLAIM, CMD_FIGHT, CMD_REPAIR}, {"alt"})
end

--- If you left the game this widget has no raison d'etré
function widget:PlayerChanged()
    if Spring.GetSpectatingState() and Spring.GetGameFrame() > 0 then
        widgetHandler:RemoveWidget(self)
    end
end

---- Disable widget if I'm spec
function widget:Initialize()
    if not WG.automatedStates then
        Spring.Echo("<AI Builder Brain> This widget requires the 'AI Builder Brain' widget to run.")
        widgetHandler:RemoveWidget(self)
    end
    if Spring.IsReplay() or Spring.GetGameFrame() > 0 then
        widget:PlayerChanged() end
    local _, _, spec = Spring.GetPlayerInfo(Spring.GetMyPlayerID(), false)
    if spec then
        widgetHandler:RemoveWidget()
        return false
    end
    automatedState = WG.automatedStates             -- Set by unitai_auto_assist
    harvesters = WG.harvesters          -- -- Set by unitai_auto_assist
    WG.harvestState = harvestState      -- This will allow the harvest state to be read and set by other widgets

    -- We do this to re-initialize (after /luaui reload) properly
    myTeamID = spGetMyTeamID()
    myAllyTeamID = spGetMyAllyTeamID
    local allUnits = spGetAllUnits()
    for i = 1, #allUnits do
        local unitID    = allUnits[i]
        local unitDefID = spGetUnitDefID(unitID)
        local unitTeam  = spGetUnitTeam(unitID)
        widget:UnitFinished(unitID, unitDefID, unitTeam)
    end
end

--function widget:UnitCreated(unitID, unitDefID, teamID, builderID)
    --local unitDef = UnitDefs[unitDefID]
    --if canrepair[unitDef.name] or canresurrect[unitDef.name] then
    --    spEcho("Registering unit "..unitID.." as automatable: "..unitDef.name)--and isCom(unitID)
    --    automatableUnits[unitID] = true
    --end
--end

function widget:UnitFinished(unitID, unitDefID, unitTeam)
    local unitDef = UnitDefs[unitDefID]
    if not unitDef then
        return end
    if oreTowerDefNames[unitDef.name] then
        oreTowers[unitID] = getOreTowerRange(nil, unitDef) end
    --local maxorestorage = tonumber(unitDef.customParams.maxorestorage)
    --if maxorestorage and maxorestorage > 0 then
    --    harvesters[unitID] = { maxorestorage = maxorestorage, parentOreTowerID = nil, returnPos = {}, targetChunkID = nil,
    --                           recheckFrame = spGetGameFrame() + recheckLatency, loadPercent = 0,  }
    --    Spring.Echo("unitai_autoharvest: added harvester: "..unitID.." storage: "..maxorestorage)
    --    orphanHarvesters[unitID] = true -- newborns are orphan. Usually not for long.
    --end
end

function widget:UnitDestroyed(unitID)
    orphanHarvesters[unitID] = nil
    --- if an Ore Tower is destroyed, must go through all harvesters and clear their nearest/parentOreTower
    if oreTowers[unitID] then
        for harvesterID, data in pairs(harvesters) do
            if data.parentOreTowerID == unitID then
                harvesters[harvesterID].parentOreTowerID = nil
            end
        end
        oreTowers[unitID] = nil
    end
end


local function deautomateUnit(unitID)
    removeCommands(unitID)  -- removes Guard, Patrol, Fight and Repair commands
    --spEcho("Deharvesting Unit: "..unitID)
    --harvestersInAction[unitID] = nil
    automatedHarvesters[unitID] = nil
    spEcho("Auto harvest:: Deautomating Unit: "..unitID..", try re-automation in: "..harvesters[unitID].recheckFrame)
end

local function setHarvestState(unitID, state, caller) -- idle, attack, waitforunload, deliver, resume
    if state == "idle" then
        deautomateUnit(unitID)
        harvesters[unitID].recheckFrame = spGetGameFrame() + recheckLatency
    end
    harvestState[unitID] = state
    spEcho("New harvest State: ".. state .." for: "..unitID.." set by function: "..caller)
end

--- Decides and issues orders on what to do around the unit, in this order (1 == higher):
--- 1. If is not harvesting and there's a chunk nearby, harvest nearest chunk
--- 2. If is harvesting and a) not fully loaded, just destroyed chunk => go for nearest chunk;
---                         b) fully loaded => go for nearest ore tower.
local automatedFunctions = {
    [1] = { id="delivering",
            condition = function(ud)
                        --Spring.Echo("parent ore towerID: "..(ud.parentOreTowerID or "nil").." load perc: "..(harvesters[ud.unitID] and harvesters[ud.unitID].loadPercent or "nil").." harvest state: "..harvestState[ud.unitID])
                        if not ud.parentOreTowerID then
                            local nearestOreTowerID = getNearestOreTowerID (ud, oreTowers, oretowerLongScanRange)
                            ud.parentOreTowerID = nearestOreTowerID end
                        local pushed
                        if ud.parentOreTowerID and
                            (harvestState[ud.unitID] == "unloading" or
                             (harvestState[ud.unitID] == "delivering" and spGetCommandQueue(ud.unitID, 0) < 1)) then
                            pushed = getFarFromOreTower(ud.unitID, oreTowers[ud.parentOreTowerID], ud.parentOreTowerID)--(ud)
                        end
                        return ud.parentOreTowerID and harvestState[ud.unitID] ~= "delivering"
                            and (harvesters[ud.unitID].loadPercent == 1
                                    and (
                                        (harvestState[ud.unitID] == "attacking" or harvestState[ud.unitID] == "idle")
                                        and ud.parentOreTowerID
                                    ) )
                            or pushed
                        end,
            action = function(ud)
                harvesters[ud.unitID].returnPos = { x = ud.pos.x, y = ud.pos.y, z = ud.pos.z }
                spGiveOrderToUnit(ud.unitID, CMD_REMOVE, {CMD_MOVE}, {"alt"})
                local x,y,z = spGetUnitPosition(ud.parentOreTowerID)
                spGiveOrderToUnit(ud.unitID, CMD_MOVE, {x, y, z}, { "" })
                --Spring.Echo("HARVESTER: Issued Command: MOVE")
                return "delivering"
            end
    },
    [2] = { id="unloading",
            condition = function(ud) -- delivering => unloading
                        if not ud.parentOreTowerID then
                            local nearestOreTowerID = getNearestOreTowerID (ud, oreTowers, oretowerLongScanRange)
                            ud.parentOreTowerID = nearestOreTowerID end
                        local farFromOreTower = getFarFromOreTower(ud.unitID, oreTowers[ud.parentOreTowerID], ud.parentOreTowerID)--(ud)
                        return harvestState[ud.unitID] == "delivering"
                                and ud.parentOreTowerID and not farFromOreTower
                        end,
            action = function(ud)
              spEcho("**2** Unloading Actions")
              spGiveOrderToUnit(ud.unitID, CMD_STOP, {} , CMD_OPT_RIGHT )
              return "unloading"
            end
    },
    [3] = { id="returning",
            condition = function(ud)
                       return harvestState[ud.unitID] == "unloading" -- has no resources & has return pos
                               and spGetUnitHarvestStorage(ud.unitID) <= 0 and ud.returnPos
                       end,
            action = function(ud) --unitData
               spEcho("**3** Returning Actions")
               local rp = ud.returnPos
               if rp.x then
                   spGiveOrderToUnit(ud.unitID, CMD_MOVE, { rp.x, rp.y, rp.z }, { "" })
                   --Spring.Echo("HARVESTER: Issued Command: MOVE")
                   return "returning"
               end
            end
    },
    [4] = { id="returned",
            condition = function(ud)
                local rp = ud.returnPos
                --Spring.Echo("*** returning dist: "..(sqrDistance(ud.pos.x, ud.pos.z, rp.x, rp.z) or "nil"))
                local hasReturned = rp and rp.x and (sqrDistance(ud.pos.x, ud.pos.z, rp.x, rp.z) <= 140)
                if (harvestState[ud.unitID] == "returning" and not hasReturned and spGetCommandQueue(ud.unitID, 0) < 1) then
                    local rp = harvesters[ud.unitID].returnPos
                    if rp and rp.x then
                        spGiveOrderToUnit(ud.unitID, CMD_MOVE, { rp.x, rp.y, rp.z }, { "" })
                    end
                end
                return harvestState[ud.unitID] == "returning" and hasReturned  -- distance to returnPos <= 40 (sqr)
            end,
            action = function(ud)
                spEcho("**4** Returned Actions")
                --local rp = harvesters[ud.unitID].returnPos
                --if rp.x then
                --    spGiveOrderToUnit(ud.unitID, CMD_MOVE, { rp.x, rp.y, rp.z }, { "" })
                --    --Spring.Echo("HARVESTER: Issued Command: MOVE")
                --    return "returned"
                --end
                return "returned"
            end
    },
    [5] = { id="attacking",
            condition = function(ud)
                        --Spring.Echo("has nearest chunk: "..(ud.nearestChunkID or "nil").." can harvest: "..tostring(canharvest[ud.unitDef.name]).." load perc: "..(harvesters[ud.unitID] and harvesters[ud.unitID].loadPercent or "nil"))
                        local nearestChunkID = getNearestChunkID(ud)
                        ud.nearestChunkID = nearestChunkID
                        return nearestChunkID and (harvestState[ud.unitID] == "idle" or harvestState[ud.unitID] == "returned")
                                and canharvest[ud.unitDef.name]
                                and (harvesters[ud.unitID].loadPercent ~= 1)
                        end,
            action = function(ud)
               spEcho("**5** Attacking actions - nearest chunk: "..(ud.nearestChunkID or "nil"))
               --local x, y, z = spGetUnitPosition(ud.nearestChunkID)
               spGiveOrderToUnit(ud.unitID, CMD_ATTACK, ud.nearestChunkID, { "alt" }) --"alt" favors reclaiming --Spring.Echo("Farking")
               harvesters[ud.unitID].targetChunkID = ud.nearestChunkID
               --Spring.Echo("HARVESTER: Issued Command: ATTACK")
               return "attacking"
            end
    },
    [6] = { id="idle",
            condition = function(ud) -- if full and no parent or nearby oreTower
                local nearestOreTowerID = getNearestOreTowerID(ud, oreTowers, oretowerShortScanRange)
                return (harvestState[ud.unitID] == "attacking" and
                            (   ud.targetChunkID == nil
                                or
                                (harvesters[ud.unitID].loadPercent >= 1 and (not ud.parentOreTowerID and not nearestOreTowerID))
                            )
                        )
                        or
                        (
                            (harvestState[ud.unitID] == "delivering" or harvestState[ud.unitID] == "unloading")
                            and (not ud.parentOreTowerID and not nearestOreTowerID )
                        )
            end,
            action = function(ud)
                spEcho("**6** Idle actions")
                harvesters[ud.unitID].parentOreTowerID = nil
                harvesters[ud.unitID].returnPos = nil
                --spGiveOrderToUnit(ud.unitID, CMD_STOP, {} , CMD_OPT_RIGHT )
                return "idle"
            end
    },
}

local function automateCheck(unitID, caller)
    if not unitID then
        return end
    local unitDef = harvesters[unitID].unitDef
    if not unitDef then
        --Spring.Echo("harvesters unitDef not found")
        return end
    local x, y, z = spGetUnitPosition(unitID)
    local pos = { x = x, y = y, z = z }

    local radius = unitDef.buildDistance * 1.8
    if unitDef.canFly then               -- Air units need that extra oomph
        radius = radius * 1.3
    end

    -- During automation we check if the parentOreTowerID was destroyed and update it accordingly
    --- TODO: Move to destroy() maybe? One less thing to do every automateCheck update..
    local parentOreTowerID = harvesters[unitID].parentOreTowerID
    if not parentOreTowerID or not IsValidUnit(parentOreTowerID) then
        local nearestOreTowerID = NearestItemAround(unitID, pos, unitDef, oretowerShortScanRange, nil,
            function(x) return (oreTowers and oreTowers[x] or nil) end)
        parentOreTowerID = nearestOreTowerID
    end

    local ud = { unitID = unitID, unitDef = unitDef, pos = pos, radius = radius, orderIssued = nil,
                 returnPos = harvesters[unitID].returnPos, targetChunkID = harvesters[unitID].targetChunkID,
                 parentOreTowerID = parentOreTowerID, harvestRange = harvesters[unitID].harvestRange,
               }

    -- Will try and (if condition succeeds) execute each automatedFunction, in order. #1 is highest priority, etc.
    for i = 1, #automatedFunctions do
        local autoFunc = automatedFunctions[i]
        if autoFunc.condition(ud) then
            ud.orderIssued = autoFunc.action(ud)
            break
        end
    end
    --- If any automation attempt above was successful, set new harvest state
    if ud.orderIssued then
        if ud.orderIssued == "idle" then
            --Spring.Echo ("Auto harvest:: Sending message: harvesterIdle_"..unitID)
            spSendLuaUIMsg("harvesterIdle_"..unitID, "allies") --(message, mode)
        end
        spEcho ("Auto harvest:: New order Issued: "..ud.orderIssued)
        --orphanHarvesters[unitID] = nil
        setHarvestState(unitID, ud.orderIssued, caller.."> automateCheck")
    end
    return ud.orderIssued
end



--function widget:CommandNotify(cmdID, params, options)
--    spEcho("CommandID registered: "..(cmdID or "nil"))
--    -- User commands are tracked here, check what unit(s) is/are selected and remove it from automatedUnits
--    local selUnits = spGetSelectedUnits()  --() -> { [1] = unitID, ... }
--    for _, unitID in ipairs(selUnits) do
--        if automatedHarvesters[unitID] then
--            local setToAttacking
--            if (cmdID == CMD_ATTACK or cmdID == CMD_UNIT_SET_TARGET) then
--                spEcho("CMD_ATTACK, params #: "..#params)
--                if #params == 1 then
--                    setHarvestState(unitID, "attacking", "CommandNotify")
--                    setToAttacking = true
--                end
--            end
--            if not setToAttacking then
--                setHarvestState(unitID, "idle", "CommandNotify") --"deautomated"
--            end
--        end
--    end
--end

--local function nearestOreTowerID(unitID)
--    local unitDef = UnitDefs[spGetUnitDefID(unitID)]
--    local x, y, z = spGetUnitPosition(unitID)
--    local pos = { x = x, y = y, z = z }
--    local nearestOreTowerID = NearestItemAround(unitID, pos, unitDef, maxOreTowerScanRange, nil,
--            function(x) return (oreTowers and oreTowers[x] or nil) end)
--    --Spring.Echo("Nearest Ore Tower: "..(nearestOreTowerID or "nil").."; loaded: "..tostring(loadedHarvesters[unitID]))
--    return nearestOreTowerID
--end

--- Frame-based Update
function widget:GameFrame(f)
    if f < startupGracetime then
        return
    end
    if f % updateRate < 0.001 then
        for harvesterID, data in pairs(harvesters) do
            local maxStorage = data.maxorestorage
            local curStorage = spGetUnitHarvestStorage(harvesterID) or 0
            harvesters[harvesterID].loadPercent = math_clamp(curStorage/maxStorage, 0, 1)
            --Spring.Echo("Harvester id: "..harvesterID.." state: "..automatedState[harvesterID].." recheckFrame: "..data.recheckFrame.." this Frame: "..f)
            if automatedState[harvesterID] == "harvest" and f >= data.recheckFrame then
                --- Check/Update harvest Automation
                --local unitDef = UnitDefs[spGetUnitDefID(harvesterID)]
                automateCheck(harvesterID, "harvesters")
                -- Queue up the next automation test
                harvesters[harvesterID].recheckFrame = spGetGameFrame() + recheckLatency
            end
        end
    end
    --- TODO: Orphans processing
    --- load < maxload & has no parentOretower
    --- => Find nearest ore tower and set parentOretower, new returnPos to it
    --- => Attack nearest ore Chunk
end

----From unitai_auto_assist or eco_ore_manager: Spring.SendLuaRulesMsg("msgKey_"..value, "allies")
function widget:RecvLuaMsg(msg, playerID)
    --if not playerID == myTeamID then
    --    return end
    --Spring.Echo("Message Received: "..msg)
    local data = Split(msg, '_')
    if data[1] == 'unitDeautomated' then
        local unitID = tonumber(data[2])
        --Spring.Echo("Harvester To Deautomate: "..(unitID or "nil"))
        if unitID and harvesters[unitID] then
            setHarvestState(unitID, "idle", "RcvLuaMsg")
            --harvestersToAutomate[unitID] = true
        end
    end
    ----spSendLuaUIMsg("harvesterAttack_"..ud.unitID.."_"..ud.nearestChunkID, "allies") --(message, mode)
    --if data[1] == 'harvesterAttack' then
    --    local unitID = tonumber(data[2])
    --    local nearestChunkID = tonumber(data[3])
    --    --Spring.Echo("Harvester To Attack: "..(unitID or "nil"))
    --    if unitID then
    --        setHarvestState(unitID, "attacking", "RcvLuaMsg")
    --        spGiveOrderToUnit(unitID, CMD_ATTACK, nearestChunkID, { "alt" })
    --        Spring.Echo("HARVESTER: Received message: ATTACK")
    --    end
    --end
    --chunkDestroyed_
    if data[1] == 'chunkDestroyed' then
        local thisChunkID = tonumber(data[2])
        --Spring.Echo("Chunk destroyed message received: "..(thisChunkID or "nil"))
        if thisChunkID then
            for harvesterID, data in pairs(harvesters) do
                if data.targetChunkID == thisChunkID then
                    harvesters[harvesterID].targetChunkID = nil
                    --local unitDef = UnitDefs[spGetUnitDefID(harvesterID)]
                    --automateCheck(harvesterID, "chunkDestroyed") --not needed
                end
            end
        end
    end

end

---- Initialize the unit when received (shared)
function widget:UnitGiven(unitID, unitDefID, unitTeam)
    widget:UnitFinished(unitID, unitDefID, unitTeam)
end

function widget:UnitTaken(unitID, unitDefID, oldTeamID, teamID)
    widget:UnitDestroyed(unitID, unitDefID, oldTeamID)
end

function widget:ViewResize(n_vsx,n_vsy)
    vsx, vsy = glGetViewSizes()
    widgetScale = (0.50 + (vsx*vsy / 5000000))
end