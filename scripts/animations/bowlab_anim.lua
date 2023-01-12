-- #=#=# Animations:

local function openstd()
    initTween({veryLastFrame=52,
               [left_cover1]={
                   [1]={cmd="turn", axis=x_axis, targetValue=2.093080, firstFrame=0, lastFrame=52,},
               },
               [right_back_cover1]={
                   [1]={cmd="turn", axis=x_axis, targetValue=2.093080, firstFrame=0, lastFrame=52,},
               },
               [right_arm2]={
                   [1]={cmd="turn", axis=y_axis, targetValue=1.570796, firstFrame=32, lastFrame=52,},
               },
               [right_arm3]={
                   [1]={cmd="turn", axis=y_axis, targetValue=1.047198, firstFrame=32, lastFrame=52,},
               },
               [right_head]={
                   [1]={cmd="turn", axis=y_axis, targetValue=0.785398, firstFrame=40, lastFrame=52,},
               },
               [left_arm2]={
                   [1]={cmd="turn", axis=y_axis, targetValue=-1.570796, firstFrame=32, lastFrame=52,},
               },
               [left_arm3]={
                   [1]={cmd="turn", axis=y_axis, targetValue=-1.047198, firstFrame=32, lastFrame=52,},
               },
               [left_head]={
                   [1]={cmd="turn", axis=y_axis, targetValue=-0.785398, firstFrame=40, lastFrame=52,},
               },
    })
end
local function closestd()
    initTween({veryLastFrame=48,
               [left_cover1]={
                   [1]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=12, lastFrame=48,},
               },
               [right_back_cover1]={
                   [1]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=12, lastFrame=48,},
               },
               [right_arm2]={
                   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=29,},
               },
               [right_arm3]={
                   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=29,},
               },
               [right_head]={
                   [1]={cmd="turn", axis=y_axis, targetValue=0.193183, firstFrame=0, lastFrame=14,},
                   [2]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=14, lastFrame=29,},
               },
               [left_arm2]={
                   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=29,},
               },
               [left_arm3]={
                   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=29,},
               },
               [left_head]={
                   [1]={cmd="turn", axis=y_axis, targetValue=-0.193183, firstFrame=0, lastFrame=14,},
                   [2]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=14, lastFrame=29,},
               },
    })
