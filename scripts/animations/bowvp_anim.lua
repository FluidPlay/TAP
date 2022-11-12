local Animations = {};

--- open_default
local function anim1()
	initTween({veryLastFrame=40,
			   [right_cover5]={
				   [1]={cmd="turn", axis=z_axis, targetValue=3.106686, firstFrame=0, lastFrame=32,},
				   [2]={cmd="hide", firstFrame=8,},
			   },
			   [left_cover5]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-3.106686, firstFrame=0, lastFrame=32,},
				   [2]={cmd="hide", firstFrame=8,},
			   },
			   [right_cover4]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-0.418879, firstFrame=0, lastFrame=12,},
				   [2]={cmd="hide", firstFrame=12,},
			   },
			   [right_cover3]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-0.418879, firstFrame=4, lastFrame=16,},
				   [2]={cmd="hide", firstFrame=20,},
			   },
			   [right_cover2]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-0.418879, firstFrame=8, lastFrame=20,},
				   [2]={cmd="hide", firstFrame=24,},
			   },
			   [right_cover1]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-0.418879, firstFrame=12, lastFrame=24,},
			   },
			   [left_cover4]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.418879, firstFrame=0, lastFrame=12,},
				   [2]={cmd="hide", firstFrame=12,},
			   },
			   [left_cover3]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.418879, firstFrame=4, lastFrame=16,},
				   [2]={cmd="hide", firstFrame=20,},
			   },
			   [left_cover2]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.418879, firstFrame=8, lastFrame=20,},
				   [2]={cmd="hide", firstFrame=24,},
			   },
			   [left_cover1]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.418879, firstFrame=12, lastFrame=24,},
			   },
			   [right_arm2]={
				   [1]={cmd="turn", axis=z_axis, targetValue=1.553343, firstFrame=0, lastFrame=40,},
			   },
			   [right_arm3]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.698132, firstFrame=12, lastFrame=40,},
			   },
			   [right_head]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.698132, firstFrame=12, lastFrame=40,},
			   },
			   [left_sign]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-0.523599, firstFrame=12, lastFrame=24,},
			   },
			   [right_sign]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.523599, firstFrame=12, lastFrame=24,},
			   },
			   [left_arm2]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-1.553343, firstFrame=0, lastFrame=40,},
			   },
			   [left_arm3]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-0.698132, firstFrame=12, lastFrame=40,},
			   },
			   [left_head]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-0.698132, firstFrame=12, lastFrame=40,},
			   },
			   [left_base]={
				   [1]={cmd="move", axis=x_axis, targetValue=3.000000, firstFrame=0, lastFrame=20,},
			   },
			   [right_base]={
				   [1]={cmd="move", axis=x_axis, targetValue=-3.000000, firstFrame=0, lastFrame=20,},
			   },
			   [right_arm1]={
				   [1]={cmd="move", axis=x_axis, targetValue=-4.700000, firstFrame=10, lastFrame=40,},
			   },
			   [left_arm1]={
				   [1]={cmd="move", axis=x_axis, targetValue=4.700000, firstFrame=0, lastFrame=40,},
			   },
	})
end

