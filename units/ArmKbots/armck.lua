return {
	armck = {
		acceleration = 0.48,
		brakerate = 3,
		buildcostenergy = 1600,
		buildcostmetal = 110,
		builddistance = 130,
		builder = true,
		shownanospray = false,
		buildpic = "ARMCK.DDS",
		buildtime = 3453,
		canmove = true,
		category = "KBOT MOBILE ALL NOTSUB NOWEAPON NOTSHIP NOTAIR SURFACE",
		collisionvolumeoffsets = "0 -1 0",
		collisionvolumescales = "27 27 27",
		collisionvolumetype = "CylY",
		corpse = "DEAD",
		description = "Tech Level 1",
		energymake = 7,
		energystorage = 50,
		energyuse = 7,
		explodeas = "smallexplosiongeneric-builder",
		footprintx = 2,
		footprintz = 2,
        harveststorage = 700,
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 540,
		maxslope = 20,
		maxvelocity = 1.2,
		maxwaterdepth = 25,
		metalmake = 0.07,
		metalstorage = 50,
		movementclass = "KBOT3",
		name = "Construction Kbot",
		objectname = "ARMCK",
		seismicsignature = 0,
		selfdestructas = "smallExplosionGenericSelfd-builder",
		sightdistance = 305,
		terraformspeed = 450,
		turninplace = 1,
		turninplaceanglelimit = 60,
		turninplacespeedlimit = 0.792,
		turnrate = 1100,
		upright = true,
		workertime = 80,
		buildoptions = {
			"armsolar",
			"armadvsol",
			"armwin",
			"armgeo",
			"armmstor",
			"armestor",
			"armmex",
			"armamex",
			"armmakr",
			"armalab",
			"armlab",
			"armvp",
			"armap",
			"armhp",
			"armnanotc",
			"armeyes",
			"armrad",
			"armdrag",
			"armclaw",
			"armllt",
			"armbeamer",
			"armhlt",
			"armguard",
			"armrl",
			--"armpacko",
			"armcir",
			"armdl",
			"armjamt",
			"armjuno",
			"armsy",
		},
		customparams = {
			description_long = "A construction Kbot is able to build basic T1 structures like the ones made by the Commander. Moreover, it can build some more advanced land and air defense towers, advanced solars and most importantly the T2 Kbot lab. It is slightly slower and weaker than vehicle constructor, but it can climb steeper hills, so it is effective in expansion on mountainous terrain. Each Construction Kbot increases the player's energy and metal storage capacity by 50. It is wise to use pairs of cons for expansion, so they can heal each other and build defensive structures faster. This makes them immune to light assault units like Fleas/Jeffies.",
			area_mex_def = "armmex",
		},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "1.68473052979 1.77978515623e-05 -1.12860870361",
				collisionvolumescales = "28.1473846436 25.0852355957 27.3032073975",
				collisionvolumetype = "Box",
				damage = 424,
				description = "Construction Kbot Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 40,
				hitdensity = 100,
				metal = 66,
				object = "ARMCK_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 262,
				description = "Construction Kbot Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 2,
				footprintz = 2,
				height = 4,
				hitdensity = 100,
				metal = 26,
				object = "2X2D",
                collisionvolumescales = "35.0 4.0 6.0",
                collisionvolumetype = "cylY",
				reclaimable = true,
				resurrectable = 0,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sfxtypes = { 
 			pieceExplosionGenerators = { 
				"deathceg3-builder",
				"deathceg2-builder",
			},
		},
		sounds = {
			build = "nanlath1",
			canceldestruct = "cancel2",
			capture = "capture1",
			repair = "repair1",
			underattack = "warning1",
			working = "reclaim1",
			cant = {
				[1] = "cantdo4",
			},
			count = {
				[1] = "count6",
				[2] = "count5",
				[3] = "count4",
				[4] = "count3",
				[5] = "count2",
				[6] = "count1",
			},
			ok = {
				[1] = "kbarmmov",
			},
			select = {
				[1] = "kbarmsel",
			},
		},
	},
}
