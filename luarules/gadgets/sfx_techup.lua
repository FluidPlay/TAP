--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function gadget:GetInfo()
    return {
        name      = "SFX - Tech Up",
        desc      = "Plays a sound notification when a Tech Center morph is Finished",
        author    = "MaDDoX",
        date      = "Aug 2020",
        license   = "GNU GPL, v2 or later",
        version   = 1,
        layer     = 5,
        enabled   = false --true  --  loaded by default?
    }
end

---Currently disabled, this will be eventually used for CARTS (to play alerts for all playerIDs on a team)

local txtcolor = "\255\240\200\86"

--function GetAllyTeamID(teamID)
--	local _,_,_,_,_,allyTeamID = Spring.GetTeamInfo(teamID)
--	return allyTeamID
--end
--
--function GetPlayerTeamID(playerID)
--	local _,_,_,_,allyTeam = Spring.GetPlayerInfo(id)
--	return allyTeam
--end
--
--function AllPlayers()
--	local players = Spring.GetPlayerList()
--	for ct, id in pairs(players) do
--		local _,_,spectate = Spring.GetPlayerInfo(id)
--		if spectate == true then players[ct] = nil end
--	end
--	return players
--end
--
--function AllUsers()
--	local players = Spring.GetPlayerList()
--	return players
--end
--
--function PlayersInAllyTeamID(allyTeamID)
--	local players = AllPlayers()
--	for ct, id in pairs(players) do
--		local _,_,_,_,allyTeam = Spring.GetPlayerInfo(id)
--		if allyTeam ~= allyTeamID then players[ct] = nil end
--	end
--	return players
--end
--
--function AllButAllyTeamID(allyTeamID)
--	local players = AllPlayers()
--	for ct, id in pairs(players) do
--		local _,_,_,_,allyTeam = Spring.GetPlayerInfo(id)
--		if allyTeam == allyTeamID then players[ct] = nil end
--	end
--	return players
--end
--
--function PlayersInTeamID(teamID)
--	local players = Spring.GetPlayerList(teamID)
--	return players
--end

if not gadgetHandler:IsSyncedCode() then
    return end

--VFS.Include("gamedata/taptools.lua")
--
--local techCenters = {armtech = 2, armtech1 = 3, armtech2 = 4, armtech3 = 5, armtech4 = 6,
--                     cortech = 2, cortech1 = 3, cortech2 = 4, cortech3 = 5, cortech4 = 6}
--
--function gadget:UnitFinished(unitID, unitDefID, teamID)
--    local unitDef = UnitDefs[unitDefID]
--    if unitDef == nil then
--        return end
--    if not techCenters[unitDef.name] then
--        return end
--    local newTier = tostring(techCenters[unitDef.name])
--    --TODO: Check if tech was already unlocked, only play sound if it wasn't
--    if IsValidUnit(unitID) then
--        local playerIDs = Spring.GetPlayerList (teamID)
--        for _,playerID in ipairs(playerIDs) do
--            --Spring.SendMessageToTeam
--            Spring.SendMessageToPlayer(playerID, txtcolor .."------------------------------------------------")
--            Spring.SendMessageToPlayer(playerID, txtcolor .."  You've reached Tech Level "..newTier)
--            Spring.SendMessageToPlayer(playerID, txtcolor .."------------------------------------------------")
--            --Spring.PlaySoundFile("sounds/ui/achievement.wav",0.5) --,_,_,_,_,_,_,"userinterface")
--            Spring.PlaySoundFile("sounds/ui/t"..newTier..".wav",0.5, 'sfx')
--        end
--    end
--end
	

