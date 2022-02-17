function widget:GetInfo()
    return {
        name      = "SFX - Tech Up",
        desc      = "Plays text + sound notification when a Tech Center morph is Finished",
        author    = "MaDDoX",
        date      = "Aug 2020",
        license   = "GNU GPL, v2 or later",
        layer     = 1,
        enabled   = true
    }
end

-------------------------------------------------------------------------------------------
VFS.Include("gamedata/taptools.lua")

local techCenters = {armtech = 2, armtech1 = 3, armtech2 = 4, armtech3 = 5, armtech4 = 6,
                     cortech = 2, cortech1 = 3, cortech2 = 4, cortech3 = 5, cortech4 = 6}
-------------------------------------------------------------------------------------------
local txtcolor = "\255\240\200\86"
local spGetPlayerList = Spring.GetPlayerList
local spSendMessageToPlayer = Spring.SendMessageToPlayer
local spPlaySoundFile = Spring.PlaySoundFile

function widget:UnitFinished(unitID, unitDefID, teamID)
    local unitDef = UnitDefs[unitDefID]
    if unitDef == nil or not techCenters[unitDef.name] then
        return end
    local newTier = tostring(techCenters[unitDef.name])
    --TODO: Check if tech was already unlocked, only play sound if it wasn't
    if IsValidUnit(unitID) then
        spPlaySoundFile("sounds/ui/t"..newTier..".wav",0.5,_,_,_,_,_,_,"ui")
        local playerIDs = spGetPlayerList (teamID)
        for _,playerID in ipairs(playerIDs) do
            --Spring.SendMessageToTeam
            spSendMessageToPlayer(playerID, txtcolor .."------------------------------------------------")
            spSendMessageToPlayer(playerID, txtcolor .."  You've reached Tech Level "..newTier)
            spSendMessageToPlayer(playerID, txtcolor .."------------------------------------------------")
            --Spring.PlaySoundFile("sounds/ui/achievement.wav",0.5) --,_,_,_,_,_,_,"userinterface")
            --spPlaySoundFile("sounds/ui/t"..newTier..".wav",1, "ui")
        end
    end
end
