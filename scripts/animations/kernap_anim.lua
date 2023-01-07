local Animations = {};

--- open_default	-- Flip all turn and move x/z_axis to flip rotations (180 deg Y)
local function openstd()
	initTween({veryLastFrame=40,
			   [left_cover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=2.356194, firstFrame=8, lastFrame=20,},
			   },
			   [right_cover]={
				   [1]={cmd="turn", axis=x_axis, targetValue=-2.356194, firstFrame=8, lastFrame=20,},
			   },
			   [right_box]={
				   [1]={cmd="move", axis=z_axis, targetValue=16.000000, firstFrame=0, lastFrame=16,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=16, lastFrame=28,},
			   },
			   [left_box]={
				   [1]={cmd="move", axis=z_axis, targetValue=16.000000, firstFrame=0, lastFrame=16,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=16, lastFrame=28,},
			   },
			   [right_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=32.000000, firstFrame=16, lastFrame=28,},
			   },
			   [left_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=32.000000, firstFrame=16, lastFrame=28,},
			   },
			   [left_head]={
				   [1]={cmd="turn", axis=y_axis, targetValue=1.047198, firstFrame=16, lastFrame=40,},
			   },
			   [right_head]={
				   [1]={cmd="turn", axis=x_axis, targetValue=-1.047198, firstFrame=16, lastFrame=40,},
			   },
	})
end

--- Close_default
local function closestd()
	initTween({veryLastFrame=28,
			   [left_cover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=8, lastFrame=20,},
			   },
			   [right_cover]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=8, lastFrame=20,},
			   },
			   [right_box]={
				   [1]={cmd="move", axis=z_axis, targetValue=16.000000, firstFrame=0, lastFrame=12,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=12, lastFrame=28,},
			   },
			   [left_box]={
				   [1]={cmd="move", axis=z_axis, targetValue=16.000000, firstFrame=0, lastFrame=12,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=12, lastFrame=28,},
			   },
			   [right_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=0, lastFrame=12,},
			   },
			   [left_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=0, lastFrame=12,},
			   },
			   [left_head]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-0.000000, firstFrame=0, lastFrame=8,},
				   [2]={cmd="hide", firstFrame=28,},
			   },
			   [right_head]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=0, lastFrame=8,},
				   [2]={cmd="hide", firstFrame=28,},
			   },
			   [left_head_advanced]={
				   [1]={cmd="show", firstFrame=28,},
			   },
			   [right_head_advanced]={
				   [1]={cmd="show", firstFrame=28,},
			   },
			   [left_pointer1]={
				   [1]={cmd="show", firstFrame=28,},
			   },
			   [left_pointer2]={
				   [1]={cmd="show", firstFrame=28,},
			   },
			   [right_pointer1]={
				   [1]={cmd="show", firstFrame=28,},
			   },
			   [right_pointer2]={
				   [1]={cmd="show", firstFrame=28,},
			   },
	})
end

----- Upgrade / Morph-up
local function morphup()
	initTween({veryLastFrame=44,
			   [left_frontal_base]={
				   [1]={cmd="move", axis=y_axis, targetValue=-8.000001, firstFrame=0, lastFrame=32,},
			   },
			   [right_frontal_base]={
				   [1]={cmd="move", axis=x_axis, targetValue=-8.000001, firstFrame=0, lastFrame=32,},
			   },
			   [left_back_base]={
				   [1]={cmd="move", axis=x_axis, targetValue=8.000001, firstFrame=0, lastFrame=32,},
			   },
			   [right_back_base]={
				   [1]={cmd="move", axis=y_axis, targetValue=8.000001, firstFrame=0, lastFrame=32,},
			   },
			   [building_plate_expansion3]={
				   [1]={cmd="move", axis=x_axis, targetValue=3.535534, firstFrame=20, lastFrame=44,},
				   [2]={cmd="move", axis=y_axis, targetValue=3.535534, firstFrame=20, lastFrame=44,},
			   },
			   [building_plate_expansion4]={
				   [1]={cmd="move", axis=x_axis, targetValue=-3.535534, firstFrame=20, lastFrame=44,},
				   [2]={cmd="move", axis=y_axis, targetValue=3.535534, firstFrame=20, lastFrame=44,},
			   },
			   [building_plate_expansion2]={
				   [1]={cmd="move", axis=x_axis, targetValue=3.535534, firstFrame=20, lastFrame=44,},
				   [2]={cmd="move", axis=y_axis, targetValue=-3.535534, firstFrame=20, lastFrame=44,},
			   },
			   [building_plate_expansion1]={
				   [1]={cmd="move", axis=x_axis, targetValue=-3.535534, firstFrame=20, lastFrame=44,},
				   [2]={cmd="move", axis=y_axis, targetValue=-3.535534, firstFrame=20, lastFrame=44,},
			   },
			   [left_frontal_protection]={
				   [1]={cmd="move", axis=z_axis, targetValue=4.000000, firstFrame=28, lastFrame=44,},
			   },
			   [left_back_protection]={
				   [1]={cmd="move", axis=z_axis, targetValue=4.000000, firstFrame=28, lastFrame=44,},
			   },
			   [right_frontal_protection]={
				   [1]={cmd="move", axis=z_axis, targetValue=4.000000, firstFrame=28, lastFrame=44,},
			   },
			   [right_back_protection]={
				   [1]={cmd="move", axis=z_axis, targetValue=4.000000, firstFrame=28, lastFrame=44,},
			   },
			   [building_plate_base]={
				   [1]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=20, lastFrame=36,},
			   },
	})
