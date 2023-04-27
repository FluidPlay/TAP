function gadget:GetInfo()
    return {
        name = "Signal Handler - Unlock Tech",
        desc = "Unlocks tech after receiving a signal",
        author = "MaDDoX",
        date = "March 2023",
        license = "Whatever is free-er",
        layer = 0, -- Must be > -999
        enabled = true,
    }
end

--[[ USAGE EXAMPLE:

Setting up a Signal:end
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
local unlockableTechs = {
    bowhq = {'Tech', 'EnhancedTech', 'AdvancedTech', 'MohoTech', 'UberTech',},
    kernhq = {'Tech', 'EnhancedTech', 'AdvancedTech', 'MohoTech', 'UberTech',}
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

--function gadget:Initialize()
--	GG.Signals = Signals
--	GG.SendSignal = SendSignal
--end

--- After a sequential-morph unit is finished, it should store it and assign all possible signals to it
function gadget:UnitFinished(unitID, unitDefID, unitTeam)
    local unitDefName = UnitDefs[unitDefID].name
    -- If it's one of the units-of-interest, initialize all its possible signals
    if unlockableTechs[unitDefName] then
        for _, techName in ipairs(unlockableTechs[unitDefName]) do
            --Spring.Echo("sighandler: Tech to unlock = "..techName)
            GG.SetupSignal(unitID, techName, function ()
                                GG.TechGrant(techName, unitTeam) --, Init)
                            end
            )
        end
    end
    ---- To send the signal from elsewhere:
    -- GG.SendSignal(unitID, techName)
end
