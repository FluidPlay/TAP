local armorDefs = {
	robot = { "armack","armck","armfark","armpw","armrectr","armsubk","armconsul","coraca","corack","corak",
			  "corck","cornecro","corspy","corsub","corsktl", "corpyro",
			  "armaak","armsptk","armrock","coraak","corah",
			  "corstorm","cortermite", "cordefiler","armsnipe", },
	armorbot={"armmark", "armzeus", "corsumo","armfboy","armham","armvader","armwar","corcan","corthud",
			  "cormando","armmav","kernfry", "armspid","cormort","corhrk", "armraz", "corkarg",},
	--lightbot={"armack","armck","armfark","armpw","armrectr","armsubk","armconsul","coraca","corack","corak",
	--          "corck","cornecro","corspy","corsub","kernfry", "corsktl", "corpyro",},
	--supportbot={"armaak","armsptk","armrock","coraak","corhrk","corah",
	--		"cormort","corstorm","cortermite", "cordefiler","armsnipe", },
	--heavybot={"armmark", "armzeus", "corsumo","armfboy","armham","armvader","armwar","corcan","corroach","corthud",
	--          "cormando","armmav","armspid",},
	superunit={"corkrog","armbanth", "meteor",}, --"corthovr",

	--++++==== Vehicles
	vehicle = {		"armflash", "armyork", "corsent", "cormuskrat", "cormls", "armacv", "armcv", "armmls", "coracv", "bowscrow",
					   "critter_ant", "critter_duck", "critter_goldfish", "critter_gull", "critter_penguin", "corcv", "corgator",
					   "armlatnk","armfav","armsh","armspy","coresupp","corst",
					   "corlevlr","corsh","decade","marauder","nsaclash","armmart","armsam", "cormist",
					   "armmerl","armshock","cormart","corwolv","shiva","tawf013",
					   "cortrem", "corban","corvrad",},
	armorveh={"armanac","armbull","armcroc","armlun","armscab","armseer","armstump","armthovr",
			  "corgol","cormabm","corraid","correap","corsnap",
			  "armintr","armmanni", "armjam", "corjugg",},
	--lightveh = {
	--	"armflash", "armyork", "corsent", "cormuskrat", "cormls", "armacv", "armcv", "armmls", "coracv", "corfast",
	--	"critter_ant", "critter_duck", "critter_goldfish", "critter_gull", "critter_penguin", "corcv", "corgator",
	--   "armlatnk","armfav","armmlv","armsh","armspy","coresupp","corst",
	--   "corlevlr","corsh","decade","marauder","nsaclash",
	--},
	--supportveh = {"armmart","armsam", "cormist", "armmerl","corcat","armshock","cormart","corvroc",
	--			  "corwolv","corjugg","shiva","tawf013","cortrem", "corban","corvrad",},
	--
	--heavyveh={"armanac","armbull","armcroc","armlun","armpincer","armscab","armseer","armstump","armthovr",
	--         "corgarp","corgol","cormabm","corraid","correap","corsilo","corsnap",
	--         "corsok","armintr","armmanni", "armjam",},

	--++++==== Air

	air = { "armfig","armhawk","corveng","corvamp", "armbrawl", "corape", "armkameyes", "corkameyes"},
	armorair={"corbw","armaca","armawac","armca","armsehak","armsfig","corawac","corca",
			  "corhunt","armkam","armatlas","armdfly","armpeep","armsaber","armseap",
			  "corseah","corfink","corvalk","armblade","armliche","armlance",
			  "armpnix","armsb","armthund","corstil","corhurc","corshad","cortitan","corcrw",},
	--lightair={"corbw","armaca","armawac","armca","armcsa","armfig","armhawk","armsehak","armsfig","corawac","corca","corhunt","corsfig","corvamp","corveng",},
	--supportair={"armkam","armatlas","armbrawl","armdfly","armpeep","armsaber","armseap","corseah","corape","corfink","corseap","corvalk","armblade",},
	--heavyair={"armliche","armlance","armpnix","armsb","armthund","corstil","corhurc","corsb","corshad","cortitan","corcrw",},

	--++++==== Structures & Defenses
	structure = {"armsolar", "corsolar", "armmex", "cormex", "armmoho", "cormoho","armfus","corfus","armafus","corafus",
				 "armuber","coruber","armgeo","armgmm","armageo","armuwmex","armuwmme","armtide","coruwmex","coruwmme","cortide",
				 "armoutpost","armoutpost2","armoutpost3","armoutpost4","coroutpost","coroutpost2","coroutpost3","coroutpost4","armtech","armtech2", "armtech3","armtech4",
				 "cortech","cortech2", "cortech3","cortech4","armawin","corawin","armaap","armadvsol","armalab","armap","armarad","armason", "armamex",
				 "armasp","armasy","armavp","armdf","armestor","armeyes","armfdrag","armfmine3","armfmkr","armfort","armfrad",
				 "armgate","armjamt","armlab","armmakr","armmine1","armmine2","armmine3","armnanotc","armrad","armsd","armshltx",
				 "armveil","armvp","armwin","asubpen","corageo","coraap","coradvsol","coralab","corap","corarad","corason","corasp","corasy","coravp",
				 "cordrag","corestor","coreyes","corfdrag","corfmine3","corfort","corgant","corgantuw","corgeo","corhp",
				 "corjamt","corlab","cormakr","cormine4","cormmkr","cormstor","cornanotc","corrad",
				 "corshroud","corsonar","corsy","cortron","coruwadves","coruwadvms",
				 "corvp","corwin","csubpen","tllmedfusion","armsonar","scavengerdroppodbeacon_scav","armmstor", "armuwadvms",
				 "armsilo", "corsilo",
	},

	defense = {"armvulc","armamb","armamd","armdrag","armemp","armfhlt","armguard","armhlt","armllt","armmlt",
			   "armpb","corbhmth","corbuzz","corexp","corfmd","corgate",
			   "corhlt","corllt","cordlt","corft","corpun","cortoast","corvipe","hllt","armbeamer","armbrtha","corint",
			   "armkamturret", "corbwturret",
			   "kernhq_rt", "kernhq_lt", "kernhq_ct",
	},
	armordefense={"armrl","armatl","armcir","armdeva","armfflak","armfrt","coratl","corerad","corfrt","corrl","armmercury","corscreamer","cordoom","armanni","armptl","corptl","armtl","cortl", "kernhq_mt", },

	--defense={"armvulc","armamb","armamd","armdrag","armemp","armfhlt","armguard","armhlt","armllt","armpb","corbhmth","corbuzz","corexp","corfmd","corgate","corhlt","corllt","corpun","cortoast","corvipe","hllt","armbeamer","armbrtha","corint","armamex",},
	--
	--defenseaa={"armrl","armatl","armcir","armdeva","armfflak","armfrt","coratl","corerad","corfrt","corrl","armmercury","corscreamer","cordoom","armanni","armptl","corptl","armtl","cortl",},
	--
	--resource={ "armsolar", "corsolar", "armmex", "cormex", "armmoho", "cormoho","armfus","corfus","armafus","corafus","armuber","coruber","armgeo","armgmm","armageo",
	--   "armuwmex","armuwmme","armtide","coruwmex","coruwmme","cortide",},
	--
	--structure={"armoutpost","armoutpost2","armoutpost3","armoutpost4","coroutpost","coroutpost2","coroutpost3","coroutpost4","armtech","armtech2", "armtech3","armtech4",
	--	"cortech","cortech2", "cortech3","cortech4","armawin","corawin","armaap","armadvsol","armalab","armap","armarad","armason",
	--	"armasp","armasy","armavp","armdf","armestor","armeyes","armfdrag","armfgate","armfhp","armfmine3","armfmkr","armfort","armfrad",
	--	"armgate","armjamt","armlab","armmakr","armmine1","armmine2","armmine3","armnanotc","armrad","armsd","armshltx",
	--	"armveil","armvp","armwin","asubpen","corageo","coraap","coradvsol","coralab","corap","corarad","corason","corasp","corasy","coravp",
	--	"cordrag","corestor","coreyes","corfatf","corfdrag","corfhp","corfmine3","corfort","corfrad","corgant","corgantuw","corgeo","corhp",
	--	"corjamt","corlab","cormakr","cormine4","cormmkr","cormstor","cornanotc","corrad",
	--	"corshroud","corsonar","corsy","cortarg","cortron","coruwadves","coruwadvms","coruwes","coruwfus","coruwmmm","coruwms",
	--	"corvp","corwin","csubpen","tllmedfusion","armsonar","scavengerdroppodbeacon_scav"},

	--++++==== Ships

	ship = { "corpt", "corcrus", "armpt", "armcrus", "armcs", "armacsub", "armpship", "armrecl", "armmship", "armsjam",
			 "armaas", "corcs", "coracsub", "corpship", "correcl", "cormship", "corsjam", "corbow", },
	armorship = {"armroy", "armtship", "armbats", "armsub", "armcarry", "armepoch",
				 "corshark", "corssub", "corcarry", "corroy", "cortship", "corbats", "corblackhy",} ,

	--lightship = {"corpt", "corcrus", "armpt", "armcrus",},
	--supportship = {"armcs", "armacsub", "armpship", "armrecl", "armmship", "armsjam", "armaas",
	--			   "corcs", "coracsub", "corpship", "correcl", "cormship", "corsjam", "corbow",},
	--heavyship = {"armroy", "armtship", "armbats", "armsub", "armcarry", "armepoch",
	--			 "corshark", "corssub", "corcarry", "corroy", "cortship", "corbats", "corblackhy",} ,

	--++++==== Extras
	commander = {
		"armcom", "armcom1", "armcom2", "armcom3", "armcom4", "armdecom", "corcom", "corcom1", "corcom2", "corcom3", "corcom4","cordecom","armcomboss","corcomboss",
		"bowdaemon", "kerndaemon", "bowadvdaemon", "kernadvdaemon",
	},

	guardian = { "guardsml", "guardmed", "guardlrg", "guarduber", },

	shield = {
		"armflash_shield",
	},

	ore = { "orelrg", "oreuber", "oremoho", "oresml",
	},

	["else"] = {},
}

-- Copy regular unit armor def to its Scavengers counterpart
for categoryName, categoryUnits in pairs(armorDefs) do
    for _, thisUdID in pairs(categoryUnits) do
        if not string.find(thisUdID, '_scav') then
            table.insert(armorDefs[categoryName], thisUdID.."_scav")
            --Spring.Echo("Added Scav Unit: ", thisUdID, " to armorclass: "..categoryName)
        end
    end
end

--[[
-- -- put any unit that doesn't go in any other category in light armor
for name, ud in pairs(DEFS.unitDefs) do
	local found
	for categoryName, categoryTable in pairs(armorDefs) do
		for _, usedName in pairs(categoryTable) do
			if (usedName == name) then
				found = true
			end
		end
	end
	if (not found) then
		table.insert(armorDefs.LIGHT, name)
		--Spring.Echo("Unit: ", ud.unitname, " Armorclass: light armor")
	end
end
--]]

--local system = VFS.Include('gamedata/system.lua')
--
--return system.lowerkeys(armorDefs)

return armorDefs
