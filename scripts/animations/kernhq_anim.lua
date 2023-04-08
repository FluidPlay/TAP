local Animations = {};

local function on()
	initTween({veryLastFrame=28,
			   [PadR_top]={
				   [1]={cmd="move", axis=z_axis, targetValue=22.000000, firstFrame=0, lastFrame=28,},
			   },
			   [PadL_top]={
				   [1]={cmd="move", axis=z_axis, targetValue=22.000000, firstFrame=0, lastFrame=28,},
			   },
			   [antenna_base]={
				   [1]={cmd="move", axis=z_axis, targetValue=14.750000, firstFrame=0, lastFrame=28,},
			   },
	})
end
local function off()
	initTween({veryLastFrame=32,
			   [PadR_top]={
				   [1]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
			   },
			   [PadL_top]={
				   [1]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
			   },
			   [antenna_base]={
				   [1]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
			   },
	})
end
--- open_default
local function openstd()
	initTween({veryLastFrame=24,
			   [left_head]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.523599, firstFrame=0, lastFrame=24,},
			   },
			   [right_head]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-0.523599, firstFrame=0, lastFrame=24,},
			   },
	})
end
local function closestd()
	initTween({veryLastFrame=40,
			   [left_head]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=40,},
			   },
			   [right_head]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=40,},
			   },
	})
end
local function openadv()
	initTween({veryLastFrame=28,
			   [left_head_advanced]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.523599, firstFrame=0, lastFrame=28,},
			   },
			   [right_head_advanced]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-0.523599, firstFrame=0, lastFrame=28,},
			   },
	})
end
local function closeadv()
	initTween({veryLastFrame=32,
			   [left_head_advanced]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
			   },
			   [right_head_advanced]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
			   },
	})
end
local function morphup()
	initTween({veryLastFrame=48,
			   [extenderFL]={
				   [1]={cmd="move", axis=y_axis, targetValue=-8.999999, firstFrame=0, lastFrame=48,},
			   },
			   [extenderBL]={
				   [1]={cmd="move", axis=y_axis, targetValue=-9.000001, firstFrame=0, lastFrame=48,},
			   },
			   [extenderFR]={
				   [1]={cmd="move", axis=y_axis, targetValue=8.999996, firstFrame=0, lastFrame=48,},
			   },
			   [extenderBR]={
				   [1]={cmd="move", axis=y_axis, targetValue=9.000001, firstFrame=0, lastFrame=48,},
			   },
			   [frameL]={
				   [1]={cmd="move", axis=x_axis, targetValue=8.350000, firstFrame=0, lastFrame=48,},
			   },
			   [frameR]={
				   [1]={cmd="move", axis=x_axis, targetValue=-8.350000, firstFrame=0, lastFrame=48,},
			   },
	})
end
local function morphup2()
	initTween({veryLastFrame=40,
			   [toppieceR]={
				   [1]={cmd="move", axis=z_axis, targetValue=11.820000, firstFrame=0, lastFrame=40,},
			   },
			   [upgradeR]={
				   [1]={cmd="move", axis=x_axis, targetValue=-3.000000, firstFrame=12, lastFrame=40,},
			   },
			   [upgradeR_door]={
				   [1]={cmd="move", axis=x_axis, targetValue=5.966000, firstFrame=28, lastFrame=40,},
				   [2]={cmd="move", axis=z_axis, targetValue=2.892000, firstFrame=28, lastFrame=40,},
			   },
	})
end
local function morphup3()
	initTween({veryLastFrame=40,
			   [toppieceL]={
				   [1]={cmd="move", axis=z_axis, targetValue=11.820000, firstFrame=0, lastFrame=40,},
			   },
			   [upgradeL]={
				   [1]={cmd="move", axis=x_axis, targetValue=3.000000, firstFrame=12, lastFrame=40,},
			   },
			   [upgradeL_door]={
				   [1]={cmd="move", axis=x_axis, targetValue=-5.651984, firstFrame=28, lastFrame=40,},
				   [2]={cmd="move", axis=z_axis, targetValue=2.668996, firstFrame=28, lastFrame=40,},
			   },
	})
end

local Animations = {on = on, off = off, openstd = openstd, closestd = closestd, openadv = openadv, closeadv = closeadv,
					morphup = morphup, morphup2 = morphup2, morphup3 = morphup3, }

return Animations
