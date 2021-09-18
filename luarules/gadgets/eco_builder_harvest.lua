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

    local CHECK_FREQ = 30 --4

    local spGetGameFrame = Spring.GetGameFrame
    local spCreateUnit = Spring.CreateUnit
    local spSetUnitNeutral = Spring.SetUnitNeutral
    local spSetUnitHarvestStorage = Spring.SetUnitHarvestStorage
    local spGetUnitDefID = Spring.GetUnitDefID
    local spGetUnitHarvestStorage = Spring.GetUnitHarvestStorage
    local spCallCOBScript = Spring.CallCOBScript
    local spSetUnitWeaponState = Spring.SetUnitWeaponState
    local spGiveOrderToUnit = Spring.GiveOrderToUnit
    local spSetUnitRulesParam = Spring.SetUnitRulesParam

    local defaultMaxStorage = 620
    local loadedHarvesters = {}

    local CMD_STOP = CMD.STOP

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
        if not IsValidUnit(attackerID) or loadedHarvesters[attackerID] then
            return end
        local curStorage = spGetUnitHarvestStorage(attackerID)
        --Spring.Echo("cur Storage: "..curStorage.." damage: "..damage)

        -- Block further usage of the unit's harvest weapon while storage is full
        local attackerDef = UnitDefs[attackerDefID]
        local maxStorage = attackerDef and attackerDef.harveststorage or defaultMaxStorage
        Spring.Echo("cur Storage: "..curStorage.." max: "..maxStorage)
        if curStorage >= maxStorage then
            --spSetUnitRulesParam(unitID, "maxStorage", 1)
            spCallCOBScript(attackerID, "BlockWeapon", 0)
            --spSetUnitWeaponState(attackerID, 1, "range", 0)    --block weapon while it's running
            --spGiveOrderToUnit(attackerID, CMD_STOP, {}, {} )

            loadedHarvesters[attackerID] = true
            Spring.Echo("unit ".. attackerID .." is loaded!!")
        else
            spSetUnitHarvestStorage (attackerID, math.min(maxStorage, curStorage + damage))
        end
    end

    function gadget:GameFrame(gf)
        if gf % CHECK_FREQ > 0.001 then
            return
        end
        for unitID in pairs(loadedHarvesters) do
            if IsValidUnit(unitID) then
                local unitDefID = spGetUnitDefID(unitID)
                local uDef = UnitDefs[unitDefID]
                local maxStorage = uDef and (uDef.harvestStorage or defaultMaxStorage)
                local curStorage = spGetUnitHarvestStorage(unitID)
                --if (curStorage < maxStorage) then
                    loadedHarvesters[unitID] = nil
                    spCallCOBScript(unitID, "UnblockWeapon", 0)
                    ----TODO: Cache original weapon ranges by unitDefID
                    --local weaponDefID = UnitDefs[Spring.GetUnitDefID(unitID)].weapons[1].weaponDef
                    --local origRange = WeaponDefs[weaponDefID].range
                    --
                    ----Spring.Echo("Restored range to: "..origRange)
                    --spSetUnitWeaponState(unitID, 1, "range", origRange) --300) -- TODO: Remove temp fix --
                    Spring.Echo("unit ".. unitID .." is no longer loaded")
                --end
            end
        end
    end

    -- *** DO NOT USE - Not yet fully implemented in the engine (105.0)
    --function gadget:UnitHarvestStorageFull(unitID)
    --    Spring.Echo("Harvest Storage is full!")
    --end
    --function gadget:UnitPreDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
    --end
end