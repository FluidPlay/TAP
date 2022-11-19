function widget:GetInfo()
	return {
		name = "TAPrime Hotkeys",
		desc = "Enables TAPrime Hotkeys, including ZXCV,BN,YJ,O,Q" ,
		author = "Beherith, modified by MaDDoX",
		date = "23 march 2012",
		license = "GNU LGPL, v2.1 or later",
		layer = 1,
		enabled = true,
        handler = true,
	}
end

function widget:Initialize()
    -- keyreload: load with unbindall before
    Spring.SendCommands("keyreload luaui/configs/uikeys.txt")

    -- Load user keybindings with tap defaults on top
    -- Keep in mind users can do 'keyreload luaui/configs/uikeys.txt'
    -- on top of their uikeys instead
    --
    -- keyload: load without unbindall before
    -- Spring.SendCommands("keyload uikeys.txt")
end

function widget:Shutdown()
    Spring.SendCommands("keyreload")
end