--- Close_default
local function anim2()
	initTween({veryLastFrame=32,
			   [right_cover5]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
				   [2]={cmd="show", firstFrame=24,},
			   },
			   [left_cover5]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
				   [2]={cmd="show", firstFrame=24,},
			   },
			   [right_cover4]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=8, lastFrame=32,},
				   [2]={cmd="show", firstFrame=20,},
			   },
			   [right_cover3]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=8, lastFrame=32,},
				   [2]={cmd="show", firstFrame=16,},
			   },
			   [right_cover2]={
				   [1]={cmd="show", firstFrame=8,},
				   [2]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=8, lastFrame=32,},
			   },
			   [right_cover1]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=8, lastFrame=32,},
			   },
			   [left_cover4]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=8, lastFrame=32,},
				   [2]={cmd="show", firstFrame=20,},
			   },
			   [left_cover3]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=8, lastFrame=32,},
				   [2]={cmd="show", firstFrame=15,},
			   },
			   [left_cover2]={
				   [1]={cmd="show", firstFrame=8,},
				   [2]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=8, lastFrame=32,},
			   },
			   [left_cover1]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=8, lastFrame=32,},
			   },
			   [right_arm2]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=0, lastFrame=16,},
			   },
			   [right_arm3]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=0, lastFrame=20,},
			   },
			   [right_head]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=0, lastFrame=20,},
			   },
			   [left_sign]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=16, lastFrame=24,},
			   },
			   [right_sign]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=16, lastFrame=24,},
			   },
			   [left_arm2]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-0.000000, firstFrame=0, lastFrame=16,},
			   },
			   [left_arm3]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=0, lastFrame=20,},
			   },
			   [left_head]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=0, lastFrame=20,},
			   },
			   [left_base]={
				   [1]={cmd="move", axis=x_axis, targetValue=-0.000000, firstFrame=12, lastFrame=28,},
			   },
			   [right_base]={
				   [1]={cmd="move", axis=x_axis, targetValue=-0.000000, firstFrame=12, lastFrame=28,},
			   },
			   [right_arm1]={
				   [1]={cmd="move", axis=x_axis, targetValue=-0.000000, firstFrame=0, lastFrame=20,},
			   },
			   [left_arm1]={
				   [1]={cmd="move", axis=x_axis, targetValue=-0.000000, firstFrame=0, lastFrame=20,},
			   },
	})
end

