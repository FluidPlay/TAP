local armorDefs = {
	robot = { "armack","armch","armck","armfark","armpw","armrectr","armsubk","armconsul","coraca","corack","corak",
			"coramph","corch","corck","cornecro","corspy","corsub","corvoyr","armfast", "corsktl", "corpyro",
			"armaak","armaser","armah","armjeth","armsptk","armmh","armrock","coraak","corhrk","corah","corcrash",
			"cormort","corstorm","cortermite", "cordefiler","armsnipe", "armmark", "armzeus", "corsumo","armfboy",
			"armham","armvader","armwar","corcan","corroach","corthud","cormando","armmav","armspid",},
    --lightbot={"armack","armch","armck","armfark","armpw","armrectr","armsubk","armconsul","coraca","corack","corak",
    --          "coramph","corch","corck","cornecro","corspy","corsub","corvoyr","armfast", "corsktl", "corpyro",},
    --supportbot={"armaak","armaser","armah","armjeth","armsptk","armmh","armrock","coraak","corhrk","corah","corcrash",
		--		"cormort","corstorm","cortermite", "cordefiler","armsnipe", },
    --heavybot={"armmark", "armzeus", "corsumo","armfboy","armham","armvader","armwar","corcan","corroach","corthud",
    --          "cormando","armmav","armspid",},
    superunit={"corkrog","armbanth", "armorco","armraz","corkarg","corthovr","krogtaar","meteor",},

	--++++==== Vehicles
	vehicle = {		"armflash", "armyork", "corsent", "cormuskrat", "cormls", "armacv", "armcv", "armmls", "coracv", "corfast",
					   "critter_ant", "critter_duck", "critter_goldfish", "critter_gull", "critter_penguin", "corcv", "corgator",
					   "armlatnk","armfav","armjanus","armmlv","armsh","armspy","coresupp","corfav","corst",
					   "corlevlr","corsh","decade","marauder","nsaclash","armfido","armmart","armsam", "cormist",
					   "armmerl","corcat","armshock","cormart","cormh","corvroc","corwolv","corjugg","shiva","tawf013",
					   "cortrem", "corban","corvrad","armanac","armbull","armcroc","armlun","armpincer","armscab","armseer","armstump","armthovr","cordl",
					   "coreter","corgarp","corgol","cormabm","cormlv","corparrow","corraid","correap","corseal","corsilo","corsnap",
					   "corsok","armintr","armmanni", "armjam",},
	--lightveh = {
	--	"armflash", "armyork", "corsent", "cormuskrat", "cormls", "armacv", "armcv", "armmls", "coracv", "corfast",
	--	"critter_ant", "critter_duck", "critter_goldfish", "critter_gull", "critter_penguin", "corcv", "corgator",
     --   "armlatnk","armfav","armjanus","armmlv","armsh","armspy","coresupp","corfav","corst",
     --   "corlevlr","corsh","decade","marauder","nsaclash",
	--},
	--supportveh = {"armfido","armmart","armsam", "cormist", "armmerl","corcat","armshock","cormart","cormh","corvroc",
	--			  "corwolv","corjugg","shiva","tawf013","cortrem", "corban","corvrad",},
    --
	--heavyveh={"armanac","armbull","armcroc","armlun","armpincer","armscab","armseer","armstump","armthovr","cordl",
     --         "coreter","corgarp","corgol","cormabm","cormlv","corparrow","corraid","correap","corseal","corsilo","corsnap",
     --         "corsok","armintr","armmanni", "armjam",},

    --++++==== Air
	air = { "corbw","armaca","armawac","armca","armcsa","armfig","armhawk","armsehak","armsfig","corawac","corca","corcsa",
			"corhunt","corsfig","corvamp","corveng","armkam","armatlas","armbrawl","armdfly","armpeep","armsaber","armseap",
			"corseah","corape","corcut","corfink","corseap","corvalk","armblade","armliche","armlance","armpnix","armsb",
			"armthund","corstil","corhurc","corsb","corshad","cortitan","corcrw",},
	--lightair={"corbw","armaca","armawac","armca","armcsa","armfig","armhawk","armsehak","armsfig","corawac","corca","corcsa","corhunt","corsfig","corvamp","corveng",},
	--supportair={"armkam","armatlas","armbrawl","armdfly","armpeep","armsaber","armseap","corseah","corape","corcut","corfink","corseap","corvalk","armblade",},
	--heavyair={"armliche","armlance","armpnix","armsb","armthund","corstil","corhurc","corsb","corshad","cortitan","corcrw",},

    --++++==== Structures & Defenses
	structure = {"armsolar", "corsolar", "armmex", "cormex", "armmoho", "cormoho","armfus","corfus","armafus","corafus",
				 "armuber","coruber","armgeo","armgmm","armageo","armuwmex","armuwmme","armtide","coruwmex","coruwmme","cortide",
				 "armoutpost","armoutpost2","armoutpost3","armoutpost4","coroutpost","coroutpost2","coroutpost3","coroutpost4","armtech","armtech2", "armtech3","armtech4",
				 "cortech","cortech2", "cortech3","cortech4","armawin","corawin","armjuno","armaap","armadvsol","armalab","armap","armarad","armason",
				 "armasp","armasy","armavp","armbeaver","armckfus","armdf","armestor","armeyes","armfatf","armfdrag","armfgate","armfhp","armfmine3","armfmkr","armfort","armfrad",
				 "armgate","armhp","armjamt","armlab","armmakr","armmine1","armmine2","armmine3","armnanotc","armrad","armsd","armshltx",
				 "armveil","armvp","armwin","asubpen","corjuno","corageo","coraap","coradvsol","coralab","corap","corarad","corason","corasp","corasy","coravp",
				 "cordrag","corestor","coreyes","corfatf","corfdrag","corfhp","corfmine3","corfmkr","corfort","corfrad","corgant","corgantuw","corgeo","corhp",
				 "corjamt","corlab","cormakr","cormexp","cormine1","cormine2","cormine3","cormine4","cormmkr","cormstor","cornanotc","corrad","corsd",
				 "corshroud","corsonar","corsy","cortarg","cortron","coruwadves","coruwadvms","coruwes","coruwfus","coruwmmm","coruwms",
				 "corvp","corwin","csubpen","tllmedfusion","armsonar","scavengerdroppodbeacon_scav","armmstor", "cormstor", "armuwadvms", "coruwadvms",
	},

    defense = {"armvulc","armamb","armamd","armclaw","armdl","armdrag","armemp","armfhlt","armguard","armhlt","armllt",
               "armpb","corbhmth","corbuzz","corexp","corfgate","corfhlt","cormaw","corfmd","corgate",
               "corhlt","corllt","corhllt","corpun","cortoast","corvipe","hllt","armbeamer","armbrtha","corint","armamex",
               "armrl","armatl","armcir","armdeva","armfflak","armflak","armfrt","coratl","corenaa","corerad","corflak",
               "corfrt","corrl","madsam","armmercury","corscreamer","cordoom","armanni","armptl","corptl","armtl","cortl",
    },

    ore = { "orelrg", "oreuber", "oremoho", "oresml", },

    --defense={"armvulc","armamb","armamd","armclaw","armdl","armdrag","armemp","armfhlt","armguard","armhlt","armllt","armpb","corbhmth","corbuzz","corexp","corfgate","corfhlt","cormaw","corfmd","corgate","corhlt","corllt","corhllt","corpun","cortoast","corvipe","hllt","armbeamer","armbrtha","corint","armamex",},
	--
	--defenseaa={"armrl","armatl","armcir","armdeva","armfflak","armflak","armfrt","coratl","corenaa","corerad","corflak","corfrt","corrl","madsam","armmercury","corscreamer","cordoom","armanni","armptl","corptl","armtl","cortl",},
    --
	--resource={ "armsolar", "corsolar", "armmex", "cormex", "armmoho", "cormoho","armfus","corfus","armafus","corafus","armuber","coruber","armgeo","armgmm","armageo",
     --   "armuwmex","armuwmme","armtide","coruwmex","coruwmme","cortide",},
    --
	--structure={"armoutpost","armoutpost2","armoutpost3","armoutpost4","coroutpost","coroutpost2","coroutpost3","coroutpost4","armtech","armtech2", "armtech3","armtech4",
	--	"cortech","cortech2", "cortech3","cortech4","armawin","corawin","armjuno","armaap","armadvsol","armalab","armap","armarad","armason",
	--	"armasp","armasy","armavp","armbeaver","armckfus","armdf","armestor","armeyes","armfatf","armfdrag","armfgate","armfhp","armfmine3","armfmkr","armfort","armfrad",
	--	"armgate","armhp","armjamt","armlab","armmakr","armmine1","armmine2","armmine3","armnanotc","armrad","armsd","armshltx",
	--	"armveil","armvp","armwin","asubpen","corjuno","corageo","coraap","coradvsol","coralab","corap","corarad","corason","corasp","corasy","coravp",
	--	"cordrag","corestor","coreyes","corfatf","corfdrag","corfhp","corfmine3","corfmkr","corfort","corfrad","corgant","corgantuw","corgeo","corhp",
	--	"corjamt","corlab","cormakr","cormexp","cormine1","cormine2","cormine3","cormine4","cormmkr","cormstor","cornanotc","corrad","corsd",
	--	"corshroud","corsonar","corsy","cortarg","cortron","coruwadves","coruwadvms","coruwes","coruwfus","coruwmmm","coruwms",
	--	"corvp","corwin","csubpen","tllmedfusion","armsonar","scavengerdroppodbeacon_scav"},

    --++++==== Ships

	ship = { "corpt", "corcrus", "armpt", "armcrus", "armcs", "armacsub", "armpship", "armrecl", "armmship", "armsjam",
			 "armaas", "corcs", "coracsub", "corpship", "correcl", "cormship", "corsjam", "corbow", "armroy", "armtship",
			 "armbats", "armsub", "armcarry", "armepoch", "corshark", "corssub", "corcarry", "corroy", "cortship",
			 "corbats", "corblackhy",},

	--lightship = {"corpt", "corcrus", "armpt", "armcrus",},
	--supportship = {"armcs", "armacsub", "armpship", "armrecl", "armmship", "armsjam", "armaas",
	--			   "corcs", "coracsub", "corpship", "correcl", "cormship", "corsjam", "corbow",},
	--heavyship = {"armroy", "armtship", "armbats", "armsub", "armcarry", "armepoch",
	--			 "corshark", "corssub", "corcarry", "corroy", "cortship", "corbats", "corblackhy",} ,

    --++++==== Extras
	commander = {
		"armcom", "armcom1", "armcom2", "armcom3", "armcom4", "armdecom", "corcom", "corcom1", "corcom2", "corcom3", "corcom4","cordecom","armcomboss","corcomboss",
	},

    shield = {
        "armflash_shield",
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
