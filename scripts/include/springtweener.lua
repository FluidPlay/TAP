--- Created by Breno "MaDDoX" Azevedo
--- DateTime: 15-Oct-22 3:12 AM
--- License: GPLv3

local easingFunctions = VFS.Include("scripts/include/easing.lua")

local math_abs = math.abs
local math_rad = math.rad
local spEcho = Spring.Echo

local functionFromString = {
	["linear"] = easingFunctions.linear,
	["inQuad"] = easingFunctions.inQuad,
	["outQuad"] = easingFunctions.outQuad,
	["inOutQuad"] = easingFunctions.inOutQuad,
	["outInQuad"] = easingFunctions.outInQuad,
	["inCubic"]  = easingFunctions.inCubic,
	["outCubic"] = easingFunctions.outCubic,
	["inOutCubic"] = easingFunctions.inOutCubic,
	["outInCubic"] = easingFunctions.outInCubic,
	["inQuart"] = easingFunctions.inQuart,
	["outQuart"] = easingFunctions.outQuart,
	["inOutQuart"] = easingFunctions.inOutQuart,
	["outInQuart"] = easingFunctions.outInQuart,
	["inQuint"] = easingFunctions.inQuint,
	["outQuint"] = easingFunctions.outQuint,
	["inOutQuint"] = easingFunctions.inOutQuint,
	["outInQuint"] = easingFunctions.outInQuint,
	["inSine"] = easingFunctions.inSine,
	["outSine"] = easingFunctions.outSine,
	["inOutSine"] = easingFunctions.inOutSine,
	["outInSine"] = easingFunctions.outInSine,
	["inExpo"] = easingFunctions.inExpo,
	["outExpo"] = easingFunctions.outExpo,
	["inOutExpo"] = easingFunctions.inOutExpo,
	["outInExpo"] = easingFunctions.outInExpo,
	["inCirc"] = easingFunctions.inCirc,
	["outCirc"] = easingFunctions.outCirc,
	["inOutCirc"] = easingFunctions.inOutCirc,
	["outInCirc"] = easingFunctions.outInCirc,
	["inElastic"] = easingFunctions.inElastic,
	["outElastic"] = easingFunctions.outElastic,
	["inOutElastic"] = easingFunctions.inOutElastic,
	["outInElastic"] = easingFunctions.outInElastic,
	["inBack"] = easingFunctions.inBack,
	["outBack"] = easingFunctions.outBack,
	["inOutBack"] = easingFunctions.inOutBack,
	["outInBack"] = easingFunctions.outInBack,
	["inBounce"] = easingFunctions.inBounce,
	["outBounce"] = easingFunctions.outBounce,
	["inOutBounce"] = easingFunctions.inOutBounce,
	["outInBounce"] = easingFunctions.outInBounce,
}