----- open_advanced
local function anim3()
	initTween({veryLastFrame=48,
			   [right_cover5]={
				   [1]={cmd="turn", axis=z_axis, targetValue=3.106686, firstFrame=0, lastFrame=32,},
				   [2]={cmd="hide", firstFrame=8,},
			   },
			   [left_cover5]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-3.106686, firstFrame=0, lastFrame=32,},
				   [2]={cmd="hide", firstFrame=8,},
			   },
			   [right_cover4]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-0.418879, firstFrame=0, lastFrame=12,},
				   [2]={cmd="hide", firstFrame=12,},
			   },
			   [right_cover3]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-0.418879, firstFrame=4, lastFrame=16,},
				   [2]={cmd="hide", firstFrame=20,},
			   },
			   [right_cover2]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-0.418879, firstFrame=8, lastFrame=20,},
				   [2]={cmd="hide", firstFrame=24,},
			   },
			   [right_cover1]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-0.418879, firstFrame=12, lastFrame=24,},
			   },
			   [left_cover4]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.418879, firstFrame=0, lastFrame=12,},
				   [2]={cmd="hide", firstFrame=12,},
			   },
			   [left_cover3]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.418879, firstFrame=4, lastFrame=16,},
				   [2]={cmd="hide", firstFrame=20,},
			   },
			   [left_cover2]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.418879, firstFrame=8, lastFrame=20,},
				   [2]={cmd="hide", firstFrame=24,},
			   },
			   [left_cover1]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.418879, firstFrame=12, lastFrame=24,},
			   },
			   [right_arm2]={
				   [1]={cmd="hide", firstFrame=0,},
			   },
			   [right_arm3]={
				   [1]={cmd="hide", firstFrame=0,},
			   },
			   [right_head]={
				   [1]={cmd="hide", firstFrame=0,},
			   },
			   [left_sign]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-0.523599, firstFrame=28, lastFrame=40,},
			   },
			   [right_sign]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.523599, firstFrame=28, lastFrame=40,},
			   },
			   [left_arm2]={
				   [1]={cmd="hide", firstFrame=0,},
			   },
			   [left_arm3]={
				   [1]={cmd="hide", firstFrame=0,},
			   },
			   [left_head]={
				   [1]={cmd="hide", firstFrame=0,},
			   },
			   [left_base]={
				   [1]={cmd="move", axis=x_axis, targetValue=17.000000, firstFrame=0, lastFrame=48,},
			   },
			   [right_base]={
				   [1]={cmd="move", axis=x_axis, targetValue=-17.000000, firstFrame=0, lastFrame=48,},
			   },
			   [left_front_extension]={
				   [1]={cmd="move", axis=z_axis, targetValue=18.000000, firstFrame=0, lastFrame=48,},
			   },
			   [right_front_extension]={
				   [1]={cmd="move", axis=z_axis, targetValue=17.874325, firstFrame=0, lastFrame=48,},
			   },
			   [left_arm2_advanced]={
				   [1]={cmd="show", firstFrame=0,},
				   [2]={cmd="turn", axis=z_axis, targetValue=-1.902409, firstFrame=12, lastFrame=36,},
			   },
			   [left_arm3_advanced]={
				   [1]={cmd="show", firstFrame=0,},
				   [2]={cmd="turn", axis=z_axis, targetValue=2.617994, firstFrame=12, lastFrame=36,},
			   },
			   [left_head_advanced]={
				   [1]={cmd="show", firstFrame=0,},
				   [2]={cmd="turn", axis=z_axis, targetValue=0.314159, firstFrame=12, lastFrame=40,},
			   },
			   [right_arm2_advanced]={
				   [1]={cmd="show", firstFrame=0,},
				   [2]={cmd="turn", axis=z_axis, targetValue=1.919862, firstFrame=16, lastFrame=40,},
			   },
			   [right_arm3_advanced]={
				   [1]={cmd="show", firstFrame=0,},
				   [2]={cmd="turn", axis=z_axis, targetValue=-2.827433, firstFrame=16, lastFrame=40,},
			   },
			   [right_head_advanced]={
				   [1]={cmd="show", firstFrame=0,},
				   [2]={cmd="turn", axis=z_axis, targetValue=0.314159, firstFrame=16, lastFrame=40,},
			   },
			   [left_back_extension]={
				   [1]={cmd="move", axis=z_axis, targetValue=-18.000000, firstFrame=0, lastFrame=48,},
			   },
			   [right_back_extension]={
				   [1]={cmd="move", axis=z_axis, targetValue=-18.000000, firstFrame=0, lastFrame=48,},
			   },
			   [back_wall_top]={
				   [1]={cmd="move", axis=z_axis, targetValue=-18.000000, firstFrame=0, lastFrame=48,},
				   [2]={cmd="move", axis=y_axis, targetValue=4.000000, firstFrame=32, lastFrame=48,},
			   },
			   [right_wall]={
				   [1]={cmd="move", axis=y_axis, targetValue=4.000000, firstFrame=32, lastFrame=48,},
			   },
			   [left_wall]={
				   [1]={cmd="move", axis=y_axis, targetValue=4.000000, firstFrame=32, lastFrame=48,},
			   },
			   [right_back_upgrade]={
				   [1]={cmd="show", firstFrame=0,},
				   [2]={cmd="move", axis=x_axis, targetValue=-3.000000, firstFrame=20, lastFrame=48,},
			   },
			   [left_back_upgrade]={
				   [1]={cmd="show", firstFrame=0,},
				   [2]={cmd="move", axis=x_axis, targetValue=3.000000, firstFrame=20, lastFrame=48,},
			   },
			   [right_arm1_advanced]={
				   [1]={cmd="show", firstFrame=0,},
				   [2]={cmd="move", axis=x_axis, targetValue=-20.000000, firstFrame=18, lastFrame=48,},
			   },
			   [left_arm1_advanced]={
				   [1]={cmd="show", firstFrame=0,},
				   [2]={cmd="move", axis=x_axis, targetValue=20.000000, firstFrame=18, lastFrame=48,},
			   },
			   [right_arm1]={
				   [1]={cmd="hide", firstFrame=0,},
			   },
			   [left_arm1]={
				   [1]={cmd="hide", firstFrame=0,},
			   },
	})
