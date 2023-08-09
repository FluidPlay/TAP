--
-- Created by IntelliJ IDEA.
-- User: MaDDoX
-- Date: 14/05/17
-- Time: 04:16
--
-- Here we store which units (values) are assigned to each base damage type (keys)
-- This was used as starting values for the weapondamagetypes.lua table, which's actually used in alldefs_post to calculate damage/armor
--
local damageTypes = {

	cannon={"armcrus","armfflak","armblade","armmav","armroy","corcrus","corraid","corroy","corst","armanac","armcroc","armlun","corparrow","corsnap","armbull","armstump","corgol","correap",},

	bullet={"armkam","armsaber","corfink","corveng","armpw","armpt","corpt","armflash","armemp","armspid",},

	rocket={"armfig","armpship","corpship","armlance","armmerl","armsb","corcrw","cortitan","armseap","corape","corvipe","armtl","corptl","cortl","armpb","corerad","corcat","armrock","coraak","armaak","corstorm","armbanth","corbuzz","armmship","cormship","armptl","armaas","corbow","armsptk","corfrt","packo","armsub","corssub","tawf009","corah","armfrt",},

	laser={"armfast","armwar","armsubk","corshark","corak","corgator",},

	hflaser={"armllt","corllt","armhlt","corhlt","corexp","corhllt","armfhlt",},

	flak={"armdeva","armyork","corsent","corshred","corhrk","cordefiler",},

	neutron={"armmanni","corcan",},

	rail={"armsnipe","corsktl",},

	emp={"corstil","corbw","armemp","armspid",},

	homing={"armrl","corrl","corsumo","armfav","armcir","armsam","coratl","cormist","armatl","armmercury","corscreamer","armsfig","corvamp","marauder","coresupp","armdecade","corsh","nsaclash",},

	plasma={"armbeamer","armanni","corbhmth","cortoast","cordoom","corthud","armham","armraz","corkarg","armamb","armepoch","corbats","armbats","corblackhy","corlevlr","cortrem",},

	explosive={"armfboy","armthund","armpnix","corhurc","corshad","armguard","corpun","corban","armmark",},

	thermo={"armzeus","cormando","corpyro","armbrawl","armlatnk","armhawk","cortermite",},

	siege={"cormort","shiva","corkrog","armbrtha","corint","tawf013","armmart","cormart","corwolv","tawf11",},

	omni={"armshock","corjugg","armamd","corfmd","armcarry","corcarry","armscab","cormabm","armsd","armcom","armcom1","armcom2","armcom3","armdecom","corcom","corcom1","corcom2","corcom3","cordecom","meteor","armjamt","armveil","corjamt","corshroud","armsy","armaap","armalab","armap","armasy","armavp","armlab","armshltx","armshltxuw","armvp","coraap","coralab","corap","corasy","coravp","corgant","corgantuw","corlab","corsy","corvp","csubpen","armspy","armfark","armvulc","armfmine3","armmine1","armmine2","armmine3","cormine4","armvader","corroach","corthovr","armthovr","armintr","armtship","cortship","corgate","armfgate","armgate",
    "meteor", "armck","corck","armack","corack", "armca", "corca", "armaca", "coraca",},

	nuke={"cortron","armliche","corsilo","armsilo",},

	none={"armpeep","armatlas","armdfly","corseah","corvalk","armsehak","corawac","armawac","cormuskrat","cormls","armack","armacsub","armacv","armcv","armmls","coracsub","coracv","corfast","armconsul","coraca","corack","corck","armch","armck","armcs","corcs","armaca","armca","critter_ant","critter_duck","critter_goldfish","critter_gull","critter_penguin","cormakr","armrectr","cornecro","armnanotc","cornanotc","tllmedfusion","armmex","armmmkr","armuwes","armuwfus","armuwmex","armuwmme","armuwmmm","armuwms","armafus","armageo","armadvsol","armamex","armdf","armfmkr","armfus","armgeo","armgmm","armmakr","armsolar","armtide","armwin","corafus","corageo","coradvsol","corfus","corgeo","cormex","cormmkr","cormoho","corsolar","cortide","coruwfus","coruwmex","coruwmme","coruwmmm","corwin","coreyes","corsjam","armsjam","armason","armsonar","corason","corsonar","armmoho","armmstor","armestor","armuwadves","armuwadvms","corestor","cormstor","coruwadves","coruwadvms","coruwes","coruwms","armarad","armfrad","armrad","corarad","corrad","armasp","armeyes","armtarg","corasp","armrecl","correcl","armjam","corcv","armseer","corvrad","armdrag","armfdrag","armfort","cordrag","corfdrag","corfort",},

	["else"] = {},
}

--local system = VFS.Include('gamedata/system.lua')
--
--return system.lowerkeys(damageTypes)

return damageTypes