end
local function morphup()
    initTween({veryLastFrame=52,
               [right_upgrade]={
                   --[1]={cmd="show", firstFrame=0,},
                   [1]={cmd="move", axis=y_axis, targetValue=-11.148439, firstFrame=0, lastFrame=40,},
                   [2]={cmd="move", axis=x_axis, targetValue=-0.800000, firstFrame=40, lastFrame=48,},
               },
               [left_upgrade]={
                   --[1]={cmd="show", firstFrame=0,},
                   [1]={cmd="move", axis=y_axis, targetValue=-11.148439, firstFrame=0, lastFrame=40,},
                   [2]={cmd="move", axis=x_axis, targetValue=0.800000, firstFrame=40, lastFrame=48,},
               },
               --[right_arm1_advanced]={
               --    [1]={cmd="show", firstFrame=0,},
               --},
               --[left_arm1_advanced]={
               --    [1]={cmd="show", firstFrame=0,},
               --},
               [right_front_base]={
                   [1]={cmd="move", axis=x_axis, targetValue=-11.600000, firstFrame=0, lastFrame=42,},
                   [2]={cmd="move", axis=y_axis, targetValue=-11.600000, firstFrame=0, lastFrame=42,},
               },
               [left_front_base]={
                   [1]={cmd="move", axis=x_axis, targetValue=11.600000, firstFrame=0, lastFrame=42,},
                   [2]={cmd="move", axis=y_axis, targetValue=-11.600000, firstFrame=0, lastFrame=42,},
               },
               [right_front_wall]={
                   [1]={cmd="move", axis=z_axis, targetValue=3.300000, firstFrame=40, lastFrame=52,},
               },
               [left_front_wall]={
                   [1]={cmd="move", axis=z_axis, targetValue=3.300000, firstFrame=40, lastFrame=52,},
               },
               [right_back_base]={
                   [1]={cmd="move", axis=x_axis, targetValue=-11.400000, firstFrame=0, lastFrame=42,},
                   [2]={cmd="move", axis=y_axis, targetValue=11.400000, firstFrame=0, lastFrame=42,},
               },
               [left_back_base]={
                   [1]={cmd="move", axis=x_axis, targetValue=11.400000, firstFrame=0, lastFrame=42,},
                   [2]={cmd="move", axis=y_axis, targetValue=11.400000, firstFrame=0, lastFrame=42,},
               },
               [right_back_wall]={
                   [1]={cmd="move", axis=z_axis, targetValue=3.300000, firstFrame=40, lastFrame=52,},
               },
               [left_back_wall]={
                   [1]={cmd="move", axis=z_axis, targetValue=3.130494, firstFrame=40, lastFrame=52,},
               },
               [back_connection]={
                   [1]={cmd="move", axis=y_axis, targetValue=11.483793, firstFrame=0, lastFrame=42,},
                   [2]={cmd="move", axis=z_axis, targetValue=0.344059, firstFrame=0, lastFrame=42,},
                   [3]={cmd="move", axis=y_axis, targetValue=11.725308, firstFrame=42, lastFrame=52,},
                   [4]={cmd="move", axis=z_axis, targetValue=3.483554, firstFrame=42, lastFrame=52,},
               },
               --[right_arm1]={
               --    [1]={cmd="hide", firstFrame=0,},
               --},
               --[left_arm1]={
                   --[1]={cmd="hide", firstFrame=0,},
                   --[2]={cmd="move", axis=z_axis, targetValue=1000.000000, firstFrame=4, lastFrame=8,},
               --},
               --[right_arm2]={
               --    [1]={cmd="hide", firstFrame=0,},
               --},
               --[right_arm3]={
               --    [1]={cmd="hide", firstFrame=0,},
               --},
               --[right_head]={
               --    [1]={cmd="hide", firstFrame=0,},
               --},
               --[right_pointer]={
               --    [1]={cmd="hide", firstFrame=0,},
               --},
               --[left_arm2]={
               --    [1]={cmd="hide", firstFrame=0,},
               --},
               --[left_arm3]={
               --    [1]={cmd="hide", firstFrame=0,},
               --},
               --[left_head]={
               --    [1]={cmd="hide", firstFrame=0,},
               --},
               --[left_pointer]={
               --    [1]={cmd="hide", firstFrame=0,},
               --},
               --[left_arm2_advanced]={
               --    [1]={cmd="show", firstFrame=0,},
               --},
               --[left_arm3_advanced]={
               --    [1]={cmd="show", firstFrame=0,},
               --},
               --[left_head_advanced]={
               --    [1]={cmd="show", firstFrame=0,},
               --},
               --[right_arm2_advanced]={
               --    [1]={cmd="show", firstFrame=0,},
               --},
               --[right_arm3_advanced]={
               --    [1]={cmd="show", firstFrame=0,},
               --},
               --[right_head_advanced]={
               --    [1]={cmd="show", firstFrame=0,},
               --},
               --[left_pointer2]={
               --    [1]={cmd="show", firstFrame=0,},
               --},
               --[left_pointer1]={
               --    [1]={cmd="show", firstFrame=0,},
               --},
               --[right_pointer1]={
               --    [1]={cmd="show", firstFrame=0,},
               --},
               --[right_pointer2]={
               --    [1]={cmd="show", firstFrame=0,},
               --},
    })
