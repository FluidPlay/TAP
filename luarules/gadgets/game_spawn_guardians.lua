function gadget:GetInfo()
    return {
        name      = "Spawn Guardians",
        desc      = "Control spawning of alien guardians on top of ore spots",
        author    = "MaDDoX",
        date      = "May 2023",
        license   = "GNU GPL, v2 or later",
        layer     = 50,
        enabled   = true,
    }
end

if not gadgetHandler:IsSyncedCode() then
    return end

-----------------
---- SYNCED
-----------------

GG.Guardians = {}

VFS.Include("gamedata/taptools.lua")

local gaiaTeamID

local initialized

local spGetAllFeatures = Spring.GetAllFeatures
--local spGetGameFrame = Spring.GetGameFrame
local spGetUnitPosition = Spring.GetUnitPosition
local spGetUnitRulesParam = Spring.GetUnitRulesParam
local spSetUnitRulesParam = Spring.SetUnitRulesParam
local spCreateUnit = Spring.CreateUnit
local spSetUnitNeutral = Spring.SetUnitNeutral
local spSetUnitRotation = Spring.SetUnitRotation
local spGiveOrderToUnit = Spring.GiveOrderToUnit
local spGetAllUnits	= Spring.GetAllUnits
local spGetUnitDefID = Spring.GetUnitDefID
local spGetUnitTeam = Spring.GetUnitTeam
local spValidUnitID = Spring.ValidUnitID
local spGetGameFrame = Spring.GetGameFrame

local CMD_EZ_MORPH = 31337

local isHQ = {}  -- { unitID = true, ... }  -- TODO: Support HQs created after initial spawn

local guardian = { sml = {id = UnitDefNames["guardsml"].id},   --TODO: add minSpawnDistance, per type
              med = {id = UnitDefNames["guardmed"].id},
              lrg = {id = UnitDefNames["guardlrg"].id},
              uber = {id = UnitDefNames["guarduber"].id} }

--local guardianUnitDefId = UnitDefNames["guardsml"].id -- guardian.sml.id

local spawnType = { [1] = "sml",    -- 0 mins
                    [2] = "sml",    -- 5 mins
                    [3] = "sml",    -- 10 mins
                    [4] = "med",    -- 15 mins
                    [5] = "med",    -- 20 mins
                    [6] = "lrg",    -- 25 mins
                    [7] = "lrg",    -- 30 mins
                    [8] = "uber",   -- 35 mins onwards
}

local morphChance = {   [1] = 0.25,    -- 25%     -- key == #guardians assigned to spot
                        [2] = 0.5,    -- 50%
                        [3] = 0.75,    -- 75%
                        [4] = 1.0,    -- 100%
}

-- Reverse access table, to find the lowest level (for guardian timely morphs)
local spawnTypeLevel = { ["sml"] = 1, ["med"] = 2, ["lrg"] = 3, ["uber"] = 4}

local currentIter = 1   -- This will be increased by 1 every spawn
local maxLevel = "uber"     -- Will use this if spawnType index fail (greater than 7, initially)

local guardians = {}        -- { [unitID]={x,y,z,spotIdx}, ... }
local teamStartPos = {}    -- { [teamID] = { x=x, y=y, z=z }, ... }
local minGuardianDistance = 50    -- This prevents duplicated objects
local minStartposDistance = 600   -- Prevents guardians from being spawned near start Positions
local maxGuardiansPerSpot = 3
local maxTier = 4                 -- maximum Guardian tier (1..4)

--local updateRate = 30*60        -- test: 10s ; Guardian spawning frequency (every 4 minutes)
local updateRate = 30*60*5 --2    -- Guardian spot-reinforcement frequency, either spawn or morph (every 5 minutes)

local cmdFly = 145
local cmdAirRepairLevel = CMD.AUTOREPAIRLEVEL
local nextFrameUnitSetup = {}

local oreSpots = {} -- { 1 = { chunks = { unitID = { pos = {x, y}, kind, spotIdx, idxInSpot }, ...},
                    --         hostedGuardians = { unitID = { pos = {x, y}, level }, ...},
                    --    }
--TODO:    sprawlLevel = 1..5,   //1 = no Sprawler; 2 = basic Sprawler, 3 = large, 4 = moho, 5 = mantle
--       }, ...
-- }

local function istable(var)
    return type(var) == "table" end

local function sqr (x)
    return math.pow(x, 2)
end

local function distance (x1, y1, z1, x2, y2, z2 )
    return math.sqrt(sqr(x2-x1) + sqr(y2-y1) + sqr(z2-z1))
end

local function guardianNearby(x, y, z)
    if x == nil or y == nil or z == nil then
        return false end
    for _, data in pairs(guardians) do
        if distance(data.x, data.y, data.z, x, y, z) < 200 then
            return true
        end
    end
    return false
end

local function guardianNearbyInit(x, y, z)
    if x == nil or y == nil or z == nil then
        return false end
    for _, data in pairs(guardians) do
        if distance(data.x, data.y, data.z, x, y, z) < minGuardianDistance then
            return true
        end
    end
    return false
end

