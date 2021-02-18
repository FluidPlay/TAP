--------------------------------------------------------------------------------------------
--- set some spring settings before the game/engine is really loaded yet
--------------------------------------------------------------------------------------------

-- higher textureatlas size for particles than the default of 2048x2048
local maxTextureAtlasSize = 4096
Spring.SetConfigInt("MaxTextureAtlasSizeX", maxTextureAtlasSize)
Spring.SetConfigInt("MaxTextureAtlasSizeZ", maxTextureAtlasSize)
if tonumber(Spring.GetConfigInt("MaxTextureAtlasSizeX",2048) or 2048) < maxTextureAtlasSize then
	Spring.SetConfigInt("MaxTextureAtlasSizeX", maxTextureAtlasSize)
	Spring.SetConfigInt("MaxTextureAtlasSizeZ", maxTextureAtlasSize)
end

-- Sets necessary spring configuration parameters, so shaded units look the way they should
Spring.SetConfigInt("CubeTexGenerateMipMaps", 1)
Spring.SetConfigInt("CubeTexSizeReflection", 2048)

-- adv unit shading
if not tonumber(Spring.GetConfigInt("AdvUnitShading",0) or 0) then
	Spring.SetConfigInt("AdvUnitShading", 1)
end

-- adv map shading
if not tonumber(Spring.GetConfigInt("AdvMapShading",0) or 0) then
	Spring.SetConfigInt("AdvMapShading", 1)
end

-- unit Icon dist
if not tonumber(Spring.GetConfigInt("UnitIconDist",0) or 0) then
    Spring.SetConfigInt("AdvMapShading", 85)
end

-- Mouse drag scroll threshold (-1 means no drag-scroll allowed, the default on TAP)
if not tonumber(Spring.GetConfigFloat("MouseDragScrollThreshold",0) or 0) then
    Spring.SetConfigFloat("MouseDragScrollThreshold", -1)
end

---- make sure default/minimum ui opacity is set
--if Spring.GetConfigFloat("ui_opacity", 0.6) < 0.3 then
--	Spring.SetConfigFloat("ui_opacity", 0.6)
--end
---- set default bg tile settings
--if Spring.GetConfigFloat("ui_tileopacity", 0.011) < 0 then
--	Spring.SetConfigFloat("ui_tileopacity", 0.011)
--end
--if Spring.GetConfigFloat("ui_tilescale", 7) < 0 then
--	Spring.SetConfigFloat("ui_tilescale", 7)
--end

-- disable ForceDisableShaders
if Spring.GetConfigInt("ForceDisableShaders",0) == 1 then
	Spring.SetConfigInt("ForceDisableShaders", 0)
end

-- enable lua shaders
if not tonumber(Spring.GetConfigInt("LuaShaders",0) or 0) then
	Spring.SetConfigInt("LuaShaders", 1)
end

-- Disable PBO for intel GFX
if Platform.gpuVendor ~= 'Nvidia' and Platform.gpuVendor ~= 'AMD' then
	Spring.SetConfigInt("UsePBO", 0)
else
	Spring.SetConfigInt("UsePBO", 1)
end

-- Disable dynamic model lights
Spring.SetConfigInt("MaxDynamicModelLights", 0)

-- Disable LoadingMT because: crashes on load
Spring.SetConfigInt("LoadingMT", 0)

-- Chobby had this set to 100 before and it introduced latency of 4ms a sim-frame, having a 10%-15% penalty compared it the default
Spring.SetConfigInt("LuaGarbageCollectionMemLoadMult", 2)


---- change some default value(s), upp the version and set what needs to be set
--local version = 2
--if Spring.GetConfigInt("version",0) < version then
--
--	Spring.SetConfigFloat("CrossAlpha", 0)	-- will be in effect next launch
--
--	if Spring.GetConfigFloat("ui_tileopacity", 0.011) <= 0 then
--		Spring.SetConfigFloat("ui_tileopacity", 0.011)
--	end
--	if Spring.GetConfigFloat("ui_tilescale", 7) <= 0 then
--		Spring.SetConfigFloat("ui_tilescale", 7)
--	end
--end