end
local function openadv()
    initTween({veryLastFrame=52,
               [right_arm1_advanced]={
                   [1]={cmd="move", axis=x_axis, targetValue=-13.500000, firstFrame=12, lastFrame=52,},
               },
               [left_arm1_advanced]={
                   [1]={cmd="move", axis=x_axis, targetValue=13.500000, firstFrame=12, lastFrame=52,},
               },
               [left_front_sign]={
                   [1]={cmd="turn", axis=x_axis, targetValue=-0.233050, firstFrame=34, lastFrame=52,},
               },
               [right_front_sign]={
                   [1]={cmd="turn", axis=x_axis, targetValue=-0.233050, firstFrame=34, lastFrame=52,},
               },
               [left_cover1]={
                   [1]={cmd="turn", axis=x_axis, targetValue=2.093080, firstFrame=0, lastFrame=30,},
               },
               [right_back_cover1]={
                   [1]={cmd="turn", axis=x_axis, targetValue=2.094395, firstFrame=0, lastFrame=30,},
               },
               [left_arm2_advanced]={
                   [1]={cmd="turn", axis=y_axis, targetValue=-2.356194, firstFrame=12, lastFrame=52,},
               },
               [left_arm3_advanced]={
                   [1]={cmd="turn", axis=y_axis, targetValue=3.139847, firstFrame=12, lastFrame=52,},
               },
               [left_head_advanced]={
                   [1]={cmd="turn", axis=y_axis, targetValue=0.087266, firstFrame=12, lastFrame=52,},
               },
               [right_arm2_advanced]={
                   [1]={cmd="turn", axis=y_axis, targetValue=2.356194, firstFrame=12, lastFrame=52,},
               },
               [right_arm3_advanced]={
                   [1]={cmd="turn", axis=y_axis, targetValue=-3.139847, firstFrame=12, lastFrame=52,},
               },
               [right_head_advanced]={
                   [1]={cmd="turn", axis=y_axis, targetValue=0.523313, firstFrame=12, lastFrame=52,},
               },
    })
end
local function closeadv()
    initTween({veryLastFrame=44,
               [right_arm1_advanced]={
                   [1]={cmd="move", axis=x_axis, targetValue=0.000000, firstFrame=0, lastFrame=40,}, --0.254169
                   --[2]={cmd="move", axis=x_axis, targetValue=0.000000, firstFrame=28, lastFrame=40,},
               },
               [left_arm1_advanced]={
                   [1]={cmd="move", axis=x_axis, targetValue=0.000000, firstFrame=0, lastFrame=40,},
               },
               [left_front_sign]={
                   [1]={cmd="turn", axis=x_axis, targetValue=-0.002041, firstFrame=14, lastFrame=26,},
               },
               [right_front_sign]={
                   [1]={cmd="turn", axis=x_axis, targetValue=-0.002041, firstFrame=14, lastFrame=26,},
               },
               [left_cover1]={
                   [1]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=12, lastFrame=44,},
               },
               [right_back_cover1]={
                   [1]={cmd="turn", axis=x_axis, targetValue=0.000000, firstFrame=12, lastFrame=44,},
               },
               [left_arm2_advanced]={
                   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=40,},
               },
               [left_arm3_advanced]={
                   [1]={cmd="turn", axis=y_axis, targetValue=0.007994, firstFrame=0, lastFrame=40,},
               },
               [left_head_advanced]={
                   [1]={cmd="turn", axis=y_axis, targetValue=-0.284752, firstFrame=0, lastFrame=24,},
                   [2]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=24, lastFrame=40,},
               },
               [right_arm2_advanced]={
                   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=40,},
               },
               [right_arm3_advanced]={
                   [1]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=0, lastFrame=40,},
               },
               [right_head_advanced]={
                   [1]={cmd="turn", axis=y_axis, targetValue=0.181863, firstFrame=0, lastFrame=40,},
               },
    })
end

local Animations = {openstd = openstd, closestd = closestd, morphup = morphup, openadv = openadv, closeadv = closeadv, }

return Animations
