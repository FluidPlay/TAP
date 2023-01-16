local Animations = {};

--- open_default
local function openstd()
	initTween({veryLastFrame=40,
			   [right_cover5]={
				   [1]={cmd="turn", axis=y_axis, targetValue=3.106686, firstFrame=0, lastFrame=32,},
				   [2]={cmd="hide", firstFrame=8,},
			   },
			   [left_cover5]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-3.106686, firstFrame=0, lastFrame=32,},
				   [2]={cmd="hide", firstFrame=8,},
			   },
			   [right_cover4]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-0.418879, firstFrame=0, lastFrame=12,},
				   [2]={cmd="hide", firstFrame=12,},
			   },
			   [right_cover3]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-0.418879, firstFrame=4, lastFrame=16,},
				   [2]={cmd="hide", firstFrame=20,},
			   },
			   [right_cover2]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-0.418879, firstFrame=8, lastFrame=20,},
				   [2]={cmd="hide", firstFrame=24,},
			   },
			   [right_cover1]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-0.418879, firstFrame=12, lastFrame=24,},
			   },
			   [left_cover4]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.418879, firstFrame=0, lastFrame=12,},
				   [2]={cmd="hide", firstFrame=12,},
			   },
			   [left_cover3]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.418879, firstFrame=4, lastFrame=16,},
				   [2]={cmd="hide", firstFrame=20,},
			   },
			   [left_cover2]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.418879, firstFrame=8, lastFrame=20,},
				   [2]={cmd="hide", firstFrame=24,},
			   },
			   [left_cover1]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.418879, firstFrame=12, lastFrame=24,},
			   },
			   [right_arm2]={
				   [1]={cmd="turn", axis=y_axis, targetValue=1.605703, firstFrame=0, lastFrame=40,},
			   },
			   [right_arm3]={
				   [1]={cmd="turn", axis=y_axis, targetValue=1.047198, firstFrame=12, lastFrame=40,},
			   },
			   [right_head]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.523599, firstFrame=12, lastFrame=40,},
			   },
			   [left_sign]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-0.523599, firstFrame=12, lastFrame=24,},
			   },
			   [right_sign]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.523599, firstFrame=12, lastFrame=24,},
			   },
			   [left_arm2]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-1.605703, firstFrame=0, lastFrame=40,},
			   },
			   [left_arm3]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-1.047198, firstFrame=12, lastFrame=40,},
			   },
			   [left_head]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-0.523599, firstFrame=12, lastFrame=40,},
			   },
			   [left_base]={
				   [1]={cmd="move", axis=x_axis, targetValue=-3.000000, firstFrame=0, lastFrame=20,},
			   },
			   [right_base]={
				   [1]={cmd="move", axis=x_axis, targetValue=3.000000, firstFrame=0, lastFrame=20,},
			   },
			   [right_arm1]={
				   [1]={cmd="move", axis=x_axis, targetValue=4.700000, firstFrame=10, lastFrame=40,},
			   },
			   [left_arm1]={
				   [1]={cmd="move", axis=x_axis, targetValue=-4.700000, firstFrame=0, lastFrame=40,},
			   },
	})
