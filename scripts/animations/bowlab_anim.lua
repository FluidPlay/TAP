local Animations = {};
-- Animations['openstd']=anim1, Animations['closestd']=anim2,
-- Animations['openadv']=anim3, Animations['closeadv']=anim4,

--0-52 - open default
--56-104 - close default
--112-172 - open advanced
--212-220-274-320 - close advanced
--236

--- open_default
local function anim1()
    initTween({ veryLastFrame = 52, --sleepTime = sleepTime,
                --[1] = { pieceID = right_back_cover1, cmd = "turn", axis = x_axis,
                --        targetValue = rad(120), firstFrame = 0, lastFrame = 52,
                --},
                [right_back_cover1] = { [1] = { cmd = "turn", axis = x_axis,
                        targetValue = rad(-120), firstFrame = 0, lastFrame = 52,}
                },
                [left_cover1] = { [1] = { cmd = "turn", axis = x_axis,
                        targetValue = rad(-120), firstFrame = 0, lastFrame = 52,}
                },
                [right_arm2] = { [1] = { cmd = "turn", axis = z_axis,
                        targetValue = rad(90), firstFrame = 32, lastFrame = 52, easingFunction = "inOutCirc",}
                },
                [left_arm2] = { [1] = {cmd = "turn", axis = z_axis,
                        targetValue = rad(-90), firstFrame = 32, lastFrame = 52, easingFunction = "inOutCirc",}
                },
                [right_arm3] = { [1] = {cmd = "turn", axis = z_axis,
                        targetValue = rad(60), firstFrame = 32, lastFrame = 52, easingFunction = "inOutCirc",}
                },
                [left_arm3] = { [1] = {cmd = "turn", axis = z_axis,
                        targetValue = rad(-60), firstFrame = 32, lastFrame = 52, easingFunction = "inOutCirc",}
                },
                [right_head] = { [1] = {cmd = "turn", axis = z_axis,
                        targetValue = rad(45), firstFrame = 40, lastFrame = 52, easingFunction = "inOutCirc",}
                },
                [left_head] = { [1] = {cmd = "turn", axis = z_axis,
                        targetValue = rad(-45), firstFrame = 40, lastFrame = 52, easingFunction = "inOutCirc",}
                },
    })
    ---- Frame:1
    --Turn(left_cover1, x_axis, -0.002830, 0.084886 )
    --Turn(right_back_cover1, x_axis, -0.002830, 0.084886 )
    --Sleep(32)
    ---- Frame:32
    --Turn(left_cover1, x_axis, -0.026996, 0.026125 )
    --Turn(left_cover1, x_axis, -1.546749, 1.494116 )
    --Turn(right_back_cover1, x_axis, -0.026996, 0.026125 )
    --Turn(right_back_cover1, x_axis, -1.546749, 1.494116 )
    --Sleep(1022)
    ---- Frame:40
    --Turn(left_arm2, z_axis, -0.552920, 2.073451 )
    --Turn(left_arm3, z_axis, -0.368614, 1.382301 )
    --Turn(left_cover1, x_axis, -1.891990, 1.294651 )
    --Turn(right_arm2, z_axis, 0.552920, 2.073451 )
    --Turn(right_arm3, z_axis, 0.368614, 1.382301 )
    --Turn(right_back_cover1, x_axis, -1.891990, 1.294651 )
    --Sleep(263)
    ---- Frame:52
    --Turn(left_arm2, z_axis, -0.027416, 0.068539 )
    --Turn(left_arm2, z_axis, -1.570796, 2.544690 )
    --Turn(left_arm3, z_axis, -0.018277, 0.045693 )
    --Turn(left_arm3, z_axis, -1.047198, 1.696460 )
    --Turn(left_cover1, x_axis, -0.036531, 0.023838 )
    --Turn(left_cover1, x_axis, -2.093080, 0.502726 )
    --Turn(left_head, z_axis, -0.013708, 0.034269 )
    --Turn(left_head, z_axis, -0.785398, 1.963495 )
    --Turn(right_arm2, z_axis, 0.027416, 0.068539 )
    --Turn(right_arm2, z_axis, 1.570796, 2.544690 )
    --Turn(right_arm3, z_axis, 0.018277, 0.045693 )
    --Turn(right_arm3, z_axis, 1.047198, 1.696460 )
    --Turn(right_back_cover1, x_axis, -0.036531, 0.023838 )
    --Turn(right_back_cover1, x_axis, -2.093080, 0.502726 )
    --Turn(right_head, z_axis, 0.013708, 0.034269 )
    --Turn(right_head, z_axis, 0.785398, 1.963495 )
    --Sleep(395)
