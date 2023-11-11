--- open_default
local function create()
	initTween({veryLastFrame=89,
			   [root_x]={
				   [1]={cmd="turn", axis=x_axis, targetValue=-0.702437, firstFrame=14, lastFrame=39,},
				   [2]={cmd="move", axis=y_axis, targetValue=0.170520, firstFrame=14, lastFrame=39,},
				   [3]={cmd="move", axis=z_axis, targetValue=-0.290530, firstFrame=14, lastFrame=39,},
				   [4]={cmd="turn", axis=x_axis, targetValue=0.374860, firstFrame=39, lastFrame=89,},
				   [5]={cmd="move", axis=y_axis, targetValue=0.105219, firstFrame=39, lastFrame=89,},
				   [6]={cmd="move", axis=z_axis, targetValue=-0.391124, firstFrame=39, lastFrame=89,},
			   },
			   [c_thigh_b_r]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.090754, firstFrame=14, lastFrame=39,},
			   },
			   [thigh_stretch_r]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.090754, firstFrame=14, lastFrame=39,},
			   },
			   [leg_stretch_r]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.090753, firstFrame=14, lastFrame=39,},
				   [2]={cmd="turn", axis=z_axis, targetValue=-0.524671, firstFrame=39, lastFrame=89,},
			   },
			   [foot_r]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.090754, firstFrame=14, lastFrame=39,},
				   [2]={cmd="turn", axis=z_axis, targetValue=-1.111272, firstFrame=39, lastFrame=89,},
			   },
			   [c_thigh_b_dupli_001_l]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-0.087618, firstFrame=14, lastFrame=39,},
			   },
			   [thigh_stretch_dupli_001_l]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-0.087618, firstFrame=14, lastFrame=39,},
			   },
			   [leg_stretch_dupli_001_l]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-0.087619, firstFrame=14, lastFrame=39,},
			   },
			   [foot_dupli_001_l]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-0.087618, firstFrame=14, lastFrame=39,},
				   [2]={cmd="turn", axis=z_axis, targetValue=-0.474476, firstFrame=39, lastFrame=89,},
			   },
			   [c_thigh_b_dupli_001_r]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-0.087618, firstFrame=14, lastFrame=39,},
			   },
			   [thigh_stretch_dupli_001_r]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-0.087618, firstFrame=14, lastFrame=39,},
			   },
			   [leg_stretch_dupli_001_r]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-0.087618, firstFrame=14, lastFrame=39,},
			   },
			   [foot_dupli_001_r]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-0.087618, firstFrame=14, lastFrame=39,},
				   [2]={cmd="turn", axis=z_axis, targetValue=-0.474476, firstFrame=39, lastFrame=89,},
			   },
			   [c_tail_00_x]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.279025, firstFrame=14, lastFrame=39,},
				   [2]={cmd="turn", axis=z_axis, targetValue=-0.697085, firstFrame=39, lastFrame=89,},
			   },
			   [c_tail_01_x]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.279025, firstFrame=14, lastFrame=39,},
				   [2]={cmd="turn", axis=z_axis, targetValue=-0.697085, firstFrame=39, lastFrame=89,},
			   },
			   [c_tail_02_x]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.279025, firstFrame=14, lastFrame=39,},
				   [2]={cmd="turn", axis=z_axis, targetValue=-0.697085, firstFrame=39, lastFrame=89,},
			   },
			   [c_tail_03_x]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.279025, firstFrame=14, lastFrame=39,},
				   [2]={cmd="turn", axis=z_axis, targetValue=-0.697084, firstFrame=39, lastFrame=89,},
			   },
			   [c_tail_04_x]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.279025, firstFrame=14, lastFrame=39,},
				   [2]={cmd="turn", axis=z_axis, targetValue=-0.697084, firstFrame=39, lastFrame=89,},
			   },
			   [c_thigh_b_dupli_002_l]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.095720, firstFrame=14, lastFrame=39,},
				   [2]={cmd="turn", axis=z_axis, targetValue=0.192620, firstFrame=39, lastFrame=89,},
			   },
			   [thigh_stretch_dupli_002_l]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.095720, firstFrame=14, lastFrame=39,},
				   [2]={cmd="turn", axis=z_axis, targetValue=-0.577922, firstFrame=39, lastFrame=89,},
			   },
			   [leg_stretch_dupli_002_l]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.095720, firstFrame=14, lastFrame=39,},
				   [2]={cmd="turn", axis=z_axis, targetValue=-0.577922, firstFrame=39, lastFrame=89,},
			   },
			   [foot_dupli_002_l]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.095720, firstFrame=14, lastFrame=39,},
				   [2]={cmd="turn", axis=z_axis, targetValue=-1.122439, firstFrame=39, lastFrame=89,},
			   },
			   [c_thigh_b_dupli_002_r]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.095720, firstFrame=14, lastFrame=39,},
				   [2]={cmd="turn", axis=z_axis, targetValue=0.192620, firstFrame=39, lastFrame=89,},
			   },
			   [thigh_stretch_dupli_002_r]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.095720, firstFrame=14, lastFrame=39,},
				   [2]={cmd="turn", axis=z_axis, targetValue=-0.577922, firstFrame=39, lastFrame=89,},
			   },
			   [leg_stretch_dupli_002_r]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.095720, firstFrame=14, lastFrame=39,},
				   [2]={cmd="turn", axis=z_axis, targetValue=-0.577922, firstFrame=39, lastFrame=89,},
			   },
			   [foot_dupli_002_r]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.095720, firstFrame=14, lastFrame=39,},
				   [2]={cmd="turn", axis=z_axis, targetValue=-1.122440, firstFrame=39, lastFrame=89,},
			   },
			   [cc_wing_L]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-1.287216, firstFrame=14, lastFrame=39,},
				   [2]={cmd="turn", axis=z_axis, targetValue=0.942039, firstFrame=39, lastFrame=89,},
			   },
			   [cc_wing_R]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-1.287216, firstFrame=14, lastFrame=39,},
				   [2]={cmd="turn", axis=z_axis, targetValue=0.942039, firstFrame=39, lastFrame=89,},
			   },
			   [c_thigh_b_l]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.090753, firstFrame=14, lastFrame=39,},
			   },
			   [thigh_stretch_l]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.090753, firstFrame=14, lastFrame=39,},
			   },
			   [leg_stretch_l]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.090753, firstFrame=14, lastFrame=39,},
				   [2]={cmd="turn", axis=z_axis, targetValue=-0.524671, firstFrame=39, lastFrame=89,},
			   },
			   [foot_l]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.090754, firstFrame=14, lastFrame=39,},
				   [2]={cmd="turn", axis=z_axis, targetValue=-1.111272, firstFrame=39, lastFrame=89,},
			   },
	})
end

local Animations = {create = create, }

return Animations