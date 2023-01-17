local Animations = {};

--- open_default	-- Flip all turn and move x/z_axis to flip rotations (180 deg Y)
local function openstd()
	initTween({veryLastFrame=48,
			   [left_box]={
				   [1]={cmd="move", axis=z_axis, targetValue=19.000000, firstFrame=12, lastFrame=32,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=32, lastFrame=40,},
			   },
			   [left_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=24.000000, firstFrame=32, lastFrame=40,},
			   },
			   [right_box]={
				   [1]={cmd="move", axis=z_axis, targetValue=19.000000, firstFrame=12, lastFrame=32,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=32, lastFrame=40,},
			   },
			   [right_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=24.000000, firstFrame=32, lastFrame=40,},
			   },
			   [left_extension]={
				   [1]={cmd="move", axis=x_axis, targetValue=7.000000, firstFrame=0, lastFrame=12,},
			   },
			   [right_extension]={
				   [1]={cmd="move", axis=x_axis, targetValue=-7.000000, firstFrame=0, lastFrame=12,},
			   },
			   [left_boxcover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=2.356194, firstFrame=16, lastFrame=32,},
			   },
			   [right_boxcover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-2.356194, firstFrame=16, lastFrame=32,},
			   },
			   [left_cover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=2.356194, firstFrame=4, lastFrame=28,},
			   },
			   [right_cover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-2.356194, firstFrame=4, lastFrame=28,},
			   },
			   [right_head]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-0.872665, firstFrame=32, lastFrame=48,},
			   },
			   [left_head]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.872665, firstFrame=32, lastFrame=48,},
			   },
			   [right_pointer]={
				   [1]={cmd="move", axis=z_axis, targetValue=1.500000, firstFrame=28, lastFrame=36,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=36, lastFrame=44,},
			   },
			   [left_pointer]={
				   [1]={cmd="move", axis=z_axis, targetValue=1.500000, firstFrame=28, lastFrame=36,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=36, lastFrame=44,},
			   },
			   [back_wall]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.279253, firstFrame=24, lastFrame=40,},
			   },
	})
end
local function closestd()
	initTween({veryLastFrame=32,
			   [left_box]={
				   [1]={cmd="move", axis=z_axis, targetValue=19.000000, firstFrame=0, lastFrame=12,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=12, lastFrame=20,},
			   },
			   [left_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=19.000000, firstFrame=0, lastFrame=4,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=4, lastFrame=12,},
			   },
			   [right_box]={
				   [1]={cmd="move", axis=z_axis, targetValue=19.000000, firstFrame=0, lastFrame=12,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=12, lastFrame=20,},
			   },
			   [right_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=19.000000, firstFrame=0, lastFrame=4,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=4, lastFrame=12,},
			   },
			   [left_boxcover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=4, lastFrame=16,},
			   },
			   [right_boxcover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=4, lastFrame=16,},
			   },
			   [left_cover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=12, lastFrame=32,},
			   },
			   [right_cover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=12, lastFrame=32,},
			   },
			   [right_head]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=8,},
			   },
			   [left_head]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=8,},
			   },
			   [right_pointer]={
				   [1]={cmd="move", axis=z_axis, targetValue=1.500000, firstFrame=0, lastFrame=4,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=4, lastFrame=16,},
			   },
			   [left_pointer]={
				   [1]={cmd="move", axis=z_axis, targetValue=1.500000, firstFrame=0, lastFrame=4,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=4, lastFrame=16,},
			   },
			   [back_wall]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=0, lastFrame=20,},
			   },
	})
end
local function morphup()
	initTween({veryLastFrame=40,
			   [left_extension]={
				   [1]={cmd="move", axis=x_axis, targetValue=-10.000000, firstFrame=12, lastFrame=36,},
			   },
			   [right_extension]={
				   [1]={cmd="move", axis=x_axis, targetValue=10.000000, firstFrame=12, lastFrame=36,},
			   },
			   [back_wall]={
				   [1]={cmd="move", axis=z_axis, targetValue=5.000000, firstFrame=20, lastFrame=40,},
			   },
			   [left_base]={
				   [1]={cmd="move", axis=x_axis, targetValue=10.000000, firstFrame=0, lastFrame=32,},
			   },
			   [right_base]={
				   [1]={cmd="move", axis=x_axis, targetValue=-10.000000, firstFrame=0, lastFrame=32,},
			   },
			   [left_back_upgrade]={
				   [1]={cmd="move", axis=y_axis, targetValue=10.000000, firstFrame=12, lastFrame=40,},
			   },
			   [right_back_upgrade]={
				   [1]={cmd="move", axis=y_axis, targetValue=10.000000, firstFrame=12, lastFrame=40,},
			   },
			   [left_front_extension]={
				   [1]={cmd="move", axis=y_axis, targetValue=-10.000000, firstFrame=12, lastFrame=40,},
			   },
			   [right_front_extension]={
				   [1]={cmd="move", axis=y_axis, targetValue=-10.000000, firstFrame=12, lastFrame=40,},
			   },
			   [back_base]={
				   [1]={cmd="move", axis=y_axis, targetValue=15.000000, firstFrame=8, lastFrame=28,}, --5
			   },
			   [left_wall]={
				   [1]={cmd="move", axis=z_axis, targetValue=5.000000, firstFrame=20, lastFrame=40,},
			   },
			   [right_wall]={
				   [1]={cmd="move", axis=z_axis, targetValue=5.000000, firstFrame=20, lastFrame=40,},
			   },
	})
