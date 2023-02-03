local Animations = {};

--- open_default	-- Flip all turn and move x/z_axis to flip rotations (180 deg Y)
local function openstd()
	initTween({veryLastFrame=52,
			   [conver]={
				   [1]={cmd="turn", axis=x_axis, targetValue=-2.356194, firstFrame=0, lastFrame=52,},
			   },
			   [cover_extension]={
				   [1]={cmd="move", axis=y_axis, targetValue=21.000000, firstFrame=32, lastFrame=52,},
			   },
			   [right_box]={
				   [1]={cmd="move", axis=z_axis, targetValue=19.000000, firstFrame=12, lastFrame=32,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=32, lastFrame=40,},
			   },
			   [left_box]={
				   [1]={cmd="move", axis=z_axis, targetValue=19.000000, firstFrame=12, lastFrame=32,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=32, lastFrame=40,},
			   },
			   [left_boxcover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=2.268928, firstFrame=20, lastFrame=32,},
			   },
			   [right_boxcover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-2.268928, firstFrame=20, lastFrame=32,},
			   },
			   [left_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=19.000000, firstFrame=32, lastFrame=40,},
			   },
			   [right_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=19.000000, firstFrame=32, lastFrame=40,},
			   },
			   [left_head]={
				   [1]={cmd="turn", axis=y_axis, targetValue=1.047198, firstFrame=36, lastFrame=52,},
			   },
			   [right_head]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-1.047198, firstFrame=36, lastFrame=52,},
			   },
	})
end
local function closestd()
	initTween({veryLastFrame=44,
			   [conver]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=16, lastFrame=44,},
			   },
			   [cover_extension]={
				   [1]={cmd="move", axis=y_axis, targetValue=0.000000, firstFrame=28, lastFrame=44,},
			   },
			   [right_box]={
				   [1]={cmd="move", axis=z_axis, targetValue=19.000000, firstFrame=4, lastFrame=12,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=12, lastFrame=24,},
			   },
			   [left_box]={
				   [1]={cmd="move", axis=z_axis, targetValue=19.000000, firstFrame=4, lastFrame=12,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=12, lastFrame=24,},
			   },
			   [left_boxcover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=8, lastFrame=16,},
			   },
			   [right_boxcover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=8, lastFrame=16,},
			   },
			   [left_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=4, lastFrame=12,},
			   },
			   [right_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=4, lastFrame=12,},
			   },
			   [left_head]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=8,},
			   },
			   [right_head]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=8,},
			   },
	})
end

local function morphup()
	initTween({veryLastFrame=48,
			   [left_head]={
				   [1]={cmd="hide", firstFrame=0,},
			   },
			   [right_head]={
				   [1]={cmd="hide", firstFrame=0,},
			   },
			   [left_base]={
				   [1]={cmd="move", axis=x_axis, targetValue=20.000000, firstFrame=0, lastFrame=48,},
			   },
			   [right_base]={
				   [1]={cmd="move", axis=x_axis, targetValue=-20.000000, firstFrame=0, lastFrame=48,},
			   },
			   [back_base]={
				   [1]={cmd="move", axis=y_axis, targetValue=11.500000, firstFrame=0, lastFrame=48,},
			   },
			   [left_back_expansion]={
				   [1]={cmd="move", axis=y_axis, targetValue=11.500000, firstFrame=28, lastFrame=48,},
			   },
			   [right_back_expansion]={
				   [1]={cmd="move", axis=y_axis, targetValue=11.500000, firstFrame=28, lastFrame=48,},
			   },
			   [left_frontal_expension]={
				   [1]={cmd="move", axis=y_axis, targetValue=-10.000000, firstFrame=28, lastFrame=48,},
			   },
			   [right_frontal_expansion]={
				   [1]={cmd="move", axis=y_axis, targetValue=-10.000000, firstFrame=28, lastFrame=48,},
			   },
			   [right_barrier]={
				   [1]={cmd="move", axis=x_axis, targetValue=-18.000000, firstFrame=24, lastFrame=48,},
			   },
			   [left_barrier]={
				   [1]={cmd="move", axis=x_axis, targetValue=18.000000, firstFrame=24, lastFrame=48,},
			   },
			   [back_wall]={
				   [1]={cmd="move", axis=z_axis, targetValue=5.000000, firstFrame=32, lastFrame=48,},
			   },
			   [left_wall]={
				   [1]={cmd="move", axis=z_axis, targetValue=6.000000, firstFrame=32, lastFrame=48,},
			   },
			   [right_wall]={
				   [1]={cmd="move", axis=z_axis, targetValue=6.000000, firstFrame=32, lastFrame=48,},
			   },
			   [left_arm]={
				   [1]={cmd="hide", firstFrame=0,},
			   },
	})
end
local function openadv()
	initTween({veryLastFrame=44,
			   [conver]={
				   [1]={cmd="turn", axis=x_axis, targetValue=-2.356194, firstFrame=0, lastFrame=44,},
			   },
			   [cover_extension]={
				   [1]={cmd="move", axis=y_axis, targetValue=21.000000, firstFrame=12, lastFrame=44,},
			   },
			   [right_box]={
				   [1]={cmd="move", axis=z_axis, targetValue=24.000000, firstFrame=0, lastFrame=20,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=20, lastFrame=28,},
			   },
			   [left_box]={
				   [1]={cmd="move", axis=z_axis, targetValue=24.000000, firstFrame=0, lastFrame=20,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=20, lastFrame=28,},
			   },
			   [left_boxcover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=2.268928, firstFrame=4, lastFrame=16,},
			   },
			   [right_boxcover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-2.268928, firstFrame=4, lastFrame=16,},
			   },
			   [left_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=8.000000, firstFrame=0, lastFrame=20,},
				   [2]={cmd="move", axis=z_axis, targetValue=32.424507, firstFrame=20, lastFrame=28,},
			   },
			   [right_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=8.000000, firstFrame=0, lastFrame=20,},
				   [2]={cmd="move", axis=z_axis, targetValue=32.424507, firstFrame=20, lastFrame=28,},
			   },
			   [left_head_advanced]={
				   [1]={cmd="turn", axis=y_axis, targetValue=1.134464, firstFrame=28, lastFrame=44,},
			   },
			   [right_head_advanced]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-1.134464, firstFrame=28, lastFrame=44,},
			   },
	})
end
local function closeadv()
	initTween({veryLastFrame=24,
			   [conver]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=0, lastFrame=24,},
			   },
			   [cover_extension]={
				   [1]={cmd="move", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=20,},
			   },
			   [right_box]={
				   [1]={cmd="move", axis=z_axis, targetValue=24.000000, firstFrame=8, lastFrame=16,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=16, lastFrame=24,},
			   },
			   [left_box]={
				   [1]={cmd="move", axis=z_axis, targetValue=24.000000, firstFrame=8, lastFrame=16,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=16, lastFrame=24,},
			   },
			   [left_boxcover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=12, lastFrame=20,},
			   },
			   [right_boxcover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=12, lastFrame=20,},
			   },
			   [left_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=8, lastFrame=16,},
			   },
			   [right_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=8, lastFrame=16,},
			   },
			   [left_head_advanced]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=8,},
			   },
			   [right_head_advanced]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=8,},
			   },
			   [left_arm]={
				   [1]={cmd="move", axis=z_axis, targetValue=0.867489, firstFrame=0, lastFrame=8,},
			   },
	})
end

local Animations = {openstd = openstd, closestd = closestd, morphup = morphup, openadv = openadv, closeadv = closeadv, }

return Animations
