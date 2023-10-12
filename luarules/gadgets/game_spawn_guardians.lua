function gadget:GetInfo()
    return {
        name      = "Spawn Guardians",
        desc      = "Control spawning of alien guardians on top of ore spots",
        author    = "MaDDoX",
        date      = "May 2023",
        license   = "GNU GPL, v2 or later",
        layer     = 200,
        enabled   = true,
    }
end

if not gadgetHandler:IsSyncedCode() then
    return end

-----------------
---- SYNCED
-----------------

local gaiaTeamID

local initialized

local spGetAllFeatures = Spring.GetAllFeatures
--local spGetGameFrame = Spring.GetGameFrame
local spGetUnitPosition = Spring.GetUnitPosition
local spCreateUnit = Spring.CreateUnit
local spSetUnitNeutral = Spring.SetUnitNeutral
local spSetUnitRotation = Spring.SetUnitRotation
local spGiveOrderToUnit = Spring.GiveOrderToUnit
local spGetAllUnits	= Spring.GetAllUnits
local spGetUnitDefID = Spring.GetUnitDefID
local spGetUnitTeam = Spring.GetUnitTeam

local isHQ = {}  -- { unitID = true, ... }  -- TODO: Support HQs created after initial spawn

local guardian = { sml = {id = UnitDefNames["guardsml"].id},   --TODO: add minSpawnDistance, per type
              med = {id = UnitDefNames["guardmed"].id},
              lrg = {id = UnitDefNames["guardlrg"].id},
              uber = {id = UnitDefNames["guarduber"].id} }

--local guardianUnitDefId = UnitDefNames["guardsml"].id -- guardian.sml.id

local spawnType = { [1] = "sml",    -- 0 mins
                    [1] = "sml",    -- 4 mins
                    [2] = "sml",    -- 8 mins
                    [3] = "med",    -- 12 mins
                    [4] = "med",    -- 16 mins
                    [5] = "lrg",    -- 20 mins
                    [6] = "lrg",    -- 24 mins
                    [7] = "uber",   -- 28 mins
}

local currentIter = 1   -- This will be increased by 1 every spawn
local maxLevel = "uber"     -- Will use this if spawnType index fail (greater than 7, initially)

local guardians = {}        -- { [unitID]={x,y,z}, ... }
local teamStartPos = {}    -- { [teamID] = { x=x, y=y, z=z }, ... }
local minGuardianDistance = 50    -- This prevents duplicated objects
local minStartposDistance = 600   -- Prevents guardians from being spawned near start Positions

--local updateRate = 30*10        -- test: 10s ; Guardian spawning frequency (every 4 minutes)
local updateRate = 30*60*4        -- Guardian spawning frequency (every 4 minutes)

local cmdFly = 145
local cmdAirRepairLevel = CMD.AUTOREPAIRLEVEL

local oreSpots = {} -- { 1 = { chunks = { unitID = { pos, kind, spotIdx, idxInSpot }, ...},
                    --         guardians = { unitID = { pos, kind, spotIdx, idxInSpot }, ...},
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
    for _, pos in pairs(guardians) do
        if distance(pos.x, pos.y, pos.z, x, y, z) < minGuardianDistance then
            return true
        end
    end
    return false
end

local function spawnGuardian(x, y, z, iter)
    local guardianType = spawnType[iter]
    if not guardianType then
        guardianType = maxLevel end
    --Spring.Echo("Guardian type: "..(guardianType or "nil").." || Iter: "..(tostring(iter) or "nil"))
    local guardianUnitDefId = guardian[guardianType].id
    local unitID = spCreateUnit(guardianUnitDefId, x, y, z, 0, gaiaTeamID)

    guardians[unitID]={ x=x, y=y, z=z}

    --if not oreSpots[spotIdx].chunks then
    --    oreSpots[spotIdx].chunks = {}
    --end
    --(oreSpots[spotIdx].chunks)[unitID] = { pos = {x=x, z=z}, kind= startOreKind, spotIdx = spotIdx }

    --spSetUnitNeutral(unitID, true)

    spSetUnitRotation(unitID,0,math.random()*85,0) -- 0~85 degress after the spawn placement (N,S,E,W)
    spGiveOrderToUnit(unitID, cmdFly, { 0 }, {})
    spGiveOrderToUnit(unitID, cmdAirRepairLevel, { 0 }, {})
end

function gadget:Initialize()
    gaiaTeamID = Spring.GetGaiaTeamID()
    oreSpots = GG.metalSpots  -- Set by mex_spot_finder.lua
    if not istable(oreSpots) then
        Spring.Echo("Warning: GG.metalSpots not found by game_spawn_guardians.lua!")
        oreSpots = {}
    end
end

--function gadget:GameStart()
function gadget:GameFrame(frame)
    -- Initial Spawn
    if not initialized and frame > 0 then
        local allUnits = spGetAllUnits()
        --TODO: Use GG.teamStartPoints = teamStartPoints instead of this
        for _, unitID in ipairs(allUnits) do
            local unitDefID = spGetUnitDefID(unitID)
            local unitDef = unitDefID and UnitDefs[unitDefID] or nil
            if unitDef and unitDef.customParams and unitDef.customParams.ishq then
                --local teamID = spGetUnitTeam(unitID)
                local x, y, z = spGetUnitPosition(unitID)
                isHQ[unitID] = { x=x, y=y, z=z }
            end
        end
        for _, data in ipairs(oreSpots) do
            local x, y, z = data.x, data.y, data.z
            local doSpawnHere = true
            for _, hqp in pairs(isHQ) do
                if distance(x, y, z, hqp.x, hqp.y, hqp.z) < minStartposDistance then
                    doSpawnHere = false
                    break
                end
            end
            if doSpawnHere and not guardianNearby(x,y,z) then
                spawnGuardian(x,y,z, 1) end --, data.spotIdx) end
        end
        initialized = true
    end

    if not initialized or frame % updateRate > 0.001 then
        return end
    currentIter = currentIter + 1
    for _, data in ipairs(oreSpots) do
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
            spawnGuardian(sx+x, sy,sz+z, currentIter) end --, data.spotIdx) end
    end
end

function gadget:UnitDestroyed(unitID)
    trackedUnits[unitID] = nil
end