end

--- Close_default
local function anim2()
    initTween({ veryLastFrame = 48,
                --[1] = { pieceID = right_back_cover1, cmd = "turn", axis = x_axis,
                --        targetValue = 0, firstFrame = 12, lastFrame = 48,
                --},
                [right_back_cover1] = { [1] = {cmd = "turn", axis = x_axis,
                        targetValue = 0, firstFrame = 12, lastFrame = 48,}
                },
                [left_cover1] = { [1] = {cmd = "turn", axis = x_axis,
                        targetValue = 0, firstFrame = 12, lastFrame = 48,}
                },
                [right_arm2] = { [1] = {cmd = "turn", axis = z_axis,
                        targetValue = 0, firstFrame = 0, lastFrame = 28,}
                },
                [left_arm2] = { [1] = {cmd = "turn", axis = z_axis,
                        targetValue = 0, firstFrame = 0, lastFrame = 28,}
                },
                [right_arm3] = { [1] = {cmd = "turn", axis = z_axis,
                        targetValue = 0, firstFrame = 0, lastFrame = 28,}
                },
                [left_arm3] = { [1] = {cmd = "turn", axis = z_axis,
                        targetValue = 0, firstFrame = 0, lastFrame = 28,}
                },
                [right_head] = { [1] = {cmd = "turn", axis = z_axis,
                        targetValue = 0, firstFrame = 0, lastFrame = 28,}
                },
                [left_head] = { [1] = {cmd = "turn", axis = z_axis,
                        targetValue = 0, firstFrame = 0, lastFrame = 28,}
                },
    })
end