local function addGuardianToSpot(guardianUID, spotIdx, pos, guardianLevel)
    local hostedGuardians = oreSpots[spotIdx].hostedGuardians
    if not hostedGuardians then
        oreSpots[spotIdx].hostedGuardians = {}
    end
    (oreSpots[spotIdx].hostedGuardians)[guardianUID] = { pos=pos, level=guardianLevel }

    spSetUnitRotation(guardianUID,0,math.random()*85,0)            -- N + 0~85 degress (N,S,E,W)
    spGiveOrderToUnit(guardianUID, cmdFly, { 0 }, {})
    spGiveOrderToUnit(guardianUID, cmdAirRepairLevel, { 0 }, {})    -- don't land for anything!
end

local function addGuardian(x, y, z, iter, spotIdx)
    local guardianType = spawnType[iter]
    if not guardianType then
        guardianType = maxLevel end

    local guardianLevel = spawnTypeLevel[guardianType]
    if not guardianLevel then
        guardianLevel = 0
    end

    --Spring.Echo("Guardian type: "..(guardianType or "nil").." || Iter: "..(tostring(iter) or "nil"))
    local guardianUnitDefId = guardian[guardianType].id
    local guardianUID = spCreateUnit(guardianUnitDefId, x, y, z, 0, gaiaTeamID)

    --Store info for further processing
    spSetUnitRulesParam(guardianUID, "hotSpotIdx", tostring(spotIdx))
    spSetUnitRulesParam(guardianUID, "guardPosX", tostring(x))
    spSetUnitRulesParam(guardianUID, "guardPosY", tostring(y))
    spSetUnitRulesParam(guardianUID, "guardPosZ", tostring(z))

    guardians[guardianUID]={ x=x, y=y, z=z, spotIdx=spotIdx }

    --if not istable(oreSpots[id].guardians) then
    --    oreSpots[id].guardians = {} end
    --
    --table.insert(oreSpots[id].guardians, guardianUID)
    --table.insert(oreSpots[spotIdx].hostedGuardians, { id = guardianUID, pos = {x=x, z=z}, level=guardianLevel })

    addGuardianToSpot(guardianUID, spotIdx, { x = x, y = y, z = z}, guardianLevel)

    return guardianUID
end

function gadget:Initialize()
    gaiaTeamID = Spring.GetGaiaTeamID()
    oreSpots = GG.metalSpots  -- Set by mex_spot_finder.lua
    GG.Guardians = guardians  -- used by unit_avoidshootingguardians.lua
    if not istable(oreSpots) then
        Spring.Echo("Warning: GG.metalSpots not found by game_spawn_guardians.lua!")
        oreSpots = {}
    end
end

function gadget:UnitFinished(unitID, unitDefID, unitTeam)
    if not unitID or not spValidUnitID(unitID) then
        return end

    local unitDef = unitDefID and UnitDefs[unitDefID] or nil
    if unitDef and unitDef.customParams then
        if unitDef.customParams.ishq then
            local x, y, z = spGetUnitPosition(unitID)
            isHQ[unitID] = { x=x, y=y, z=z }
        end
        if unitDef.customParams.tedclass == "guardian" then
            nextFrameUnitSetup[unitID] = { frame = spGetGameFrame() + 1, unitDef = unitDef }
        end
    end
end

local function unitFinishedSetup(unitID, unitDef)
    if unitDef and unitDef.customParams then
        if unitDef.customParams.ishq then
            local x, y, z = spGetUnitPosition(unitID)
            isHQ[unitID] = { x=x, y=y, z=z }
        end
        -- This is stored in a Guardian, so the system may assign the spot Idx after morph
        --Spring.GetUnitRulesParam ( number unitID, number index | string ruleName )
        local hotSpotIdx = spGetUnitRulesParam(unitID, "hotSpotIdx")
        if hotSpotIdx then
            hotSpotIdx = tonumber(hotSpotIdx)
            local x = tonumber(spGetUnitRulesParam(unitID, "guardPosX"))
            local y = tonumber(spGetUnitRulesParam(unitID, "guardPosY"))
            local z = tonumber(spGetUnitRulesParam(unitID, "guardPosZ"))
            local guardianLevel = isnumber(unitDef.customParams.tier) and tonumber(unitDef.customParams.tier) or 1
            addGuardianToSpot(unitID, hotSpotIdx, {x = x, y = y, z = z}, guardianLevel)
        end
    end
end

local function cleanupGuardianData(guardianUID)
    -- guardians = { [unitID]={x,y,z,spotIdx}, ... }
    local data = guardians[guardianUID]
    if not istable(data) or not istable(oreSpots[data.spotIdx]) then
        return end
    --Spring.Echo("Removing guardian: "..(guardianUID or "nil").." from spot idx: "..(tostring(data.spotIdx) or "nil"))
    local hostedGuardiansInSpot = oreSpots[data.spotIdx].hostedGuardians
    hostedGuardiansInSpot[guardianUID] = nil
    if tablelength(hostedGuardiansInSpot) == 0 then
        oreSpots[data.spotIdx].allowGuardians = false end
end

