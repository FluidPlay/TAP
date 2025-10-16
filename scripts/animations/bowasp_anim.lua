local function landing()
    initTween({veryLastFrame=20,
               [wingFR]={
                   [1]={cmd="turn", axis=y_axis, targetValue=-0.610865, firstFrame=0, lastFrame=20,},
               },
               [wingBL]={
                   [1]={cmd="turn", axis=y_axis, targetValue=1.047198, firstFrame=0, lastFrame=20,},
               },
               [wingBR]={
                   [1]={cmd="turn", axis=y_axis, targetValue=-1.047198, firstFrame=0, lastFrame=20,},
               },
               [wingFL]={
                   [1]={cmd="turn", axis=y_axis, targetValue=0.610865, firstFrame=0, lastFrame=20,},
               },
    })
end
local function takeoff()
    initTween({veryLastFrame=24,
               [wingFR]={
                   [1]={cmd="turn", axis=y_axis, targetValue=-0.000000, firstFrame=0, lastFrame=24,},
               },
               [wingBL]={
                   [1]={cmd="turn", axis=y_axis, targetValue=-0.000000, firstFrame=0, lastFrame=24,},
               },
               [wingBR]={
                   [1]={cmd="turn", axis=y_axis, targetValue=-0.000000, firstFrame=0, lastFrame=24,},
               },
               [wingFL]={
                   [1]={cmd="turn", axis=y_axis, targetValue=-0.000000, firstFrame=0, lastFrame=24,},
               },
    })
end
local function premorphanim()   --deploy
    initTween({veryLastFrame=32,
               [wingFR]={
                   [1]={cmd="turn", axis=y_axis, targetValue=0.698132, firstFrame=4, lastFrame=20,},
                   [2]={cmd="turn", axis=y_axis, targetValue=0.349066, firstFrame=20, lastFrame=26,},
                   [3]={cmd="turn", axis=y_axis, targetValue=1.047198, firstFrame=26, lastFrame=32,},
               },
               [wingBL]={
                   [1]={cmd="turn", axis=y_axis, targetValue=0.785398, firstFrame=4, lastFrame=20,},
                   [2]={cmd="turn", axis=y_axis, targetValue=-1.047198, firstFrame=20, lastFrame=32,},
               },
               [wingBR]={
                   [1]={cmd="turn", axis=y_axis, targetValue=-0.349066, firstFrame=4, lastFrame=20,},
                   [2]={cmd="turn", axis=y_axis, targetValue=1.047198, firstFrame=20, lastFrame=32,},
               },
               [wingFL]={
                   [1]={cmd="turn", axis=y_axis, targetValue=0.785398, firstFrame=0, lastFrame=16,},
                   [2]={cmd="turn", axis=y_axis, targetValue=-1.047198, firstFrame=16, lastFrame=32,},
               },
               [base_root]={
                   [1]={cmd="turn", axis=y_axis, targetValue=1.57080, firstFrame=0, lastFrame=32,},
               },
               [base]={
                   [1]={cmd="turn", axis=y_axis, targetValue=1.57080, firstFrame=0, lastFrame=32,},
                   [2]={cmd="move", axis=z_axis, targetValue=20.000000, firstFrame=0, lastFrame=16,},
                   [3]={cmd="move", axis=x_axis, targetValue=5.999995, firstFrame=0, lastFrame=16,},
                   [4]={cmd="move", axis=z_axis, targetValue=14.000000, firstFrame=16, lastFrame=32,},
                   [5]={cmd="move", axis=x_axis, targetValue=0.000000, firstFrame=16, lastFrame=32,},
               },
    })
end
--local function undeploy()
--    initTween({veryLastFrame=36,
--               [wingFR]={
--                   [1]={cmd="turn", axis=y_axis, targetValue=0.436332, firstFrame=4, lastFrame=8,},
--                   [2]={cmd="turn", axis=y_axis, targetValue=-0.383972, firstFrame=8, lastFrame=20,},
--                   [3]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=20, lastFrame=36,},
--               },
--               [wingBL]={
--                   [1]={cmd="turn", axis=y_axis, targetValue=-0.698132, firstFrame=0, lastFrame=4,},
--                   [2]={cmd="turn", axis=y_axis, targetValue=0.349066, firstFrame=4, lastFrame=20,},
--                   [3]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=20, lastFrame=36,},
--               },
--               [wingBR]={
--                   [1]={cmd="turn", axis=y_axis, targetValue=0.698132, firstFrame=4, lastFrame=20,},
--                   [2]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=20, lastFrame=36,},
--               },
--               [wingFL]={
--                   [1]={cmd="turn", axis=y_axis, targetValue=-0.261799, firstFrame=0, lastFrame=16,},
--                   [2]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=16, lastFrame=32,},
--               },
--               [base]={
--                   [1]={cmd="turn", axis=y_axis, targetValue=1.570796, firstFrame=0, lastFrame=16,},
--                   [2]={cmd="move", axis=z_axis, targetValue=20.000000, firstFrame=0, lastFrame=16,},
--                   [3]={cmd="move", axis=x_axis, targetValue=5.999995, firstFrame=0, lastFrame=16,},
--                   [4]={cmd="turn", axis=y_axis, targetValue=0.785398, firstFrame=16, lastFrame=24,},
--                   [4]={cmd="turn", axis=y_axis, targetValue=0.000000, firstFrame=24, lastFrame=32,},
--                   [5]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=16, lastFrame=32,},
--                   [6]={cmd="move", axis=x_axis, targetValue=-0.000005, firstFrame=16, lastFrame=32,},
--               },
--    })
--end
local function shoot()
    initTween({veryLastFrame=12,
               [turret1]={
                   [1]={cmd="move", axis=y_axis, targetValue=-3.000000, firstFrame=0, lastFrame=4,},
                   [2]={cmd="move", axis=y_axis, targetValue=0.000000, firstFrame=4, lastFrame=12,},
               },
    })
end

local Animations = { land = landing, takeoff = takeoff, premorphanim = premorphanim, fireweapon = shoot, }

return Animations