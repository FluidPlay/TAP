function widget:GetInfo()
    return {
        name = "Unit Idle Test",
        desc = "Test of the UnitIdle event",
        author = "MaDDoX",
        date = "Apr 16, 2023",
        license = "GPLv3",
        layer = 0,
        enabled = false, --true,
        handler = false,
    }
end

function widget:UnitIdle(unitID, unitDefID, unitTeam)
    Spring.Echo("\nUnitIdle fired for: "..unitID)
end

function widget:CommandNotify(cmdID, params, options)
    Spring.Echo("CommandID registered: "..(cmdID or "nil"))
end