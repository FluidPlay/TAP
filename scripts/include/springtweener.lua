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
local Hide = Spring.UnitScript.Hide
local Show = Spring.UnitScript.Show

local spGetUnitPieceList = Spring.GetUnitPieceList

local Sleep = Spring.UnitScript.Sleep
local x_axis, y_axis, z_axis = 1, 2, 3 -- axis: number (1 = x axis, 2 = y axis, 3 = z axis)

local pieceList = spGetUnitPieceList(unitID)
--Spring.GetUnitPieceList ( number unitID ) => { [1] = string "piecename", ... , [pieceNumN] = string "piecename" }

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

local function getCurrentValue(pieceID, cmd, pieceTween)
	local targetValue = pieceTween.targetValue --normalizeAngle(
	local axis = pieceTween.axis

	local posX, posY, posZ = spGetPieceTranslation (pieceID)
	--Spring.Echo("piece "..pieceID.." current PosY: "..(posY or "null"))
	local rotX, rotY, rotZ = spGetPieceRotation (pieceID)
	if not posX or not rotX then
		Spring.Echo("Tween Error: Piece info couldn't be determined") -- for "..unitID)
		return
	end
	local startPosDir = { ["move"] = {[x_axis] = posX, [y_axis] = posY, [z_axis] = posZ,},
						  ["turn"] = { [x_axis] = rotX, [y_axis] = rotY, [z_axis] = rotZ,},
	}
	local startValue = startPosDir[cmd][axis]  --normalizeAngle(

	--- Gotta normalize the current piece angle, since GetPieceTrans/Rot always it (else it results in not-shortest rotations)
	local nrmTargetValue = targetValue
	local nrmStartValue = startValue
	local valueDelta = targetValue - startValue   -- valueSign * math.abs(
	if cmd == "turn" then
		if valueDelta <= 3.1399 then		--TODO: math.abs(pieceTween.valueDelta)
			nrmTargetValue = normalizeAngle(targetValue)
			nrmStartValue = normalizeAngle(startValue)
		else
			-- Spring.Echo("Big delta "..pieceTween.valueDelta.." found for piece "..pieceID)
			nrmTargetValue = normalizeAngle(targetValue + 6.2)
			nrmStartValue = normalizeAngle(startValue + 6.2)
		end
		valueDelta = nrmTargetValue - nrmStartValue
	end
	return nrmStartValue, valueDelta
end

---This function recurses the tween until it's (fully) done, then returns to the caller (tweenPiece)
---pieceID, cmd, axis, startValue, valueDelta, prevValue, startTime, duration, easingFunction
local function tweenPieces(tweenData)
	local currentGameFrame = spGetGameFrame()
	local tweenFrame = currentGameFrame - tweenData.startGameFrame

	--- That's the full duration of the included tweens, something like the animation duration in Blender, for instance
	if tweenFrame > tweenData.veryLastFrame then
		return end
	for pieceID, pieceData in pairs(tweenData) do
		if type(pieceID) == "number" then
			for _, subtween in ipairs(pieceData) do			-- each piece may have multiple tweens
				local firstFrame = subtween.firstFrame		-- internal tween first frame
                local lastFrame = subtween.lastFrame		-- internal tween last frame
				local subtweenFrame = tweenFrame - firstFrame   -- eg: tweenFrame 32, firstFrame 28 => subtweenFrame = 2
                local cmd = subtween.cmd
                if cmd == "hide" or cmd == "show" then
                    if (tweenFrame >= firstFrame) then
                        --Spring.Echo("piece: "..pieceID.." first frame: "..(firstFrame or "nil").." tweenDeltaFrame: "..(tweenDeltaFrame or "nil"))
                        if cmd == "hide" then
                            Hide(pieceID)
                        end
                        if cmd == "show" then
                            Show(pieceID)
                        end
                    end
                elseif subtweenFrame >= 0 and tweenFrame <= lastFrame then
					--- startValue has to be updated for tweens which started after global-tween-frame zero (to get in-game value)
					if firstFrame > 0 and not subtween.initialized then
						subtween.startValue, subtween.valueDelta = getCurrentValue(pieceID, cmd, subtween)
						subtween.prevValue = subtween.startValue
						subtween.initialized = true
						--Spring.Echo("piece "..pieceList[pieceID]..", frame: "..(tweenFrame or "nil").." startValue: "..startValue.." valueDelta: "..valueDelta)
					end
				    local durationInS = subtween.durationInS  -- duration in Seconds
					local axis = subtween.axis
					local prevValue = subtween.prevValue
					local valueDelta = subtween.valueDelta
					local startValue = subtween.startValue

					local strEasingFunction = subtween.easingFunction and subtween.easingFunction or "inOutSine"
					local easingFunction = functionFromString[strEasingFunction]
					--- Uncomment for detailed single-piece debugging:
					--if pieceList[pieceID] == "right_box" then
					--	local targetValue =  valueDelta + startValue
					--	Spring.Echo("piece "..pieceList[pieceID]..", frame: "..(tweenFrame or "nil").." startValue: "..startValue.." targetValue: "..targetValue)
					--end

					--Actually do the Tween calculation below (1st convert frame to milliseconds)
					local newValue = easingFunction(subtweenFrame /30, startValue, valueDelta, durationInS)
					local speed = math_abs(newValue - prevValue) / tweenData.sleepTime

					if cmd == "turn" then
						Turn(pieceID, axis, newValue, speed )
					else
						--if pieceList[pieceID] == "right_box" then
						--	Spring.Echo("Frame: "..subtweenFrame..", targetValue: "..(valueDelta + startValue).." Speed: "..speed)
						--end
						Move(pieceID, axis, newValue, speed )
					end
					subtween.prevValue = newValue
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
	tweenData.startGameFrame = spGetGameFrame()
	if not tweenData.sleepTime then
		tweenData.sleepTime = 0.133333 --- default is 4 frames for each speed update; use 0.033333 for 'every frame'
	end
	for pieceID, pieceData in pairs(tweenData) do
		if type(pieceID) == "number" then
			--- Each piece may have multiple tweens (start/end frames) in the same full range (defined by veryLastFrame)
			for _, pieceTween in ipairs(pieceData) do
				local cmd = pieceTween.cmd
                if cmd == "move" or cmd == "turn" then  -- hide and show require no initial setup here
					-- This initialization is only good for tweens which start at frame-offset zero
					pieceTween.startValue, pieceTween.valueDelta = getCurrentValue(pieceID, cmd, pieceTween)
					pieceTween.prevValue = pieceTween.startValue									-- initialize with startValue
					pieceTween.durationInS = pieceTween.lastFrame <= pieceTween.firstFrame and 0	-- duration in Seconds
                            or ((pieceTween.lastFrame - pieceTween.firstFrame) / 30)
                end
			end
		end
	end
	tweenPieces(tweenData)	-- Actually start tweening
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