end

----- close_advanced
local function anim4()
	initTween({veryLastFrame=38,
			   [right_cover5]={
				   [1]={cmd="turn", axis=z_axis, targetValue=-0.010000, firstFrame=4, lastFrame=38,},
				   [2]={cmd="show", firstFrame=32,},
			   },
			   [left_cover5]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=4, lastFrame=38,},
				   [2]={cmd="show", firstFrame=32,},
			   },
			   [right_cover4]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=4, lastFrame=38,},
				   [2]={cmd="show", firstFrame=28,},
			   },
			   [right_cover3]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=4, lastFrame=38,},
				   [2]={cmd="show", firstFrame=24,},
			   },
			   [right_cover2]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=4, lastFrame=38,},
				   [2]={cmd="show", firstFrame=16,},
			   },
			   [right_cover1]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=4, lastFrame=38,},
			   },
			   [left_cover4]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=4, lastFrame=38,},
				   [2]={cmd="show", firstFrame=28,},
			   },
			   [left_cover3]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=4, lastFrame=38,},
				   [2]={cmd="show", firstFrame=24,},
			   },
			   [left_cover2]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=4, lastFrame=38,},
				   [2]={cmd="show", firstFrame=16,},
			   },
			   [left_cover1]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=4, lastFrame=38,},
			   },
			   [left_sign]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=20, lastFrame=28,},
			   },
			   [right_sign]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=20, lastFrame=28,},
			   },
			   [left_base]={
				   [1]={cmd="move", axis=x_axis, targetValue=-0.000000, firstFrame=0, lastFrame=34,},
			   },
			   [right_base]={
				   [1]={cmd="move", axis=x_axis, targetValue=1.000000, firstFrame=0, lastFrame=34,},
			   },
			   [left_front_extension]={
				   [1]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
			   },
			   [right_front_extension]={
				   [1]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
			   },
			   [left_arm2_advanced]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=0, lastFrame=24,},
			   },
			   [left_arm3_advanced]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=0, lastFrame=24,},
			   },
			   [left_head_advanced]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.383972, firstFrame=0, lastFrame=24,},
			   },
			   [right_arm2_advanced]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=0, lastFrame=20,},
			   },
			   [right_arm3_advanced]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=0, lastFrame=20,},
			   },
			   [right_head_advanced]={
				   [1]={cmd="turn", axis=z_axis, targetValue=0.000000, firstFrame=0, lastFrame=20,},
			   },
			   [left_back_extension]={
				   [1]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
			   },
			   [right_back_extension]={
				   [1]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
			   },
			   [back_wall_top]={
				   [1]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=0, lastFrame=32,},
			   },
			   [right_arm1_advanced]={
				   [1]={cmd="move", axis=x_axis, targetValue=-0.000000, firstFrame=0, lastFrame=24,},
			   },
			   [left_arm1_advanced]={
				   [1]={cmd="move", axis=x_axis, targetValue=-0.000000, firstFrame=0, lastFrame=24,},
			   },
	})
end