--- open_advanced
local function anim3()
    initTween({veryLastFrame=60,
               [right_upgrade]={
                   [1]={cmd="move", axis=z_axis, targetValue=-11.148439, firstFrame=0, lastFrame=40,},
                   [2]={cmd="move", axis=x_axis, targetValue=-0.800000, firstFrame=40, lastFrame=48,},
               },
               [left_upgrade]={
                   [1]={cmd="move", axis=z_axis, targetValue=-11.148439, firstFrame=0, lastFrame=40,},
                   [2]={cmd="move", axis=x_axis, targetValue=0.800000, firstFrame=40, lastFrame=48,},
               },
               [right_arm1_advanced]={
                   [1]={cmd="move", axis=x_axis, targetValue=-13.500000, firstFrame=12, lastFrame=52,},
               },
               [left_arm1_advanced]={
                   [1]={cmd="move", axis=x_axis, targetValue=13.500000, firstFrame=12, lastFrame=52,},
               },
               [right_front_base]={
                   [1]={cmd="move", axis=x_axis, targetValue=-11.600000, firstFrame=0, lastFrame=44,},
                   [2]={cmd="move", axis=z_axis, targetValue=11.600000, firstFrame=0, lastFrame=44,},
               },
               [left_front_base]={
                   [1]={cmd="move", axis=x_axis, targetValue=11.600000, firstFrame=0, lastFrame=44,},
                   [2]={cmd="move", axis=z_axis, targetValue=11.600000, firstFrame=0, lastFrame=44,},
               },
               [right_front_wall]={
                   [1]={cmd="move", axis=y_axis, targetValue=3.200000, firstFrame=40, lastFrame=52,},
               },
               [left_front_wall]={
                   [1]={cmd="move", axis=y_axis, targetValue=3.200000, firstFrame=40, lastFrame=52,},
               },
               [left_front_sign]={
                   [1]={cmd="turn", axis=x_axis, targetValue=0.233050, firstFrame=40, lastFrame=48,},
                   [2]={cmd="turn", axis=x_axis, targetValue=0.002041, firstFrame=48, lastFrame=60,},
               },
               [right_front_sign]={
                   [1]={cmd="turn", axis=x_axis, targetValue=0.233050, firstFrame=40, lastFrame=48,},
                   [2]={cmd="turn", axis=x_axis, targetValue=0.002041, firstFrame=48, lastFrame=60,},
               },
               [right_back_base]={
                   [1]={cmd="move", axis=x_axis, targetValue=-11.400000, firstFrame=0, lastFrame=44,},
                   [2]={cmd="move", axis=z_axis, targetValue=-11.400000, firstFrame=0, lastFrame=44,},
               },
               [left_back_base]={
                   [1]={cmd="move", axis=x_axis, targetValue=11.400000, firstFrame=0, lastFrame=44,},
                   [2]={cmd="move", axis=z_axis, targetValue=-11.400000, firstFrame=0, lastFrame=44,},
               },
               [right_back_wall]={
                   [1]={cmd="move", axis=y_axis, targetValue=3.300000, firstFrame=40, lastFrame=52,},
               },
               [left_back_wall]={
                   [1]={cmd="move", axis=y_axis, targetValue=3.130494, firstFrame=40, lastFrame=52,},
                   [2]={cmd="move", axis=y_axis, targetValue=3.300000, firstFrame=52, lastFrame=60,},
               },
               [back_connection]={
                   [1]={cmd="move", axis=z_axis, targetValue=-11.483793, firstFrame=0, lastFrame=44,},
                   [2]={cmd="move", axis=y_axis, targetValue=0.344059, firstFrame=0, lastFrame=44,},
                   [3]={cmd="move", axis=z_axis, targetValue=-11.725308, firstFrame=44, lastFrame=52,},
                   [4]={cmd="move", axis=y_axis, targetValue=3.483554, firstFrame=44, lastFrame=52,},
               },
               [left_cover1]={
                   [1]={cmd="turn", axis=x_axis, targetValue=-2.093080, firstFrame=0, lastFrame=32,},
               },
               [right_back_cover1]={
                   [1]={cmd="turn", axis=x_axis, targetValue=-2.094395, firstFrame=0, lastFrame=32,},
               },
               [left_arm2_advanced]={
                   [1]={cmd="turn", axis=z_axis, targetValue=-2.356194, firstFrame=12, lastFrame=52,},
               },
               [left_arm3_advanced]={
                   [1]={cmd="turn", axis=z_axis, targetValue=3.139847, firstFrame=12, lastFrame=52,},
               },
               [left_head_advanced]={
                   [1]={cmd="turn", axis=z_axis, targetValue=0.087266, firstFrame=12, lastFrame=52,},
               },
               [right_arm2_advanced]={
                   [1]={cmd="turn", axis=z_axis, targetValue=2.356194, firstFrame=12, lastFrame=52,},
               },
               [right_arm3_advanced]={
                   [1]={cmd="turn", axis=z_axis, targetValue=-3.139847, firstFrame=12, lastFrame=52,},
               },
               [right_head_advanced]={
                   [1]={cmd="turn", axis=z_axis, targetValue=0.523313, firstFrame=12, lastFrame=52,},
               },
    })
end