end

local function openadv()
	initTween({veryLastFrame=40,
			   [left_cover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=2.356194, firstFrame=8, lastFrame=20,},
			   },
			   [right_cover]={
				   [1]={cmd="turn", axis=x_axis, targetValue=-2.356194, firstFrame=8, lastFrame=20,},
			   },
			   [right_box]={
				   [1]={cmd="move", axis=z_axis, targetValue=16.000000, firstFrame=0, lastFrame=16,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=16, lastFrame=28,},
			   },
			   [left_box]={
				   [1]={cmd="move", axis=z_axis, targetValue=16.000000, firstFrame=0, lastFrame=16,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=16, lastFrame=28,},
			   },
			   [right_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=32.000000, firstFrame=16, lastFrame=28,},
			   },
			   [left_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=32.000000, firstFrame=16, lastFrame=28,},
			   },
			   [left_head]={
				   [1]={cmd="hide", firstFrame=0,},
			   },
			   [right_head]={
				   [1]={cmd="hide", firstFrame=0,},
			   },
			   [left_head_advanced]={
				   [1]={cmd="show", firstFrame=0,},
				   [2]={cmd="turn", axis=y_axis, targetValue=1.047198, firstFrame=24, lastFrame=40,},
			   },
			   [right_head_advanced]={
				   [1]={cmd="show", firstFrame=0,},
				   [2]={cmd="turn", axis=x_axis, targetValue=-1.047198, firstFrame=24, lastFrame=40,},
			   },
			   [left_pointer1]={
				   [1]={cmd="show", firstFrame=0,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=24, lastFrame=36,},
			   },
			   [left_pointer2]={
				   [1]={cmd="show", firstFrame=0,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=24, lastFrame=36,},
			   },
			   [right_pointer1]={
				   [1]={cmd="show", firstFrame=0,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=24, lastFrame=36,},
			   },
			   [right_pointer2]={
				   [1]={cmd="show", firstFrame=0,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=24, lastFrame=36,},
			   },
	})
end

local function closeadv()
	initTween({veryLastFrame=28,
			   [left_cover]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=8, lastFrame=20,},
			   },
			   [right_cover]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=8, lastFrame=20,},
			   },
			   [right_box]={
				   [1]={cmd="move", axis=z_axis, targetValue=16.000000, firstFrame=0, lastFrame=12,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=12, lastFrame=28,},
			   },
			   [left_box]={
				   [1]={cmd="move", axis=z_axis, targetValue=16.000000, firstFrame=0, lastFrame=12,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=12, lastFrame=28,},
			   },
			   [right_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=29.533281, firstFrame=0, lastFrame=8,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=8, lastFrame=16,},
			   },
			   [left_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=29.533281, firstFrame=0, lastFrame=8,},
				   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=8, lastFrame=16,},
			   },
			   [left_head_advanced]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=8,},
			   },
			   [right_head_advanced]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=0, lastFrame=8,},
			   },
			   [left_pointer1]={
				   [1]={cmd="move", axis=z_axis, targetValue=2.000000, firstFrame=0, lastFrame=4,},
			   },
			   [left_pointer2]={
				   [1]={cmd="move", axis=z_axis, targetValue=2.000000, firstFrame=0, lastFrame=4,},
			   },
			   [right_pointer1]={
				   [1]={cmd="move", axis=z_axis, targetValue=2.000000, firstFrame=0, lastFrame=4,},
			   },
			   [right_pointer2]={
				   [1]={cmd="move", axis=z_axis, targetValue=2.000000, firstFrame=0, lastFrame=4,},
			   },
	})
end

Animations = { openstd=openstd, closestd=closestd, morphup=morphup, openadv=openadv, closeadv=closeadv }

return Animations
