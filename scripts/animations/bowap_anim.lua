local Animations = {};

--- open_default	-- Flip all turn and move x/z_axis to flip rotations (180 deg Y)
local function openstd()
	initTween({veryLastFrame=52,
			   [right_cover]={
				   [1]={cmd="turn", axis=x_axis, targetValue=-2.879793, firstFrame=0, lastFrame=52,},
			   },
			   [left_cover]={
				   [1]={cmd="turn", axis=x_axis, targetValue=-2.879793, firstFrame=0, lastFrame=52,},
			   },
			   [right_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=7.000000, firstFrame=24, lastFrame=36,},
			   },
			   [right_pointer]={
				   [1]={cmd="move", axis=y_axis, targetValue=-1.500000, firstFrame=20, lastFrame=32,},
				   [2]={cmd="move", axis=y_axis, targetValue=0.000000, firstFrame=44, lastFrame=52,},
			   },
			   [right_arm1]={
				   [1]={cmd="move", axis=y_axis, targetValue=-14.000002, firstFrame=28, lastFrame=52,},
			   },
			   [right_arm2]={
				   [1]={cmd="turn", axis=x_axis, targetValue=-1.570796, firstFrame=28, lastFrame=52,},
			   },
			   [right_arm3]={
				   [1]={cmd="turn", axis=x_axis, targetValue=-1.570796, firstFrame=28, lastFrame=52,},
			   },
			   [right_head]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.294524, firstFrame=28, lastFrame=34,},
				   [2]={cmd="turn", axis=x_axis, targetValue=-0.349066, firstFrame=34, lastFrame=52,},
			   },
			   [left_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=7.000000, firstFrame=24, lastFrame=36,},
			   },
			   [left_arm2]={
				   [1]={cmd="turn", axis=x_axis, targetValue=-1.570796, firstFrame=28, lastFrame=52,},
			   },
			   [left_arm3]={
				   [1]={cmd="turn", axis=x_axis, targetValue=-1.570796, firstFrame=28, lastFrame=52,},
			   },
			   [left_head]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.294524, firstFrame=28, lastFrame=34,},
				   [2]={cmd="turn", axis=x_axis, targetValue=-0.349066, firstFrame=34, lastFrame=52,},
			   },
			   [left_arm1]={
				   [1]={cmd="move", axis=y_axis, targetValue=-14.000002, firstFrame=28, lastFrame=52,},
			   },
			   [left_pointer]={
				   [1]={cmd="move", axis=y_axis, targetValue=-1.500000, firstFrame=20, lastFrame=32,},
				   [2]={cmd="move", axis=y_axis, targetValue=0.000000, firstFrame=44, lastFrame=52,},
			   },
			   [right_sign]={
				   [1]={cmd="turn", axis=x_axis, targetValue=-0.349066, firstFrame=40, lastFrame=48,},
			   },
			   [left_sign]={
				   [1]={cmd="turn", axis=x_axis, targetValue=-0.349066, firstFrame=40, lastFrame=48,},
			   },
	})
end
local function closestd()
	initTween({veryLastFrame=40,
			   [right_cover]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=4, lastFrame=40,},
			   },
			   [left_cover]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=4, lastFrame=40,},
			   },
			   [right_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=8, lastFrame=24,},
			   },
			   [right_pointer]={
				   [1]={cmd="move", axis=y_axis, targetValue=-1.500000, firstFrame=0, lastFrame=8,},
				   [2]={cmd="move", axis=y_axis, targetValue=0.000000, firstFrame=16, lastFrame=28,},
			   },
			   [right_arm1]={
				   [1]={cmd="move", axis=y_axis, targetValue=0.000000, firstFrame=4, lastFrame=24,},
			   },
			   [right_arm2]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=0, lastFrame=24,},
			   },
			   [right_arm3]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=0, lastFrame=28,},
			   },
			   [right_head]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.294524, firstFrame=0, lastFrame=16,},
				   [2]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=16, lastFrame=28,},
			   },
			   [left_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=8, lastFrame=24,},
			   },
			   [left_arm2]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=0, lastFrame=24,},
			   },
			   [left_arm3]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=0, lastFrame=28,},
			   },
			   [left_head]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.294524, firstFrame=0, lastFrame=16,},
				   [2]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=16, lastFrame=28,},
			   },
			   [left_arm1]={
				   [1]={cmd="move", axis=y_axis, targetValue=0.000000, firstFrame=4, lastFrame=24,},
			   },
			   [left_pointer]={
				   [1]={cmd="move", axis=y_axis, targetValue=-1.500000, firstFrame=0, lastFrame=8,},
				   [2]={cmd="move", axis=y_axis, targetValue=0.000000, firstFrame=16, lastFrame=28,},
			   },
			   [right_sign]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=29, lastFrame=40,},
			   },
			   [left_sign]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=29, lastFrame=40,},
			   },
	})
