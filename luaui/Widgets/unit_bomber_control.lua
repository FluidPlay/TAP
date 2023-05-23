function widget:GetInfo()
	return {
		name	= "Bomber control",
		desc	= "Makes bombers snap to enemy target near click if any, or 'fight' to position.",
		author	= "dizekat",
		date	= "2010-02-04",
		license	= "GPL v2 or later",
		layer	= 5,
		enabled	= true,
	}
end

--fixed for 0.83 (by vbs)

--local bombers={armpnix=true, armliche=true, corstil=true, armthund=true, armsb=true, corhurc=true, corshad=true, cortitan=true}
local bomber_uds = {}
local bombersToSnapAttack = {}

local spGetUnitWeaponState = Spring.GetUnitWeaponState
local spGetUnitDefID = Spring.GetUnitDefID
local GiveOrderToUnit      = Spring.GiveOrderToUnit
local GetGameFrame         = Spring.GetGameFrame
local spGetMyTeamID = Spring.GetMyTeamID
local spGetUnitTeam = Spring.GetUnitTeam
local spGetGameFrame = Spring.GetGameFrame
local GetCommandQueue      = Spring.GetCommandQueue
local GetUnitStates        = Spring.GetUnitStates
local spGetActionHotKeys = Spring.GetActionHotKeys
local spSendCommmands = Spring.SendCommands
local spGiveOrderToUnit = Spring.GiveOrderToUnit
local spGetSelectedUnits = Spring.GetSelectedUnits
local spGetUnitAllyTeam = Spring.GetUnitAllyTeam
local spGetUnitsInCylinder = Spring.GetUnitsInCylinder
local spGetUnitPosition = Spring.GetUnitPosition
local spGetUnitDefID = Spring.GetUnitDefID
local spGetUnitRulesParam = Spring.GetUnitRulesParam
local spValidUnitID = Spring.ValidUnitID

local myAllyTeam = Spring.GetMyAllyTeamID()
local my_bombers={}
--local targetSetUnits = {}
local snapRadius = 200
local updateRate = 2

local CMD_OPT_INTERNAL = CMD.OPT_INTERNAL
local CMD_REMOVE = CMD.REMOVE
local CMD_INSERT = CMD.INSERT
local CMD_ATTACK = CMD.ATTACK
local CMD_FIGHT = CMD.FIGHT
local CMD_STOP = CMD.STOP
local CMD_UNIT_SET_TARGET = 34923
local CMD_UNIT_CANCEL_TARGET = 34924
local CMD_OPT_RIGHT = CMD.OPT_RIGHT

-- de-generalized from taptools.lua
local function sqrDistance(x1,z1,x2,z2)
	if not x1 or not z1 or not x2 or not z2 then
		return 9999999 end
	local dx,dz = x1-x2,z1-z2
	return dx*dx + dz*dz
end

local function isBomber(unitID, uDef)
	if not uDef then
		uDef = UnitDefs[spGetUnitDefID(unitID)] end
	return uDef.customParams and uDef.customParams.tedclass and uDef.customParams.func == "bomber"
end

local function AddUnit(unit_id, unit_udid_)
	local unit_udid = unit_udid_
	if not spGetUnitTeam(unit_id) == spGetMyTeamID() then --my unit
		return end
	if unit_udid == nil then
		unit_udid = spGetUnitDefID(unit_id)
	end
	local ud = UnitDefs[unit_udid]
	if ud and isBomber(unit_id, ud) then --bomber_uds[unit_udid]
		if  ud.primaryWeapon then
			local _,reloaded_,reloadFrame_ = spGetUnitWeaponState(unit_id,ud.primaryWeapon)
			my_bombers[unit_id]={reloaded=reloaded_, reloadFrame=reloadFrame_}
			--Spring.Echo("bomber added")
		end
	end
end

local function AssignSetTarget(targetUID, options)
	if options == nil then
		options = {} end
	for _,unitID in ipairs(spGetSelectedUnits()) do
		if isBomber(unitID) then
			spGiveOrderToUnit(unitID, CMD_UNIT_SET_TARGET, { targetUID }, options)
		end
	end
end

function widget:UnitCreated(unit_id, unit_udid, unit_tid)
	if unit_tid==Spring.GetMyTeamID() then
		AddUnit(unit_id,unit_udid)
	end
end

local function RemoveUnit(unit_id)
	my_bombers[unit_id]=nil
end

function widget:UnitDestroyed(unit_id, unit_udid, unit_tid)
	RemoveUnit(unit_id)
end


function widget:UnitGiven(unit_id, unit_udid, old_team, new_team)
	RemoveUnit(unit_id)
	if new_team== spGetMyTeamID() then
		AddUnit(unit_id,unit_udid)
	end	
end


local function UpdateUnitsList()
	local my_team= spGetMyTeamID()
	my_bombers={}
	for _,unit_id in ipairs(Spring.GetTeamUnits(my_team)) do
		AddUnit(unit_id,nil)
	end
end

function removeSelfCheck()
    if Spring.GetSpectatingState() and (Spring.GetGameFrame() > 0 or gameStarted) then
        widgetHandler:RemoveWidget(self)
    end
end

local function hasAmmo(unitID)
	local unitammo = tonumber(spGetUnitRulesParam(unitID, "ammo"))
	if not unitammo then
		return false end
	--spEcho("ammo: "..(tostring(unitammo) or "nil"))
	return unitammo > 0
end

function widget:GameStart()
    gameStarted = true
    removeSelfCheck()
end

function widget:PlayerChanged(playerID)
    removeSelfCheck()
end