end
local function closestd()
	initTween({veryLastFrame=32,
			   [right_cover5]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
				   [2]={cmd="show", firstFrame=24,},
			   },
			   [left_cover5]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
				   [2]={cmd="show", firstFrame=24,},
			   },
			   [right_cover4]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=8, lastFrame=32,},
				   [2]={cmd="show", firstFrame=20,},
			   },
			   [right_cover3]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=8, lastFrame=32,},
				   [2]={cmd="show", firstFrame=16,},
			   },
			   [right_cover2]={
				   [1]={cmd="show", firstFrame=8,},
				   [2]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=8, lastFrame=32,},
			   },
			   [right_cover1]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=8, lastFrame=32,},
			   },
			   [left_cover4]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=8, lastFrame=32,},
				   [2]={cmd="show", firstFrame=20,},
			   },
			   [left_cover3]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=8, lastFrame=32,},
				   [2]={cmd="show", firstFrame=15,},
			   },
			   [left_cover2]={
				   [1]={cmd="show", firstFrame=8,},
				   [2]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=8, lastFrame=32,},
			   },
			   [left_cover1]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=8, lastFrame=32,},
			   },
			   [right_arm2]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=16,},
			   },
			   [right_arm3]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=20,},
			   },
			   [right_head]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=20,},
			   },
			   [left_sign]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=16, lastFrame=24,},
			   },
			   [right_sign]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=16, lastFrame=24,},
			   },
			   [left_arm2]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-0.000000, firstFrame=0, lastFrame=16,},
			   },
			   [left_arm3]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=20,},
			   },
			   [left_head]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=20,},
			   },
			   [left_base]={
				   [1]={cmd="move", axis=x_axis, targetValue=0.000000, firstFrame=12, lastFrame=28,},
			   },
			   [right_base]={
				   [1]={cmd="move", axis=x_axis, targetValue=0.000000, firstFrame=12, lastFrame=28,},
			   },
			   [right_arm1]={
				   [1]={cmd="move", axis=x_axis, targetValue=0.000000, firstFrame=0, lastFrame=20,},
			   },
			   [left_arm1]={
				   [1]={cmd="move", axis=x_axis, targetValue=0.000000, firstFrame=0, lastFrame=20,},
			   },
	})
end
local function morphup()
	initTween({veryLastFrame=48,
			   [left_sign]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-0.139626, firstFrame=4, lastFrame=20,},
				   [2]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=20, lastFrame=48,},
			   },
			   [right_sign]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.139626, firstFrame=4, lastFrame=20,},
				   [2]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=20, lastFrame=48,},
			   },
			   [left_base]={
				   [1]={cmd="move", axis=x_axis, targetValue=-17.000000, firstFrame=0, lastFrame=48,},
			   },
			   [right_base]={
				   [1]={cmd="move", axis=x_axis, targetValue=17.000000, firstFrame=0, lastFrame=48,},
			   },
			   [left_back_extension]={
				   [1]={cmd="move", axis=y_axis, targetValue=-18.000000, firstFrame=0, lastFrame=48,},
			   },
			   [right_back_extension]={
				   [1]={cmd="move", axis=y_axis, targetValue=-18.000000, firstFrame=0, lastFrame=48,},
			   },
			   [back_wall_top]={
				   [1]={cmd="move", axis=y_axis, targetValue=-18.000000, firstFrame=0, lastFrame=48,},
				   [2]={cmd="move", axis=z_axis, targetValue=4.000000, firstFrame=32, lastFrame=48,},
			   },
			   [right_wall]={
				   [1]={cmd="move", axis=z_axis, targetValue=4.000000, firstFrame=32, lastFrame=48,},
			   },
			   [left_wall]={
				   [1]={cmd="move", axis=z_axis, targetValue=4.000000, firstFrame=32, lastFrame=48,},
			   },
			   [right_back_upgrade]={
				   [1]={cmd="move", axis=x_axis, targetValue=24.000000, firstFrame=20, lastFrame=48,},
				   [2]={cmd="show", firstFrame=32,},
			   },
			   [left_back_upgrade]={
				   [1]={cmd="move", axis=x_axis, targetValue=-24.000000, firstFrame=20, lastFrame=48,},
				   [2]={cmd="show", firstFrame=32,},
			   },
			   [right_front_extension]={
				   [1]={cmd="move", axis=y_axis, targetValue=17.874325, firstFrame=0, lastFrame=48,},
			   },
			   [left_front_extension]={
				   [1]={cmd="move", axis=y_axis, targetValue=18.000000, firstFrame=0, lastFrame=48,},
			   },
	})
