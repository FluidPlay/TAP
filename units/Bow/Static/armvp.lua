return {
	armvp = {
		acceleration = 0,
		brakerate = 0,
		buildangle = 1024,
		buildcostenergy = 1800,
		buildcostmetal = 750,
		builder = true,
		shownanospray = true,
		buildinggrounddecaldecayspeed = 30,
		buildinggrounddecalsizex = 9,
		buildinggrounddecalsizey = 9,
		buildinggrounddecaltype = "armvp_aoplane.dds",
		buildpic = "ARMVP.DDS",
		buildtime = 7192,
		canmove = true,
		category = "ALL NOTLAND NOTSUB NOWEAPON NOTSHIP NOTAIR SURFACE",
		collisionvolumescales = "120 34 92",
		collisionvolumetype = "Box",
		corpse = "DEAD",
		description = "Produces Level 1 Vehicles",
		energystorage = 100,
		explodeas = "largeBuildingexplosiongeneric",
		footprintx = 7,
		footprintz = 6,
		icontype = "building",
		idleautoheal = 5,
		idletime = 1800,
		levelground = false,
		maxdamage = 2700,
		maxslope = 15,
		maxwaterdepth = 0,
		metalstorage = 100,
		name = "Vehicle Plant",
		objectname = "Units/Bow/ARMVP.s3o",
		radardistance = 50,
		seismicsignature = 0,
		selfdestructas = "largeBuildingExplosionGenericSelfd",
		sightdistance = 273,
		terraformspeed = 500,
		usebuildinggrounddecal = true,
		workertime = 100,
		yardmap = "ooooooo oocccoo oocccoo oocccoo oocccoo yocccoy",
		buildoptions = {
			[1] = "armcv",
		},
		customparams = {
			bar_footprintx = 6,
			bar_footprintz = 7,
			bar_yardmap = "oooooooooooooooooooooooooccccooccccoocccco",
		},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "-5 0 0",
				collisionvolumescales = "110 34 92",
				collisionvolumetype = "Box",
				damage = 1668,
				description = "Vehicle Plant Wreckage",
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 6,
				footprintz = 6,
				height = 40,
				hitdensity = 100,
				metal = 483,
				object = "ARMVP_DEAD",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 834,
				description = "Vehicle Plant Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 6,
				footprintz = 6,
				height = 4,
				hitdensity = 100,
				metal = 193,
				object = "6X6A",
				reclaimable = true,
				resurrectable = 0,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sfxtypes = { 
 			pieceExplosionGenerators = { 
				"deathceg2",
				"deathceg3",
				"deathceg4",
			},
		},
		sounds = {
			canceldestruct = "cancel2",
			underattack = "warning1",
			unitcomplete = "untdone",
			count = {
				[1] = "count6",
				[2] = "count5",
				[3] = "count4",
				[4] = "count3",
				[5] = "count2",
				[6] = "count1",
			},
			select = {
				[1] = "pvehactv",
			},
		},
	},
}
