--
-- User: MaDDoX
-- Date: 17/05/22
-- Time: 01:57
--

local SIG_STATECHG = {}
local SIG_REQSTATE = {}

--local base = piece 'base'
--local body = piece 'body'
--local aim = piece 'aim'
--local tower1, tower2, tower3 = piece('tower1', 'tower2', 'tower3')
--local emitnano = piece 'emitnano'

local base, outpost2, outpost3, outpost4, outpost5, outpostwing1, outpostwing2, pillar1, pillar2, pillar3, pillar4,
      pillar5, emitnano, cap1, cap2, cap3, cap4, cap5, headadv
            = piece('base', 'outpost2', 'outpost3', 'outpost4', 'outpost5', 'outpostwing1', 'outpostwing2',
                    'pillar1', 'pillar2', 'pillar3', 'pillar4', 'pillar5', 'emitnano', 'cap1', 'cap2', 'cap3', 'cap4', 'cap5', 'headadv')

--#include "sfxtype.h"
--#include "exptype.h"

local HeadingAngle, PitchAngle, RestoreDelay, statechg_StateChanging
local minPitch, maxPitch = -0.2, 0.84
local undergroundHeight = -23
local state = { build = 0, stop = 1}
local statechg_DesiredState
local level = 1
local justcreated
local Rad = math.rad
local Rand = math.random

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

local function SmokeUnit(healthpercent, sleeptime, smoketype)
	while GetUnitValue(COB.BUILD_PERCENT_LEFT) do
		Sleep (400)
	end
	while true do
		local healthpercent = GetUnitValue(COB.HEALTH)
		if  healthpercent < 66  then
			smoketype = 258 --256 | 2
			if Rand (1, 66) < healthpercent  then
				smoketype = 257 end
			EmitSfx ( outpost5, smoketype )
		end
		sleeptime = healthpercent * 50
		if  sleeptime < 200  then
			sleeptime = 200
		end
		Sleep (sleeptime)
	end
end

local function RestoreAfterDelay()
	Sleep (RestoreDelay)
	Turn (outpost2 , y_axis, 0, Rad(100.00000))
    Turn (outpost5 , x_axis, 0, Rad(120.00000))
	WaitForTurn (outpost2, y_axis)
    WaitForTurn (outpost5, x_axis)
end

local function WaitOneFrame()
	Sleep (1)
end

local function EnableTowers()
	-- If we just morphed into this guy, first insta-raise pieces below the current level
	-- Why? A.: Those pieces have been raised before
	if (justcreated) then
		justcreated = false
		if level >= 3 then
			Move (pillar1, y_axis, 0.00000)
		end
		if level >= 4 then
			Move (pillar2, y_axis, 0.00000)
		end
        --if level >= 5 then
        --    Move (pillar3, y_axis, 0.00000)
        --end
        --if level == 6 then
        --    Move (pillar4, y_axis, 0.00000)
        --end
	end
	if level >= 1 then
        Move (pillar1, y_axis, 0.00000, 18.03424 )
        WaitForMove(pillar1, y_axis)
        Show (cap1)
	end
	if level >= 2 then
		Move (pillar2, y_axis, 0.00000, 18.03424 )
        WaitForMove(pillar2, y_axis)
        Show (cap2)
        --
        Show (outpostwing1)
        Show (outpostwing2)
        Move (outpostwing1, x_axis, 0.0, 18.03)
        Move (outpostwing2, x_axis, 0.0, 18.03)
	end
	if level >= 3 then
        Hide (outpost5)
        Hide (outpostwing1)
        Hide (outpostwing2)
        Show (headadv)
        --
		Move (pillar3, y_axis, 0.00000, 18.03424 )
        WaitForMove(pillar3, y_axis)
        Show (cap3)
	end
    if level >= 4 then
        Move (pillar4, y_axis, 0.00000, 18.03424 )
        WaitForMove(pillar1, y_axis)
        Show (cap4)
        Move (outpost2, y_axis, 15, 18.03424 ) --TODO: temp
    end
    --if level >= 5 then
    --    Move (pillar5, y_axis, 0.00000, 18.03424 )
    --end
    --if level == 6 then
    --    --TEST: Raise central piece
    --    Move (outpost2, y_axis, 26.5, 18.03424 )
    --end

    ---
    --Move (pillar1, y_axis, 0, 80)
    --WaitForMove (pillar1, y_axis)
    --Show(cap1)
end

local function DisableTowers()
    Hide (cap1)
    Hide (cap2)
    Hide (cap3)
    Hide (cap4)
    Hide (cap5)
    Move (pillar1, y_axis, undergroundHeight)
    Move (pillar2, y_axis, undergroundHeight)
    Move (pillar3, y_axis, undergroundHeight)
    Move (pillar4, y_axis, undergroundHeight)
    Move (pillar5, y_axis, undergroundHeight)
		--if level >= 2 then
		--	Move (pillar1, y_axis, 0.00000, 8.00000)
		--end
		--if level >= 3 then
		--	Move (pillar2, y_axis, 0.00000, 8.00000)
		--end
		--if level == 4 then
		--	Move (pillar3, y_axis, 0.00000, 8.00000)
		--end
end

local function Stop()
  Spring.UnitScript.Signal(SIG_STATECHG)
  Spring.UnitScript.SetSignalMask(SIG_STATECHG)
    --Spring.Echo("armoutpost_lus: Stopping")
	SetUnitValue(COB.INBUILDSTANCE, 0)	--set INBUILDSTANCE to 0
	--DisableTowers() :: Removed to prevent 'bouncing towers' after building etc
	WaitOneFrame()
	StartThread(RestoreAfterDelay)