--- close_advanced
local function anim4()
    initTween({veryLastFrame=104,
               [right_upgrade]={
                   [1]={cmd="move", axis=x_axis, targetValue=-0.100034, firstFrame=8, lastFrame=40,},
                   [2]={cmd="move", axis=z_axis, targetValue=0.305976, firstFrame=8, lastFrame=40,},
                   [3]={cmd="move", axis=x_axis, targetValue=-0.000000, firstFrame=40, lastFrame=60,},
                   [4]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=40, lastFrame=60,},
               },
               [left_upgrade]={
                   [1]={cmd="move", axis=x_axis, targetValue=0.100034, firstFrame=8, lastFrame=40,},
                   [2]={cmd="move", axis=z_axis, targetValue=0.305976, firstFrame=8, lastFrame=40,},
                   [3]={cmd="move", axis=x_axis, targetValue=-0.000000, firstFrame=40, lastFrame=60,},
                   [4]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=40, lastFrame=60,},
               },
               [right_arm1_advanced]={
                   [1]={cmd="move", axis=x_axis, targetValue=-0.254169, firstFrame=0, lastFrame=44,},
                   [2]={cmd="move", axis=x_axis, targetValue=-0.000000, firstFrame=44, lastFrame=60,},
               },
               [left_arm1_advanced]={
                   [1]={cmd="move", axis=x_axis, targetValue=-0.000000, firstFrame=0, lastFrame=60,},
               },
               [right_front_base]={
                   [1]={cmd="move", axis=x_axis, targetValue=-0.000000, firstFrame=4, lastFrame=48,},
                   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=4, lastFrame=48,},
               },
               [left_front_base]={
                   [1]={cmd="move", axis=x_axis, targetValue=-0.000000, firstFrame=4, lastFrame=48,},
                   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=4, lastFrame=48,},
               },
               [right_front_wall]={
                   [1]={cmd="move", axis=y_axis, targetValue=0.289492, firstFrame=4, lastFrame=20,},
               },
               [left_front_wall]={
                   [1]={cmd="move", axis=y_axis, targetValue=0.289492, firstFrame=4, lastFrame=20,},
               },
               [left_front_sign]={
                   [1]={cmd="turn", axis=x_axis, targetValue=-0.264369, firstFrame=8, lastFrame=16,},
                   [2]={cmd="turn", axis=x_axis, targetValue=-0.037476, firstFrame=16, lastFrame=24,},
               },
               [right_front_sign]={
                   [1]={cmd="turn", axis=x_axis, targetValue=-0.264369, firstFrame=8, lastFrame=16,},
                   [2]={cmd="turn", axis=x_axis, targetValue=-0.037476, firstFrame=16, lastFrame=24,},
               },
               [right_back_base]={
                   [1]={cmd="move", axis=x_axis, targetValue=-0.000000, firstFrame=4, lastFrame=60,},
                   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=4, lastFrame=60,},
               },
               [left_back_base]={
                   [1]={cmd="move", axis=x_axis, targetValue=-0.000000, firstFrame=4, lastFrame=60,},
                   [2]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=4, lastFrame=60,},
               },
               [right_back_wall]={
                   [1]={cmd="move", axis=y_axis, targetValue=0.300000, firstFrame=12, lastFrame=20,},
                   [2]={cmd="move", axis=y_axis, targetValue=0.000000, firstFrame=20, lastFrame=48,},
               },
               [left_back_wall]={
                   [1]={cmd="move", axis=y_axis, targetValue=0.300000, firstFrame=12, lastFrame=20,},
                   [2]={cmd="move", axis=y_axis, targetValue=0.000000, firstFrame=20, lastFrame=48,},
               },
               [back_connection]={
                   [1]={cmd="move", axis=z_axis, targetValue=-8.312860, firstFrame=4, lastFrame=20,},
                   [2]={cmd="move", axis=y_axis, targetValue=3.247269, firstFrame=4, lastFrame=12,},
                   [3]={cmd="move", axis=y_axis, targetValue=0.272874, firstFrame=12, lastFrame=20,},
                   [4]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=20, lastFrame=56,},
                   [5]={cmd="move", axis=y_axis, targetValue=0.000000, firstFrame=20, lastFrame=56,},
               },
               [left_cover1]={
                   [1]={cmd="turn", axis=x_axis, targetValue=-0.000000, firstFrame=60, lastFrame=104,},
               },
               [right_back_cover1]={
                   [1]={cmd="turn", axis=x_axis, targetValue=-0.000000, firstFrame=60, lastFrame=104,},
               },
               [left_arm2_advanced]={
                   [1]={cmd="turn", axis=z_axis, targetValue=-0.000000, firstFrame=0, lastFrame=60,},
               },
               [left_arm3_advanced]={
                   [1]={cmd="turn", axis=z_axis, targetValue=0.007994, firstFrame=0, lastFrame=60,},
               },
               [left_head_advanced]={
                   [1]={cmd="turn", axis=z_axis, targetValue=-0.284752, firstFrame=0, lastFrame=24,},
                   [2]={cmd="turn", axis=z_axis, targetValue=-0.000000, firstFrame=24, lastFrame=60,},
               },
               [right_arm2_advanced]={
                   [1]={cmd="turn", axis=z_axis, targetValue=-0.000000, firstFrame=0, lastFrame=60,},
               },
               [right_arm3_advanced]={
                   [1]={cmd="turn", axis=z_axis, targetValue=-0.000000, firstFrame=0, lastFrame=60,},
               },
               [right_head_advanced]={
                   [1]={cmd="turn", axis=z_axis, targetValue=0.181863, firstFrame=0, lastFrame=60,},
               },
    })
