--local base, link0, link1, link2, link3, link4, arm1, arm2, arm3, arm4, thrust1, thrust2 = piece('base', 'link0', 'link1', 'link2', 'link3', 'link4', 'arm1', 'arm2', 'arm3', 'arm4', 'thrust1', 'thrust2')

local justcreated = false
local statechg_DesiredState, statechg_StateChanging
local level = 1

local Explode = Spring.UnitScript.Explode
local sfxShatter = SFX.SHATTER
local sfxBITMAPONLY = 32    --https://github.com/Balanced-Annihilation/Balanced-Annihilation/blob/master/scripts/exptype.h
local sfxBITMAP1 = 256
local sfxBITMAP2 = 512
local sfxBITMAP3 = 1024
local sfxBITMAP4 = 2048
local sfxBITMAP5 = 4096
local sfxFall = SFX.FALL
local sfxFire = SFX.FIRE
local sfxSmoke = SFX.SMOKE
local sfxExplodeOnHit = SFX.EXPLODE_ON_HIT

local sleepPerFrame = 1/30 -- Anim FPS = 30 by default
local keyframeDelta = 4   -- How frequently the lerp is updated
local sleepTime = sleepPerFrame * keyframeDelta		-- 133.3333 == 4 frames (1f = 0.325)

local pieceValue = {}

VFS.Include("gamedata/taptools.lua")
VFS.Include("scripts/include/springtweener.lua")

local topSpinAngle = 35

--- Animations-begin =======================================

local Base, Top, LeafN, LeafNTip, LeafNE, LeafNETip, LeafNW, LeafNWTip, LeafS, LeafSTip, LeafSE, LeafSETip, LeafSW, LeafSWTip =
    piece('Base', 'Top', 'LeafN', 'LeafNTip', 'LeafNE', 'LeafNETip', 'LeafNW',
          'LeafNWTip', 'LeafS', 'LeafSTip', 'LeafSE', 'LeafSETip', 'LeafSW', 'LeafSWTip')

--1 = x axis, 2 = y axis, 3 = z axis

--pieceValue[Top] = { ["move"] = {[1] = 0, [2] = 0, [3] = 0}, ["turn"] = {[1] = 0, [2] = 0, [3] = 0},}
--pieceValue[Base] = { ["move"] = {[1] = 0, [2] = 0, [3] = 0}, ["turn"] = {[1] = 0, [2] = 0, [3] = 0},}
--pieceList["Top"] = Top

local scriptEnv = { Base = Base,
                    Top = Top,
                    LeafN = LeafN,
                    LeafNTip = LeafNTip,
                    LeafNE = LeafNE,
                    LeafNETip = LeafNETip,
                    LeafNE = LeafNE,
                    LeafNETip = LeafNETip,
                    LeafNW = LeafNW,
                    LeafNWTip = LeafNWTip,
                    LeafS = LeafS,
                    LeafSTip = LeafSTip,
                    LeafSE = LeafSE,
                    LeafSETip = LeafSETip,
                    LeafSW = LeafSW,
                    LeafSWTip = LeafSWTip,
                    -- rad = math.rad
                    x_axis = x_axis,
                    y_axis = y_axis,
                    z_axis = z_axis,
                    --
                    Turn = Turn,
                    Move = Move,
                    Sleep = Sleep,
}

local PlayAnimation = VFS.Include("scripts/animations/kernsolar_anim.lua", scriptEnv)

function constructSkeleton(unit, piece, offset)
	if (offset == nil) then
		offset = {0,0,0};
	end

	local bones = {};
	local info = Spring.GetUnitPieceInfo(unit,piece);

	for i=1,3 do
		info.offset[i] = offset[i]+info.offset[i];
	end

	bones[piece] = info.offset;
    -- return: { string "piecename1" = number pieceNum1, ... , string "piecenameN" = number pieceNumN }
	local map = Spring.GetUnitPieceMap(unit);
	local children = info.children;

	if (children) then
		for i, childName in pairs(children) do
			local childId = map[childName];
			local childBones = constructSkeleton(unit, childId, info.offset);
			for cid, cinfo in pairs(childBones) do
				bones[cid] = cinfo;
			end
		end
	end
	return bones;
