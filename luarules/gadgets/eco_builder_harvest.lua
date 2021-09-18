---
--- Created by Breno "MaDDoX" Azevedo.
--- DateTime: 14-Nov-18 9:19 AM
---
function gadget:GetInfo()
    return {
        name      = "Eco - Builder Harvest",
        desc      = "Damaged (Harvested) Pandore Chunks are converted (or stored) into ore resources",
        author    = "MaDDoX",
        date      = "Sep 2021",
        license   = "GNU GPL, v2 or later",
        layer     = 1,
        enabled   = true,
    }
end

if gadgetHandler:IsSyncedCode() then
    -----------------
    ---- SYNCED
    -----------------

    VFS.Include("gamedata/taptools.lua")

    local spGetGameFrame = Spring.GetGameFrame
    local spCreateUnit = Spring.CreateUnit
    local spSetUnitNeutral = Spring.SetUnitNeutral
    local spSetUnitHarvestStorage = Spring.SetUnitHarvestStorage
    local spGetUnitHarvestStorage = Spring.GetUnitHarvestStorage

    local ore = { sml = UnitDefNames["oresml"].id, lrg = UnitDefNames["orelrg"].id, moho = UnitDefNames["oremoho"].id, uber = UnitDefNames["oremantle"].id } --{ sm = UnitDefNames["oresml"].id, lrg = UnitDefNames["orelrg"].id, moho = UnitDefNames["oremoho"].id, uber = UnitDefNames["oremantle"].id }

    function gadget:Initialize()
        --startFrame = Spring.GetGameFrame()
        --gaiaTeamID = Spring.GetGaiaTeamID()
    end

    function gadget:UnitDestroyed(unitID, unitDefID, teamID, attackerID, attackerDefID, attackerTeam)
        --chunksToSprawl[unitID] = nil
        --local chunk = spawnedChunks[unitID]
        --if not spawnedChunks[unitID] then
        --    return end
        -----if 'destroyer' is a builder, sets its harvestStorage
        -----TODO: Sent it to closest drop point
        --local attackerDef = UnitDefs[attackerDefID]
        --if attackerDef and attackerDef.canCapture then
        --    spSetUnitHarvestStorage ( attackerID, oreValue[chunk.type])
        --end
        --spawnedChunks[unitID] = nil
    end

    function gadget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
        --Spring.Echo("Damage: "..(damage or "nil").." from: "..(attackerID or "nil"))
        if not IsValidUnit(attackerID) then
            return end
        local curStorage = spGetUnitHarvestStorage(attackerID)
        Spring.Echo("cur Storage: "..curStorage.." damage: "..damage)
        --TODO: Block further usage of the unit's harvest weapon while storage is full
        spSetUnitHarvestStorage (attackerID, curStorage + damage)
    end

    -- *** DO NOT USE - Not yet fully implemented in the engine (105.0)
    --function gadget:UnitHarvestStorageFull(unitID)
    --    Spring.Echo("Harvest Storage is full!")
    --end
    --function gadget:UnitPreDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
    --end
end