end

-- Test animation
local function anim5()
    initTween({veryLastFrame=172,
               [right_upgrade]={
                   [1]={cmd="move", axis=z_axis, targetValue=-11.148439, firstFrame=112, lastFrame=152,},
                   [2]={cmd="move", axis=x_axis, targetValue=-0.800000, firstFrame=152, lastFrame=160,},
               },
               [left_upgrade]={
                   [1]={cmd="move", axis=z_axis, targetValue=-11.148439, firstFrame=112, lastFrame=152,},
                   [2]={cmd="move", axis=x_axis, targetValue=0.800000, firstFrame=152, lastFrame=160,},
               },
               [right_arm1_advanced]={
                   [1]={cmd="move", axis=x_axis, targetValue=-13.500000, firstFrame=124, lastFrame=164,},
               },
               [left_arm1_advanced]={
                   [1]={cmd="move", axis=x_axis, targetValue=13.500000, firstFrame=124, lastFrame=164,},
               },
               [right_front_base]={
                   [1]={cmd="move", axis=x_axis, targetValue=-11.600000, firstFrame=112, lastFrame=154,},
                   [2]={cmd="move", axis=z_axis, targetValue=11.600000, firstFrame=112, lastFrame=154,},
               },
               [left_front_base]={
                   [1]={cmd="move", axis=x_axis, targetValue=11.600000, firstFrame=112, lastFrame=154,},
                   [2]={cmd="move", axis=z_axis, targetValue=11.600000, firstFrame=112, lastFrame=154,},
               },
               [right_front_wall]={
                   [1]={cmd="move", axis=y_axis, targetValue=3.200000, firstFrame=152, lastFrame=162,},
               },
               [left_front_wall]={
                   [1]={cmd="move", axis=y_axis, targetValue=3.200000, firstFrame=152, lastFrame=162,},
               },
               [left_front_sign]={
                   [1]={cmd="turn", axis=x_axis, targetValue=0.233050, firstFrame=154, lastFrame=160,},
                   [2]={cmd="turn", axis=x_axis, targetValue=0.002041, firstFrame=160, lastFrame=172,},
               },
               [right_front_sign]={
                   [1]={cmd="turn", axis=x_axis, targetValue=0.233050, firstFrame=154, lastFrame=160,},
                   [2]={cmd="turn", axis=x_axis, targetValue=0.002041, firstFrame=160, lastFrame=172,},
               },
               [right_back_base]={
                   [1]={cmd="move", axis=x_axis, targetValue=-11.400000, firstFrame=112, lastFrame=154,},
                   [2]={cmd="move", axis=z_axis, targetValue=-11.400000, firstFrame=112, lastFrame=154,},
               },
               [left_back_base]={
                   [1]={cmd="move", axis=x_axis, targetValue=11.400000, firstFrame=112, lastFrame=154,},
                   [2]={cmd="move", axis=z_axis, targetValue=-11.400000, firstFrame=112, lastFrame=154,},
               },
               [right_back_wall]={
                   [1]={cmd="move", axis=y_axis, targetValue=3.300000, firstFrame=154, lastFrame=162,},
               },
               [left_back_wall]={
                   [1]={cmd="move", axis=y_axis, targetValue=3.300000, firstFrame=154, lastFrame=162,},
               },
               [back_connection]={
                   [1]={cmd="move", axis=z_axis, targetValue=-11.483793, firstFrame=112, lastFrame=154,},
                   [2]={cmd="move", axis=y_axis, targetValue=0.344059, firstFrame=112, lastFrame=154,},
                   [3]={cmd="move", axis=z_axis, targetValue=-11.725308, firstFrame=154, lastFrame=162,},
                   [4]={cmd="move", axis=y_axis, targetValue=3.483554, firstFrame=154, lastFrame=162,},
               },
               [left_cover1]={
                   [1]={cmd="turn", axis=x_axis, targetValue=-2.093080, firstFrame=112, lastFrame=142,},
               },
               [right_back_cover1]={
                   [1]={cmd="turn", axis=x_axis, targetValue=-2.094395, firstFrame=112, lastFrame=142,},
               },
               [left_arm2_advanced]={
                   [1]={cmd="turn", axis=z_axis, targetValue=-2.899244, firstFrame=124, lastFrame=164,},
               },
               [left_arm3_advanced]={
                   [1]={cmd="turn", axis=z_axis, targetValue=3.944304, firstFrame=124, lastFrame=164,},
               },
               [left_head_advanced]={
                   [1]={cmd="turn", axis=z_axis, targetValue=-0.272431, firstFrame=124, lastFrame=164,},
               },
               [right_arm2_advanced]={
                   [1]={cmd="turn", axis=z_axis, targetValue=2.863163, firstFrame=124, lastFrame=164,},
               },
               [right_arm3_advanced]={
                   [1]={cmd="turn", axis=z_axis, targetValue=-4.197709, firstFrame=124, lastFrame=164,},
               },
               [right_head_advanced]={
                   [1]={cmd="turn", axis=z_axis, targetValue=1.266023, firstFrame=124, lastFrame=164,},
               },
    })