end

--local animCmd = {['turn']=Turn,['move']=Move};

-----piece, axis, destination, speed
--local function PlayAnimation(animname)
--	local anim = Animations[animname];
--	for i = 1, #anim do
--		local commands = anim[i].commands;
--		for j = 1,#commands do
--			local cmd = commands[j];
--			--Spring.Echo("Has cmd: "..(cmd and "yes" or "no").." | cmd,piece,axis,time,s: "..(cmd.c or "nil").." "
--			--        ..(cmd.p or "nil").." "..(cmd.a or "nil").." "..(cmd.t or "nil").." "..(cmd.s or "nil"))
--			local t = cmd.t
--			if cmd.a == x_axis then
--				t = -t
--			--elseif cmd.a == y_axis then --else
--			--    t = -2*t
--			elseif cmd.a == z_axis then
--				t = -t
--			end
--			animCmd[cmd.c](cmd.p,cmd.a,t,cmd.s);
--		end
--		if(i < #anim) then
--			local t = anim[i+1]['time'] - anim[i]['time'];
--			Sleep(t*33); -- sleep works on milliseconds
--		end
--	end
--end


--- Animations-end ============================================

local function activatescr()
	---Play Animation "Open"

	--Spring.Echo("Level: "..level.." justcreated: "..tostring(justcreated))
	--- If we just morphed into this guy, insta-set pieces under the current level
	--if level > 1 and justcreated then
	--    Turn( post1 , z_axis, 0 ) --x_axis
	--    Turn( post2 , z_axis, 0 ) --x_axis
	--    Turn( post3 , x_axis, 0 ) --z_axis
	--    Turn( post4 , x_axis, 0 ) --z_axis
	--    Move ( light1 , x_axis, 0 ) Move ( light2 , x_axis, 0 )
	--    Move ( light3 , z_axis, 0 ) Move ( light4 , z_axis, 0 )
	--    --
	--    Turn ( post1 , z_axis, radians(90))
	--    Move ( light1 , x_axis, 13.800000)
	--elseif level >= 1 then
	--    Turn ( post1 , z_axis, radians(90), radians(82.329670) ) --x_axis -90.236264
	--    Sleep (1096)
	--    Move ( light1 , x_axis, 13.800000 , 18.03424 ) --z_axis 2, 1.803
	--end

	if justcreated then
		justcreated = false
	end

	SetUnitValue(COB.ARMORED, 0) --set ARMORED to 0

	Sleep(1109)
end

local function deactivatescr()
	---Play animation "close"

	--if level >=1 then
	--    Turn ( post1, z_axis, radians(90) ) --x_axis
	--    Move ( light1, x_axis, 13.800000 ) --z_axis - 2
	--    Move ( light1, x_axis, 0.000000 , 16.58368 ) -- z_axis 0
	--    Sleep(1206)
	--    Turn ( post1, z_axis, radians(0), radians(73.961538) ) --x_axis
	--end
	----
	--if level >= 2 then
	--    Turn ( post4, x_axis, radians(90.236264) ) --z_axis 90
	--    Move ( light4, z_axis, -12.500000  )  --x_axis 1.9
	--    Move ( light4, z_axis, -0.000000 , 15.75452 ) --x_axis 0, 1.575452
	--    Sleep(1206)
	--    Turn ( post4, x_axis, radians(-(0.000000)), radians(73.961538) ) --z_axis
	--end

	Sleep(1220)
	SetUnitValue(COB.ARMORED, 1) --set ARMORED to 1
end

--local function setlevel(newlevel)
--    level = newlevel
--end
--local scriptEnv = {	Base = Base,
--                    SolarLeafBotNE = SolarLeafBotNE,
--                    SolarLeafBotNETip = SolarLeafBotNETip,
--                    SolarLeafBotNW = SolarLeafBotNW,
--                    SolarLeafBotNWTip = SolarLeafBotNWTip,
--                    SolarLeafBotS = SolarLeafBotS,
--                    SolarLeafBotSTip = SolarLeafBotSTip,
--                    SolarTop = SolarTop,
--                    x_axis = x_axis,
--                    y_axis = y_axis,
--                    z_axis = z_axis,
--                     --test_upspring_pivots.s3o.SpringHeight = test_upspring_pivots.s3o.SpringHeight,
--                     --test_upspring_pivots.s3o.SpringRadius = test_upspring_pivots.s3o.SpringRadius,
--                   }

--VFS.Include("scripts/animations/corsolar_anim.lua", scriptEnv)

local function SmokeUnit(healthpercent, sleeptime, smoketype)
	while GetUnitValue(COB.BUILD_PERCENT_LEFT) do --while get BUILD_PERCENT_LEFT do
		Sleep (500)
	end
	while true do
		local healthpercent = GetUnitValue(COB.HEALTH)  --get HEALTH
		if  healthpercent < 66 then
			smoketype = 258
			if math.random(1, 66) < healthpercent  then
				smoketype = 257 end
			EmitSfx (Base, smoketype)
		end
		sleeptime = healthpercent * 50
		if  sleeptime < 200  then
			sleeptime = 200
		end
		Sleep(sleeptime)
	end
end

local function SpinTop()
    if not GetUnitValue(COB.ACTIVATION) then
        return
    end
    --LerpPiece(Top, "turn", z_axis, math.rad(45), 0.25) -- final angle, interpolator (t)
    --LerpPiece(Top, "turn", z_axis, math.rad(-45), 0.25) -- final angle, interpolator (t)

    --tweenPiece(Top, "turn", z_axis, math.rad(topSpinAngle), 5, inOutCubic)
    --tweenPiece(Top, "turn", z_axis, math.rad(-topSpinAngle), 5, inOutCubic)
    initTween({ veryLastFrame = 5*30, --sleepTime = sleepTime,
                [Top] = { [1] = { cmd = "turn", targetValue = math.rad(topSpinAngle),
                         axis = z_axis, easingFunction = "inOutCubic", firstFrame = 0, lastFrame = 150,}
                       },
                --[2] = { pieceID = Base, cmd = "turn", targetValue = math.rad(90),
                --        axis = y_axis, easingFunction = "inOutCubic", firstFrame = 2*30, lastFrame = 4*30,
                --       },
                } )
    initTween({ veryLastFrame = 5*30, --sleepTime = sleepTime,
                [Top] = { [1] = { cmd = "turn", targetValue = math.rad(-topSpinAngle),
                        axis = z_axis, easingFunction = "inOutCubic", firstFrame = 0, lastFrame = 150,}
                },
                --[2] = { pieceID = Base, cmd = "turn", targetValue = math.rad(-90),
                --        axis = y_axis, easingFunction = "inOutCubic", firstFrame = 2*30, lastFrame = 4*30,
                --       },
                } )

    SpinTop()
end

local function StopTopSpin()
    --Turn(Top, z_axis, 0.000000, 0.3 )
    --LerpPiece(Top, "turn", z_axis, math.rad(0), 0.5) -- final angle, interpolator (t)

    --tweenPiece(Top, "turn", z_axis, math.rad(0), 1.25, inOutCubic)
    initTween({ veryLastFrame = 1.5*30, sleepTime = sleepTime,
                [Top] = { [1] = { cmd = "turn", targetValue = 0,
                        axis = z_axis, easingFunction = "inOutCubic", firstFrame = 0, lastFrame = 1.5*30,}
                },
        --[2] = { pieceID = Base, cmd = "turn", targetValue = math.rad(90),
        --        axis = y_axis, easingFunction = inOutCubic
        --       },
    })
end

local function RequestState(requestedstate, currentstate)
	if  statechg_StateChanging then
		statechg_DesiredState = requestedstate
		return (0)
	end
	statechg_StateChanging = true
	currentstate = statechg_DesiredState
	statechg_DesiredState = requestedstate
	while  statechg_DesiredState ~= currentstate  do
		if  statechg_DesiredState == 1  then
			deactivatescr()
			currentstate = 1
		else
			activatescr()
			currentstate = 0
		end
	end
	statechg_StateChanging = false
end

function script.Create()
    local unitDefID = UnitDefs[unitDefID].name
    if unitDefID == "corsolar" then
        level = 1
    elseif unitDefID == "coradvsol" then
        level = 2
    end

	justcreated = true
	statechg_DesiredState = 1 --true
	statechg_StateChanging = false
	StartThread(SmokeUnit)
end

local function OpenCloseAnim(open)
	Signal(1) -- Kill any other copies of this thread
	SetSignalMask(1) -- Allow this thread to be killed by fresh copies
	if open then
		-- PlayAnimation('open')   --from corsolar_anim.lua
        PlayAnimation.openstd() --'closestd, openadv, closeadv'
        if level >= 2 then
            PlayAnimation.openadv() --'closestd, openadv, closeadv'
        end
        Sleep(3500)
        StartThread(SpinTop)
    else
        StartThread(StopTopSpin)
        PlayAnimation.closestd()
        if level >= 2 then
            PlayAnimation.closeadv() --'closestd, openadv, closeadv'
        end
    end
    SetUnitValue(COB.ARMORED, open)
	-- SetUnitValue(COB.INBUILDSTANCE, open)
	-- SetUnitValue(COB.BUGGER_OFF, open)
end

function script.Activate()
	StartThread(RequestState, 0)
	StartThread(OpenCloseAnim, true)
end

function script.Deactivate()
	StartThread(RequestState, 1)
	StartThread(OpenCloseAnim, false)
end

--called whenever construction begins.
function script.StartBuilding(heading, pitch)
	--Signal(SIG_BUILD)
	--SetSignalMask(SIG_BUILD)
	--SetUnitValue(COB.INBUILDSTANCE, 1)
	--return 1
end

function script.StopBuilding()
	--Signal(SIG_BUILD)
	--SetSignalMask(SIG_BUILD)
	--SetUnitValue(COB.INBUILDSTANCE, 0)
	--Sleep(1)
	--return 0
end

function script.QueryBuildInfo ( )
	return Base
end

local function WasHit()
	while GetUnitValue(COB.BUILD_PERCENT_LEFT) do
		Sleep(500)
	end
	Signal(2)
	SetSignalMask(2)
	script.SetUnitValue(COB.ACTIVATION, 0)      --ACTIVATION = 0
	Sleep (8000)
	script.SetUnitValue(COB.ACTIVATION, 1)      --ACTIVATION = 1
end

function script.HitByWeapon(Func_Var_1, Func_Var_2)
	StartThread(WasHit)
end

function SweetSpot(piecenum)
	piecenum = Base
end

-- script.Killed ( number recentDamage, number maxHealth )
function script.Killed(recentDamage, maxHealth)
	local corpsetype = 3
	local severity = recentDamage / maxHealth * 100
	--Spring.Echo(" Death Severity: "..severity)

	if  severity <= 25  then
		corpsetype = 1
		Explode( Base, sfxBITMAPONLY + sfxBITMAP1)
		Explode( Top, sfxBITMAPONLY + sfxBITMAP2)
		Explode( LeafNE, sfxBITMAPONLY + sfxBITMAP3)
		Explode( LeafNETip, sfxBITMAPONLY + sfxBITMAP4)
		Explode( LeafNW, sfxBITMAPONLY + sfxBITMAP5)
		Explode( LeafNWTip, sfxBITMAPONLY + sfxBITMAP1)
		Explode( LeafS, sfxBITMAPONLY + sfxBITMAP2)
		Explode( LeafSTip, sfxBITMAPONLY + sfxBITMAP3)
		--Explode( post3, sfxBITMAPONLY + sfxBITMAP4)
		--Explode( post4, sfxBITMAPONLY + sfxBITMAP5)
		return (corpsetype)
	end
	if  severity <= 50  then
		corpsetype = 2
		Explode( Base, sfxBITMAPONLY + sfxBITMAP1)
		Explode( Top, sfxFall + sfxBITMAP2)
		Explode( LeafNE, sfxFall + sfxBITMAP3)
		Explode( LeafNETip, sfxFall + sfxBITMAP4)
		Explode( LeafNW, sfxFall + sfxBITMAP5)
		Explode( LeafNWTip, sfxFall + sfxBITMAP1)
		Explode( LeafS, sfxShatter + sfxBITMAP2)
		Explode( LeafSTip, sfxBITMAPONLY + sfxBITMAP3)
		--Explode( post3, sfxBITMAPONLY + sfxBITMAP4)
		--Explode( post4, sfxBITMAPONLY + sfxBITMAP5)
		return (corpsetype)
	end
	if  severity <= 99  then
		corpsetype = 3
		Explode( Base, sfxBITMAPONLY + sfxBITMAP1)
		Explode( Top, sfxFall + sfxFire + sfxSmoke + sfxExplodeOnHit + sfxBITMAP2)
		Explode( LeafNE, sfxFall + sfxFire + sfxSmoke + sfxExplodeOnHit + sfxBITMAP3)
		Explode( LeafNETip, sfxFall + sfxFire + sfxSmoke + sfxExplodeOnHit + sfxBITMAP4)
		Explode( LeafNW, sfxFall + sfxFire + sfxSmoke + sfxExplodeOnHit + sfxBITMAP5)
		Explode( LeafNWTip, sfxFall + sfxFire + sfxSmoke + sfxExplodeOnHit + sfxBITMAP1)
		Explode( LeafS, sfxShatter + sfxBITMAP2)
		Explode( LeafSTip, sfxBITMAPONLY + sfxBITMAP3)
		--Explode( post3, sfxBITMAPONLY + sfxBITMAP4)
		--Explode( post4, sfxBITMAPONLY + sfxBITMAP5)
		return (corpsetype)
	end
	--    corpsetype = 3
	Explode( Base, sfxBITMAPONLY + sfxBITMAP1)
	Explode( Top, sfxFall + sfxFire + sfxSmoke + sfxExplodeOnHit + sfxBITMAP2)
	Explode( LeafNE, sfxFall + sfxFire + sfxSmoke + sfxExplodeOnHit + sfxBITMAP3)
	Explode( LeafNETip, sfxFall + sfxFire + sfxSmoke + sfxExplodeOnHit + sfxBITMAP4)
	Explode( LeafNW, sfxFall + sfxFire + sfxSmoke + sfxExplodeOnHit + sfxBITMAP5)
	Explode( LeafNWTip, sfxFall + sfxFire + sfxSmoke + sfxExplodeOnHit + sfxBITMAP1)
	Explode( LeafS, sfxShatter + sfxExplodeOnHit + sfxBITMAP2)
	Explode( LeafSTip, sfxBITMAPONLY + sfxBITMAP3)
	--Explode( post3, sfxBITMAPONLY + sfxBITMAP4)
	--Explode( post4, sfxBITMAPONLY + sfxBITMAP5)

	return corpsetype
end

---OLD BOS code

--local base = piece 'base'
--local shell = piece 'shell'
--local leg1 = piece 'leg1'
--local leg2 = piece 'leg2'
--local leg3 = piece 'leg3'
--local leg4 = piece 'leg4'
--local wing1 = piece 'wing1'
--local wing2 = piece 'wing2'
--local wing3 = piece 'wing3'
--local wing4 = piece 'wing4'
--
--local  Static_Var_1, Static_Var_2, Static_Var_3
--
--OpenYard()
--	set YARD_OPEN to 1
--	while not get YARD_OPEN  do
--
--		set BUGGER_OFF to 1
--		Sleep( 1000)
--		set YARD_OPEN to 1
--	end
--	set BUGGER_OFF to 0
--end
--
--CloseYard()
--
--	set YARD_OPEN to 0
--	while  get YARD_OPEN  do
--
--		set BUGGER_OFF to 1
--		Sleep( 1000)
--		set YARD_OPEN to 0
--	end
--	set BUGGER_OFF to 0
--end
--
--activatescr()
--
--	if  Static_Var_1  then
--		set ACTIVATION to 0
--		return (0)
--	end
--	-- CloseYard()
--	Move( shell , y_axis, 0.000000  )
--	Move( shell , y_axis, 4.089990 , 8.000000 )
--	Sleep( 597)
--	Move( leg1 , x_axis, -4.450000 , 9.000000 )
--	Move( leg1 , z_axis, 4.489990 , 9.000000 )
--	Move( leg2 , x_axis, --4.550000 , 9.000000 )
--	Move( leg2 , z_axis, 4.500000 , 9.000000 )
--	Move( leg3 , x_axis, --4.339990 , 9.000000 )
--	Move( leg3 , z_axis, -4.450000 , 9.000000 )
--	Move( leg4 , x_axis, -4.400000 , 9.000000 )
--	Move( leg4 , z_axis, -4.379999 , 9.000000 )
--	Sleep( 726)
--	Turn( wing1 , z_axis, math.rad(-(-90.016484)), math.rad(241.000000) )
--	Turn( wing2 , z_axis, math.rad(-(90.016484)), math.rad(241.000000) )
--	Sleep( 372)
--	Turn( wing1 , z_axis, math.rad(-(-229.049451)), math.rad(365.000000) )
--	Turn( wing2 , z_axis, math.rad(-(229.049451)), math.rad(365.000000) )
--	Sleep( 381)
--	Move( wing3 , y_axis, 0.300000 , 1.000000 )
--	Move( wing4 , y_axis, 0.300000 , 1.000000 )
--	Sleep( 226)
--	Move( wing3 , y_axis, 0.000000 , 0.000000 )
--	Move( wing4 , y_axis, 0.000000 , 0.000000 )
--	Turn( wing3 , x_axis, math.rad(-90.016484), math.rad(246.000000) )
--	Turn( wing4 , x_axis, math.rad(91.016484), math.rad(249.000000) )
--	Sleep( 365)
--	Move( wing3 , y_axis, 0.300000 , 0.000000 )
--	Move( wing4 , y_axis, 0.300000 , 0.000000 )
--	Turn( wing3 , x_axis, math.rad(-229.049451), math.rad(446.000000) )
--	Turn( wing4 , x_axis, math.rad(229.049451), math.rad(442.000000) )
--	Sleep( 345)
--end
--
--deactivatescr()
--
--	-- OpenYard()
--	Move( shell , y_axis, 4.089990  )
--	Move( leg1 , x_axis, 4.450000  )
--	Move( leg1 , z_axis, 4.489990  )
--	Move( leg2 , x_axis, -4.550000  )
--	Move( leg2 , z_axis, 4.500000  )
--	Move( leg3 , x_axis, -4.339990  )
--	Move( leg3 , z_axis, -4.450000  )
--	Move( leg4 , x_axis, 4.400000  )
--	Move( leg4 , z_axis, -4.379999  )
--	Move( wing3 , y_axis, 0.300000  )
--	Move( wing3 , y_axis, 0.000000 , 0.000000 )
--	Move( wing4 , y_axis, 0.300000  )
--	Move( wing4 , y_axis, 0.000000 , 0.000000 )
--	Turn( wing1 , z_axis, math.rad(-229.302198) )
--	Turn( wing2 , z_axis, math.rad(229.302198) )
--	Turn( wing3 , x_axis, math.rad(-229.302198) )
--	Turn( wing3 , x_axis, math.rad(-90.016484), math.rad(321.000000) )
--	Turn( wing4 , x_axis, math.rad(229.302198) )
--	Turn( wing4 , x_axis, math.rad(91.016484), math.rad(318.000000) )
--	Sleep( 433)
--	Move( wing3 , y_axis, 0.300000 , 0.000000 )
--	Move( wing4 , y_axis, 0.300000 , 0.000000 )
--	Turn( wing3 , x_axis, 0, math.rad(207.000000) )
--	Turn( wing4 , x_axis, 0, math.rad(210.000000) )
--	Sleep( 434)
--	Move( wing3 , y_axis, 0.000000 , 1.000000 )
--	Move( wing4 , y_axis, 0.000000 , 1.000000 )
--	Sleep( 204)
--	Turn( wing1 , z_axis, math.rad(-(-90.016484)), math.rad(324.000000) )
--	Turn( wing2 , z_axis, math.rad(-(90.016484)), math.rad(324.000000) )
--	Sleep( 429)
--	Turn( wing1 , z_axis, math.rad(-(0.000000)), math.rad(209.000000) )
--	Turn( wing2 , z_axis, math.rad(-(0.000000)), math.rad(209.000000) )
--	Sleep( 568)
--	Move( leg1 , x_axis, -0.000000 , 11.000000 )
--	Move( leg1 , z_axis, 0.000000 , 11.000000 )
--	Move( leg2 , x_axis, -0.000000 , 11.000000 )
--	Move( leg2 , z_axis, 0.000000 , 11.000000 )
--	Move( leg3 , x_axis, -0.000000 , 11.000000 )
--	Move( leg3 , z_axis, 0.000000 , 11.000000 )
--	Move( leg4 , x_axis, -0.000000 , 11.000000 )
--	Move( leg4 , z_axis, 0.000000 , 11.000000 )
--	Turn( wing1 , z_axis, math.rad(-(0.000000)), 0 )
--	Sleep( 503)
--	Move( shell , y_axis, 0.000000 , 12.000000 )
--	Sleep( 389)
--end
--
--SmokeUnit(healthpercent, Sleep(time, smoketype)
--	while  get BUILD_PERCENT_LEFT  do
--		sleep 500
--	end
--	while  true  do
--
--		healthpercent = get HEALTH
--		if  healthpercent < 66  then
--
--			smoketype = 258
--			if  1, 66 ) < healthpercent  then
--
--				smoketype = 257
--			end
--			EmitSfx( base,  smoketype )
--		end
--		Sleep(time = healthpercent * 50)
--		if  Sleep(time < 200  then
--
--			sleeptime = 200)
--		end
--		Sleep( sleeptime)
--	end
--end
--
--RequestState(requestedstate, currentstate)
--	if  Static_Var_3  then
--		Static_Var_2 = requestedstate
--		return (0)
--	end
--	Static_Var_3 = 1
--	currentstate = Static_Var_2
--	Static_Var_2 = requestedstate
--	while  Static_Var_2 ~= currentstate  do
--
--		if  Static_Var_2  then
--
--			 deactivatescr()
--			currentstate = 1
--		else
--
--			 activatescr()
--			currentstate = 0
--		end
--	end
--	Static_Var_3 = 0
--end
--
--function script.Create()
--
--	dont-shade base
--	dont-shade leg1
--	dont-shade leg2
--	dont-shade leg3
--	dont-shade leg4
--	dont-shade shell
--	dont-shade wing1
--	dont-shade wing2
--	dont-shade wing3
--	dont-shade wing4
--	dont-cache leg1
--	dont-cache leg2
--	dont-cache leg3
--	dont-cache leg4
--	dont-cache shell
--	dont-cache wing1
--	dont-cache wing2
--	dont-cache wing3
--	dont-cache wing4
--	Static_Var_2 = 1
--	Static_Var_3 = 0
--	StartThread(SmokeUnit)
--	Static_Var_1 = 0
--end
--
--function script.Activate()
--
--	if  Static_Var_1  then
--
--		set ACTIVATION to 0
--		return (0)
--	end
--	set ARMORED to 0
--	StartThread(RequestState)
--end
--
--function script.Deactivate()
--	Spring.SetUnitArmored(unitID, true)
--	StartThread(RequestState)
--end
--
--function script.HitByWeapon(Func_Var_1, Func_Var_2)
--
--	if  get ACTIVATION  then
--
--		Static_Var_1 = 1
--	end
--	if  Static_Var_1  then
--
--		Signal( 2)
--		SetSignalMask( 2)
--		set ACTIVATION to 0
--		Sleep( 8000)
--		Static_Var_1 = 0
--		set ACTIVATION to 100
--	end
--end
--
--SweetSpot(piecenum)
--
--	piecenum = base
--end
--
--function script.Killed(severity, corpsetype)
--
--	if  severity <= 25  then
--
--		corpsetype = 1
--		Explode( base, sfxBITMAPONLY + sfxBITMAP1)
--		Explode( leg1, sfxShatter + sfxBITMAP2)
--		Explode( leg2, sfxShatter + sfxBITMAP3)
--		Explode( leg3, sfxBITMAPONLY + sfxBITMAP4)
--		Explode( leg4, sfxBITMAPONLY + sfxBITMAP5)
--		Explode( shell, sfxBITMAPONLY + sfxBITMAP1)
--		Explode( wing1, sfxFall + sfxBITMAP2)
--		Explode( wing2, sfxFall + sfxBITMAP3)
--		Explode( wing3, sfxBITMAPONLY + sfxBITMAP4)
--		Explode( wing4, sfxBITMAPONLY + sfxBITMAP5)
--		return (corpsetype)
--	end
--	if  severity <= 50  then
--
--		corpsetype = 2
--		Explode( base, sfxBITMAPONLY + sfxBITMAP1)
--		Explode( leg1, sfxShatter + sfxBITMAP2)
--		Explode( leg2, sfxShatter + sfxBITMAP3)
--		Explode( leg3, sfxBITMAPONLY + sfxBITMAP4)
--		Explode( leg4, sfxBITMAPONLY + sfxBITMAP5)
--		Explode( shell, sfxBITMAPONLY + sfxBITMAP1)
--		Explode( wing1, sfxFall + sfxBITMAP2)
--		Explode( wing2, sfxFall + sfxBITMAP3)
--		Explode( wing3, sfxBITMAPONLY + sfxBITMAP4)
--		Explode( wing4, sfxBITMAPONLY + sfxBITMAP5)
--		return (corpsetype)
--	end
--	if  severity <= 99  then
--
--		corpsetype = 3
--		Explode( base, sfxBITMAPONLY + sfxBITMAP1)
--		Explode( leg1, sfxShatter + sfxBITMAP2)
--		Explode( leg2, sfxShatter + sfxBITMAP3)
--		Explode( leg3, sfxBITMAPONLY + sfxBITMAP4)
--		Explode( leg4, sfxBITMAPONLY + sfxBITMAP5)
--		Explode( shell, sfxBITMAPONLY + sfxBITMAP1)
--		Explode( wing1, sfxFall + sfxSmoke + sfxFire + sfxExplodeOnHit + sfxBITMAP2)
--		Explode( wing2, sfxFall + sfxSmoke + sfxFire + sfxExplodeOnHit + sfxBITMAP3)
--		Explode( wing3, sfxBITMAPONLY + sfxBITMAP4)
--		Explode( wing4, sfxBITMAPONLY + sfxBITMAP5)
--		return (corpsetype)
--	end
--	corpsetype = 3
--	Explode( base, sfxBITMAPONLY + sfxBITMAP1)
--	Explode( leg1, sfxShatter + sfxExplodeOnHit + sfxBITMAP2)
--	Explode( leg2, sfxShatter + sfxExplodeOnHit + sfxBITMAP3)
--	Explode( leg3, sfxBITMAPONLY + sfxBITMAP4)
--	Explode( leg4, sfxBITMAPONLY + sfxBITMAP5)
--	Explode( shell, sfxBITMAPONLY + sfxBITMAP1)
--	Explode( wing1, sfxFall + sfxSmoke + sfxFire + sfxExplodeOnHit + sfxBITMAP2)
--	Explode( wing2, sfxFall + sfxSmoke + sfxFire + sfxExplodeOnHit + sfxBITMAP3)
--	Explode( wing3, sfxBITMAPONLY + sfxBITMAP4)
--	Explode( wing4, sfxBITMAPONLY + sfxBITMAP5)
--	return corpsetype
--end
