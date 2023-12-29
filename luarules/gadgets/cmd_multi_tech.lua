
--[[
------------------------------------------------------------
		Tech Tree gadget
------------------------------------------------TechSlaveCommand------------
To make use of this gadget:
	Edit the FBI of your units, 
	adding RequireTech and ProvideTech tags
	in the CustomParams section of UnitInfo.
------------------------------------------------------------
Exemple of FBI declaring tech trees that would be managed by this gadget:

[UNITINFO]
{
	Name=Research Center;
	Unitname=searchlab;
	Description=Unlock new technologies;
	[CustomParams]
	{
		ProvideTech=SuperComputers, Exotic Alloys;
	}
	FootprintX=6;
	FootprintZ=6;
	MaxDamage=40000;
	....
}

[UNITINFO]
{
	Name=Stealth tank;
	Unitname=stlthtnk;
	Description=Made of absorbing material;
	[CustomParams]
	{
		RequireTech=Exotic Alloys;
	}
	FootprintX=3;
	FootprintZ=3;
	MaxDamage=8000;
	....
}

[UNITINFO]
{
	Name=Spatial Study Center;
	Unitname=spacelab;
	Description=Unlock spatial technologies;
	[CustomParams]
	{
		RequireTech=SuperComputers, Big-Rockets;
		ProvideTech=Satellite, Exotic Alloys;
	}
	FootprintX=8;
	FootprintZ=8;
	MaxDamage=30000;
	....
}

------------------------------------------------------------
As a bonus:
				Advanced users only!
	Sticking to the FBI should cover all your needs already.
------------------------------------------------------------
Other synced gadgets may access the four following functions:

	GG.TechSlaveCommand(commandID,requirements)
		Makes a command locked until all the techs in the string requirements are reached.
		Useful to lock commands that are not build commands.
		Cannot be used more than once on the same command.
		Exemple: GG.TechSlaveCommand(CMD.DGUN,"Heavy Weapons, Offensive Commander")
		Would make the D-Gun button locked until both "heavy weapons" and "offensive commander" technologies are reached.

	GG.TechCheckCommand(CommandID,TeamID)
		return true if the command is unlocked for the team
		return false if the command is locked for the team

	GG.TechCheck(TechName,TeamID)
		return nil if TechName is not a known technology
		return false if team has not reached the tech
		return true if team has reached the tech

	GG.TechGrant(TechName,TeamID)
		Makes a team get a tech for free

------------------------------------------------------------
Any widgets and gadgets, synced or unsynced, may use:

	Spring.GetTeamRulesParam(team,"technology:"..techname)
		Returns the number of unit providing access to a tech.
		Warning: techname must be lower case.

	For instance, assuming the mod use FBIs such as above,
	Spring.GetTeamRulesParam(Spring.GetMyTeamID(),"technology:exotic alloys")
	would return 0 at game start, and 5 after you finish
	three "Research Center" and two "Spatial Study Center".

	Note that: Spring.GetTeamRulesParam(team,"technology:"..techname)>=1
	Would return the same as GG.TechCheck(techname,team).
	Save that GG.TechCheck is limited to synced gadget,
	while Spring.GetTeamRulesParam is allowed in every lua.
------------------------------------------------------------
Those four functions and those TeamRules are only available
after the Initialize phase of gadgets. Check the layer value
in GetInfo if you need to call them in Initialize.
------------------------------------------------------------

Update: Disables the tech if the unit is deactivated, and vice-versa (by MaDDoX, 06/2022)

]]--

function gadget:GetInfo()
	return {
		name = "Tech Trees",
		desc = "Prerequisites",
		author = "zwzsg",
		date = "October 2009",
		license = "Public domain",
		layer = -10,
		enabled = true
	}
end

