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
    local spGetUnitTeam = Spring.GetUnitTeam
    local spAddTeamResource = Spring.AddTeamResource
    local spCallCOBScript = Spring.CallCOBScript
    local spSetUnitWeaponState = Spring.SetUnitWeaponState
    local spGiveOrderToUnit = Spring.GiveOrderToUnit
    local spSetUnitRulesParam = Spring.SetUnitRulesParam
    local spGetUnitSeparation = Spring.GetUnitSeparation

    local defaultMaxStorage = 620
    local loadedHarvesters = {}
    local oreTowers = {}

    local oreTowerDefNames = {
        armmstor = true, cormstor = true, armuwadvms = true, coruwadvms = true,
    }

    local CMD_STOP = CMD.STOP

    local ore = { sml = UnitDefNames["oresml"].id, lrg = UnitDefNames["orelrg"].id, moho = UnitDefNames["oremoho"].id, uber = UnitDefNames["oremantle"].id } --{ sm = UnitDefNames["oresml"].id, lrg = UnitDefNames["orelrg"].id, moho = UnitDefNames["oremoho"].id, uber = UnitDefNames["oremantle"].id }

    function gadget:Initialize()
        --startFrame = Spring.GetGameFrame()
        --gaiaTeamID = Spring.GetGaiaTeamID()
    end

    function gadget:UnitFinished(unitID, unitDefID, unitTeam)
        local ud = UnitDefs[unitDefID]
        if ud == nil then
            return end
        if not oreTowerDefNames[ud.name] then
            return end

        oreTowers[unitID] = ud.buildDistance -- 330 is lvl1 outpost build range
    end

    function gadget:UnitDestroyed(unitID, unitDefID, teamID, attackerID, attackerDefID, attackerTeam)
        local ud = UnitDefs[unitDefID]
        if ud == nil then
            return end
        if not oreTowerDefNames[ud.name] then
            return end

        oreTowers[unitID] = nil
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

    local function inTowerRange(harvesterID)
        for oreTowerID, range in pairs(oreTowers) do
            local thisTowerDist = spGetUnitSeparation ( harvesterID, oreTowerID, true) -- [, bool surfaceDist ]] )
            if thisTowerDist <= range then
                return true
            end
        end
    end

    -- attackerID => harvesterID, for legibility purposes
    function gadget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, harvesterID, harvesterDefID, attackerTeam)
        --Spring.Echo("Damage: "..(damage or "nil").." from: "..(attackerID or "nil"))
        if not IsValidUnit(harvesterID) or loadedHarvesters[harvesterID] then
            return end
        local curStorage = spGetUnitHarvestStorage(harvesterID)
        --Spring.Echo("cur Storage: "..curStorage.." damage: "..damage)

        -- Block further usage of the unit's harvest weapon while storage is full
        local attackerDef = UnitDefs[harvesterDefID]
        local maxStorage = attackerDef and attackerDef.harveststorage or defaultMaxStorage
        Spring.Echo("cur Storage: "..curStorage.." max: "..maxStorage)
        --- Can it harvest?
        if curStorage < maxStorage then
            if inTowerRange(harvesterID) then
                --TODO: If in range of an ore tower
                spAddTeamResource (spGetUnitTeam(harvesterID), "metal", damage )
            else
                spSetUnitHarvestStorage (harvesterID, math.min(maxStorage, curStorage + damage))
            end
        else
            spCallCOBScript(harvesterID, "BlockWeapon", 0)
            --spSetUnitWeaponState(attackerID, 1, "range", 0)    --block weapon while it's running?
            loadedHarvesters[harvesterID] = true
            Spring.Echo("unit ".. harvesterID .." is loaded!!")
            --TODO: Move to be in range of closest ore tower, once there it'll only return to previous
            ---harvest spot when it's totally unloaded
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
                if (curStorage < maxStorage) then
                    loadedHarvesters[unitID] = nil
                    spCallCOBScript(unitID, "UnblockWeapon", 0)
                    Spring.Echo("unit ".. unitID .." is no longer loaded")
                    --TODO: Check - Maybe locking range will help AI?
                    ---TODO: Cache original weapon ranges by unitDefID
                    --local weaponDefID = UnitDefs[Spring.GetUnitDefID(unitID)].weapons[1].weaponDef
                    --local origRange = WeaponDefs[weaponDefID].range
                    --spSetUnitWeaponState(unitID, 1, "range", origRange) --300) -- TODO: Remove temp fix --
                    ----Spring.Echo("Restored range to: "..origRange)
                end
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