local function ipairs_sparse(t)
	-- tmpIndex will hold sorted indices, otherwise
	-- this iterator would be no different from pairs iterator
	local tmpIndex = {}
	local index, _ = next(t)
	while index do
		tmpIndex[#tmpIndex+1] = index
		index, _ = next(t, index)
	end
	-- sort table indices
	table.sort(tmpIndex)
	local j = 1

	return function()
		-- get index value
		local i = tmpIndex[j]
		j = j + 1
		if i then
			return i, t[i]
		end
	end
end

local spGetGameFrame = Spring.GetGameFrame
local spGetPieceTranslation = Spring.UnitScript.GetPieceTranslation
local spGetPieceRotation = Spring.UnitScript.GetPieceRotation

local TWO_PI = 2*math.pi
local Turn = Spring.UnitScript.Turn
local Move = Spring.UnitScript.Move
local Sleep = Spring.UnitScript.Sleep
local x_axis, y_axis, z_axis = 1, 2, 3 -- axis: number (1 = x axis, 2 = y axis, 3 = z axis)

local function LerpPiece(pieceID, cmd, axis, targetValue, t)
	--TODO: Move ;; if cmd == "turn" then
	-- pieceValue.Top = { move = {x = 0, y = 0, z = 0}, turn = {x = 0, y = 0, z = 0},}
	local thisPieceValue = pieceValue[pieceID]
	if not thisPieceValue[cmd] or not thisPieceValue[cmd][axis] then
		Spring.Echo(" Couldn't find cmd or axis for piece: "..pieceID.." axis: "..axis)
		return end

	--local speedMult = 1.4
	local curValue = thisPieceValue[cmd][axis]
	local newValue = lerp(curValue, targetValue, t) --*speedMult)

	-- If reached target value (given a toleration delta), stop lerping
	--if (newValue - curValue < 0.01) then
	--    Spring.Echo("Done Lerping!")
	--    return end

	local speed = math.abs(newValue - curValue) / sleepTime --TODO: 0.25 is speed mult * 0.25

	if (speed < 0.1) then
		Spring.Echo("Done Lerping!")
		return end

	Turn(pieceID, axis, newValue, speed )

	Sleep(sleepTime * 1000) --133.3333
	Spring.Echo("f: "..spGetGameFrame().." oldValue: "..curValue.." newValue: "..newValue.." delta: "..(newValue - curValue).." speed: "..speed.." sleepTime: "..sleepTime)

	-- Update piece value and recurse
	pieceValue[pieceID][cmd][axis] = newValue
	LerpPiece(pieceID, cmd, axis, targetValue, t)
end

-- Normalize between -PI and PI (to prevent unwanted longest-angle rotations)
local function normalizeAngle(angle)
	return math.atan2(math.sin(angle), math.cos(angle)) ---slower ver, below is faster
	--return angle - TWO_PI * math.floor((angle + math.pi) / TWO_PI)
end

---This function recurses the tween until it's (fully) done, then returns to the caller (tweenPiece)
---pieceID, cmd, axis, startValue, valueDelta, prevValue, startTime, duration, easingFunction
local function tweenPieces(tweenData)
	local currentFrame = spGetGameFrame()
	local tweenDeltaFrame = currentFrame - tweenData.startFrame

	--- That's the full duration of the included tweens, something like the animation duration in Blender, for instance
	if tweenDeltaFrame > tweenData.veryLastFrame then
		return end
	for pieceID, pieceData in pairs(tweenData) do
		if type(pieceID) == "number" then
			for _, pieceTween in ipairs(pieceData) do
				local durationInS = pieceTween.durationInS
				local firstFrame = pieceTween.firstFrame
				local pieceDeltaFrame = tweenDeltaFrame - firstFrame   -- eg: tweenDF 32, firstFrame 28 => tweenDF = 2
				if pieceDeltaFrame >= 0 and tweenDeltaFrame <= pieceTween.lastFrame then
					--local pieceID = pieceTween.pieceID
					local cmd = pieceTween.cmd
					local valueDelta = pieceTween.valueDelta
					local axis = pieceTween.axis
					local strEasingFunction = pieceTween.easingFunction and pieceTween.easingFunction or "inOutCubic"
					local easingFunction = functionFromString[strEasingFunction]
					local prevValue = pieceTween.prevValue
					local startValue = pieceTween.startValue

					--Actually do the Tween calculation below (1st convert frame to milliseconds)
					local newValue = easingFunction(pieceDeltaFrame/30, startValue, valueDelta, durationInS)
					local speed = math_abs(newValue - prevValue) / tweenData.sleepTime

					if cmd == "turn" then
						Turn(pieceID, axis, newValue, speed )
						--Spring.Echo("Turning: "..pieceID)
					else
						Move(pieceID, axis, newValue, speed )
					end
					pieceTween.prevValue = newValue
					--Spring.Echo("tweenDeltaFrame: "..tweenDeltaFrame.." f: "..currentFrame.." deltaTime: "..pieceDeltaFrame.." startValue: "..startValue.." newValue: "..newValue.." speed: "..speed)
				end
			end
		end
	end
	Sleep(tweenData.sleepTime * 1000)
	tweenPieces(tweenData)
