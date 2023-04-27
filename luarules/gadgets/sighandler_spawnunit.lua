function gadget:GetInfo()
    return {
        name = "Sighandler - Spawn Unit",
        desc = "Spawns Unit at given offset position, after receiving a signal",
        author = "MaDDoX",
        date = "April 2023",
        license = "Whatever is free-er",
        layer = 1, -- Must be > -999
        enabled = true,
    }
end

--[[ USAGE EXAMPLE:

Setting up a Signal:
GG.SetupSignal(unitID, signalkey, func) -- number, str, function

Sending (executing) a Signal:
GG.SendSignal(unitID, signalKey)	-- number, str

Accessing a Signal function directly:
GG.Signal[unitID]

]]

if (not gadgetHandler:IsSyncedCode()) then
    return
end

--- { UnitDefName = TechToUnlock, ... }
local trackedTechs = {
    -- UnitWhichSpawnsTheUnit = {[UnlockingTechName] = { unitname = unitNameToSpawn, pice = pieceNameToSpawnItOnTop}, ... }
    bowhq = {['Tech'] = { unitname = "kernhq_rt", piece = "plugFL2"}}, --TODO: 'EnhancedTech', 'AdvancedTech', 'MohoTech', 'UberTech',}
    kernhq = {['Tech'] = { unitname = "kernhq_rt", piece = "plugFL2"}}, --TODO: 'EnhancedTech', 'AdvancedTech', 'MohoTech', 'UberTech',}
    --kernhq = {'Tech', 'EnhancedTech', 'AdvancedTech', 'MohoTech', 'UberTech',}
--    bowhq2 = "Tech",
--    bowhq3 = "EnhancedTech",
--    bowhq4 = "AdvancedTech",
--    bowhq5 = "MohoTech",
--    bowhq6 = "UberTech",
--    kernhq2 = "Tech",
--    kernhq3 = "EnhancedTech",
--    kernhq4 = "AdvancedTech",
--    kernhq5 = "MohoTech",
--    kernhq6 = "UberTech",
}

local GG_SetupSignal
local GG_TechGrant

local spGetUnitTeam = Spring.GetUnitTeam

---- Disable widget if I'm spec
function gadget:Initialize()
    if not GG.SetupSignal then
        Spring.Echo("<sighandler_spawnunit> gadget requires the 'Signal' gadget to run.")
        gadgetHandler:RemoveGadget(self)
    end
    --if not GG.TechGrant then
    --    Spring.Echo("<sighandler_spawnunit> gadget requires the 'cmd_multi_tech' gadget to run.")
    --    gadgetHandler:RemoveGadget(self)
    --end
    GG_SetupSignal = GG.SetupSignal
    GG_TechGrant = GG.TechGrant          -- -- Set by unitai_auto_assist
end

--- After a sequential-morph unit is finished, it should store it and assign all possible signals to it
function gadget:UnitFinished(unitID, unitDefID, unitTeam)
    local unitDefName = UnitDefs[unitDefID].name
    -- If it's one of the units-of-interest, initialize all its possible signals
    if trackedTechs[unitDefName] then
        for techName, spawnData in pairs(trackedTechs[unitDefName]) do
            local unitname = spawnData.unitname
            local spawnUnitDefID = UnitDefNames[unitname].id
            local piece = spawnData.piece
            --Spring.Echo("sighandler: Tech detected = "..techName..", unit to spawn: "..unitname)
            GG_SetupSignal(unitID, techName, function ()
                                --local pos = Spring.GetUnitPosition(unitID)
                                local piecemap = Spring.GetUnitPieceMap(unitID)
                                local pieceID = piecemap[piece]
                                if type(pieceID) == "number" then
                                    --- Spawn unit at the piece position
                                    local teamID = spGetUnitTeam(unitID)
                                    local x, y, z = Spring.GetUnitPiecePosDir(unitID, pieceID)
                                    Spring.CreateUnit(spawnUnitDefID, x,y,z, 0, teamID)
                                end
                            end
            )
        end
    end
    ---- To send the signal from elsewhere:
    -- GG.SendSignal(unitID, techName)
end