function gadget:GameFrame(frame)
    --- Initial Spawn
    if frame == 0 then
        for id, data in ipairs(oreSpots) do
            local x, y, z = data.x, data.y, data.z
            local doSpawnHere = true
            for _, hqp in pairs(isHQ) do
                if distance(x, y, z, hqp.x, hqp.y, hqp.z) < minStartposDistance then
                    doSpawnHere = false
                    break
                end
            end
            if doSpawnHere and not guardianNearbyInit(x,y,z) then
                oreSpots[id].allowGuardians = true
                addGuardian(x,y,z, 1, id)
                --local newGuardianUID = ...
                --addGuardianToSpot(newGuardianUID, id)
                --oreSpots[id].guardians = spawnGuardian(x,y,z, 1, id)
            end
        end
		return
    end

    --- Next-frame unit setup (after morph); we add a startup delay to prevent any issues with starting guardians
    if frame > 10 then
        --nextFrameUnitSetup[unitID] = { frame = spGetGameFrame() + 1, unitDefID=unitDefID, unitDef = unitDef }
        for unitID, v in pairs(nextFrameUnitSetup) do
            if v.frame >= frame then
                unitFinishedSetup(unitID, v.unitDef)
                nextFrameUnitSetup[unitID] = nil
            end
        end
    end

    --- Timely Spawn / Morph of Guardians
    if frame % updateRate > 0.001 then
        return end
    currentIter = currentIter + 1
    for id, data in ipairs(oreSpots) do
        local numGuardians = istable(data.hostedGuardians) and tablelength(data.hostedGuardians) or 0
        if not data.hostedGuardians then
            data.hostedGuardians = {}
        end
        -- assert that the field hasn't been cleared of Guardians already, and it ain't reached max capacity
        if data.allowGuardians and numGuardians <= maxGuardiansPerSpot then
            local sx, sy, sz = data.x, data.y, data.z   -- spot center's x,y,z
            local doSpawnHere = true
            for _, hqp in pairs(isHQ) do
                if distance(sx, sy, sz, hqp.x, hqp.y, hqp.z) < minStartposDistance then
                    doSpawnHere = false
                    break
                end
            end
            local angle = math.random() * math.pi*2
            local radius = 40
            local x = math.cos(angle)*radius
            local z = math.sin(angle)*radius
            if doSpawnHere then
                local morphInteadOfSpawn = math.random() < morphChance[numGuardians]
                if morphInteadOfSpawn then
                    -- Pick first one, for now. Will be the first 'lowest tier' one
                    local hostedGuardians = data.hostedGuardians
                    if istable(hostedGuardians) then
                        local lowestTierFound = maxTier       -- starts with max, can only go down
                        local lowestTierGuardian = nil
                        for guardianUID, data in pairs(hostedGuardians) do
                            if data.level < lowestTierFound then
                                lowestTierFound = data.level
                                lowestTierGuardian = guardianUID
                            end
                        end
                        -- Won't try morphing after max tier was already reached
                        if IsValidUnit(lowestTierGuardian) and lowestTierFound < maxTier then
                            spGiveOrderToUnit(lowestTierGuardian, CMD_EZ_MORPH, {}, { "" }) end
                    end
                else
                    addGuardian(sx+x, sy,sz+z, currentIter, id)
                    --local newGuardianUID =
                    --addGuardianToSpot(newGuardianUID, id)
                end
            end --, data.spotIdx) end
        end
    end
end

function gadget:UnitDestroyed(unitID)
    if guardians[unitID] then
        cleanupGuardianData(unitID)
    --    local x,y,z = spGetUnitPosition(unitID)
    --    if not guardianNearby(x, y, z) then
    --        local id = guardians[unitID].spotIdx
    --        oreSpots[id].allowGuardians = nil
    --    end
    --    guardians[unitID] = nil
    end
    isHQ[unitID] = nil
end

-- Called when a unit is "taken" from a team. This is called before UnitGiven and in that moment unit is still assigned to the oldTeam.
function gadget:UnitTaken(unitID, unitDefID, oldTeam, newTeam)
    gadget:UnitDestroyed(unitID)
end

-- Called when a unit is "received" in a team. This is called after UnitTaken and in that moment unit is assigned to the newTeam.
function gadget:UnitGiven(unitID, unitDefID, newTeam, oldTeam)
    gadget:UnitFinished(unitID, unitDefID, newTeam)
end



