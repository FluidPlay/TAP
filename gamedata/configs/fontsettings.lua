---
--- Created by MaDDoX
--- DateTime: 11-Jul-22 7:48 PM
---

------How to use:
-- at the top:
-- VFS.Include("gamedata/configs/fontsettings.lua")
-- then:

--Was: DefaultFontPath = "LuaUI/Fonts/GeogrotesqueCompMedium.otf" --Kelson Sans Regular.otf" --Akrobat-SemiBold.otf"
--Now: local DefaultFontPath = (VFS.Include("gamedata/configs/fontsettings.lua")).LuaUI

local FontName = "GeogrotesqueCompMedium.otf"
local fontData = { name = FontName, default = "fonts/"..FontName, LuaUI = "LuaUI/Fonts/"..FontName, skin = "LuaUI/Widgets/Skins/Evolved/fonts/"..FontName }

return fontData