if (gadgetHandler:IsSyncedCode()) then

    VFS.Include("gamedata/taptools.lua")

	-- Variables
	local TechTable = {}        -- {[techId] = { name = techname, ProvidedBy={}, AccessTo={}, ProviderCount[team] = count}
	local ProviderUnits = {}    -- {[uDefId] = { techId1, ... }} || Which technologies are provided by each unitDef Id
	local TechLockedCmdIds = {} -- {[1] = cmdId, ... }            "AccessionIDs"
	local cmdIdRequirements = {}-- {[cmdId]  = { techId1, ... }}  "AccessionTable"
	local ProviderUdefIds = {}  -- {[1] = uDefId, ... }

	local LocalTechProviders = {} --{ uDefID = techname, ... }

	local OriDesc={}
	local GrantDesc={}
	local ReqDesc={}

	local spGetAllUnits = Spring.GetAllUnits
	local spSetTeamRulesParam = Spring.SetTeamRulesParam
	local spSetUnitRulesParam = Spring.SetUnitRulesParam
	local spGetUnitTeam = Spring.GetUnitTeam
	local spSetUnitTooltip = Spring.SetUnitTooltip
	local spGetTeamUnits = Spring.GetTeamUnits
	local spGetUnitDefID = Spring.GetUnitDefID
	local spFindUnitCmdDesc = Spring.FindUnitCmdDesc
	local spEditUnitCmdDesc = Spring.EditUnitCmdDesc
	local spGetUnitCmdDescs = Spring.GetUnitCmdDescs
	local spGetUnitRulesParam = Spring.GetUnitRulesParam

	local CMD_ONOFF = CMD.ONOFF

    local cyanTooltipColor = "\255\50\128\255"
    local redTooltipColor = "\255\255\64\64"
    local humanReadableNames = {["local:advanced"] = cyanTooltipColor.."Local: Advanced Morph",
                                ["enhancedtech"] = redTooltipColor.."Enhanced Tech",
                                ["advancedtech"] = redTooltipColor.."Advanced Tech",
                                ["mohotech"] = redTooltipColor.."Moho Tech", }

	local function SplitString(Line)
		local words={}
		local str=Line
		local delimiters={","}
		local whitespaces={" ","\t"}
		local function CharIs(char,charlist)
			for _,c in ipairs(charlist) do
				if char==c then
					return true
				end
			end
			return false
		end
		-- Find the delimiter, split at them
		while string.len(str)>0 do
			local cursor1=1
			while CharIs(string.sub(str,cursor1,cursor1),delimiters) and cursor1<=string.len(str) do
				cursor1=cursor1+1
			end
			local cursor2=cursor1
			while cursor2<=string.len(str) and not CharIs(string.sub(str,cursor2,cursor2),delimiters) do
				cursor2=cursor2+1
			end
			if cursor1<cursor2 then
				table.insert(words,string.sub(str,cursor1,cursor2-1))
			end
			str=string.sub(str,cursor2,-1)
		end
		-- Remove whitespaces at the start and end of every word. And cast to lowercase.
		for w,word in ipairs(words) do
			local cursor1=1
			while CharIs(string.sub(word,cursor1,cursor1),whitespaces) and cursor1<string.len(word) do
				cursor1=cursor1+1
			end
			local cursor2=string.len(word)
			while CharIs(string.sub(word,cursor2,cursor2),whitespaces) and cursor2>=1 do
				cursor2=cursor2-1
			end
			words[w]=string.lower(string.sub(word,cursor1,cursor2))
		end
		-- Remove empty words
		for w=#words,1,-1 do
			if string.len(words[w])<1 then
				table.remove(words,w)
			end
		end
		return words
	end

	local function isAdvBuildOption(cmdID)
		if cmdID == nil then
			return false end
		if isnumber(cmdID) and cmdID > 0 then	-- must be a 'build option' (negative cmdID)
			return false end
		local advanced = false
		local uDef = UnitDefs[-cmdID]
		if uDef.customParams and uDef.customParams.tier then
			local tier_number = tonumber(uDef.customParams.tier)
			--Spring.Echo("Tier found: "..(tier_number or "nil"))
			if tier_number and tier_number >= 2 then
				advanced = true
			end
		end
		return advanced
	end

	local function InitTechEntry(techname)
		if not TechTable[techname] then
			TechTable[techname]={name=techname,ProvidedBy={},AccessTo={},ProviderCount={}}
			for _,team in ipairs(Spring.GetTeamList()) do
				TechTable[techname].ProviderCount[team]=0
				spSetTeamRulesParam(team,"technology:"..techname,0)
			end
		end
	end

	local function CheckTech(techID, teamID, unitID, cmdID)
        if not isstring(techID) then
            return false end
		techID = string.lower(techID)


		-- TODO: Check for other local-upgrade (per-unit) requirement
		-- Check if the morph setting is an "anim-morph" (plays animation and unlocks adv. build options)
		if IsValidUnit(unitID) then
			if not isnumber(teamID) then
				teamID = spGetUnitTeam(unitID)
			end
			--local unitDef = UnitDefs[spGetUnitDefID(unitID)]
			--local animationonly = unitDef.customParams and (tonumber(unitDef.customParams.morphdef__animationonly) == 1)
			--Spring.Echo("Multi_tech: Checking for local tech "..techID.."; "..(animationonly and "TRUE" or "FALSE"))
			if techID == "local:advanced" and isAdvBuildOption(cmdID) then --and animationonly then
				--Spring.Echo("cmdID "..(cmdID or "nil") .." is adv: "..tostring(isAdvBuildOption(cmdID)))
				local localAdvUnitRule = spGetUnitRulesParam(unitID, "local:advanced")
				if tonumber(localAdvUnitRule) == 0 or localAdvUnitRule == nil then
					-- Spring.Echo("local advanced: FALSE")
					return nil
				else
					if tonumber(localAdvUnitRule) == 1 then
						--Spring.Echo("local advanced: TRUE")
						return true
					end
				end
			end
		end

		if not TechTable[techID] then
			--Spring.Echo("Check Tech: TechId=\""..techId.."\" is unknown")
			return nil end

        local providerCount = TechTable[techID].ProviderCount[teamID]
        if not providerCount then
            --Spring.Echo("Bad call to Check Tech (Provider Count error): TechName=\"".. techId .."\", Team=".. teamId)
            return nil
        else
            --Spring.Echo("[Tech Check] "..techID.." Provider count: "..providerCount)
            return providerCount >= 1
        end
	end

	local function CheckCmd(cmdId, teamId, unitID)
		-- If there are no requirements, always allow command
		local hasTechReqs = true
		if cmdIdRequirements[cmdId] then
            -- If any of the tech requirements is not met, return false
			for _, techId in ipairs(cmdIdRequirements[cmdId]) do
				if not CheckTech(techId, teamId, unitID, cmdId) then
					hasTechReqs = false
					break
				end
			end
		end
		return hasTechReqs
	end

	local function EditButtons(unitID, uDefId, teamID)

		-- Sub-functions
		local function GrantingToolTip(u,ucd,cmd)
			if not GrantDesc[cmd] then
				if not OriDesc[cmd] then
					OriDesc[cmd]=spGetUnitCmdDescs(u)[ucd].tooltip
				end
				GrantDesc[cmd]="\255\64\255\255Grants "..table.concat(ProviderUnits[-cmd],", ").."\n\255\255\255\255"..OriDesc[cmd]
			end
			return GrantDesc[cmd]
		end

		local function LockedToolTip(u,ucd,cmd)
            -- Initialize it in the cache if needed
			if not ReqDesc[cmd] then
                local str = "\255\255\64\64Requires "
				if not OriDesc[cmd] then    -- Store original description to local cache
					OriDesc[cmd]=spGetUnitCmdDescs(u)[ucd].tooltip end
				--str = str..table.concat(cmdIdRequirements[cmd],", ").."\n\255\255\255\255"..(GrantDesc[cmd] or OriDesc[cmd])
				for idx, techId in ipairs(cmdIdRequirements[cmd]) do
					--Spring.Echo("techID: "..(techId or "nil"))
					if humanReadableNames[techId] then
						str = str..humanReadableNames[techId]
					else
						str = str..techId
					end
					if idx < #cmdIdRequirements[cmd] then	-- don't add commas to the last element
						str = str..", "
					end
				end
				str = str.."\n\255\255\255\255"..(GrantDesc[cmd] or OriDesc[cmd])
				ReqDesc[cmd]=str
			end
			--Spring.Echo("cmd_mult_tech locked: "..(ReqDesc[cmd] or "nil"))
			return ReqDesc[cmd]
		end

		local function UnlockedToolTip(u,ucd,cmd)
			if not OriDesc[cmd] then
				OriDesc[cmd]=spGetUnitCmdDescs(u)[ucd].tooltip
			end
			--Spring.Echo("cmd_mult_tech unlocked: "..(OriDesc[cmd] or "nil"))
			return GrantDesc[cmd] or OriDesc[cmd]
		end

		-- Inits
		--local Grants=nil
		--local Requires=nil

		-- What is granted
		for _,ud in ipairs(ProviderUdefIds) do
			local UnitCmdDesc = spFindUnitCmdDesc(unitID,-ud)
			if UnitCmdDesc then
				spEditUnitCmdDesc(unitID,UnitCmdDesc,{ tooltip=GrantingToolTip(unitID,UnitCmdDesc,-ud)})
			end
		end

		-- What is required
		for _, cmdId in ipairs(TechLockedCmdIds) do
			local cmdDescId = spFindUnitCmdDesc(unitID, cmdId)
			if cmdDescId then
                --local cmdDesc = spGetUnitCmdDescs(unitID, cmdDescId, cmdDescId)[1]
				if CheckCmd(cmdId, teamID, unitID) then
					spEditUnitCmdDesc(unitID, cmdDescId,{ disabled=false, tooltip=UnlockedToolTip(unitID, cmdDescId, cmdId)})
				else
                    ---- TODO: Fix this silly last-minute workaround
                    --if dontAddDescription then
                    --    spEditUnitCmdDesc(u,UnitCmdDesc,{disabled=true})
                    --else
                    spEditUnitCmdDesc(unitID, cmdDescId,{ disabled=true, tooltip=LockedToolTip(unitID, cmdDescId, cmdId)})
                    --end
				end
			end
		end

	end

    -- ####################################
    -- # External Method (Eg.: GG.SlvCmd) #
    -- ####################################

	local function SlvCmd(cmdId, techReqList)
		local techReqs = SplitString(techReqList)
		if cmdIdRequirements[cmdId] then
			Spring.Echo("Slave Command Error: command ".. cmdId .." already tech-slaved")
			return false
		else
			cmdIdRequirements[cmdId]={}
			table.insert(TechLockedCmdIds, cmdId)   -- Watch out, this is evaluated using negatives
			for _,techname in ipairs(techReqs) do
				if not TechTable[techname] then
					Spring.Echo("Slave Command Error: TechName=\""..techname.."\" is unknown")
				else
					table.insert(TechTable[techname].AccessTo, cmdId)
					table.insert(cmdIdRequirements[cmdId],techname)
				end
			end
			-- Edit buttons of existing units:
			for _,u in ipairs(spGetAllUnits()) do
				local UnitCmdDesc = spFindUnitCmdDesc(u, cmdId)
				if UnitCmdDesc then
					EditButtons(u,spGetUnitDefID(u),spGetUnitTeam(u))
				end
			end
			return true
		end
	end

	local function RevokeTech(TechName, teamId)
		TechName=string.lower(TechName)
		if not TechTable[TechName] then
			Spring.Echo("Bad call to Revoke Tech: TechName=\""..TechName.."\" is unknown")
			return nil
        else
            if not TechTable[TechName].ProviderCount[teamId] then
                Spring.Echo("Bad call to Check Tech: TechName=\""..TechName.."\", Team=".. teamId)
                return false
            else
                TechTable[TechName].ProviderCount[teamId]=0
                spSetTeamRulesParam(teamId,"technology:"..TechName,0)
                for _,u in ipairs(spGetTeamUnits(teamId)) do
                    EditButtons(u, spGetUnitDefID(u), teamId)
                end
                return true
            end
        end
	end

	-- Init = force initialization, useful for non-unit based allowance
	local function GrantTech(TechName, Team, Init)
		TechName=string.lower(TechName)
		if Init then
			InitTechEntry(TechName)
		end
		if not TechTable[TechName] then
			Spring.Echo("Bad call to Grant Tech: TechName=\""..TechName.."\" is unknown")
			return nil
		else
			if not TechTable[TechName].ProviderCount[Team] then
				Spring.Echo("Bad call to Check Tech: TechName=\""..TechName.."\", Team="..Team)
				return false
			else
				TechTable[TechName].ProviderCount[Team]=math.huge
				spSetTeamRulesParam(Team,"technology:"..TechName,TechTable[TechName].ProviderCount[Team])
				for _,u in ipairs(spGetAllUnits()) do
					EditButtons(u,spGetUnitDefID(u),spGetUnitTeam(u))
				end
				return true
			end
		end
	end

	-- Init = force initialization, useful for non-unit based allowance
	local function GrantLocalTech(techname, unitID)
		techname = string.lower(techname)
		spSetUnitRulesParam(unitID,"local:"..techname, 1)
		EditButtons(unitID,spGetUnitDefID(unitID),spGetUnitTeam(unitID))
		return true
	end

	local function RefreshTechReqs(unitID, unitDef)
		--Spring.Echo("RefreshTechReqs")
		EditButtons(unitID, unitDef, spGetUnitTeam(unitID))
	end

	local function isComplete(u)
		local health,maxHealth,paralyzeDamage,captureProgress,buildProgress=Spring.GetUnitHealth(u)
		return (buildProgress and buildProgress>=1)
	end

	local function UnitGained(unitId, uDefId, teamId)
		if not isComplete(unitId) then
			return	end
		EditButtons(unitId, uDefId, teamId)
		-- Grant Local Tech
		--Spring.Echo("Local Tech Provision for "..unitId..": "..(LocalTechProviders[uDefId] or "Nil"))
		if LocalTechProviders[uDefId] == "advanced" then --TODO: techname
			spSetUnitRulesParam(unitId,"local:"..LocalTechProviders[uDefId], 1)
			EditButtons(unitId, uDefId, teamId)							 -- only needs to edit its own buttons
		end
		if ProviderUnits[uDefId] then
			for _,tech in ipairs(ProviderUnits[uDefId]) do
                local newCount = TechTable[tech].ProviderCount[teamId]+1
				TechTable[tech].ProviderCount[teamId] = newCount
				spSetTeamRulesParam(teamId,"technology:"..tech, newCount)
			end
			for _, teamUnit in ipairs(spGetTeamUnits(teamId)) do
				EditButtons(teamUnit,spGetUnitDefID(teamUnit), teamId)
			end
		end
	end

	local function UnitLost(unitId, uDefId, teamId)
        --Spring.Echo("cmd_multi_tech unit lost: "..(unitId or "nil"))
		if isComplete(unitId) and ProviderUnits[uDefId] then
			for _,tech in ipairs(ProviderUnits[uDefId]) do
                local newCount = TechTable[tech].ProviderCount[teamId]-1
				TechTable[tech].ProviderCount[teamId] = newCount
				spSetTeamRulesParam(teamId,"technology:"..tech,newCount)
                --Spring.Echo("cmd_multi_tech "..tech.." tech provider count: "..newCount)
			end
			for _, thisUnit in ipairs(spGetTeamUnits(teamId)) do
				EditButtons(thisUnit, spGetUnitDefID(thisUnit), teamId)
			end
		end
	end

	function gadget:UnitCreated(u, uDefId, team)
		EditButtons(u, uDefId,team)
		if ProviderUnits[uDefId] then
			spSetUnitTooltip(u,"\255\64\255\255Provides "..table.concat(ProviderUnits[uDefId],", ").."\n\255\255\255\255"..Spring.GetUnitTooltip(u))
		end
	end

	function gadget:UnitFinished(u,ud,team)
		UnitGained(u,ud,team)
	end

	function gadget:UnitDestroyed(u,ud,team)
		UnitLost(u,ud,team)
	end

	function gadget:UnitGiven(u,ud,team,oldteam)
		UnitGained(u,ud,team)
	end

	function gadget:UnitTaken(u,ud,team,newteam)
		UnitLost(u,ud,team)
	end

	-- Disables the tech if the unit is deactivated, and vice-versa
	function gadget:UnitCommand(unitID, unitDefID, unitTeam, cmdID, cmdOpts, cmdParams) --, cmdTag)
		if cmdID == CMD_ONOFF then
			if cmdParams then
				if cmdOpts[1] == 0 then -- DEACTIVATE
					UnitLost(unitID, unitDefID, unitTeam)
				elseif cmdOpts[1] == 1 then -- ACTIVATE
					UnitGained(unitID, unitDefID, unitTeam)
				end
			end
			--Spring.GiveOrderToUnit(unitID, CMD.WAIT, {}, {})
		end
	end

	function gadget:AllowCommand(unitID, ud, team, cmdId, param, opt, synced)
		return CheckCmd(cmdId, team, unitID)
	end

	function gadget:AllowUnitCreation(uDefId, builderID, team, x, y, z)
		return CheckCmd(-uDefId, team, builderID)  -- build commands are -1 * the uDefId
	end

	function gadget:Initialize()
		ReqDesc = {}
		OriDesc = {}
		for _, uDef in pairs(UnitDefs) do
			local cparms = uDef.customParams
			if cparms then
				local techProvided = cparms.providestech or cparms.providetech
				local techRequired = cparms.requirestech or cparms.requiretech --or cparms.morphdef.require
				if techProvided then
					local providedTechs = SplitString(techProvided)
					ProviderUnits[uDef.id]={}
					table.insert(ProviderUdefIds, uDef.id)
					for _, techname in ipairs(providedTechs) do
						--TODO: Support different local:xxx upgrades
						if techname == "local:advanced" then
							--Spring.Echo("local tech provision detected")
							local _, colonPos = string.find(techname, ":") -- Returns the index
							local localTechName = string.sub(techname, colonPos + 1) -- Takes the position after the colon
							LocalTechProviders[uDef.id] = localTechName
						else
							InitTechEntry(techname)
							table.insert(TechTable[techname].ProvidedBy, uDef.id)
							table.insert(ProviderUnits[uDef.id],techname)
						end
					end
				end
				--TODO: Edit here for local upgrades support
				if techRequired then
					local techReqs = SplitString(techRequired)
					cmdIdRequirements[-uDef.id] = {}
					table.insert(TechLockedCmdIds,-uDef.id)
					for _, techname in ipairs(techReqs) do
						InitTechEntry(techname)
						table.insert(TechTable[techname].AccessTo,-uDef.id)
						table.insert(cmdIdRequirements[-uDef.id],techname)
					end
				end
			end
		end

        --local msg=nil
        --for _,tech in pairs(TechTable) do
        --    msg=(msg and (msg..", ") or "")..tech.name
        --end
        --msg="\""..gadget:GetInfo().name.."\" gadget"..(msg and (" managing the technologies: "..msg..".") or " found no technology to manage.")
        --Spring.Echo(msg)

		GG.TechInit=InitTechEntry
        GG.TechSlaveCommand=SlvCmd
		GG.TechCheckCommand=CheckCmd
		GG.TechCheck=CheckTech
		GG.TechGrant=GrantTech
		GG.TechRevoke=RevokeTech
		GG.RefreshTechReqs=RefreshTechReqs
		GG.GrantLocalTech=GrantLocalTech

	end

end
