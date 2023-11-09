
function gadget:GetInfo()
	return {
		name	= 'CARTS',
		desc	= 'Implements CARTS modoption',
		author	= 'MaDDoX',
		date	= 'Nov 2023',
		license	= 'GNU GPL, v2 or later',
		layer	= 10, --should run after game_initial_spawn
		enabled	= true
	}
end

-- Modoption check
if (tonumber((Spring.GetModOptions() or {}).carts) or 0) == 0 then
	return false
end

if gadgetHandler:IsSyncedCode() then
	
	----------------------------------------------------------------
	-- Synced Var
	----------------------------------------------------------------

	local CARTSallies = {}		-- { allyTeamID = {  architectTeamID = m, warlordTeamID = n, }, ... }
	local allyTeams = {}		-- { [1] = { teamID1, ... }, ... }
	local architects = {}		-- { [architectTeamID] = warlordTeamID, ... }
	local warlords = {}			-- { [warlordTeamID] = architectTeamID, ... }
	GG.CARTS = true -- Share to other gadgets
	
	local armcomDefID = UnitDefNames.armcom.id
	local corcomDefID = UnitDefNames.corcom.id
	
	----------------------------------------------------------------
	-- Setting up
	----------------------------------------------------------------
	do
		-- for debug echos
		--local function to_string(data, indent)
		--	local str = ""
		--
		--	if(indent == nil) then
		--		indent = 0
		--	end
		--
		--	-- Check the type
		--	if(type(data) == "string") then
		--		str = str .. (" "):rep(indent) .. data .. "\n"
		--	elseif(type(data) == "number") then
		--		str = str .. (" "):rep(indent) .. data .. "\n"
		--	elseif(type(data) == "boolean") then
		--		if(data == true) then
		--			str = str .. "true\n"
		--		else
		--			str = str .. "false\n"
		--		end
		--	elseif(type(data) == "table") then
		--		local i, v
		--		for i, v in pairs(data) do
		--			-- Check for a table in a table
		--			if(type(v) == "table") then
		--				str = str .. (" "):rep(indent) .. i .. ":\n"
		--				str = str .. to_string(v, indent + 2)
		--			else
		--		str = str .. (" "):rep(indent) .. i .. ": " ..to_string(v, 0)
		--		end
		--		end
		--	elseif (data ==nil) then
		--		str=str..'nil'
		--	else
		--	   -- print_debug(1, "Error: unknown data type: %s", type(data))
		--		--str=str.. "Error: unknown data type:" .. type(data)
		--		Spring.Echo(type(data) .. 'X data type')
		--	end
		--
		--	return str
		--end
		--
		end

	--local function SetCoopStartPoint(playerID, x, y, z)
	--	coopStartPoints[playerID] = {x, y, z}
	--	--Spring.Echo('coop dbg6',playerID,x,y,z,to_string(coopStartPoints))
	--
	--	SendToUnsynced("CoopStartPoint", playerID, x, y, z)
	--end
	
	local playerList = Spring.GetPlayerList()
	for _, playerID in ipairs(playerList) do
		--Spring.GetPlayerInfo ( number playerID ) => nil | string "name", bool active, bool spectator, number teamID, number allyTeamID
		local _, isActive, isSpec, teamID, allyTeamID = Spring.GetPlayerInfo(playerID)
		--TODO: Make it work for AI players (non-active)
		if not isSpec and isActive then
			if not allyTeams[allyTeamID] then
				allyTeams[allyTeamID] = {} end
			if not allyTeams[allyTeamID][teamID] then
				allyTeams[allyTeamID][teamID] = {} end
			table.insert(allyTeams[allyTeamID][teamID], playerID )
		end
	end
	--## Eg: allyTeams[1][2] = { 4, 8, 9 } => allyTeams = 1, teamID = 2, playerIDs = 4, 8, 9

	--- TODO/WIP: if there's more than one playerID in the same allyTeam, tag it as a CARTS'ed team / allyTeam
	--- lowest playerID # will be the Architect, highest will be the Warlord
	local teamIDsInAlly = {}
	for allyTeamID, teamIDtable in pairs(allyTeams) do
		if istable(teamIDtable) then
			local teamIDcount = 0
			local architectTeamID = 999999	-- lowest teamID
			local warlordTeamID = -1		-- highest teamID
			for teamID, playerIDtable in pairs(teamIDtable) do
				teamIDcount = teamIDcount + 1
				if teamID < architectTeamID then
					architectTeamID = teamID end
				if teamID > warlordTeamID then
					warlordTeamID = teamID end
			end
			if teamIDcount > 0 then
				CARTSallies[allyTeamID] = { architectTeamID = architectTeamID, warlordTeamID = warlordTeamID }
				architects[architectTeamID] = warlordTeamID
				warlords[warlordTeamID] = architectTeamID
			end
		end
	end

	---TODO: Set warlord-teamID color to be a more "pale" shade of Architect's teamID color; or the same
	--Spring.SetTeamColor ( number teamID, number r, number g, number b )
	--return: nil


	--if coopHasEffect then
	--	GG.coopMode = true -- Inform other gadgets that coop needs to be taken into account
	--end


	----------------------------------------------------------------
	-- Synced Callins
	----------------------------------------------------------------

	---TODO: Everytime a unit finished by an architect is a factory, transfer it immediately to the warlord
	function gadget:UnitFinished(unitID, unitDefID, unitTeam)
		if not unitID or not Spring.ValidUnitID(unitID) then
			return end
		if not warlords[unitTeam] then
			return end
	end

	function gadget:GameFrame(n)
		--spawn cooped coms
		--if n==0 and GG.coopMode then
		--	--Spring.Echo('coop dbg7',to_string(coopStartPoints))
		--	for playerID, startPos in pairs(coopStartPoints) do
		--		local _, _, _, teamID, allyID = Spring.GetPlayerInfo(playerID)
		--		SpawnTeamStartUnit(playerID,teamID, allyID, startPos[1], startPos[3])
		--	end
		--end
	end
		

else
	
---

end

