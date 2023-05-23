
return {
    --- Daemon's Explosion EMP is fired by unit_commander_blast.lua, for all comm levels
	daemon_emptrigger = {
		areaofeffect = 360,
		--cameraShake = 720,
		--craterboost = 6,
		--cratermult = 3,
		edgeeffectiveness = 1,
		--explosiongenerator="custom:COMMANDER_EXPLOSION", -- COMMANDER_EXPLOSION is called from gadget unit_commander_blast
		name = "commander_emptrigger",
		range = 360,
		reloadtime = 3.5999999046326,
		soundhit = "newboom",
		soundstart = "largegun",
		turret = 1,
		weaponvelocity = 900,
		damage = {
			default = 200,
		},
		customParams = { damagetype = "omni"},
	},
}
