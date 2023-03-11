local Animations = {};

--- open_default
local function openstd()
	initTween({veryLastFrame=40,
			   [right_head]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-0.575959, firstFrame=0, lastFrame=40,},
			   },
			   [left_head]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.575959, firstFrame=0, lastFrame=40,},
			   },
	})
end
local function closestd()
	initTween({veryLastFrame=32,
			   [right_head]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=16,},
			   },
			   [left_head]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=20,},
			   },
	})
end
local function morphup()
	--initTween({veryLastFrame=48,
	--		   [left_sign]={
	--			   [1]={cmd="turn", axis=y_axis, targetValue=-0.139626, firstFrame=4, lastFrame=20,},
	--			   [2]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=20, lastFrame=48,},
	--		   },
	--		   [right_sign]={
	--			   [1]={cmd="turn", axis=y_axis, targetValue=0.139626, firstFrame=4, lastFrame=20,},
	--			   [2]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=20, lastFrame=48,},
	--		   },
	--		   [left_base]={
	--			   [1]={cmd="move", axis=x_axis, targetValue=-17.000000, firstFrame=0, lastFrame=48,},
	--		   },
	--		   [right_base]={
	--			   [1]={cmd="move", axis=x_axis, targetValue=17.000000, firstFrame=0, lastFrame=48,},
	--		   },
	--		   [left_back_extension]={
	--			   [1]={cmd="move", axis=y_axis, targetValue=-18.000000, firstFrame=0, lastFrame=48,},
	--		   },
	--		   [right_back_extension]={
	--			   [1]={cmd="move", axis=y_axis, targetValue=-18.000000, firstFrame=0, lastFrame=48,},
	--		   },
	--		   [back_wall_top]={
	--			   [1]={cmd="move", axis=y_axis, targetValue=-18.000000, firstFrame=0, lastFrame=48,},
	--			   [2]={cmd="move", axis=z_axis, targetValue=4.000000, firstFrame=32, lastFrame=48,},
	--		   },
	--		   [right_wall]={
	--			   [1]={cmd="move", axis=z_axis, targetValue=4.000000, firstFrame=32, lastFrame=48,},
	--		   },
	--		   [left_wall]={
	--			   [1]={cmd="move", axis=z_axis, targetValue=4.000000, firstFrame=32, lastFrame=48,},
	--		   },
	--		   [right_back_upgrade]={
	--			   [1]={cmd="move", axis=x_axis, targetValue=24.000000, firstFrame=20, lastFrame=48,},
	--			   [2]={cmd="show", firstFrame=32,},
	--		   },
	--		   [left_back_upgrade]={
	--			   [1]={cmd="move", axis=x_axis, targetValue=-24.000000, firstFrame=20, lastFrame=48,},
	--			   [2]={cmd="show", firstFrame=32,},
	--		   },
	--		   [right_front_extension]={
	--			   [1]={cmd="move", axis=y_axis, targetValue=17.874325, firstFrame=0, lastFrame=48,},
	--		   },
	--		   [left_front_extension]={
	--			   [1]={cmd="move", axis=y_axis, targetValue=18.000000, firstFrame=0, lastFrame=48,},
	--		   },
	--})
end
local function openadv()
	initTween({veryLastFrame=40,
			   [right_head]={
				   [1]={cmd="turn", axis=y_axis, targetValue=-0.575959, firstFrame=0, lastFrame=40,},
			   },
			   [left_head]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.575959, firstFrame=0, lastFrame=40,},
			   },
	})
end
local function closeadv()
	initTween({veryLastFrame=32,
			   [right_head]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=16,},
			   },
			   [left_head]={
				   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=20,},
			   },
	})
end

local Animations = {openstd = openstd, closestd = closestd, morphup = morphup, openadv = openadv, closeadv = closeadv, }

return Animations
