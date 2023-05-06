return {
	daemon_blast = {
		areaofeffect = 270, --570, --620, --720
        cameraShake = 300,
		craterboost = 3,
		cratermult = 2,
		edgeeffectiveness = 0.9,
        explosiongenerator="custom:DAEMON_EXPLOSION", -- COMMANDER_EXPLOSION is called from gadget unit_commander_blast
		impulseboost = 2,
		impulsefactor = 2,
		name = "Matter/DaemonExplosion",
		range = 260, --Comm: 340
		reloadtime = 3.5999999046326,
		soundhit = "newboom",
		soundstart = "largegun",
		turret = 1,
		weaponvelocity = 900, --250,
		damage = {
			default = 10000, --50000
		},
		customParams = { damagetype = "explosion"},
	},
}