function widget:Initialize()
    if Spring.IsReplay() or Spring.GetGameFrame() > 0 then
        removeSelfCheck()
    end
	for i,ud in pairs(UnitDefs) do
		if isBomber(_, ud) then --bombers[ud.name]
			bomber_uds[i]=ud
			--bomber_uds[i]=true
			ud.reloadTime    = 0
			ud.primaryWeapon = 0
			ud.shieldPower   = 0
			for i=1,#ud.weapons do
				local WeaponDefID = ud.weapons[i].weaponDef;
				local WeaponDef   = WeaponDefs[ WeaponDefID ];
				if (WeaponDef.reload>ud.reloadTime) then
					ud.reloadTime    = WeaponDef.reload;
					ud.primaryWeapon = i;
				end
			end
		end
	end
	UpdateUnitsList()
end

local current_team

---#SNAP# If enemy unit is within cylinder/radius of clicked position, assign it as target
local function snapAttackCommand(params, options)
	--DebugTable(params)
	local click = { x = params[1], y = params[2], z = params[3] }
	local minSqrDist = 999999999 -- sqrDists usually have 8 digits or more.. :o
	local nearestEnemyID = nil
	local unitsAroundClick = spGetUnitsInCylinder(click.x, click.z, snapRadius)
	--Spring.Echo("Units nearby found: "..#unitsAroundClick)
	for _, nearbyUnitID in ipairs(unitsAroundClick) do
		if spGetUnitAllyTeam(nearbyUnitID) ~= myAllyTeam then -- It's an enemy Unit
			local eUnitPos = {}
			eUnitPos.x, _, eUnitPos.z = spGetUnitPosition(nearbyUnitID)
			local sqrDist = sqrDistance(click.x, click.z, eUnitPos.x, eUnitPos.z)
			if (sqrDist < minSqrDist) then
				nearestEnemyID = nearbyUnitID
				minSqrDist = sqrDist
			end
		end
	end
	if (nearestEnemyID) then
		--Spring.Echo("Snapped to: ".. nearestEnemyID)
		for _,selUnitID in ipairs(spGetSelectedUnits()) do
			if isBomber(selUnitID) then
				-- new attack orders can only be issued next frame, so we store this for later (in widget:Update)
				bombersToSnapAttack[selUnitID] = { nearestEnemyID=nearestEnemyID, updateFrame=spGetGameFrame()+1 }
				spGiveOrderToUnit(selUnitID, CMD_UNIT_SET_TARGET, { nearestEnemyID }, options)
			end
		end
		--for _,selUnitID in ipairs(spGetSelectedUnits()) do
		--	if isBomber(selUnitID) then
		--		Spring.Echo("Sel: "..selUnitID)
		--		--spGiveOrderToUnit(selUnitID, CMD_REMOVE, {CMD_ATTACK}, {"alt"})
		--		--spGiveOrderToUnit(selUnitID, CMD_ATTACK, nearestEnemyID, { "alt" })
		--		--spGiveOrderToUnit(selUnitID, CMD_INSERT, {-1, CMD_ATTACK, CMD_OPT_INTERNAL+1, nearestEnemyID}, {"alt"})
		--	end
		--end
	end

	---TODO: After firing, remove setTarget
end

function widget:CommandNotify(id, params, options)
	if id == CMD_ATTACK then
		if #params == 1 then   	-- Targeted one UnitID
			return				-- So, let it be.
			--AssignSetTarget(params[1], options)
		else                   -- Targetted ground position
			snapAttackCommand(params, options)
		end
	end
end

function widget:Update(dt)
	local gameFrame = spGetGameFrame()
	if ((gameFrame%15)<1) then
		local my_team = spGetMyTeamID()
		if my_team ~= current_team then
			current_team = my_team
			UpdateUnitsList()
		end
	end

	if gameFrame%updateRate > 0.001 then
		return end

	for bomberID, data in pairs(bombersToSnapAttack) do
		if gameFrame >= data.updateFrame then
			local nearestEnemyID = data.nearestEnemyID
			if spValidUnitID(bomberID) and spValidUnitID(nearestEnemyID) then
				spGiveOrderToUnit(bomberID, CMD_ATTACK, nearestEnemyID, { "alt" })
			end
			bombersToSnapAttack[bomberID] = nil
		end
	end
	--- Below is obsolete for TAP, it's only useful for *TA clones and no-reload bombers
	--if ((gameFrame%3)<1) then
	--	for bomber_id,bomber_data in pairs(my_bombers) do
	--	    local udid = GetUnitDefID(bomber_id)
	--		local ud = UnitDefs[udid or -1]
	--		if ud and ud.primaryWeapon then
	--			local _,reloaded,reload_frame = GetUnitWeaponState(bomber_id, ud.primaryWeapon)
	--			local did_shot=(bomber_data.reloaded and not reloaded) or (bomber_data.reload_frame~=reload_frame)
	--			bomber_data.reloaded=reloaded
	--			bomber_data.reload_frame=reload_frame
	--			if did_shot then
	--				local commands=GetCommandQueue(bomber_id,50)
	--				if commands and commands[1] and commands[1].id==CMD.ATTACK and commands[2] then
	--					--Spring.Echo(CMD[commands[2].id])
	--					GiveOrderToUnit(bomber_id, CMD.REMOVE,{commands[1].tag},{})
	--					local states=GetUnitStates(bomber_id)
	--					if states and (states['repeat']) then
	--						GiveOrderToUnit(bomber_id, commands[1].id,commands[1].params,{'shift'})
	--					end
	--				end
	--			end
	--		end
	--	end
	--end
end