end
local function openadv()
	initTween({veryLastFrame=48,
			   [right_cover5]={
				   [1]={cmd="turn", axis=y_axis, targetValue=3.106686, firstFrame=0, lastFrame=32,},
				   [2]={cmd="hide", firstFrame=8,},
			   },
			   [left_cover5]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-3.106686, firstFrame=0, lastFrame=32,},
				   [2]={cmd="hide", firstFrame=8,},
			   },
			   [right_cover4]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-0.418879, firstFrame=0, lastFrame=12,},
				   [2]={cmd="hide", firstFrame=12,},
			   },
			   [right_cover3]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-0.418879, firstFrame=4, lastFrame=16,},
				   [2]={cmd="hide", firstFrame=20,},
			   },
			   [right_cover2]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-0.418879, firstFrame=8, lastFrame=20,},
				   [2]={cmd="hide", firstFrame=24,},
			   },
			   [right_cover1]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-0.418879, firstFrame=12, lastFrame=24,},
			   },
			   [left_cover4]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.418879, firstFrame=0, lastFrame=12,},
				   [2]={cmd="hide", firstFrame=12,},
			   },
			   [left_cover3]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.418879, firstFrame=4, lastFrame=16,},
				   [2]={cmd="hide", firstFrame=20,},
			   },
			   [left_cover2]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.418879, firstFrame=8, lastFrame=20,},
				   [2]={cmd="hide", firstFrame=24,},
			   },
			   [left_cover1]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.418879, firstFrame=12, lastFrame=24,},
			   },
			   [left_sign]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-0.523599, firstFrame=12, lastFrame=28,},
			   },
			   [right_sign]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.523599, firstFrame=12, lastFrame=28,},
			   },
			   [left_arm2_advanced]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-1.902409, firstFrame=12, lastFrame=36,},
			   },
			   [left_arm3_advanced]={
				   [1]={cmd="turn", axis=y_axis, targetValue=2.617994, firstFrame=12, lastFrame=36,},
			   },
			   [left_head_advanced]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-0.279253, firstFrame=12, lastFrame=40,},
			   },
			   [right_arm2_advanced]={
				   [1]={cmd="turn", axis=y_axis, targetValue=1.919862, firstFrame=16, lastFrame=40,},
			   },
			   [right_arm3_advanced]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-2.827433, firstFrame=16, lastFrame=40,},
			   },
			   [right_head_advanced]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.209440, firstFrame=12, lastFrame=24,},
				   [2]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=24, lastFrame=36,},
			   },
			   [right_arm1_advanced]={
				   [1]={cmd="move", axis=x_axis, targetValue=20.000000, firstFrame=10, lastFrame=48,},
			   },
			   [left_arm1_advanced]={
				   [1]={cmd="move", axis=x_axis, targetValue=-20.000000, firstFrame=10, lastFrame=48,},
			   },
	})
end
local function closeadv()
	initTween({veryLastFrame=32,
			   [right_cover5]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
				   [2]={cmd="show", firstFrame=24,},
			   },
			   [left_cover5]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
				   [2]={cmd="show", firstFrame=24,},
			   },
			   [right_cover4]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
				   [2]={cmd="show", firstFrame=20,},
			   },
			   [right_cover3]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
				   [2]={cmd="show", firstFrame=16,},
			   },
			   [right_cover2]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
				   [2]={cmd="show", firstFrame=12,},
			   },
			   [right_cover1]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
			   },
			   [left_cover4]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
				   [2]={cmd="show", firstFrame=20,},
			   },
			   [left_cover3]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
				   [2]={cmd="show", firstFrame=16,},
			   },
			   [left_cover2]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
				   [2]={cmd="show", firstFrame=12,},
			   },
			   [left_cover1]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
			   },
			   [left_sign]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=8, lastFrame=20,},
			   },
			   [right_sign]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=8, lastFrame=20,},
			   },
			   [left_arm2_advanced]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
			   },
			   [left_arm3_advanced]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
			   },
			   [left_head_advanced]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
			   },
			   [right_arm2_advanced]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=28,},
			   },
			   [right_arm3_advanced]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=28,},
			   },
			   [right_head_advanced]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.279253, firstFrame=0, lastFrame=14,},
				   [2]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=14, lastFrame=28,},
			   },
			   [right_arm1_advanced]={
				   [1]={cmd="move", axis=x_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
			   },
			   [left_arm1_advanced]={
				   [1]={cmd="move", axis=x_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
			   },
	})
end

local Animations = {openstd = openstd, closestd = closestd, morphup = morphup, openadv = openadv, closeadv = closeadv, }

return Animations
