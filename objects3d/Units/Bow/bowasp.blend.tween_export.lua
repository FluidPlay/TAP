-- For C:\Users\Breno\Documents\My Games\Spring\games\TAP.SDD\Objects3d\Units\Bow\bowasp.blend Created by https://github.com/Beherith/Skeletor_S3O V((0, 4, 1))

local base = piece 'base'
local wingFL = piece 'wingFL'
local wingBR = piece 'wingBR'
local wingBL = piece 'wingBL'
local wingFR = piece 'wingFR'
local turretaxis = piece 'turretaxis'
local turretbase = piece 'turretbase'
local turret2 = piece 'turret2'
local turret2spawner = piece 'turret2spawner'
local turret1 = piece 'turret1'
local turret1spawner = piece 'turret1spawner'
local turret3 = piece 'turret3'
local turret3spawner = piece 'turret3spawner'

VFS.Include("scripts/include/springtweener.lua")

local scriptEnv = { base = base,
					wingFL = wingFL,
					wingBR = wingBR,
					wingBL = wingBL,
					wingFR = wingFR,
					turretaxis = turretaxis,
					turretbase = turretbase,
					turret2 = turret2,
					turret2spawner = turret2spawner,
					turret1 = turret1,
					turret1spawner = turret1spawner,
					turret3 = turret3,
					turret3spawner = turret3spawner,
					rad = math.rad,
					x_axis = x_axis,
					y_axis = y_axis,
					z_axis = z_axis,
					Turn = Turn,
					Move = Move,
					Sleep = Sleep,
					initTween = initTween,
}

-- #=#=# Animations: 

local function Go()
	initTween({veryLastFrame=23,
			})
end
local function Stop()
	initTween({veryLastFrame=24,
			})
end
local function Deploy()
	initTween({veryLastFrame=32,
			})
end
local function Undeploy()
	initTween({veryLastFrame=32,
			})
end
local function Shoot()
	initTween({veryLastFrame=16,
				[turret1]={
							[1]={cmd="move", axis=y_axis, targetValue=2.271845, firstFrame=0, lastFrame=4,},
							[2]={cmd="move", axis=y_axis, targetValue=6.601174, firstFrame=4, lastFrame=16,},
							},
			})
end

local Animations = {Go = Go, Stop = Stop, Deploy = Deploy, Undeploy = Undeploy, Shoot = Shoot, }

return Animations