---- Test animation
--local function anim5()
--    initTween({veryLastFrame=172,
--               [right_upgrade]={
--                   [1]={cmd="move", axis=z_axis, targetValue=-11.148439, firstFrame=112, lastFrame=152,},
--                   [2]={cmd="move", axis=x_axis, targetValue=-0.800000, firstFrame=152, lastFrame=160,},
--               },
--               [left_upgrade]={
--                   [1]={cmd="move", axis=z_axis, targetValue=-11.148439, firstFrame=112, lastFrame=152,},
--                   [2]={cmd="move", axis=x_axis, targetValue=0.800000, firstFrame=152, lastFrame=160,},
--               },
--               [right_arm1_advanced]={
--                   [1]={cmd="move", axis=x_axis, targetValue=-13.500000, firstFrame=124, lastFrame=164,},
--               },
--               [left_arm1_advanced]={
--                   [1]={cmd="move", axis=x_axis, targetValue=13.500000, firstFrame=124, lastFrame=164,},
--               },
--               [right_front_base]={
--                   [1]={cmd="move", axis=x_axis, targetValue=-11.600000, firstFrame=112, lastFrame=154,},
--                   [2]={cmd="move", axis=z_axis, targetValue=11.600000, firstFrame=112, lastFrame=154,},
--               },
--               [left_front_base]={
--                   [1]={cmd="move", axis=x_axis, targetValue=11.600000, firstFrame=112, lastFrame=154,},
--                   [2]={cmd="move", axis=z_axis, targetValue=11.600000, firstFrame=112, lastFrame=154,},
--               },
--               [right_front_wall]={
--                   [1]={cmd="move", axis=y_axis, targetValue=3.200000, firstFrame=152, lastFrame=162,},
--               },
--               [left_front_wall]={
--                   [1]={cmd="move", axis=y_axis, targetValue=3.200000, firstFrame=152, lastFrame=162,},
--               },
--               [left_front_sign]={
--                   [1]={cmd="turn", axis=x_axis, targetValue=0.233050, firstFrame=154, lastFrame=160,},
--                   [2]={cmd="turn", axis=x_axis, targetValue=0.002041, firstFrame=160, lastFrame=172,},
--               },
--               [right_front_sign]={
--                   [1]={cmd="turn", axis=x_axis, targetValue=0.233050, firstFrame=154, lastFrame=160,},
--                   [2]={cmd="turn", axis=x_axis, targetValue=0.002041, firstFrame=160, lastFrame=172,},
--               },
--               [right_back_base]={
--                   [1]={cmd="move", axis=x_axis, targetValue=-11.400000, firstFrame=112, lastFrame=154,},
--                   [2]={cmd="move", axis=z_axis, targetValue=-11.400000, firstFrame=112, lastFrame=154,},
--               },
--               [left_back_base]={
--                   [1]={cmd="move", axis=x_axis, targetValue=11.400000, firstFrame=112, lastFrame=154,},
--                   [2]={cmd="move", axis=z_axis, targetValue=-11.400000, firstFrame=112, lastFrame=154,},
--               },
--               [right_back_wall]={
--                   [1]={cmd="move", axis=y_axis, targetValue=3.300000, firstFrame=154, lastFrame=162,},
--               },
--               [left_back_wall]={
--                   [1]={cmd="move", axis=y_axis, targetValue=3.300000, firstFrame=154, lastFrame=162,},
--               },
--               [back_connection]={
--                   [1]={cmd="move", axis=z_axis, targetValue=-11.483793, firstFrame=112, lastFrame=154,},
--                   [2]={cmd="move", axis=y_axis, targetValue=0.344059, firstFrame=112, lastFrame=154,},
--                   [3]={cmd="move", axis=z_axis, targetValue=-11.725308, firstFrame=154, lastFrame=162,},
--                   [4]={cmd="move", axis=y_axis, targetValue=3.483554, firstFrame=154, lastFrame=162,},
--               },
--               [left_cover1]={
--                   [1]={cmd="turn", axis=x_axis, targetValue=-2.093080, firstFrame=112, lastFrame=142,},
--               },
--               [right_back_cover1]={
--                   [1]={cmd="turn", axis=x_axis, targetValue=-2.094395, firstFrame=112, lastFrame=142,},
--               },
--               [left_arm2_advanced]={
--                   [1]={cmd="turn", axis=z_axis, targetValue=-2.899244, firstFrame=124, lastFrame=164,},
--               },
--               [left_arm3_advanced]={
--                   [1]={cmd="turn", axis=z_axis, targetValue=3.944304, firstFrame=124, lastFrame=164,},
--               },
--               [left_head_advanced]={
--                   [1]={cmd="turn", axis=z_axis, targetValue=-0.272431, firstFrame=124, lastFrame=164,},
--               },
--               [right_arm2_advanced]={
--                   [1]={cmd="turn", axis=z_axis, targetValue=2.863163, firstFrame=124, lastFrame=164,},
--               },
--               [right_arm3_advanced]={
--                   [1]={cmd="turn", axis=z_axis, targetValue=-4.197709, firstFrame=124, lastFrame=164,},
--               },
--               [right_head_advanced]={
--                   [1]={cmd="turn", axis=z_axis, targetValue=1.266023, firstFrame=124, lastFrame=164,},
--               },
--    })
--end