end

function sign(number)
	return number >= 0 and 1 or -1
end

--- Sets up tweenData with starting values (time, etc); works for multiple pieces at once
function initTween (tweenData)
	tweenData.startFrame = spGetGameFrame()
	if not tweenData.sleepTime then
		tweenData.sleepTime = 0.133333 -- default is 4 frames for each speed update
	end
	for pieceID, pieceData in pairs(tweenData) do
		if type(pieceID) == "number" then
			--- Each piece may have multiple tweens (start/end frames) in the same full range (defined by veryLastFrame)
			for _, pieceTween in ipairs(pieceData) do
				local cmd = pieceTween.cmd
				local targetValue = pieceTween.targetValue --normalizeAngle(
				local axis = pieceTween.axis

				local posX, posY, posZ = spGetPieceTranslation (pieceID)
				local rotX, rotY, rotZ = spGetPieceRotation (pieceID)
				if not posX or not rotX then
					Spring.Echo("Tween Error: Piece info couldn't be determined") -- for "..unitID)
					return
				end
				local startPosDir = { ["move"] = {[x_axis] = posX, [y_axis] = posY, [z_axis] = posZ,},
									  ["turn"] = { [x_axis] = rotX, [y_axis] = rotY, [z_axis] = rotZ,},
				}
				local startValue = startPosDir[cmd][axis]  --normalizeAngle(

                --- Gotta normalize the current piece angle, 'coz GetPieceTrans/Rot doesn't do it (results in not-shortest rotations)
                ---TODO: Fix, use normalizeAngle only for turn
                local nrmTargetValue = targetValue
                local nrmStartValue = startValue
                pieceTween.valueDelta = targetValue - startValue   -- valueSign * math.abs(
                if cmd == "turn" then
					-- local nrmStartValue = normalizeAngle(startValue)
					--local valueSign = sign(targetValue-startValue)
                    if pieceTween.valueDelta <= 3.1399 then
                        nrmTargetValue = normalizeAngle(targetValue)
                        nrmStartValue = normalizeAngle(startValue)
                    else
                        Spring.Echo("Big delta "..pieceTween.valueDelta.."found for piece "..pieceID)
                        nrmTargetValue = normalizeAngle(targetValue + 6.2)
                        nrmStartValue = normalizeAngle(startValue + 6.2)
                    end
                    pieceTween.valueDelta = nrmTargetValue - nrmStartValue
				end
                spEcho("pieceID: "..pieceID.." start Val: "..startValue.." target Val: "..targetValue.." normalized Start Value: "..nrmStartValue.." normalized Target Value: "..nrmTargetValue.." value Delta: "..pieceTween.valueDelta)

				pieceTween.startValue = nrmStartValue
				pieceTween.prevValue = nrmStartValue                    -- initialize with startValue
				pieceTween.durationInS = pieceTween.lastFrame <= pieceTween.firstFrame and 0
						or ((pieceTween.lastFrame - pieceTween.firstFrame) / 30)
			end
		end
	end

	tweenPieces(tweenData)
	--Spring.Echo("Done Tweening!")
end

--- Usage details:
----- inOutCubic = easingFunctions.inOutCubic
------- t = time     should go from 0 to duration
------ b = begin    value of the property being ease.
------ c = change   (delta) ending value of the property - beginning value of the property
------ d = duration
----
----beginVal = 0
----endVal = 1
----change = endVal - beginVal
----duration = 1
----
----print(inOutCubic(0             , beginVal, change, duration)) --> 0
----print(inOutCubic(duration / 4  , beginVal, change, duration)) --> 0.3828125
----print(inOutCubic(duration / 2  , beginVal, change, duration)) --> 0.5
----print(inOutCubic(duration / 3/4, beginVal, change, duration)) --> 0.10503472222222
----print(inOutCubic(duration      , beginVal, change, duration)) --> 1