--
-- Created by IntelliJ IDEA.
-- User: MaDDoX
-- Date: 14/05/17
-- Time: 04:16
--
-- Here we define, given a damageType key, a damage multiplier per armor class
--
--
local damageMultipliers = {

    laser = { 	robot = 1.5, vehicle = 0.7, air = 0.75, ship = 1, armorbot = 0.75, armorveh = 0.25, armorair = 1, armorship = 0.5,
                structure = 0.6, defense = 0.2, commander = 0.4, shield = 1, superunit = 1, ore = 0.15, },
    --    laser={     lightbot = 1.72, supportbot = 1.4,  heavybot = 0.6, lightveh = 0.61,    supportveh = 0.28,  heavyveh = 0.16,
    --                lightair = 1.395,supportair = 0.5,  heavyair = 1,   lightship = 1.25,   supportship = 2,    heavyship = 0.5,
    --                structure = 1.1, resource = 0.5,    defense = 0.5,  defenseaa = 0.15,   commander = 0.21,   superunit = 0.6,
    --    }
    --,
    --	hflaser={   lightbot = 1.5,  supportbot = 1.7,	heavybot = 0.45,lightveh = 0.55,    supportveh = 0.3,   heavyveh = 0.65,
    --				lightair = 1.25, supportair = 0.5,	heavyair = 1,   lightship = 1.5,    supportship = 0.75, heavyship = 0.25,
    --				structure = 0.75,resource = 0.75,	defense = 0.2,  defenseaa = 0.5,    commander = 0.85,   superunit = 0.65,
    --	}
    --,

    ---shell = { 	robot = 0.7, vehicle = 0.5, air = 1, ship = 1.5, structure = 1, defense = 0.33, commander = 0.6, superunit = 1.25, },

    bullet  = { robot = 0.8, vehicle = 0.5, air = 1.1, ship = 0.4, armorbot = 0.4, armorveh = 0.3, armorair = 1.5, armorship = 0.25,
                structure = 0.8, defense = 0.33, commander = 0.20, shield = 1, superunit = 0.6, ore = 0.1, },

    cannon  = { robot = 0.5, vehicle = 1.2, air = 1.3, ship = 1.5, armorbot = 0.6, armorveh = 1.0, armorair = 1.3, armorship = 1.5,
                structure = 1.2, defense = 0.33, commander = 0.75, shield = 1, superunit = 0.7, ore = 0.1, },

    flak    = { robot = 0.4, vehicle = 0.4, air = 1.0, ship = 1.0, armorbot = 2.0, armorveh = 0.3, armorair = 0.5, armorship = 0.75,
                structure = 0.5, defense = 0.33, commander = 0.20, shield = 2, superunit = 2.5, ore = 0.1, },
    --	bullet={ 	lightbot = 1.5,  supportbot = 1.5,	heavybot = 0.71,lightveh = 0.255,   supportveh = 0.4,   heavyveh = 0.4,
    --				lightair = 0.2,  supportair = 0.65,	heavyair = 1.5, lightship = 0.75,   supportship = 1,    heavyship = 0.25,
    --				structure = 0.75,resource = 0.25, 	defense = 0.18, defenseaa = 0.25,   commander = 0.21,   superunit = 0.7,
    --	}
    --,
    --	cannon={ 	lightbot = 0.2,  supportbot = 0.25, heavybot = 0.675,lightveh = 1.6, 	supportveh = 1.5,   heavyveh = 1.25,
    --                lightair = 1.5,  supportair = 2, 	heavyair = 1.25,lightship = 2,      supportship = 0.5,  heavyship = 1.5,
    --                structure = 1,   resource = 1, 		defense = 0.9, 	defenseaa = 0.22, 	commander = 0.75,   superunit = 0.7,
    --	}
    --,
    --	flak={ 		lightbot = 0.75, supportbot = 0.9, 	heavybot = 1.45,lightveh = 0.35,    supportveh = 0.75,  heavyveh = 0.275,
    --				  lightair = 1, 	 supportair = 0.75, heavyair = 0.4, lightship = 0.33,   supportship = 2.0,  heavyship = 0.75,
    --				  structure = 1, 	 resource = 0.25,	defense = 0.3, 	defenseaa = 0.8,    commander = 0.15,   superunit = 2.5,
    --	}
    --,

    pierce = { 	robot = 0.2, vehicle = 1, air = 1.0, ship = 1.5, armorbot = 0.4, armorveh = 3, armorair = 2, armorship = 2.4,
                structure = 0.75, defense = 0.4, commander = 0.5, shield = 1.5, superunit = 0.5, ore = 0.1, },
    --	rocket={ 	lightbot = 0.175,supportbot = 0.75, heavybot = 0.35,lightveh = 0.65,    supportveh = 0.85,	heavyveh = 4,
    --				lightair = 0.3,  supportair = 2.55, heavyair = 0.5, lightship = 2.45,   supportship = 1,    heavyship = 1.6,
    --				structure = 0.8, resource = 0.8,    defense = 0.275,defenseaa = 0.85,   commander = 0.4,    superunit = 0.35,
    --	}
    --,
    --	homing={ 	lightbot = 1,    supportbot = 0.25, heavybot = 0.3, lightveh = 0.75,    supportveh = 1.25,  heavyveh = 4.65, --3.2,
    --				lightair = 0.45, supportair = 2, 	heavyair = 2.5, lightship = 0.3,    supportship = 1.75, heavyship = 1.5,
    --				structure = 0.2, resource = 0.75, 	defense = 0.5,  defenseaa = 0.125,  commander = 0.2,    superunit = 0.2,
    --	}
    --,
    --	neutron={ 	lightbot = 0.3,  supportbot = 0.5, 	heavybot = 0.25,lightveh = 0.75,    supportveh = 0.4, 	heavyveh = 3.5,
    --				 lightair = 1.25, supportair = 3, 	heavyair = 1.5, lightship = 0.5,    supportship = 1,    heavyship = 4,
    --				 structure = 0.5, resource = 0.75, 	defense = 0.15, defenseaa = 0.1, 	commander = 0.2,    superunit = 0.9,
    --	}
    --,

    ---v3
    plasma = { 	robot = 1.1, vehicle = 0.65, air = 1, ship = 1.5, armorbot = 0.6, armorveh = 0.4, armorair = 1.5, armorship = 1.5,
                structure = 1.4, defense = 0.6, commander = 0.85, shield = 1, superunit = 0.75, ore = 0.2, },

    ---v2
    --plasma = { 	robot = 1.1, vehicle = 0.65, air = 1, ship = 1.5, structure = 1.4, defense = 0.6, commander = 0.85, shield = 1, superunit = 0.75, ore = 0.2, },

    ---v1
    --,
    --plasma={ 	lightbot = 1,    supportbot = 0.75, heavybot = 0.6,lightveh = 1.2,     supportveh = 0.45,  heavyveh = 0.4,
    --			lightair = 0.75, supportair = 2,    heavyair = 1.5,lightship = 0.75,   supportship = 1.5,  heavyship = 1.5,
    --			structure = 1,   resource = 1, 		defense = 0.275,defenseaa = 0.6,    commander = 1.15,   superunit = 1.15,
    --},

    photon = { 	robot = 0.9, vehicle = 0.6, air = 1.5, ship = 2, armorbot = 1.2, armorveh = 0.25, armorair = 0.25, armorship = 0.25,
                structure = 1.2, defense = 1.4, commander = 0.25, shield = 1, superunit = 1, ore = 0.15, },
    --	siege={ 	lightbot = 0.4,  supportbot = 0.85, heavybot = 1.2,	lightveh = 1, 	    supportveh = 0.6,   heavyveh = 0.25,
    --				lightair = 0.5,  supportair = 1.5, 	heavyair = 0.25,lightship = 3,      supportship = 0.75, heavyship = 0.25,
    --				structure = 1.2, resource = 1.2, 	defense = 1.6, 	defenseaa = 1.4, 	commander = 0.25,   superunit = 1,
    --	}
    --,

    thermo = { 	robot = 1.0, vehicle = 0.5, air = 1.25, ship = 1, armorbot = 1.1, armorveh = 1.1, armorair = 1, armorship = 1.25,
                structure = 0.5, defense = 0.3, commander = 0.3, shield = 0.02, superunit = 0.7, ore = 0.25, },
    --	thermo={ 	 lightbot = 1,    supportbot = 1.9, 	heavybot = 1.1, lightveh = 0.22,    supportveh = 1,     heavyveh = 1.3,
    --               lightair = 0.25,  supportair = 2.5,	heavyair = 1,   lightship = 1.5,    supportship = 0.25, heavyship = 1.25,
    --               structure = 0.5, resource = 0.25, 	defense = 0.2,  defenseaa = 0.3,    commander = 0.075,   superunit = 1.5,
    --	},
    --	nuke={ 		lightbot = 1, 	 supportbot = 1, 	heavybot = 1, 	lightveh = 1, 	    supportveh = 1,     heavyveh = 1.1,
    --				lightair = 1, 	 supportair = 1, 	heavyair = 1,   lightship = 1,	    supportship = 1,    heavyship = 1,
    --              structure = 1,   resource = 1,		defense = 1, 	defenseaa = 1, 		commander = 0.3,    superunit = 0.6,
    --	}
    --,

    emp = { robot = 1, vehicle = 1.6, air = 1, ship = 1.75, armorbot = 3, armorveh = 4.5, armorair = 1, armorship = 4,
            structure = 0.75, defense = 0.75, commander = 0.1, shield = 1, superunit = 0.33, ore = 1, },
    --	emp={ 	  lightbot = 1, 	 supportbot = 0.75, heavybot = 3, 	lightveh = 0.2,     supportveh = 2,     heavyveh = 4.5,
    --           lightair = 1, 	 supportair = 1, 	heavyair = 1,   lightship = 2,      supportship = 1.25, heavyship = 4,
    --           structure = 1, 	 resource = 1,	    defense = 1, 	defenseaa = 0.75, 	commander = 0.1,    superunit = 0.33,
    --},

    omni = { 	robot = 1, vehicle = 0.65, air = 1.5, ship = 1.25, armorbot = 1.1, armorveh = 2, armorair = 2, armorship = 2.5,
                structure = 0.5, defense = 0.75, commander = 0.75, shield = 1, superunit = 1.5, ore = 0.08, },

    --	omni={ 	    lightbot = 1.01, supportbot = 0.95, heavybot = 1.1, lightveh = 1,       supportveh = 1.5,   heavyveh = 2,
    --				lightair = 2, 	 supportair = 2, 	heavyair = 2,   lightship = 1.25,   supportship = 0.75, heavyship = 2.5,
    --                structure = 1,   resource = 1, 		defense = 0.5, 	defenseaa = 0.5, 	commander = 1.5,    superunit = 1.5,
    --	}
    --,
    --	explosive={ lightbot = 1.2,  supportbot = 1,    heavybot = 0.85,lightveh = 0.55,    supportveh = 0.325, heavyveh = 0.575,
    --				lightair = 0.5,  supportair = 0.5, 	heavyair = 0.5, lightship = 3,      supportship = 1.5,  heavyship = 3,
    --				structure = 1.25,resource = 1.25,	defense = 1.5, 	defenseaa = 0.75,   commander = 0.18,   superunit = 1.5,
    --	}
    --,

    none={ 		robot = 0.1,  vehicle = 0.1, air = 0.1, ship = 0.1, armorbot = 0.1, armorveh = 0.1, armorair = 0.1, armorship = 0.1,
                  structure = 0.1, defense = 0.1, commander = 0.1, shield = 0.1, superunit = 0.1, ore = 0, },
--	none={ 		lightbot = 0.1,  supportbot = 0.1, 	heavybot = 0.1, lightveh = 0.1,     supportveh = 0.1, 	heavyveh = 0.1,
--				lightair = 0.1,  supportair = 0.1, 	heavyair = 0.1, lightship = 0.1,    supportship = 0.1,	heavyship = 0.1,
--                structure = 0.1, resource = 0.1,    defense = 0.1, 	defenseaa = 0.1,    commander = 0.1,   superunit = 0.1,
--	}

	["else"] = {}
,
}

--local system = VFS.Include('gamedata/system.lua')
--
--return system.lowerkeys(damageMultipliers)

return damageMultipliers
