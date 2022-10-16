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
    initTween({ finalEndFrame = 52, --sleepTime = sleepTime,
                --[1] = { pieceID = right_back_cover1, cmd = "turn", axis = x_axis,
                --        targetValue = rad(120), firstFrame = 0, lastFrame = 52,
                --},
                [right_back_cover1] = { [1] = { cmd = "turn", axis = x_axis,
                        targetValue = rad(120), firstFrame = 0, lastFrame = 52,}
                },
                [left_cover1] = { [1] = { cmd = "turn", axis = x_axis,
                        targetValue = rad(120), firstFrame = 0, lastFrame = 52,}
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
    initTween({ finalEndFrame = 48,
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
                        targetValue = 0, firstFrame = 0, lastFrame = 29,}
                },
                [left_arm2] = { [1] = {cmd = "turn", axis = z_axis,
                        targetValue = 0, firstFrame = 0, lastFrame = 29,}
                },
                [right_arm3] = { [1] = {cmd = "turn", axis = z_axis,
                        targetValue = 0, firstFrame = 0, lastFrame = 29,}
                },
                [left_arm3] = { [1] = {cmd = "turn", axis = z_axis,
                        targetValue = 0, firstFrame = 0, lastFrame = 29,}
                },
                [right_head] = { [1] = {cmd = "turn", axis = z_axis,
                        targetValue = 0, firstFrame = 0, lastFrame = 29,}
                },
                [left_head] = { [1] = {cmd = "turn", axis = z_axis,
                        targetValue = 0, firstFrame = 0, lastFrame = 29,}
                },
    })
    ---- Frame:56
    --Sleep(131)
    ---- Frame:68
    --Turn(left_arm2, z_axis, -0.986506, 1.460727 )
    --Turn(left_arm3, z_axis, -0.657670, 0.973818 )
    --Turn(left_head, z_axis, -0.282760, 1.256595 )
    --Turn(right_arm2, z_axis, 0.986506, 1.460727 )
    --Turn(right_arm3, z_axis, 0.657670, 0.973818 )
    --Turn(right_head, z_axis, 0.282760, 1.256595 )
    --Sleep(395)
    ---- Frame:70
    --Turn(left_arm2, z_axis, -0.826006, 2.407493 )
    --Turn(left_arm3, z_axis, -0.550671, 1.604996 )
    --Turn(left_cover1, x_axis, -2.075239, 0.267624 )
    --Turn(left_head, z_axis, -0.003372, 0.155042 )
    --Turn(left_head, z_axis, -0.193183, 1.343657 )
    --Turn(right_arm2, z_axis, 0.826006, 2.407493 )
    --Turn(right_arm3, z_axis, 0.550671, 1.604996 )
    --Turn(right_back_cover1, x_axis, -2.075239, 0.267624 )
    --Turn(right_head, z_axis, 0.003372, 0.155042 )
    --Turn(right_head, z_axis, 0.193183, 1.343657 )
    --Sleep(65)
    ---- Frame:85
    --Turn(left_arm2, z_axis, -0.000000, 0.054831 )
    --Turn(left_arm2, z_axis, -0.000000, 1.652012 )
    --Turn(left_arm3, z_axis, -0.000000, 0.036554 )
    --Turn(left_arm3, z_axis, -0.000000, 1.101341 )
    --Turn(left_cover1, x_axis, -1.279441, 1.591596 )
    --Turn(left_head, z_axis, -0.000000, 0.006743 )
    --Turn(left_head, z_axis, -0.000000, 0.386366 )
    --Turn(right_arm2, z_axis, -0.000000, 0.054831 )
    --Turn(right_arm2, z_axis, -0.000000, 1.652012 )
    --Turn(right_arm3, z_axis, -0.000000, 0.036554 )
    --Turn(right_arm3, z_axis, -0.000000, 1.101341 )
    --Turn(right_back_cover1, x_axis, -1.279441, 1.591596 )
    --Turn(right_head, z_axis, -0.000000, 0.006743 )
    --Turn(right_head, z_axis, -0.000000, 0.386366 )
    --Sleep(494)
    ---- Frame:104
    --Turn(left_cover1, x_axis, -0.000000, 0.057681 )
    --Turn(left_cover1, x_axis, -0.000000, 2.020170 )
    --Turn(right_back_cover1, x_axis, -0.000000, 0.057681 )
    --Turn(right_back_cover1, x_axis, -0.000000, 2.020170 )
    --Sleep(626)
    ---- Frame:108
    --Turn(left_cover1, x_axis, -1.046136, 7.846019 )
    --Turn(right_back_cover1, x_axis, -1.046136, 7.846019 )
    --Turn(right_head_advanced, z_axis, 0.017498, 0.131232 )-- Failed to find previous position for boneright_head_advancedaxisrotation_euler1
    --Sleep(131)
    ---- Frame:111
    --Turn(left_cover1, x_axis, -2.002834, 9.566982 )
    --Turn(left_head_advanced, z_axis, -0.229863, 2.298634 )
    --Turn(right_back_cover1, x_axis, -2.002834, 9.566982 )
    --Turn(right_head_advanced, z_axis, 1.223433, 2.208933 )
    --Sleep(98)
end

--- open_advanced
local function anim3()
    -- Frame:112
    Move(left_arm1, y_axis, 1000.000000, 30000.000000 )-- WARNING: possible gimbal lock issue detected in frame 112 bone left_arm1

    Move(left_arm1_advanced, y_axis, 0.000000, 300000.000000 )-- WARNING: possible gimbal lock issue detected in frame 112 bone left_arm1_advanced

    Turn(left_arm2_advanced, z_axis, -0.046032, 1.380963 )-- Failed to find previous position for boneleft_arm2_advancedaxisrotation_euler1
    Turn(left_cover1, x_axis, -0.036531, 1.095934 )
    Turn(left_cover1, x_axis, -2.093080, 2.707386 )
    Turn(left_head_advanced, z_axis, -0.004755, 0.142644 )
    Turn(left_head_advanced, z_axis, -0.272431, 1.277017 )
    Move(left_upgrade, y_axis, 0.000000, 30000.000000 )

    Move(right_arm1, y_axis, 1000.000000, 30000.000000 )

    Move(right_arm1_advanced, y_axis, 0.000000, 300000.000000 )

    Turn(right_back_cover1, x_axis, -0.036531, 1.095934 )
    Turn(right_back_cover1, x_axis, -2.093080, 2.707386 )
    Turn(right_head_advanced, z_axis, 0.022067, 0.137078 )
    Turn(right_head_advanced, z_axis, 1.264339, 1.227182 )
    Move(right_upgrade, y_axis, 0.000000, 30000.000000 )

    Sleep(32)
    -- Frame:128
    Turn(left_arm2_advanced, z_axis, -0.049538, 0.006574 )
    Turn(left_arm2_advanced, z_axis, -2.838322, 0.376645 )
    Turn(left_cover1, x_axis, -2.095754, 0.005013 )
    Turn(left_cover1, z_axis, 0.005245, 0.009835 )
    Turn(left_cover1, y_axis, 0.021426, 0.040174 )
    Turn(right_arm2_advanced, z_axis, 2.838641, 0.413713 )
    Turn(right_back_cover1, x_axis, -2.095754, 0.005013 )
    Turn(right_back_cover1, z_axis, 0.005245, 0.009835 )
    Turn(right_back_cover1, y_axis, 0.021426, 0.040174 )
    Turn(right_head_advanced, z_axis, 1.218418, 0.086103 )
    Sleep(527)
    -- Frame:132
    Turn(left_arm2_advanced, z_axis, -2.858431, 0.150817 )
    Turn(left_cover1, z_axis, 0.010244, 0.037494 )
    Turn(left_cover1, y_axis, 0.023913, 0.018652 )
    Turn(right_arm2_advanced, z_axis, 0.049991, 0.032235 )
    Turn(right_arm2_advanced, z_axis, 2.864252, 0.192082 )
    Turn(right_back_cover1, z_axis, 0.010244, 0.037494 )
    Turn(right_back_cover1, y_axis, 0.023913, 0.018652 )
    Turn(right_head_advanced, z_axis, 1.196465, 0.164643 )
    Sleep(131)
    -- Frame:152
    Turn(left_arm2_advanced, z_axis, -2.898292, 0.059791 )
    Turn(left_cover1, x_axis, -2.089951, 0.008738 )
    Turn(left_cover1, z_axis, 0.079999, 0.104632 )
    Turn(left_cover1, y_axis, -0.045606, 0.104279 )
    Move(left_upgrade, z_axis, -11.148439, 16.722659 )
    Turn(right_back_cover1, x_axis, -2.089951, 0.008738 )
    Turn(right_back_cover1, z_axis, 0.079999, 0.104632 )
    Turn(right_back_cover1, y_axis, -0.045606, 0.104279 )
    Turn(right_head_advanced, z_axis, 1.070414, 0.189077 )
    Move(right_upgrade, z_axis, -11.148439, 16.722659 )
    Sleep(659)
    -- Frame:154
    Move(back_connection, z_axis, -11.483793, 172.256899 )
    Move(back_connection, y_axis, 0.344059, 5.160890 )
    Move(left_back_base, x_axis, -11.400000, 170.999994 )
    Move(left_back_base, z_axis, -11.400000, 170.999994 )
    Move(left_front_base, x_axis, -11.600000, 174.000006 )
    Move(left_front_base, z_axis, 11.600000, 174.000006 )
    Move(right_back_base, x_axis, 11.400000, 170.999994 )
    Move(right_back_base, z_axis, -11.400000, 170.999994 )
    Move(right_front_base, x_axis, 11.600000, 174.000006 )
    Move(right_front_base, z_axis, 11.600000, 174.000006 )
    Turn(right_head_advanced, z_axis, 1.059088, 0.169880 )
    Sleep(65)
    -- Frame:160
    Move(left_arm1_advanced, x_axis, -13.400000, 66.999998 )
    Turn(left_cover1, x_axis, -2.107949, 0.090688 )
    Turn(left_cover1, z_axis, 0.012719, 0.343416 )
    Turn(left_cover1, y_axis, -0.007385, 0.199395 )
    Turn(left_front_sign, x_axis, 0.004067, 0.020337 )
    Turn(left_front_sign, x_axis, 0.233050, 1.165249 )
    Move(left_upgrade, x_axis, -0.800000, 4.000000 )
    Move(right_arm1_advanced, x_axis, 13.400000, 66.999998 )
    Turn(right_back_cover1, x_axis, -2.107949, 0.090688 )
    Turn(right_back_cover1, z_axis, 0.012719, 0.343416 )
    Turn(right_back_cover1, y_axis, -0.007385, 0.199395 )
    Turn(right_front_sign, x_axis, 0.004067, 0.020337 )
    Turn(right_front_sign, x_axis, 0.233050, 1.165249 )
    Turn(right_head_advanced, z_axis, 1.029767, 0.146607 )
    Move(right_upgrade, x_axis, 0.800000, 4.000000 )
    Sleep(197)
    -- Frame:162
    Move(back_connection, z_axis, -11.725308, 3.622727 )
    Move(back_connection, y_axis, 3.483554, 47.092422 )
    Move(left_back_wall, y_axis, 3.130494, 46.957415 )
    Turn(left_cover1, x_axis, -2.111308, 0.050383 )
    Turn(left_cover1, z_axis, 0.000000, 0.190787 )
    Turn(left_cover1, y_axis, 0.000000, 0.110775 )
    Turn(left_front_sign, x_axis, 0.215938, 0.256676 )
    Move(left_front_wall, y_axis, 3.200000, 48.000001 )
    Turn(right_back_cover1, x_axis, -2.111308, 0.050383 )
    Turn(right_back_cover1, z_axis, 0.000000, 0.190787 )
    Turn(right_back_cover1, y_axis, 0.000000, 0.110775 )
    Move(right_back_wall, y_axis, 3.300000, 49.499999 )
    Turn(right_front_sign, x_axis, 0.215938, 0.256676 )
    Move(right_front_wall, y_axis, 3.200000, 48.000001 )
    Turn(right_head_advanced, z_axis, 1.021932, 0.117520 )
    Sleep(65)
    -- Frame:170
    Turn(left_arm3_advanced, z_axis, 0.068841, 0.258154 )-- Failed to find previous position for boneleft_arm3_advancedaxisrotation_euler1
    Turn(left_front_sign, x_axis, 0.019153, 0.737944 )
    Turn(right_front_sign, x_axis, 0.019153, 0.737944 )
    Turn(right_head_advanced, z_axis, 1.003393, 0.069522 )
    Sleep(263)
    -- Frame:172
    Turn(left_front_sign, x_axis, 0.000036, 0.060478 )
    Turn(left_front_sign, x_axis, 0.002041, 0.256676 )
    Turn(right_front_sign, x_axis, 0.000036, 0.060478 )
    Turn(right_front_sign, x_axis, 0.002041, 0.256676 )
    Turn(right_head_advanced, z_axis, 0.017498, 0.068539 )
    Sleep(65)
end

--- close_default
local function anim4()
    -- Frame:212
    Move(left_arm1_advanced, x_axis, -13.500000, 0.075000 )
    Move(right_arm1_advanced, x_axis, 13.500000, 0.075000 )
    Turn(right_arm3_advanced, z_axis, -0.073264, 0.054948 )-- Failed to find previous position for boneright_arm3_advancedaxisrotation_euler1
    Sleep(1319)
    -- Frame:220
    Turn(left_arm2_advanced, z_axis, -2.766889, 0.496329 )
    Turn(left_arm3_advanced, z_axis, 3.792427, 0.569540 )
    Move(left_back_wall, y_axis, 3.300000, 0.635646 )
    Turn(left_head_advanced, z_axis, -0.290421, 0.067464 )
    Turn(right_arm2_advanced, z_axis, 2.721927, 0.529633 )
    Turn(right_arm3_advanced, z_axis, -4.021894, 0.659307 )
    Turn(right_head_advanced, z_axis, 0.927619, 0.280952 )
    Sleep(263)
    -- Frame:222
    Turn(left_arm2_advanced, z_axis, -2.697306, 1.043748 )
    Turn(left_arm3_advanced, z_axis, 3.709633, 1.241913 )
    Turn(right_arm2_advanced, z_axis, 2.648179, 1.106232 )
    Turn(right_arm3_advanced, z_axis, -3.927289, 1.419075 )
    Turn(right_head_advanced, z_axis, 0.889400, 0.573284 )
    Sleep(65)
    -- Frame:224
    Turn(left_arm2_advanced, z_axis, -2.615460, 1.227686 )
    Turn(left_arm3_advanced, z_axis, 3.610174, 1.491873 )
    Turn(left_front_sign, x_axis, -0.025665, 0.415601 )
    Turn(right_arm2_advanced, z_axis, 2.561738, 1.296605 )
    Turn(right_arm3_advanced, z_axis, -3.814484, 1.692073 )
    Turn(right_front_sign, x_axis, -0.025665, 0.415601 )
    Turn(right_head_advanced, z_axis, 0.845269, 0.661963 )
    Sleep(65)
    -- Frame:227
    Move(back_connection, z_axis, -10.820299, 9.050093 )
    Move(back_connection, y_axis, 3.247269, 2.362854 )
    Turn(left_arm2_advanced, z_axis, -2.472255, 1.432056 )
    Turn(left_arm3_advanced, z_axis, 3.431126, 1.790481 )
    Turn(left_front_sign, x_axis, -0.131164, 1.054985 )
    Turn(right_arm2_advanced, z_axis, 2.411219, 1.505194 )
    Turn(right_arm3_advanced, z_axis, -3.613404, 2.010794 )
    Turn(right_front_sign, x_axis, -0.131164, 1.054985 )
    Turn(right_head_advanced, z_axis, 0.770048, 0.752209 )
    Sleep(98)
    -- Frame:228
    Turn(left_arm2_advanced, z_axis, -2.419654, 1.578026 )
    Turn(left_arm3_advanced, z_axis, 3.363797, 2.019875 )
    Turn(left_front_sign, x_axis, -0.170593, 1.182862 )
    Turn(right_arm2_advanced, z_axis, 2.356154, 1.651940 )
    Turn(right_arm3_advanced, z_axis, -3.538393, 2.250330 )
    Turn(right_front_sign, x_axis, -0.170593, 1.182862 )
    Turn(right_head_advanced, z_axis, 0.743039, 0.810281 )
    Sleep(32)
    -- Frame:232
    Turn(left_arm2_advanced, z_axis, -2.188812, 1.731314 )
    Turn(left_arm3_advanced, z_axis, 3.058358, 2.290796 )
    Turn(left_front_sign, x_axis, -0.004614, 0.034873 )
    Turn(left_front_sign, x_axis, -0.264369, 0.703324 )
    Turn(right_arm2_advanced, z_axis, 2.115916, 1.801790 )
    Turn(right_arm3_advanced, z_axis, -3.201862, 2.523987 )
    Turn(right_front_sign, x_axis, -0.004614, 0.034873 )
    Turn(right_front_sign, x_axis, -0.264369, 0.703324 )
    Turn(right_head_advanced, z_axis, 0.628462, 0.859327 )
    Sleep(131)
    -- Frame:236
    Move(back_connection, z_axis, -8.312860, 18.805790 )
    Move(back_connection, y_axis, 0.272874, 22.307957 )
    Turn(left_arm2_advanced, z_axis, -1.932278, 1.924006 )
    Turn(left_arm3_advanced, z_axis, 2.698919, 2.695790 )
    Move(left_back_wall, y_axis, 0.300000, 22.500000 )
    Turn(left_front_sign, x_axis, -0.150923, 0.850848 )
    Move(left_front_wall, y_axis, 0.289492, 21.828809 )
    Turn(right_arm2_advanced, z_axis, 1.851762, 1.981153 )
    Turn(right_arm3_advanced, z_axis, -2.813128, 2.915499 )
    Move(right_back_wall, y_axis, 0.300000, 22.500000 )
    Turn(right_front_sign, x_axis, -0.150923, 0.850848 )
    Move(right_front_wall, y_axis, 0.289492, 21.828809 )
    Turn(right_head_advanced, z_axis, 0.509073, 0.895421 )
    Sleep(131)
    -- Frame:240
    Turn(left_arm2_advanced, z_axis, -1.659394, 2.046628 )
    Turn(left_arm3_advanced, z_axis, 0.039978, 0.216477 )
    Turn(left_arm3_advanced, z_axis, 2.290544, 3.062813 )
    Turn(left_front_sign, x_axis, -0.000654, 0.029700 )
    Turn(left_front_sign, x_axis, -0.037476, 0.850848 )
    Turn(left_head_advanced, z_axis, -0.284752, 0.020750 )
    Turn(right_arm2_advanced, z_axis, 1.574433, 2.079969 )
    Turn(right_arm3_advanced, z_axis, -2.380434, 3.245210 )
    Turn(right_front_sign, x_axis, -0.000654, 0.029700 )
    Turn(right_front_sign, x_axis, -0.037476, 0.850848 )
    Turn(right_head_advanced, z_axis, 0.392405, 0.875009 )
    Sleep(131)
    -- Frame:246
    Turn(left_arm2_advanced, z_axis, -1.239850, 2.097721 )
    Turn(left_arm3_advanced, z_axis, 1.616169, 3.371875 )
    Turn(left_head_advanced, z_axis, -0.174242, 0.552546 )
    Turn(right_arm2_advanced, z_axis, 0.020197, 0.148871 )
    Turn(right_arm2_advanced, z_axis, 1.157228, 2.086021 )
    Turn(right_arm3_advanced, z_axis, -0.029094, 0.220847 )
    Turn(right_arm3_advanced, z_axis, -1.666989, 3.567225 )
    Turn(right_head_advanced, z_axis, 0.004171, 0.066633 )
    Turn(right_head_advanced, z_axis, 0.238987, 0.767089 )
    Sleep(197)
    -- Frame:248
    Turn(left_arm2_advanced, z_axis, -1.101948, 2.068527 )
    Turn(left_arm3_advanced, z_axis, 1.391961, 3.363125 )
    Turn(left_head_advanced, z_axis, -0.002691, 0.034190 )
    Turn(left_head_advanced, z_axis, -0.154156, 0.301300 )
    Turn(right_arm2_advanced, z_axis, 1.023134, 2.011421 )
    Turn(right_arm3_advanced, z_axis, -1.417580, 3.741127 )
    Turn(right_head_advanced, z_axis, 0.197161, 0.627393 )
    Sleep(65)
    -- Frame:254
    Turn(left_arm2_advanced, z_axis, -0.710432, 1.957581 )
    Turn(left_arm3_advanced, z_axis, 0.013764, 0.131065 )
    Turn(left_arm3_advanced, z_axis, 0.788645, 3.016578 )
    Turn(left_head_advanced, z_axis, -0.158667, 0.022554 )
    Turn(right_arm2_advanced, z_axis, 0.650350, 1.863919 )
    Turn(right_arm3_advanced, z_axis, -0.012780, 0.081573 )
    Turn(right_arm3_advanced, z_axis, -0.732228, 3.426764 )
    Turn(right_head_advanced, z_axis, 0.100856, 0.481522 )
    Sleep(197)
    -- Frame:257
    Turn(left_arm2_advanced, z_axis, -0.534381, 1.760509 )
    Turn(left_arm3_advanced, z_axis, 0.552511, 2.361344 )
    Turn(left_head_advanced, z_axis, -0.149028, 0.096390 )
    Move(left_upgrade, x_axis, -0.100034, 6.999664 )
    Move(left_upgrade, z_axis, 0.305976, 114.544155 )
    Turn(right_arm2_advanced, z_axis, 0.486114, 1.642356 )
    Turn(right_arm3_advanced, z_axis, -0.478419, 2.538084 )
    Turn(right_head_advanced, z_axis, 0.067159, 0.336979 )
    Move(right_upgrade, x_axis, 0.100034, 6.999664 )
    Move(right_upgrade, z_axis, 0.305976, 114.544155 )
    Sleep(98)
    -- Frame:260
    Move(left_arm1_advanced, x_axis, -0.123726, 133.762738 )
    Turn(left_arm2_advanced, z_axis, -0.376724, 1.576576 )
    Turn(left_arm3_advanced, z_axis, 0.364058, 1.884524 )
    Turn(left_head_advanced, z_axis, -0.124395, 0.246330 )
    Move(right_arm1_advanced, x_axis, 0.254169, 132.458305 )
    Turn(right_arm2_advanced, z_axis, 0.340695, 1.454197 )
    Turn(right_arm3_advanced, z_axis, -0.290137, 1.882821 )
    Turn(right_head_advanced, z_axis, 0.041674, 0.254842 )
    Sleep(98)
    -- Frame:264
    Turn(left_arm2_advanced, z_axis, -0.201938, 1.310892 )
    Turn(left_arm3_advanced, z_axis, 0.180661, 1.375478 )
    Move(left_back_wall, y_axis, 0.000000, 2.250000 )
    Move(left_front_base, x_axis, 0.000000, 87.000003 )
    Move(left_front_base, z_axis, 0.000000, 87.000003 )
    Turn(left_head_advanced, z_axis, -0.079333, 0.337960 )
    Turn(right_arm2_advanced, z_axis, 0.181315, 1.195351 )
    Turn(right_arm3_advanced, z_axis, -0.124677, 1.240948 )
    Move(right_back_wall, y_axis, 0.000000, 2.250000 )
    Move(right_front_base, x_axis, 0.000000, 87.000003 )
    Move(right_front_base, z_axis, 0.000000, 87.000003 )
    Turn(right_head_advanced, z_axis, 0.018628, 0.172848 )
    Sleep(131)
    -- Frame:270
    Move(back_connection, z_axis, 0.000000, 41.564302 )
    Move(back_connection, y_axis, 0.000000, 1.364372 )
    Turn(left_arm2_advanced, z_axis, -0.034646, 0.836459 )
    Turn(left_arm3_advanced, z_axis, 0.033461, 0.736002 )
    Turn(left_head_advanced, z_axis, -0.016501, 0.314160 )
    Turn(right_arm2_advanced, z_axis, 0.030808, 0.752533 )
    Turn(right_arm3_advanced, z_axis, -0.014344, 0.551667 )
    Turn(right_head_advanced, z_axis, 0.002348, 0.081398 )
    Sleep(197)
    -- Frame:274
    Move(left_arm1_advanced, x_axis, 0.000000, 0.927947 )
    Turn(left_arm2_advanced, z_axis, -0.000000, 0.379510 )
    Turn(left_arm2_advanced, z_axis, -0.000000, 0.259845 )
    Turn(left_arm3_advanced, z_axis, 0.000140, 0.102187 )
    Turn(left_arm3_advanced, z_axis, 0.007994, 0.191005 )
    Move(left_back_base, x_axis, 0.000000, 85.499997 )
    Move(left_back_base, z_axis, 0.000000, 85.499997 )
    Turn(left_head_advanced, z_axis, -0.000000, 0.020769 )
    Turn(left_head_advanced, z_axis, -0.000000, 0.123760 )
    Move(left_upgrade, x_axis, 0.000000, 0.750252 )
    Move(left_upgrade, z_axis, 0.000000, 2.294821 )
    Move(right_arm1_advanced, x_axis, 0.000000, 1.906271 )
    Turn(right_arm2_advanced, z_axis, -0.000000, 0.151481 )
    Turn(right_arm2_advanced, z_axis, -0.000000, 0.231061 )
    Turn(right_arm3_advanced, z_axis, -0.000000, 0.095848 )
    Turn(right_arm3_advanced, z_axis, -0.000000, 0.107580 )
    Move(right_back_base, x_axis, 0.000000, 85.499997 )
    Move(right_back_base, z_axis, 0.000000, 85.499997 )
    Turn(right_head_advanced, z_axis, -0.000000, 0.031283 )
    Turn(right_head_advanced, z_axis, -0.000000, 0.017612 )
    Move(right_upgrade, x_axis, 0.000000, 0.750252 )
    Move(right_upgrade, z_axis, 0.000000, 2.294821 )
    Sleep(131)
    -- Frame:300
    Turn(left_cover1, x_axis, -0.013301, 0.027249 )
    Turn(left_cover1, x_axis, -0.762065, 1.561236 )
    Turn(right_back_cover1, x_axis, -0.013301, 0.027249 )
    Turn(right_back_cover1, x_axis, -0.762065, 1.561236 )
    Sleep(857)
    -- Frame:320
    Turn(left_cover1, x_axis, -0.000000, 0.019951 )
    Turn(left_cover1, x_axis, -0.000000, 1.143098 )
    Turn(right_back_cover1, x_axis, -0.000000, 0.019951 )
    Turn(right_back_cover1, x_axis, -0.000000, 1.143098 )
    Sleep(659)
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

Animations={openstd=anim1, closestd=anim2, openadv=anim3, closeadv=anim4, stop=StopAnimation}

return Animations