end

local function StopAnimation()
    Move(back_connection, y_axis, 0, 470.924217)
    Move(back_connection, z_axis, 0, 1722.568989)
    Move(left_arm1, y_axis, 0, 300000.000000)
    Move(left_arm1_advanced, x_axis, 0, 1337.627375)
    Move(left_arm1_advanced, y_axis, 0, 3000000.000000)
    Move(left_back_base, x_axis, 0, 1709.999943)
    Move(left_back_base, z_axis, 0, 1709.999943)
    Move(left_back_wall, y_axis, 0, 469.574153)
    Move(left_front_base, x_axis, 0, 1740.000057)
    Move(left_front_base, z_axis, 0, 1740.000057)
    Move(left_front_wall, y_axis, 0, 480.000007)
    Move(left_upgrade, x_axis, 0, 69.996637)
    Move(left_upgrade, y_axis, 0, 300000.000000)
    Move(left_upgrade, z_axis, 0, 1145.441550)
    Move(right_arm1, y_axis, 0, 300000.000000)
    Move(right_arm1_advanced, x_axis, 0, 1324.583054)
    Move(right_arm1_advanced, y_axis, 0, 3000000.000000)
    Move(right_back_base, x_axis, 0, 1709.999943)
    Move(right_back_base, z_axis, 0, 1709.999943)
    Move(right_back_wall, y_axis, 0, 494.999993)
    Move(right_front_base, x_axis, 0, 1740.000057)
    Move(right_front_base, z_axis, 0, 1740.000057)
    Move(right_front_wall, y_axis, 0, 480.000007)
    Move(right_upgrade, x_axis, 0, 69.996637)
    Move(right_upgrade, y_axis, 0, 300000.000000)
    Move(right_upgrade, z_axis, 0, 1145.441550)
    Turn(left_arm2, z_axis, 0, 25.446904)
    Turn(left_arm2_advanced, z_axis, 0, 20.977205)
    Turn(left_arm3, z_axis, 0, 16.964601)
    Turn(left_arm3_advanced, z_axis, 0, 33.718747)
    Turn(left_cover1, x_axis, 0, 95.669818)
    Turn(left_cover1, y_axis, 0, 1.993953)
    Turn(left_cover1, z_axis, 0, 3.434164)
    Turn(left_front_sign, x_axis, 0, 11.828618)
    Turn(left_head, z_axis, 0, 19.634955)
    Turn(left_head_advanced, z_axis, 0, 22.986345)
    Turn(right_arm2, z_axis, 0, 25.446904)
    Turn(right_arm2_advanced, z_axis, 0, 20.860207)
    Turn(right_arm3, z_axis, 0, 16.964601)
    Turn(right_arm3_advanced, z_axis, 0, 37.411273)
    Turn(right_back_cover1, x_axis, 0, 95.669818)
    Turn(right_back_cover1, y_axis, 0, 1.993953)
    Turn(right_back_cover1, z_axis, 0, 3.434164)
    Turn(right_front_sign, x_axis, 0, 11.828618)
    Turn(right_head, z_axis, 0, 19.634955)
    Turn(right_head_advanced, z_axis, 0, 22.089326)
end

Animations={openstd=anim1, closestd=anim2, openadv=anim3, closeadv=anim4, stop=StopAnimation, testanim=anim5}

return Animations