end
local function morphup()
	initTween({veryLastFrame=60,
			   --[right_pointer]={
				--   [1]={cmd="hide", firstFrame=0,},
			   --},
			   --[right_arm1]={
				--   [1]={cmd="hide", firstFrame=0,},
			   --},
			   --[right_arm2]={
				--   [1]={cmd="hide", firstFrame=0,},
			   --},
			   --[right_arm3]={
				--   [1]={cmd="hide", firstFrame=0,},
			   --},
			   --[right_head]={
				--   [1]={cmd="hide", firstFrame=0,},
			   --},
			   --[left_arm2]={
				--   [1]={cmd="hide", firstFrame=0,},
			   --},
			   --[left_arm3]={
				--   [1]={cmd="hide", firstFrame=0,},
			   --},
			   --[left_head]={
				--   [1]={cmd="hide", firstFrame=0,},
			   --},
			   --[left_pointer]={
				--   [1]={cmd="hide", firstFrame=0,},
			   --},
			   [right_sign]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.261799, firstFrame=36, lastFrame=44,},
				   [2]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=44, lastFrame=60,},
			   },
			   [left_sign]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.261799, firstFrame=36, lastFrame=44,},
				   [2]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=44, lastFrame=60,},
			   },
			   [left_building_base]={
				   [1]={cmd="move", axis=y_axis, targetValue=7.500000, firstFrame=4, lastFrame=48,},
			   },
			   [right_building_base]={
				   [1]={cmd="move", axis=y_axis, targetValue=7.500000, firstFrame=4, lastFrame=48,},
			   },
			   [left_box]={
				   [1]={cmd="move", axis=z_axis, targetValue=4.000000, firstFrame=36, lastFrame=60,},
			   },
			   [right_box]={
				   [1]={cmd="move", axis=z_axis, targetValue=4.000000, firstFrame=36, lastFrame=60,},
			   },
			   [plate_back_extension]={
				   [1]={cmd="move", axis=y_axis, targetValue=6.000000, firstFrame=36, lastFrame=60,},
			   },
			   [plate_fontal_extension]={
				   [1]={cmd="move", axis=y_axis, targetValue=-6.000000, firstFrame=36, lastFrame=60,},
			   },
			   [plate_base]={
				   [1]={cmd="move", axis=z_axis, targetValue=4.000000, firstFrame=36, lastFrame=60,},
			   },
			   [upgrade]={
				   --[1]={cmd="show", firstFrame=0,},
				   [2]={cmd="move", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=36,},
			   },
			   --[left_arm2_advanced]={
				--   [1]={cmd="show", firstFrame=0,},
			   --},
			   --[right_arm2_advanced]={
				--   [1]={cmd="show", firstFrame=0,},
			   --},
			   --[left_arm3_advanced]={
				--   [1]={cmd="show", firstFrame=0,},
			   --},
			   --[right_arm3_advanced]={
				--   [1]={cmd="show", firstFrame=0,},
			   --},
			   --[left_head_advanced]={
				--   [1]={cmd="show", firstFrame=0,},
			   --},
			   --[right_head_advanced]={
				--   [1]={cmd="show", firstFrame=0,},
			   --},
			   --[left_arm1_advanced]={
				--   [1]={cmd="show", firstFrame=0,},
			   --},
			   --[right_arm1_advanced]={
				--   [1]={cmd="show", firstFrame=0,},
			   --},
	})