end

local function Go()
  Spring.UnitScript.Signal(SIG_STATECHG)
  Spring.UnitScript.SetSignalMask(SIG_STATECHG)
    if PitchAngle == nil or HeadingAngle == nil then
        Stop() end
    --Spring.Echo("armoutpost_lus: Going")
	EnableTowers()
	WaitOneFrame()
	Turn( outpost2 , y_axis, HeadingAngle, Rad(160.00000) )
    if PitchAngle then
        Turn( outpost5 , x_axis, PitchAngle, Rad(90.00000) ) end
	WaitForTurn(outpost2, y_axis)
    WaitForTurn(outpost5, x_axis)
	SetUnitValue(COB.INBUILDSTANCE, 1)
end

local function RequestState(requestedstate, currentstate)
    Spring.UnitScript.Signal(SIG_REQSTATE)
    Spring.UnitScript.SetSignalMask(SIG_REQSTATE)
	if  statechg_StateChanging  then
		statechg_DesiredState = requestedstate
		return (0)
	end
	statechg_StateChanging = true
	currentstate = statechg_DesiredState
	statechg_DesiredState = requestedstate
	while statechg_DesiredState ~= currentstate  do
		if statechg_DesiredState == state.build then
			StartThread(Go)
			currentstate = state.build
		elseif statechg_DesiredState == state.stop then
      --Spring.Echo("Stop now")
			StartThread(Stop)
			currentstate = 1
		end
	end
	statechg_StateChanging = false
end

local function InitState()
	HeadingAngle = nil
    PitchAngle = nil
	RestoreDelay = 5000
	justcreated = true
	statechg_DesiredState = 1
	statechg_StateChanging = false
    Hide (outpostwing1)
    Hide (outpostwing2)
    Move (outpostwing1, x_axis, 3.5)
    Move (outpostwing2, x_axis, -3.5)
    Move (pillar1, y_axis, undergroundHeight)
    Move (pillar2, y_axis, undergroundHeight)
    Move (pillar3, y_axis, undergroundHeight)
    Move (pillar4, y_axis, undergroundHeight)
    Move (pillar5, y_axis, undergroundHeight)
    Hide (cap1)
    Hide (cap2)
    Hide (cap3)
    Hide (cap4)
    Hide (cap5)
    Hide (headadv)
	local unitDefID = UnitDefs[unitDefID].name
	if (unitDefID == "armoutpost" or unitDefID == "coroutpost") then
		level = 1
	elseif (unitDefID == "armoutpost2" or unitDefID == "coroutpost2") then
		level = 2
	elseif (unitDefID == "armoutpost3" or unitDefID == "coroutpost3") then
		level = 3
	elseif (unitDefID == "armoutpost4" or unitDefID == "coroutpost4") then
		level = 4
        --TODO: wait for new 'factory morph upgrade' system
    --elseif (unitDefID == "armoutpost5" or unitDefID == "coroutpost5") then
    --    level = 5
    --elseif (unitDefID == "armoutpost6" or unitDefID == "coroutpost6") then
    --    level = 6
	end
	EnableTowers()
end

function script.StartBuilding(heading, pitch)
	HeadingAngle = heading
    --Spring.Echo("Source pitch: "..pitch)
    PitchAngle = -pitch -- -math.max(minPitch, math.min(pitch, maxPitch))
	StartThread(RequestState, state.build)
end

function script.StopBuilding()
	StartThread(RequestState, state.stop)
end

function script.QueryNanoPiece(piecenum)
	piecenum = emitnano
	return piecenum
end

local function SweetSpot(piecenum)
	piecenum = outpost2
end

function script.Create()
	StartThread(SmokeUnit)
	InitState()
end

function script.Activate()
    HeadingAngle = 0
	StartThread(RequestState, state.build)
end

function script.Deactivate()
    StartThread(DisableTowers) --
    StartThread(RequestState, state.stop)
end

function script.Killed(recentDamage, maxHealth)
	local corpsetype = 3
	local severity = recentDamage / maxHealth * 100

	if  severity <= 25  then
		corpsetype = 1
		Explode( base, sfxBITMAPONLY + sfxBITMAP1)
		Explode( outpost2, sfxBITMAPONLY + sfxBITMAP3)
		return (corpsetype)
	end
	if  severity <= 50  then
		corpsetype = 2
		Explode( base, sfxFall + sfxBITMAP1)
		Explode( outpost2, sfxFall + sfxBITMAP3)
		return (corpsetype)
	end
	if  severity <= 99  then
		corpsetype = 3
		Explode( base, sfxFall + sfxSmoke + sfxFire + sfxExplodeOnHit + sfxBITMAP1)
        Explode( outpost2, sfxFall + sfxBITMAP3)
        Explode( outpost3, sfxFall + sfxBITMAP3)
		Explode( outpost4, sfxFall + sfxSmoke + sfxFire + sfxExplodeOnHit + sfxBITMAP3)
		return (corpsetype)
	end
	Explode( base, sfxFall + sfxSmoke + sfxFire + sfxExplodeOnHit + sfxBITMAP1)
	Explode( outpost2, sfxShatter + sfxExplodeOnHit + sfxBITMAP3)
    Explode( outpost3, sfxExplodeOnHit + sfxFall + sfxBITMAP3)
    Explode( outpost4, sfxFall + sfxSmoke + sfxFire + sfxExplodeOnHit + sfxBITMAP3)
	return (corpsetype)
end

