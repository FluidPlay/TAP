---
--- Created by Breno "MaDDoX" Azevedo.
--- DateTime: 14-Nov-18 9:19 AM
---
function gadget:GetInfo()
    return {
        name      = "Spawn Starting Units",
        desc      = "Spawn builders, Avatar & Daemon next to the Starting Unit (HQ) at game start",
        author    = "MaDDoX",
        date      = "June 2022",
        license   = "GNU GPL v3",
        layer     = 0,
        enabled   = true,
    }
end

if gadgetHandler:IsSyncedCode() then
    -----------------
    ---- SYNCED
    -----------------

    local spGetAllUnits	= Spring.GetAllUnits
    local spGetUnitDefID = Spring.GetUnitDefID
    --local spGetGameFrame = Spring.GetGameFrame
    local spGetFeatureDefID = Spring.GetFeatureDefID
    local spGetUnitPosition = Spring.GetUnitPosition
    local spCreateUnit = Spring.CreateUnit
    local initialized = false
    local spGetUnitTeam = Spring.GetUnitTeam
    local spGetTeamInfo = Spring.GetTeamInfo

    local bowcomid = UnitDefNames["armcom"].id
    local kerncomid = UnitDefNames["corcom"].id
    local bowhqid = UnitDefNames["bowhq"].id
    local kernhqid = UnitDefNames["kernhq"].id
    local armckid = UnitDefNames["armck"].id
    local corckid = UnitDefNames["corck"].id

    local startWeapName = "kernhq_lt"
    local startTechName = "kernhq_rt"

    local minSpawnDistance = 150    -- This prevents duplicated geothermals in faulty maps
    --local respawnTime = 60 -- in frames; 60f = 2s
    --local geosToRespawn = {}

    --local function sqr (x)
    --    return math.pow(x, 2)
    --end
    --local function distance (x1, y1, z1, x2, y2, z2 )
    --    return math.sqrt(sqr(x2-x1) + sqr(y2-y1) + sqr(z2-z1))
    --end
    --
    --local function GeoNearby(x,y,z)
    --    if x == nil or y == nil or z == nil then
    --        return false end
    --    for _, pos in pairs(geoThermals) do
    --        if distance(pos.x, pos.y, pos.z, x, y, z) < minSpawnDistance then
    --            return true
    --        end
    --    end
    --    return false
    --end

    local function spawnBuilders(unitID, teamID, unitDef)
        --if not GeoNearby(x,y,z) then
            -- Spring.GetGroundHeight(x, z)
        local x,y,z = spGetUnitPosition(unitID)
        local builderID, commanderID

        --Don't use it, just reads it from the lobby setting
        --local _, _, _, _, teamSide = spGetTeamInfo(teamID)
        --teamSide = string.lower(teamSide)
        --Spring.Echo("Side : "..(teamSide or "nil"))  --(side or "nil").."|"..

        if unitDef.id == kernhqid then
            builderID = corckid
            commanderID = kerncomid
        else
            builderID = armckid
            commanderID = bowcomid
        end

        spCreateUnit(builderID, x, y, z+80, 0, teamID)
        spCreateUnit(builderID, x, y, z+40, 0, teamID)
        spCreateUnit(builderID, x, y, z-0, 0, teamID)
        spCreateUnit(builderID, x, y, z-40, 0, teamID)

        spCreateUnit(commanderID, x, y, z-100, 0, teamID)

        local piecemap = Spring.GetUnitPieceMap(unitID)
        local pieceID = piecemap["plugBL"]

        local px, py, pz = Spring.GetUnitPiecePosDir(unitID, pieceID)
        local spawnedUnitID = spCreateUnit(startWeapName, px, py, pz, 0, teamID)

        --pieceID = piecemap["plugFL2"]
        --px, py, pz = Spring.GetUnitPiecePosDir(unitID, pieceID)
        --spawnedUnitID = spCreateUnit(startTechName, px, py, pz, 0, teamID)

        --Spring.UnitAttach(unitID, spawnedUnitID, pieceID)
    end

    function gadget:GameFrame(frame)
        -- Add all supported game-start spawned units (aka. commanders)
        if not initialized and frame > 0 then
            local allUnits = spGetAllUnits()
            for _, unitID in ipairs(allUnits) do
                local unitDefID = spGetUnitDefID(unitID)
                local unitDef = unitDefID and UnitDefs[unitDefID] or nil
                if unitDef and unitDef.customParams and unitDef.customParams.ishq then
                    local teamID = spGetUnitTeam(unitID)
                    spawnBuilders(unitID, teamID, unitDef)
                end
            end
            initialized = true
        end
    end

end
--else
--    -----------------
--    ---- UNSYNCED
--    -----------------
--
--    ---- Here we'll make the 'capture' cursor the default action on top of geothermals
--    ---- for commanders and capture-enabled builders
--
--    local spGetMouseState = Spring.GetMouseState
--    local spTraceScreenRay = Spring.TraceScreenRay
--    --local spAreTeamsAllied = Spring.AreTeamsAllied
--    --local spGetUnitTeam = Spring.GetUnitTeam
--    local spGetUnitDefID = Spring.GetUnitDefID
--    local spGetSelectedUnits = Spring.GetSelectedUnits
--    --local spGetLocalTeamID = Spring.GetLocalTeamID
--    local spFindUnitCmdDesc = Spring.FindUnitCmdDesc
--    local spGetUnitCmdDescs = Spring.GetUnitCmdDescs
--    local CMD_CAPTURE = CMD.CAPTURE
--
--    local strUnit = "unit"
--
--    local geothermalsDefIDs = {
--        [UnitDefNames["armgeo"].id] = true,
--        [UnitDefNames["armageo"].id] = true,
--        [UnitDefNames["armgmm"].id] = true,
--    }
--
--    function gadget:DefaultCommand()
--        local function isGeothermal(unitDefID)
--            return geothermalsDefIDs[unitDefID]
--        end
--        local mx, my = spGetMouseState()
--        local s, targetID = spTraceScreenRay(mx, my)
--        if s ~= strUnit then
--            return false end
--
--        --if not spAreTeamsAllied(myTeamID, spGetUnitTeam(targetID)) then
--        --    return false
--        --end
--
--        -- Only proceed if target is one of the geothermal variations
--        local targetDefID = spGetUnitDefID(targetID)
--        if not isGeothermal(targetDefID) then
--            return false end
--
--        -- If any of the selected units is a capturer, default to 'capture'
--        local sUnits = spGetSelectedUnits()
--        --local teamID = spGetLocalTeamID()
--
--        for i=1,#sUnits do
--            local unitID = sUnits[i]
--            local unitDef = UnitDefs[spGetUnitDefID(unitID)]
--            if unitDef.customParams.iscommander then
--                return CMD_CAPTURE
--            end
--            if unitDef.canCapture then
--                -- Check if the units has capture enabled already
--                local cmdIdx = spFindUnitCmdDesc(unitID, CMD_CAPTURE)
--                local cmdDesc = spGetUnitCmdDescs(unitID, cmdIdx, cmdIdx)[1]
--                if not cmdDesc.disabled then
--                    return CMD_CAPTURE end
--            end
--        end
--        return false
--    end
--
--end