end
local function openadv()
	initTween({veryLastFrame=52,
			   [right_cover]={
				   [1]={cmd="turn", axis=x_axis, targetValue=-2.879793, firstFrame=0, lastFrame=52,},
			   },
			   [left_cover]={
				   [1]={cmd="turn", axis=x_axis, targetValue=-2.879793, firstFrame=0, lastFrame=52,},
			   },
			   [right_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=7.000000, firstFrame=24, lastFrame=36,},
			   },
			   [left_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=7.000000, firstFrame=24, lastFrame=36,},
			   },
			   [right_sign]={
				   [1]={cmd="turn", axis=x_axis, targetValue=-0.349066, firstFrame=40, lastFrame=48,},
			   },
			   [left_sign]={
				   [1]={cmd="turn", axis=x_axis, targetValue=-0.349066, firstFrame=40, lastFrame=48,},
			   },
			   [left_arm2_advanced]={
				   [1]={cmd="turn", axis=x_axis, targetValue=-0.601815, firstFrame=36, lastFrame=40,},
				   [2]={cmd="turn", axis=x_axis, targetValue=-2.792527, firstFrame=40, lastFrame=48,},
			   },
			   [right_arm2_advanced]={
				   [1]={cmd="turn", axis=x_axis, targetValue=-0.601815, firstFrame=36, lastFrame=40,},
				   [2]={cmd="turn", axis=x_axis, targetValue=-2.792527, firstFrame=40, lastFrame=48,},
			   },
			   [left_arm3_advanced]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.052499, firstFrame=28, lastFrame=36,},
				   [2]={cmd="turn", axis=x_axis, targetValue=3.124139, firstFrame=36, lastFrame=48,},
			   },
			   [right_arm3_advanced]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.052499, firstFrame=28, lastFrame=36,},
				   [2]={cmd="turn", axis=x_axis, targetValue=3.124139, firstFrame=36, lastFrame=48,},
			   },
			   [left_head_advanced]={
				   [1]={cmd="turn", axis=x_axis, targetValue=-0.104720, firstFrame=36, lastFrame=40,},
				   [2]={cmd="turn", axis=x_axis, targetValue=-1.308997, firstFrame=40, lastFrame=52,},
			   },
			   [right_head_advanced]={
				   [1]={cmd="turn", axis=x_axis, targetValue=-0.104720, firstFrame=36, lastFrame=40,},
				   [2]={cmd="turn", axis=x_axis, targetValue=-1.308997, firstFrame=40, lastFrame=52,},
			   },
			   [left_arm1_advanced]={
				   [1]={cmd="move", axis=y_axis, targetValue=4.500000, firstFrame=32, lastFrame=48,},
			   },
			   [right_arm1_advanced]={
				   [1]={cmd="move", axis=y_axis, targetValue=4.500000, firstFrame=32, lastFrame=48,},
			   },
	})
end
local function closeadv()
	initTween({veryLastFrame=40,
			   [right_cover]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=4, lastFrame=40,},
			   },
			   [left_cover]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=4, lastFrame=40,},
			   },
			   [right_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=8, lastFrame=24,},
			   },
			   [left_elevator]={
				   [1]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=8, lastFrame=24,},
			   },
			   [right_sign]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=29, lastFrame=40,},
			   },
			   [left_sign]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=29, lastFrame=40,},
			   },
			   [left_arm2_advanced]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=0, lastFrame=12,},
			   },
			   [right_arm2_advanced]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=0, lastFrame=12,},
			   },
			   [left_arm3_advanced]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.052499, firstFrame=0, lastFrame=12,},
				   [2]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=12, lastFrame=16,},
			   },
			   [right_arm3_advanced]={
				   [1]={cmd="turn", axis=x_axis, targetValue=0.052499, firstFrame=0, lastFrame=12,},
				   [2]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=12, lastFrame=16,},
			   },
			   [left_head_advanced]={
				   [1]={cmd="turn", axis=x_axis, targetValue=-0.137687, firstFrame=0, lastFrame=8,},
				   [2]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=8, lastFrame=16,},
			   },
			   [right_head_advanced]={
				   [1]={cmd="turn", axis=x_axis, targetValue=-0.137687, firstFrame=0, lastFrame=8,},
				   [2]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=8, lastFrame=16,},
			   },
			   [left_arm1_advanced]={
				   [1]={cmd="move", axis=y_axis, targetValue=0.000000, firstFrame=8, lastFrame=20,},
			   },
			   [right_arm1_advanced]={
				   [1]={cmd="move", axis=y_axis, targetValue=0.000000, firstFrame=8, lastFrame=20,},
			   },
	})
end

local Animations = {openstd = openstd, closestd = closestd, morphup = morphup, openadv = openadv, closeadv = closeadv, }

return Animations