local function undeploy()
    initTween({veryLastFrame=36,
               [base_root]={
                   [1]={cmd="turn", axis=y_axis, targetValue=-1.570796, firstFrame=0, lastFrame=36,},
                   [2]={cmd="move", axis=z_axis, targetValue=14.000000, firstFrame=0, lastFrame=20,},
                   [3]={cmd="move", axis=x_axis, targetValue=7.000000, firstFrame=0, lastFrame=20,},
                   [4]={cmd="move", axis=x_axis, targetValue=-0.000000, firstFrame=20, lastFrame=36,},
               },
               [base]={
                   [1]={cmd="turn", axis=y_axis, targetValue=-1.570796, firstFrame=0, lastFrame=36,},
               },
               [wingBL]={
                   [1]={cmd="turn", axis=y_axis, targetValue=0.872665, firstFrame=0, lastFrame=8,},
                   [2]={cmd="turn", axis=y_axis, targetValue=-0.157080, firstFrame=8, lastFrame=20,},
                   [3]={cmd="turn", axis=y_axis, targetValue=0.698132, firstFrame=20, lastFrame=28,},
                   [4]={cmd="turn", axis=y_axis, targetValue=1.151917, firstFrame=28, lastFrame=32,},
                   [5]={cmd="turn", axis=y_axis, targetValue=1.047198, firstFrame=32, lastFrame=36,},
               },
               [wingBR]={
                   [1]={cmd="turn", axis=y_axis, targetValue=-0.087266, firstFrame=0, lastFrame=16,},
                   [2]={cmd="turn", axis=y_axis, targetValue=-1.675516, firstFrame=16, lastFrame=28,},
                   [3]={cmd="turn", axis=y_axis, targetValue=-1.047198, firstFrame=28, lastFrame=36,},
               },
               [wingFL]={
                   [1]={cmd="turn", axis=y_axis, targetValue=0.436332, firstFrame=20, lastFrame=28,},
                   [2]={cmd="turn", axis=y_axis, targetValue=1.047198, firstFrame=28, lastFrame=36,},
               },
               [wingFR]={
                   [1]={cmd="turn", axis=y_axis, targetValue=-0.628319, firstFrame=0, lastFrame=8,},
                   [2]={cmd="turn", axis=y_axis, targetValue=-1.727876, firstFrame=8, lastFrame=24,},
                   [3]={cmd="turn", axis=y_axis, targetValue=-1.047198, firstFrame=24, lastFrame=36,},
               },
    })
end
local function shoot()
    initTween({veryLastFrame=12,
               [turret1]={
                   [1]={cmd="move", axis=y_axis, targetValue=3.996265, firstFrame=0, lastFrame=4,},
                   [2]={cmd="move", axis=y_axis, targetValue=-0.000000, firstFrame=4, lastFrame=12,},
               },
    })
end

local Animations = {undeploy = undeploy, fireweapon = shoot, }

return Animations