---
--- Created by Breno "MaDDoX" Azevedo.
---
if not gadgetHandler:IsSyncedCode() then
    return end

function gadget:GetInfo()
    return {
        name      = "Weapon Handler - Neutron Strike",
        desc      = "Spawns a bunch of minor meteors around the point where the tagger hit",
        author    = "MaDDoX",
        date      = "23 October 2019",
        license   = "GNU GPL, v2 or later",
        layer     = -100,
        enabled   = true,
    }
end

-----------------
---- SYNCED
-----------------

--VFS.Include("gamedata/taptools.lua")
--local gaiaTeamID = Spring.GetGaiaTeamID()

local trackedWeapon
local spawnList = {}
local spCreateUnit = Spring.CreateUnit
local spGetUnitTeam = Spring.GetUnitTeam
local spSetWatchWeapon = Script.SetWatchWeapon
local spSetUnitNoDraw = Spring.SetUnitNoDraw
local spSetUnitStealth = Spring.SetUnitStealth
local spSetUnitSonarStealth = Spring.SetUnitSonarStealth
local spSetUnitBlocking = Spring.SetUnitBlocking
local spSetUnitNeutral = Spring.SetUnitNeutral
local spGetGameFrame = Spring.GetGameFrame
local minSpawnDelay = 1.25 * 30 -- 1.25 --n seconds in frames  --TODO: Make static
local maxSpawnDelay = 2 * 30    -- 2 --n seconds in frames
local spSpawnProjectile = Spring.SpawnProjectile

local meteoriteDefID =  UnitDefNames["meteorite"].id
local neutronHailWeapon = WeaponDefNames.neutronhail.id
local updateRate = 2

local meteoriteSpawnRadius = 150 --250
local rnd = math.random
local dweaponCmdID = 105

VFS.Include("gamedata/taptools.lua")

function gadget:Initialize()
    for _,def in pairs(WeaponDefs) do
        if def.name == "corvrad_meteor_painter" then
            trackedWeapon = def.id
        end
    end
    spSetWatchWeapon(trackedWeapon, true)
end

function gadget:Explosion(w, x, y, z, attackerID)
    if w == trackedWeapon then --and attackerID then
        --local y2 = Spring.GetGroundHeight(x,z)+100
        --if not Spring.GetGroundBlocked(x,z) then
        local thisSpawnDelay = lerp(minSpawnDelay, maxSpawnDelay, rnd())
        table.insert(spawnList, { spawnTime = spGetGameFrame() + thisSpawnDelay, attackerID = attackerID, x=x, y=y, z=z})
        --Spring.Echo("Tracked Laser-tag explosion")
        return true
        --end
    end
    return false
end

--function gadget:ProjectileCreated(proID, proOwnerID, weaponDefID)
--    Spring.Echo("Projectile created id: "..(proID or "nil").." weaponDefID: "..(weaponDefID or "nil"))
--end

function gadget:UnitCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOpts, cmdTag)
    if not IsValidUnit(unitID) then --or not automatableUnits[unitID]
        return end
    if cmdID == 2 then -- ugly hack to prevent state changes from inadvertently exiting wait status
        return end
    --Spring.Echo("Cmd taken from "..tostring(unitID).." cmdID: "..tostring(cmdID))
    --TODO: Get weapon from this Unit, and if it's ready to fire (meaning it actually fired) get the cmdParams for x,y,z
    --TODO: Also check for having enough resources to fire it (metal); once that's done, get rid of gadget:Explosion
end

function gadget:GameFrame(f)
    if f % updateRate > 0.00001 then
        return end
    --for i, data in pairs(spawnList) do
    for i, data in ipairs(spawnList) do
        if f >= data.spawnTime then
            local rand1 = (rnd() - 0.5) * meteoriteSpawnRadius
            local rand2 = (rnd() - 0.5) * meteoriteSpawnRadius
            spSpawnProjectile(neutronHailWeapon,
                    {  pos = {data.x + rand1, data.y+400, data.z + rand2},
                                     ["end"] = {data.x + rand1, data.y, data.z + rand2},
                                     owner = spGetUnitTeam(data.attackerID),
                                     ttl = 3000,
                                     gravity = -Game.gravity/20,
                                     startAlpha = 0.1, -- number, --TODO: Play with those to fade the meteors in
                                     endAlpha = 0.9,
                                   })

    --      Spring.SpawnProjectile ( number weaponDefID, table projectileParams )
    --      return: nil | number projectileID
    --
    --      Possible keys of projectileParams are:
    --      pos = {number x, number y, number z},
    --      end = {number x, number y, number z},
    --      speed = {number x, number y, number z},
    --      spread = {number x, number y, number z},
    --      error = {number x, number y, number z},
    --      owner = number,
    --      team = number,
    --      ttl = number,
    --      gravity = number,
    --      tracking = number,
    --      maxRange = number,
    --      startAlpha = number,
    --      endAlpha = number,
    --      model = string,
    --      cegTag = string
                --local unitID = spCreateUnit(meteoriteDefID, data.x + rand1, data.y, data.z + rand2, "north", spGetUnitTeam(data.attackerID))
                ----Spring.Echo("Spawned "..unitID.." at: "..c.x..", "..c.y..", "..c.z)
                --spSetUnitNoDraw(unitID, true)
                --spSetUnitStealth(unitID, true)
                --spSetUnitSonarStealth(unitID, true)
                --spSetUnitBlocking(unitID, false, false, false, false, false, false, false)
                --spSetUnitNeutral(unitID, true)
            table.remove(spawnList, i)
        end
        --spawnList[i]=nil
    end

    ---Spring.SpawnProjectile ( number weaponDefID, table projectileParams )
    --return: nil | number projectileID
    --
    --Possible keys of projectileParams are:
    --    pos = {number x, number y, number z},
    --    end = {number x, number y, number z},
    --    speed = {number x, number y, number z},
    --    spread = {number x, number y, number z},
    --    error = {number x, number y, number z},
    --    owner = number,
    --    team = number,
    --    ttl = number,
    --    gravity = number,
    --    tracking = number,
    --    maxRange = number,
    --    startAlpha = number,
    --    endAlpha = number,
    --    model = string,
    --    cegTag = string
end

