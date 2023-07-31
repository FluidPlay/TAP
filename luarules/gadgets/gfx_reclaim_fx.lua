   function gadget:GetInfo()
      return {
        name      = "Reclaim effect",
        desc      = "Nice unit reclaim effect",
        author    = "Floris",
        date      = "December 2016",
        license   = "PD",
        layer     = 0,
        enabled   = true,
      }
    end
     
if (not gadgetHandler:IsSyncedCode()) then
  return
end

VFS.Include("gamedata/taptools.lua")

local random = math.random

local spSpawnCEG = Spring.SpawnCEG
local spGetUnitPosition = Spring.GetUnitPosition
local spGetGameFrame = Spring.GetGameFrame
local spGetFeatureHealth = Spring.GetFeatureHealth
local spGetFeaturePosition = Spring.GetFeaturePosition
local spGetFeatureResources = Spring.GetFeatureResources
local spGetFeatureDefID = Spring.GetFeatureDefID
local spSpawnCEG = Spring.SpawnCEG
local spPlaySoundFile = Spring.PlaySoundFile

local ignoreUnits = {}
if UnitDefNames["chip"] ~= nil then
	ignoreUnits[UnitDefNames["chip"].id] = true
	ignoreUnits[UnitDefNames["xmasball"].id] = true
end


local featureList = {}
for featureDefID, fdef in pairs(FeatureDefs) do
   if (fdef.model ~= nil) then
	   featureList[featureDefID] = {minx=fdef.model.minx, maxx=fdef.model.maxx, miny=fdef.model.miny, maxy=fdef.model.maxy, minz=fdef.model.minz, maxz=fdef.model.maxz}
   end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
	if attackerID == nil and ignoreUnits[unitDefID] == nil then -- if reclaimed
		local ux,uy,uz = spGetUnitPosition(unitID)
		if ux ~= nil then
			local udef = UnitDefs[unitDefID]
			local x,y,z = ux,uy,uz
			spSpawnCEG("metalshards1", x, y, z)
			
			-- add more effects depending on unit cost
			local numFx = math.floor(UnitDefs[unitDefID].metalCost/170)
			local posMultiplier = 0.5
			for i=1, numFx, 1 do
				x = ux + (random(udef.model.minx, udef.model.maxx)*posMultiplier)
				z = uz + (random(udef.model.minz, udef.model.maxz)*posMultiplier)
				y = uy + (random() * udef.model.maxy*posMultiplier)
				spSpawnCEG("metalshards"..(((i+1)%3)+1), x, y, z)
			end
		end
	end
end

local damagedFeatures = {}
function gadget:FeatureDamaged(featureID, featureDefID, featureTeam, damage, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
	if damage > 4 and (damagedFeatures[featureID] == nil or spGetGameFrame() - damagedFeatures[featureID] > 15) and select(1,spGetFeatureHealth(featureID)) > 0 then		-- not sure if "select(1,Spring.GetFeatureHealth(featureID)) > 0" is needed because if featuredestroyed, featuredamaged wont be called probably
		local fx,fy,fz = spGetFeaturePosition(featureID)
		if (fx ~= nil) then
			local x,y,z = fx,fy,fz
			local _, mm, _, me, _ = spGetFeatureResources(featureID)
			local fdef = featureList[featureDefID]
			if me ~= nil and me > 0 then
				local numFx = math.floor(me/250)
				local posMultiplier = 0.5
				spSpawnCEG("energyshards1", x, y, z)
				for i=1, numFx, 1 do
					if fdef.minx and fdef.maxx and fdef.maxx ~= fdef.minx then
						x = fx + (random(fdef.minx, fdef.maxx)*posMultiplier)
						z = fz + (random(fdef.minz, fdef.maxz)*posMultiplier)
						y = fy + (random() * fdef.maxy*posMultiplier)
						spSpawnCEG("energyshards"..(((i+1)%3)+1), x, y, z)
					end
				end
				--spEcho(numFxE..'  '..FeatureDefs[featureDefID].energy)
			end
			if mm ~= nil and mm > 0 then
				local numFx = math.floor(mm/90)
				local posMultiplier = 0.5
				spSpawnCEG("metalshards1", x, y, z)
				for i=1, numFx, 1 do
					x = fx + (random(fdef.minx, fdef.maxx)*posMultiplier)
					z = fz + (random(fdef.minz, fdef.maxz)*posMultiplier)
					y = fy + (random() * fdef.maxy*posMultiplier)
					spSpawnCEG("metalshards"..(((i+1)%3)+1), x, y, z)
				end
				--spEcho(numFxE..'  '..FeatureDefs[featureDefID].energy)
			end
		end
		damagedFeatures[featureID] = spGetGameFrame()
	end
end

function gadget:FeatureDestroyed(featureID, allyteam)
	if damagedFeatures[featureID] ~= nil then
		damagedFeatures[featureID] = nil
	end
	if IsValidFeature(featureID) then
		local fx,fy,fz = spGetFeaturePosition(featureID)
		local x,y,z = fx,fy,fz
		--local featureDefID = spGetFeatureDefID(featureID)
		local rm, mm, re, me, rl = spGetFeatureResources(featureID)
		local fdef = featureList[spGetFeatureDefID(featureID)]

		if me ~= nil and me > 0 then
			local numFx = math.floor(me/250)
			local posMultiplier = 0.5
			spSpawnCEG("energyshards1", x, y, z)
			for i=1, numFx, 1 do
				x = fx + (random(fdef.minx, fdef.maxx)*posMultiplier)
				z = fz + (random(fdef.minz, fdef.maxz)*posMultiplier)
				y = fy + (random(fdef.miny, fdef.maxy)*posMultiplier)
				spSpawnCEG("energyshards"..(((i+1)%3)+1), x, y, z)
			end
			--spEcho(numFxE..'  '..FeatureDefs[featureDefID].energy)
		end
		if mm ~= nil and mm > 0 then
			local numFx = math.floor(mm/90)
			local posMultiplier = 0.5
			spSpawnCEG("metalshards1", x, y, z)
			for i=1, numFx, 1 do
				x = fx + (random(fdef.minx, fdef.maxx)*posMultiplier)
				z = fz + (random(fdef.minz, fdef.maxz)*posMultiplier)
				y = fy + (random(fdef.miny, fdef.maxy)*posMultiplier)
				spSpawnCEG("metalshards"..(((i+1)%3)+1), x, y, z)
			end
			--spEcho(numFxE..'  '..FeatureDefs[featureDefID].energy)
		end
		
		if (rm ~= nil) then
			if mm==0 and re == 0 then
				spSpawnCEG("sparklegreen", fx, fy, fz)
				spPlaySoundFile("reclaimate", 1, fx, fy, fz, 'sfx')
			end
		end
	end
end