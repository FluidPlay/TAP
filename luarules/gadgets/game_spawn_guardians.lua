function gadget:GetInfo()
    return {
        name      = "Spawn Guardians",
        desc      = "Spawn neutral alien guardians on top of ore spots at game start",
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

local guardianUnitDefId = UnitDefNames["pandoreguard"].id

local guardians = {}        -- { [unitID]={x,y,z}, ... }
local teamStartPos = {}    -- { [teamID] = { x=x, y=y, z=z }, ... }
local minGuardianDistance = 50    -- This prevents duplicated objects
local minStartposDistance = 600   -- Prevents guardians from being spawned near start Positions

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

local function spawnGuardian(x, y, z)
    if guardianNearby(x,y,z) then
        return end

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
    if not initialized and frame > 0 then
        local allUnits = spGetAllUnits()
        local isHQ = {}  -- { unitID = true, ... }
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
            if doSpawnHere then
                spawnGuardian(x,y,z) end --, data.spotIdx) end
        end
        initialized = true
    end
end