--local function StopAnimation()
--    Move(back_connection, y_axis, 0, 470.924217)
--    Move(back_connection, z_axis, 0, 1722.568989)
--    Move(left_arm1, y_axis, 0, 300000.000000)
--    Move(left_arm1_advanced, x_axis, 0, 1337.627375)
--    Move(left_arm1_advanced, y_axis, 0, 3000000.000000)
--    Move(left_back_base, x_axis, 0, 1709.999943)
--    Move(left_back_base, z_axis, 0, 1709.999943)
--    Move(left_back_wall, y_axis, 0, 469.574153)
--    Move(left_front_base, x_axis, 0, 1740.000057)
--    Move(left_front_base, z_axis, 0, 1740.000057)
--    Move(left_front_wall, y_axis, 0, 480.000007)
--    Move(left_upgrade, x_axis, 0, 69.996637)
--    Move(left_upgrade, y_axis, 0, 300000.000000)
--    Move(left_upgrade, z_axis, 0, 1145.441550)
--    Move(right_arm1, y_axis, 0, 300000.000000)
--    Move(right_arm1_advanced, x_axis, 0, 1324.583054)
--    Move(right_arm1_advanced, y_axis, 0, 3000000.000000)
--    Move(right_back_base, x_axis, 0, 1709.999943)
--    Move(right_back_base, z_axis, 0, 1709.999943)
--    Move(right_back_wall, y_axis, 0, 494.999993)
--    Move(right_front_base, x_axis, 0, 1740.000057)
--    Move(right_front_base, z_axis, 0, 1740.000057)
--    Move(right_front_wall, y_axis, 0, 480.000007)
--    Move(right_upgrade, x_axis, 0, 69.996637)
--    Move(right_upgrade, y_axis, 0, 300000.000000)
--    Move(right_upgrade, z_axis, 0, 1145.441550)
--    Turn(left_arm2, z_axis, 0, 25.446904)
--    Turn(left_arm2_advanced, z_axis, 0, 20.977205)
--    Turn(left_arm3, z_axis, 0, 16.964601)
--    Turn(left_arm3_advanced, z_axis, 0, 33.718747)
--    Turn(left_cover1, x_axis, 0, 95.669818)
--    Turn(left_cover1, y_axis, 0, 1.993953)
--    Turn(left_cover1, z_axis, 0, 3.434164)
--    Turn(left_front_sign, x_axis, 0, 11.828618)
--    Turn(left_head, z_axis, 0, 19.634955)
--    Turn(left_head_advanced, z_axis, 0, 22.986345)
--    Turn(right_arm2, z_axis, 0, 25.446904)
--    Turn(right_arm2_advanced, z_axis, 0, 20.860207)
--    Turn(right_arm3, z_axis, 0, 16.964601)
--    Turn(right_arm3_advanced, z_axis, 0, 37.411273)
--    Turn(right_back_cover1, x_axis, 0, 95.669818)
--    Turn(right_back_cover1, y_axis, 0, 1.993953)
--    Turn(right_back_cover1, z_axis, 0, 3.434164)
--    Turn(right_front_sign, x_axis, 0, 11.828618)
--    Turn(right_head, z_axis, 0, 19.634955)
--    Turn(right_head_advanced, z_axis, 0, 22.089326)
--end

Animations = { openstd=anim1, closestd=anim2, openadv=anim3, closeadv=anim4, }

return Animations