-- That's just a temp function to offset features from the 'coast to coast dry x map'. Could be useful for some others
--function temp()
--    local objectlist = {{ name = "ad0_senegal_4", x = 5211, z = 1324, rot = 24532 },
--                        { name = "ad0_senegal_5_large", x = 42, z = 2050, rot = -1058 },
--                        { name = "cycas4", x = 1004, z = 2648, rot = 2673 },
--                        { name = "ad0_senegal_1", x = 665, z = 645, rot = 24856 },
--                        { name = "ad0_senegal_2", x = 5868, z = 4063, rot = 4751 },
--                        { name = "ad0_senegal_1_large", x = 95, z = 758, rot = -27559 },
--                        { name = "ad0_senegal_3_large", x = 18, z = 1963, rot = 18238 },
--                        { name = "cycas4", x = 281, z = 382, rot = -26752 },
--                        { name = "ad0_senegal_7_large", x = 605, z = 663, rot = -26271 },
--                        { name = "ad0_senegal_5_large", x = 5930, z = 4025, rot = 8576 },
--                        { name = "ad0_senegal_3", x = 22, z = 820, rot = 5320 },
--                        { name = "ad0_senegal_2", x = 5869, z = 18, rot = -12214 },
--                        { name = "cycas5", x = 472, z = 2179, rot = -25957 },
--                        { name = "ad0_senegal_7_large", x = 78, z = 3929, rot = -5107 },
--                        { name = "ad0_senegal_7", x = 6108, z = 4038, rot = 19654 },
--                        { name = "ad0_senegal_3_large", x = 225, z = 463, rot = 21354 },
--                        { name = "ad0_senegal_2", x = 17, z = 2132, rot = 14334 },
--                        { name = "cycas3", x = 342, z = 247, rot = -24007 },
--                        { name = "ad0_senegal_4", x = 12, z = 2237, rot = -16452 },
--                        { name = "cycas7", x = 4662, z = 34, rot = -28378 },
--                        { name = "cycas4", x = 77, z = 822, rot = -29668 },
--                        { name = "ad0_senegal_1", x = 5212, z = 1440, rot = -14190 },
--                        { name = "ad0_senegal_7", x = 5722, z = 3437, rot = 26625 },
--                        { name = "ad0_senegal_4", x = 6070, z = 4059, rot = -1633 },
--                        { name = "ad0_senegal_5_large", x = 5798, z = 3612, rot = 8061 },
--                        { name = "cycas4", x = 6102, z = 1873, rot = -22863 },
--                        { name = "cycas5", x = 6034, z = 993, rot = -24683 },
--                        { name = "cycas2", x = 1296, z = 3200, rot = 5845 },
--                        { name = "ad0_senegal_6", x = 5590, z = 958, rot = -568 },
--                        { name = "ad0_senegal_2", x = 5912, z = 3954, rot = -21345 },
--                        { name = "ad0_senegal_6_large", x = 1022, z = 2619, rot = -30907 },
--                        { name = "ad0_senegal_6_large", x = 246, z = 307, rot = -17944 },
--                        { name = "ad0_senegal_1", x = 5779, z = 1551, rot = -11203 },
--                        { name = "ad0_senegal_4_large", x = 6112, z = 2869, rot = 13778 },
--                        { name = "ad0_senegal_2_large", x = 499, z = 2334, rot = -27755 },
--                        { name = "cycas3", x = 6112, z = 2045, rot = -18182 },
--                        { name = "cycas5", x = 6096, z = 1937, rot = 9507 },
--                        { name = "ad0_senegal_2_large", x = 626, z = 60, rot = 1633 },
--                        { name = "ad0_senegal_2_large", x = 136, z = 4032, rot = -8905 },
--                        { name = "ad0_senegal_2", x = 182, z = 3961, rot = 16955 },
--                        { name = "ad0_senegal_6_large", x = 1223, z = 4026, rot = -16003 },
--                        { name = "ad0_senegal_5_large", x = 564, z = 33, rot = 14319 },
--                        { name = "ad0_senegal_1_large", x = 688, z = 56, rot = -10478 },
--                        { name = "ad0_senegal_6", x = 1092, z = 3545, rot = -19627 },
--                        { name = "ad0_senegal_7", x = 5809, z = 1525, rot = -7444 },
--                        { name = "ad0_senegal_1", x = 1317, z = 3186, rot = -14881 },
--                        { name = "ad0_senegal_5_large", x = 1052, z = 2659, rot = 3457 },
--                        { name = "cycas7", x = 32, z = 3231, rot = -13785 },
--                        { name = "cycas7", x = 6124, z = 2055, rot = -8567 },
--                        { name = "cycas2", x = 1087, z = 3542, rot = 20517 },
--                        { name = "ad0_senegal_1_large", x = 425, z = 2846, rot = 24093 },
--                        { name = "ad0_senegal_6_large", x = 4773, z = 728, rot = 3423 },
--                        { name = "ad0_senegal_1", x = 1107, z = 3584, rot = 12652 },
--                        { name = "ad0_senegal_4", x = 9, z = 1914, rot = 5034 },
--                        { name = "ad0_senegal_5", x = 5129, z = 1324, rot = -6165 },
--                        { name = "cycas4", x = 4793, z = 728, rot = 12019 },
--                        { name = "ad0_senegal_2_large", x = 27, z = 3024, rot = -10142 },
--                        { name = "ad0_senegal_3", x = 5864, z = 60, rot = 30473 },
--                        { name = "cycas4", x = 5885, z = 3972, rot = -4183 },
--                        { name = "ad0_senegal_3", x = 46, z = 3987, rot = -15842 },
--                        { name = "cycas4", x = 24, z = 3177, rot = -24504 },
--                        { name = "cycas3", x = 418, z = 2913, rot = -24038 },
--                        { name = "cycas4", x = 241, z = 4004, rot = 21325 },
--                        { name = "ad0_senegal_2", x = 5841, z = 3923, rot = 25478 },
--                        { name = "ad0_senegal_1_large", x = 428, z = 2261, rot = 3014 },
--                        { name = "ad0_senegal_6", x = 64, z = 804, rot = -28035 },
--                        { name = "cycas4", x = 5127, z = 1369, rot = 9619 },
--                        { name = "ad0_senegal_4", x = 618, z = 704, rot = 27824 },
--                        { name = "ad0_senegal_7_large", x = 1111, z = 2706, rot = 6854 },
--                        { name = "ad0_senegal_5", x = 477, z = 2360, rot = -13156 },
--                        { name = "cycas7", x = 5977, z = 4055, rot = -18506 },
--                        { name = "cycas2", x = 5707, z = 3372, rot = 13886 },
--                        { name = "ad0_senegal_3", x = 5611, z = 863, rot = -23742 },
--                        { name = "cycas3", x = 81, z = 2080, rot = -1946 },
--                        { name = "ad0_senegal_6", x = 447, z = 2819, rot = 15429 },
--                        { name = "ad0_senegal_4_large", x = 256, z = 277, rot = -28473 },
--                        { name = "cycas4", x = 6116, z = 1096, rot = 4357 },
--                        { name = "ad0_senegal_6", x = 5901, z = 92, rot = -24768 },
--                        { name = "ad0_senegal_5_large", x = 56, z = 1838, rot = 8506 },
--                        { name = "cycas5", x = 5541, z = 773, rot = 26059 },
--                        { name = "ad0_senegal_5_large", x = 5795, z = 4056, rot = 25990 },
--                        { name = "ad0_senegal_3_large", x = 289, z = 320, rot = 25650 },
--                        { name = "ad0_senegal_7", x = 6117, z = 2004, rot = -24043 },
--                        { name = "ad0_senegal_2", x = 30, z = 1918, rot = -22175 },
--                        { name = "ad0_senegal_1_large", x = 5075, z = 1293, rot = 4104 },
--                        { name = "ad0_senegal_5_large", x = 1094, z = 3560, rot = 2132 },
--                        { name = "ad0_senegal_3", x = 54, z = 3922, rot = -26773 },
--                        { name = "ad0_senegal_2_large", x = 662, z = 724, rot = 19859 },
--                        { name = "ad0_senegal_5", x = 235, z = 329, rot = 13702 },
--                        { name = "cycas4", x = 4805, z = 696, rot = 1743 },
--                        { name = "cycas7", x = 26, z = 1718, rot = 29225 },
--                        { name = "ad0_senegal_1_large", x = 480, z = 2947, rot = 23716 },
--                        { name = "ad0_senegal_5_large", x = 525, z = 2334, rot = -24675 },
--                        { name = "cycas4", x = 544, z = 74, rot = 12517 },
--                        { name = "ad0_senegal_5_large", x = 573, z = 774, rot = 871 },
--                        { name = "ad0_senegal_5_large", x = 4778, z = 708, rot = -23724 },
--                        { name = "ad0_senegal_1_large", x = 6028, z = 4066, rot = -22590 },
--                        { name = "ad0_senegal_6", x = 5901, z = 4011, rot = -8543 },
--                        { name = "ad0_senegal_5_large", x = 5815, z = 3902, rot = -19249 },
--                        { name = "cycas2", x = 5765, z = 3490, rot = -25046 },
--                        { name = "ad0_senegal_7_large", x = 1111, z = 3547, rot = -12212 },
--                        { name = "ad0_senegal_3_large", x = 6142, z = 979, rot = -29740 },
--                        { name = "cycas4", x = 5927, z = 4028, rot = 4753 },
--                        { name = "ad0_senegal_4_large", x = 1059, z = 2688, rot = -13299 },
--                        { name = "ad0_senegal_4_large", x = 6022, z = 4044, rot = 22440 },
--                        { name = "cycas4", x = 5854, z = 3578, rot = 2438 },
--                        { name = "cycas5", x = 30, z = 1832, rot = -19053 },
--                        { name = "cycas3", x = 5783, z = 1566, rot = -28272 },
--                        { name = "cycas3", x = 5884, z = 121, rot = -13445 },
--                        { name = "ad0_senegal_4_large", x = 1201, z = 4054, rot = 13736 },
--                        { name = "ad0_senegal_6_large", x = 1255, z = 4032, rot = -6028 },
--                        { name = "ad0_senegal_5", x = 433, z = 2994, rot = -30509 },
--                        { name = "cycas5", x = 5588, z = 823, rot = 8669 },
--                        { name = "cycas5", x = 6052, z = 972, rot = -7289 },
--                        { name = "ad0_senegal_2", x = 4795, z = 700, rot = 25707 },
--                        { name = "ad0_senegal_2_large", x = 92, z = 2021, rot = 29996 },
--                        { name = "ad0_senegal_6", x = 4744, z = 15, rot = 26938 },
--                        { name = "ad0_senegal_1_large", x = 5041, z = 1254, rot = 28075 },
--                        { name = "cycas5", x = 4701, z = 49, rot = 23931 },
--                        { name = "ad0_senegal_3", x = 5742, z = 3401, rot = -25234 },
--                        { name = "ad0_senegal_5_large", x = 402, z = 2795, rot = 29527 },
--                        { name = "ad0_senegal_6_large", x = 1108, z = 3525, rot = 20990 },
--                        { name = "cycas3", x = 459, z = 2872, rot = 30063 },
--                        { name = "ad0_senegal_4", x = 6124, z = 1034, rot = 17732 },
--                        { name = "ad0_senegal_1", x = 5801, z = 1600, rot = 19558 },
--                        { name = "ad0_senegal_6", x = 6125, z = 2000, rot = 26229 },
--                        { name = "ad0_senegal_2_large", x = 60, z = 2121, rot = -129 },
--                        { name = "cycas3", x = 1289, z = 3198, rot = 17479 },
--                        { name = "ad0_senegal_1", x = 6088, z = 1922, rot = -29551 },
--                        { name = "ad0_senegal_1", x = 5749, z = 1609, rot = 14423 },
--                        { name = "ad0_senegal_5", x = 5947, z = 222, rot = 3346 },
--                        { name = "cycas3", x = 585, z = 23, rot = -16716 },
--                        { name = "ad0_senegal_5", x = 5197, z = 1396, rot = 31566 },
--                        { name = "cycas4", x = 4790, z = 686, rot = 15432 },
--                        { name = "ad0_senegal_3_large", x = 589, z = 38, rot = -27295 },
--                        { name = "ad0_senegal_4_large", x = 5150, z = 1379, rot = -20195 },
--                        { name = "ad0_senegal_1", x = 1184, z = 4056, rot = -30562 },
--                        { name = "ad0_senegal_6", x = 6107, z = 1960, rot = 19003 },
--                        { name = "ad0_senegal_1", x = 48, z = 3775, rot = 21272 },
--                        { name = "ad0_senegal_4", x = 48, z = 3070, rot = -11301 },
--                        { name = "ad0_senegal_3_large", x = 452, z = 2269, rot = -16059 },
--                        { name = "ad0_senegal_3", x = 5576, z = 743, rot = 20063 },
--                        { name = "cycas4", x = 4742, z = 62, rot = 27104 },
--                        { name = "ad0_senegal_7_large", x = 1153, z = 2773, rot = -14245 },
--                        { name = "ad0_senegal_4_large", x = 36, z = 2970, rot = 28049 },
--                        { name = "ad0_senegal_4_large", x = 6112, z = 2765, rot = -12931 },
--                        { name = "ad0_senegal_2_large", x = 416, z = 2773, rot = -8789 },
--                        { name = "cycas2", x = 557, z = 2375, rot = -23384 },
--                        { name = "ad0_senegal_2_large", x = 5983, z = 4047, rot = -966 },
--                        { name = "ad0_senegal_1", x = 87, z = 771, rot = 10062 },
--                        { name = "ad0_senegal_3_large", x = 5760, z = 1489, rot = 20544 },
--                        { name = "ad0_senegal_4", x = 42, z = 3072, rot = 1206 },
--                        { name = "ad0_senegal_5_large", x = 5572, z = 789, rot = -9276 },
--                        { name = "ad0_senegal_5_large", x = 6046, z = 1076, rot = 21382 },
--                        { name = "cycas5", x = 5772, z = 1422, rot = -29864 },
--                        { name = "ad0_senegal_2", x = 5741, z = 3426, rot = -6153 },
--                        { name = "cycas3", x = 6074, z = 2876, rot = -24313 },
--                        { name = "ad0_senegal_5_large", x = 641, z = 645, rot = 31564 },
--                        { name = "ad0_senegal_4", x = 231, z = 309, rot = -16903 },
--                        { name = "ad0_senegal_3_large", x = 30, z = 3080, rot = 6803 },
--                        { name = "cycas2", x = 6050, z = 2869, rot = -31742 },
--                        { name = "cycas2", x = 5813, z = 1486, rot = 29221 },
--                        { name = "ad0_senegal_3", x = 623, z = 13, rot = 10126 },
--                        { name = "ad0_senegal_4_large", x = 5764, z = 3329, rot = -16890 },
--                        { name = "ad0_senegal_2", x = 6087, z = 2825, rot = -11042 },
--                        { name = "ad0_senegal_2", x = 1123, z = 2705, rot = -15038 },
--                        { name = "ad0_senegal_7_large", x = 4785, z = 642, rot = -25417 },
--                        { name = "ad0_senegal_6_large", x = 275, z = 290, rot = 2119 },
--                        { name = "ad0_senegal_4", x = 5863, z = 4021, rot = -17977 },
--                        { name = "cycas2", x = 5187, z = 1341, rot = 12127 },
--                        { name = "ad0_senegal_7_large", x = 5854, z = 3610, rot = 29578 },
--                        { name = "cycas2", x = 63, z = 1976, rot = -14390 },
--                        { name = "ad0_senegal_1", x = 6071, z = 1096, rot = 13198 },
--                        { name = "ad0_senegal_3_large", x = 590, z = 2413, rot = -29885 },
--                        { name = "ad0_senegal_2", x = 70, z = 3118, rot = 26676 },
--                        { name = "ad0_senegal_7_large", x = 5582, z = 881, rot = -8663 },
--                        { name = "cycas3", x = 33, z = 3125, rot = -30576 },
--                        { name = "cycas4", x = 453, z = 2797, rot = 10779 },
--                        { name = "ad0_senegal_7", x = 5547, z = 744, rot = 27382 },
--                        { name = "ad0_senegal_1_large", x = 201, z = 4035, rot = 27495 },
--                        { name = "ad0_senegal_1", x = 1323, z = 3210, rot = -4114 },
--                        { name = "ad0_senegal_7_large", x = 4647, z = 15, rot = -27361 },
--                        { name = "cycas2", x = 5592, z = 774, rot = -2251 },
--                        { name = "ad0_senegal_3_large", x = 58, z = 1901, rot = 12802 },
--                        { name = "ad0_senegal_6", x = 1076, z = 2711, rot = -8325 },
--                        { name = "ad0_senegal_1", x = 674, z = 29, rot = -17550 },
--                        { name = "ad0_senegal_6_large", x = 6088, z = 986, rot = 21069 },
--                        { name = "cycas2", x = 92, z = 1870, rot = 13169 },
--                        { name = "ad0_senegal_5_large", x = 1165, z = 4027, rot = -24137 },
--                        { name = "cycas3", x = 124, z = 3828, rot = -23136 },
--                        { name = "ad0_senegal_2", x = 6089, z = 2769, rot = 12773 },
--                        { name = "ad0_senegal_3_large", x = 603, z = 663, rot = 2402 },
--                        { name = "cycas5", x = 46, z = 2102, rot = 21972 },
--                        { name = "ad0_senegal_4_large", x = 5083, z = 1384, rot = 537 },
--                        { name = "ad0_senegal_6_large", x = 5513, z = 764, rot = 17955 },
--                        { name = "ad0_senegal_5_large", x = 99, z = 763, rot = 21941 },
--                        { name = "ad0_senegal_6_large", x = 5821, z = 4001, rot = 11786 },
--                        { name = "ad0_senegal_4_large", x = 83, z = 905, rot = -15074 },
--                        { name = "cycas3", x = 46, z = 771, rot = -8699 },
--                        { name = "cycas5", x = 6072, z = 4075, rot = 2364 },
--                        { name = "ad0_senegal_7", x = 5835, z = 96, rot = -26366 },
--                        { name = "ad0_senegal_2_large", x = 6075, z = 2739, rot = -31658 },
--                        { name = "ad0_senegal_6", x = 15, z = 3108, rot = 29117 },
--                        { name = "cycas5", x = 1305, z = 3223, rot = -13383 },
--                        { name = "ad0_senegal_2_large", x = 6105, z = 1137, rot = -26360 },
--                        { name = "ad0_senegal_4_large", x = 605, z = 764, rot = 16766 },
--                        { name = "cycas7", x = 5561, z = 827, rot = -11406 },
--                        { name = "ad0_senegal_1", x = 5731, z = 3488, rot = 8154 },
--                        { name = "ad0_senegal_3_large", x = 466, z = 2905, rot = 21197 },
--                        { name = "cycas5", x = 4538, z = 10, rot = 16097 },
--                        { name = "ad0_senegal_2_large", x = 42, z = 3150, rot = 21674 },
--                        { name = "ad0_senegal_2", x = 4808, z = 771, rot = -4563 },
--                        { name = "ad0_senegal_1", x = 1154, z = 3548, rot = -16593 },
--                        { name = "ad0_senegal_6", x = 6112, z = 2743, rot = -10401 },
--                        { name = "ad0_senegal_6_large", x = 5820, z = 3550, rot = 22255 },
--                        { name = "ad0_senegal_2_large", x = 6123, z = 1069, rot = -2825 },
--                        { name = "ad0_senegal_1", x = 5845, z = 25, rot = -2613 },
--                        { name = "cycas2", x = 5747, z = 1595, rot = 21609 },
--                        { name = "ad0_senegal_2", x = 5, z = 2080, rot = -28831 },
--                        { name = "cycas3", x = 6089, z = 1009, rot = -31385 },
--                        { name = "cycas5", x = 6114, z = 4073, rot = 24128 },
--                        { name = "cycas4", x = 1104, z = 2726, rot = 11999 },
--                        { name = "ad0_senegal_6", x = 32, z = 3118, rot = 22775 },
--                        { name = "ad0_senegal_1", x = 6113, z = 1922, rot = -5099 },
--                        { name = "cycas7", x = 5797, z = 3569, rot = -10094 },
--                        { name = "ad0_senegal_4_large", x = 4607, z = 23, rot = 19522 },
--                        { name = "ad0_senegal_1", x = 6109, z = 4035, rot = 20684 },
--                        { name = "cycas5", x = 4753, z = 674, rot = 16608 },
--                        { name = "ad0_senegal_7_large", x = 5167, z = 1416, rot = -11736 },
--                        { name = "cycas3", x = 6085, z = 1096, rot = 20171 },
--                        { name = "ad0_senegal_2", x = 4747, z = 634, rot = -2112 },
--                        { name = "ad0_senegal_2_large", x = 5828, z = 3668, rot = -28656 },
--                        { name = "ad0_senegal_7", x = 199, z = 406, rot = 26361 },
--                        { name = "ad0_senegal_5_large", x = 33, z = 2169, rot = -26887 },
--                        { name = "ad0_senegal_4", x = 4641, z = 36, rot = -7923 },
--                        { name = "cycas5", x = 391, z = 2862, rot = 8412 },
--                        { name = "cycas5", x = 18, z = 2007, rot = 2746 },
--                        { name = "ad0_senegal_7", x = 6039, z = 2947, rot = 24256 },
--                        { name = "ad0_senegal_4", x = 565, z = 109, rot = -9959 },
--                        { name = "ad0_senegal_1_large", x = 77, z = 3868, rot = 6050 },
--                        { name = "ad0_senegal_4_large", x = 1126, z = 3493, rot = -4775 },
--                        { name = "ad0_senegal_2_large", x = 173, z = 3914, rot = -6885 },
--                        { name = "ad0_senegal_6", x = 1005, z = 2592, rot = -691 },
--                        { name = "ad0_senegal_7", x = 49, z = 3872, rot = -24635 },
--                        { name = "ad0_senegal_4", x = 6064, z = 4013, rot = 17504 },
--                        { name = "ad0_senegal_1", x = 51, z = 1726, rot = -6350 },
--                        { name = "ad0_senegal_2", x = 5256, z = 1492, rot = -8465 },
--                        { name = "ad0_senegal_5_large", x = 68, z = 3954, rot = -8788 },
--                        { name = "ad0_senegal_2", x = 5598, z = 926, rot = -15863 },
--                        { name = "ad0_senegal_2", x = 1130, z = 4044, rot = -31893 },
--                        { name = "cycas7", x = 76, z = 2970, rot = -4149 },
--                        { name = "ad0_senegal_7", x = 28, z = 883, rot = 6654 },
--                        { name = "ad0_senegal_5", x = 5162, z = 1325, rot = -20977 },
--                        { name = "ad0_senegal_1_large", x = 5824, z = 58, rot = 17916 },
--                        { name = "ad0_senegal_6", x = 94, z = 1926, rot = -31745 },
--                        { name = "ad0_senegal_1_large", x = 4601, z = 10, rot = -18656 },
--                        { name = "cycas5", x = 264, z = 240, rot = -13463 },
--                        { name = "cycas5", x = 6108, z = 2823, rot = 21051 },
--                        { name = "ad0_senegal_3_large", x = 5254, z = 1445, rot = -28672 },
--                        { name = "ad0_senegal_1_large", x = 172, z = 2010, rot = 4806 },
--                        { name = "cycas2", x = 5728, z = 3409, rot = 12454 },
--                        { name = "ad0_senegal_5_large", x = 129, z = 4057, rot = 23866 },
--                        { name = "ad0_senegal_7_large", x = 1177, z = 3503, rot = -20775 },
--                        { name = "ad0_senegal_4_large", x = 4802, z = 748, rot = -18271 },
--                        { name = "ad0_senegal_4_large", x = 597, z = 696, rot = 14927 },
--                        { name = "ad0_senegal_5_large", x = 4680, z = 31, rot = -1082 },
--                        { name = "cycas4", x = 1102, z = 3499, rot = -19203 },
--                        { name = "ad0_senegal_6_large", x = 5903, z = 137, rot = -18060 },
--                        { name = "cycas3", x = 618, z = 124, rot = -18119 },
--                        { name = "cycas2", x = 5563, z = 807, rot = -9264 },
--                        { name = "cycas2", x = 5979, z = 3978, rot = -22153 },
--                        { name = "cycas2", x = 6084, z = 2911, rot = 22935 },
--                        { name = "cycas2", x = 6082, z = 1977, rot = 7596 },
--                        { name = "ad0_senegal_3", x = 536, z = 2288, rot = -18356 },
--                        { name = "cycas5", x = 71, z = 3826, rot = 3520 },
--                        { name = "ad0_senegal_6_large", x = 413, z = 2968, rot = -4290 },
--                        { name = "cycas5", x = 5906, z = 168, rot = 14026 },
--                        { name = "cycas2", x = 6113, z = 1906, rot = -28770 },
--                        { name = "ad0_senegal_6_large", x = 6031, z = 2905, rot = -10012 },
--                        { name = "ad0_senegal_2_large", x = 6112, z = 2000, rot = 17153 },
--                        { name = "ad0_senegal_6", x = 1244, z = 4071, rot = -22174 },
--                        { name = "ad0_senegal_5_large", x = 5215, z = 1409, rot = 13057 },
--                        { name = "ad0_senegal_3_large", x = 268, z = 4067, rot = -11722 },
--                        { name = "ad0_senegal_5", x = 5177, z = 1363, rot = -16170 },
--                        { name = "ad0_senegal_3", x = 5129, z = 1341, rot = 11046 },
--                        { name = "cycas3", x = 1047, z = 2657, rot = -7632 },
--                        { name = "ad0_senegal_6_large", x = 92, z = 3044, rot = -14828 },
--                        { name = "ad0_senegal_7_large", x = 1146, z = 3577, rot = -19736 },
--                        { name = "ad0_senegal_5", x = 1291, z = 3228, rot = 6770 },
--                        { name = "ad0_senegal_5", x = 5778, z = 1470, rot = 1929 },
--                        { name = "cycas2", x = 6131, z = 934, rot = 16289 },
--                        { name = "ad0_senegal_3_large", x = 5726, z = 3481, rot = 24628 },
--                        { name = "ad0_senegal_1", x = 5890, z = 11, rot = -9154 },
--                        { name = "cycas2", x = 144, z = 3902, rot = -24318 },
--                        { name = "ad0_senegal_7_large", x = 4704, z = 23, rot = -28221 },
--                        { name = "ad0_senegal_7", x = 621, z = 696, rot = 25586 },
--                        { name = "ad0_senegal_7", x = 4554, z = 34, rot = -25481 },
--                        { name = "ad0_senegal_2_large", x = 5810, z = 7, rot = -28986 },
--                        { name = "ad0_senegal_6", x = 4776, z = 724, rot = -17521 },
--                        { name = "ad0_senegal_1", x = 1133, z = 3524, rot = 20412 },
--                        { name = "ad0_senegal_7_large", x = 5090, z = 1326, rot = 31140 },
--                        { name = "ad0_senegal_6", x = 6077, z = 1020, rot = 23975 },
--                        { name = "cycas3", x = 5485, z = 729, rot = -10688 },
--                        { name = "ad0_senegal_2_large", x = 6080, z = 924, rot = -27969 },
--                        { name = "ad0_senegal_7_large", x = 569, z = 2340, rot = -1865 },
--                        { name = "ad0_senegal_7", x = 5789, z = 1507, rot = -18709 },
--    }
--    for i, v in ipairs(objectlist) do
--        if v.x > 3072 then
--            v.x = v.x + 2048
--        end
--    end
--end