end
local function openadv()
	initTween({veryLastFrame=48,
			   [left_box]={
				   [1]={cmd="move", axis=z_axis, targetValue=19.000000, firstFrame=12, lastFrame=32,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=32, lastFrame=40,},
			   },
			   [left_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=32.000000, firstFrame=32, lastFrame=40,},
			   },
			   [right_box]={
				   [1]={cmd="move", axis=z_axis, targetValue=19.000000, firstFrame=12, lastFrame=32,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=32, lastFrame=40,},
			   },
			   [right_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=32.000000, firstFrame=32, lastFrame=40,},
			   },
			   [left_extension]={
				   [1]={cmd="move", axis=x_axis, targetValue=7.000000, firstFrame=0, lastFrame=20,},
			   },
			   [right_extension]={
				   [1]={cmd="move", axis=x_axis, targetValue=-7.000000, firstFrame=0, lastFrame=20,},
			   },
			   [left_boxcover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=2.356194, firstFrame=16, lastFrame=32,},
			   },
			   [right_boxcover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-2.356194, firstFrame=16, lastFrame=32,},
			   },
			   [left_cover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=2.356194, firstFrame=4, lastFrame=28,},
			   },
			   [right_cover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-2.356194, firstFrame=4, lastFrame=28,},
			   },
			   [back_wall]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.279253, firstFrame=24, lastFrame=40,},
			   },
			   [left_pointer1]={
				   [1]={cmd="move", axis=z_axis, targetValue=2.250000, firstFrame=32, lastFrame=40,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=40, lastFrame=48,},
			   },
			   [left_pointer2]={
				   [1]={cmd="move", axis=z_axis, targetValue=2.250000, firstFrame=32, lastFrame=40,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=40, lastFrame=48,},
			   },
			   [right_pointer2]={
				   [1]={cmd="move", axis=z_axis, targetValue=2.250000, firstFrame=32, lastFrame=40,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=40, lastFrame=48,},
			   },
			   [right_pointer1]={
				   [1]={cmd="move", axis=z_axis, targetValue=2.250000, firstFrame=32, lastFrame=40,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=40, lastFrame=48,},
			   },
			   [left_head_advanced]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.785398, firstFrame=36, lastFrame=48,},
			   },
			   [right_head_advanced]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-0.785398, firstFrame=36, lastFrame=48,},
			   },
	})
end
local function closeadv()
	initTween({veryLastFrame=32,
			   [left_box]={
				   [1]={cmd="move", axis=z_axis, targetValue=19.000000, firstFrame=4, lastFrame=16,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=16, lastFrame=24,},
			   },
			   [left_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=4, lastFrame=16,},
			   },
			   [right_box]={
				   [1]={cmd="move", axis=z_axis, targetValue=19.000000, firstFrame=4, lastFrame=16,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=16, lastFrame=24,},
			   },
			   [right_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=4, lastFrame=16,},
			   },
			   [left_boxcover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=8, lastFrame=20,},
			   },
			   [right_boxcover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=8, lastFrame=20,},
			   },
			   [left_cover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=12, lastFrame=32,},
			   },
			   [right_cover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=12, lastFrame=32,},
			   },
			   [back_wall]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=0, lastFrame=20,},
			   },
			   [left_pointer1]={
				   [1]={cmd="move", axis=z_axis, targetValue=2.250000, firstFrame=0, lastFrame=4,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=4, lastFrame=12,},
			   },
			   [left_pointer2]={
				   [1]={cmd="move", axis=z_axis, targetValue=2.250000, firstFrame=0, lastFrame=4,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=4, lastFrame=12,},
			   },
			   [right_pointer2]={
				   [1]={cmd="move", axis=z_axis, targetValue=2.250000, firstFrame=0, lastFrame=4,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=4, lastFrame=12,},
			   },
			   [right_pointer1]={
				   [1]={cmd="move", axis=z_axis, targetValue=2.250000, firstFrame=0, lastFrame=4,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=4, lastFrame=12,},
			   },
			   [left_head_advanced]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-0.000000, firstFrame=0, lastFrame=8,},
			   },
			   [right_head_advanced]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-0.000000, firstFrame=0, lastFrame=8,},
			   },
	})
end

local Animations = {openstd = openstd, closestd = closestd, morphup = morphup, openadv = openadv, closeadv = closeadv, }

return Animations