/**
 * TAP (Total Atomic Power) v3 Utility Functions
 * Header and Footer copied from SDE_data.lua (TAP), \r replaced by null 
 *
 * @param {number} input The value to multiply.
 * @return The input multiplied by 2.
 * @customfunction
 */

// Name of the 'selection' namedRange
var selectionId = "selection"

var driveID = {
  //v0_dt: "0BzORCUkLCDRBejRNeGxNeXJfMzg",
  //v0_sb2: "1mUfjBVs-V_xSQDt2fH6oxBOSfPdwLtOi",
  //v1_dt: "1FHmiuj2JGH-_OYB0PsnjjgyesAgUJghp",
  //v1_sb2: "14YkBEGCsYigodNa6uQw6YglBElx1GBkw",
  v2_dt: "1-0abFq66b4PeVU2giusY33vDJJWAkLRU", /** "1xHEAV8YOe6nIc0eG-Puzde2t1CkRApye",  */
  v2_sb2: "1m0WDPHujhiTbcylKuK8OrOdNdtiuOpCP",
  v4_dt: "1ESVj5Za07yesjvC8ducAC8Ed5zo_OyrC",
  v4_sb2: "17T18VhSDFXo1T7oUMB2os7LYP1zhCXCW",
}

var gdriveID = driveID.v2_dt //sb2 ~ dt

/** How to add a new field: add it to fieldsToExport (or customParamsToExport) below, then
 add it to the return string in function getHeader(). If value in sheet is default, eg. 0,
 it won't be included in the exported .lua, meaning it'll use the engine's default value
 Finally, add item to isStringParam(val) if it's a string and should be surrounded by quotes
*/

// Valid header cells, values in those columns will be exported
var fieldsToExport = [
'UnitDefID', 'name', 'side', 'acceleration', 'activatewhenbuilt', 'airsightdistance', 'airhoverfactor', 'airstrafe', 'autoheal', 
'bankingallowed', 'blocking', 'brakerate', 'buildcostmetal', 'buildcostenergy', 'builddistance', 
'builder', 'buildinggrounddecaldecayspeed', 'buildinggrounddecalsizex', 'buildinggrounddecalsizey', 
'buildinggrounddecaltype', 'buildoptions', 'buildpic', 'buildtime', 'canassist', 'canattack', 'canbeassisted', 'cancapture', 
'cancloak', 'candropflare', 'canmanualfire', 'canfight', 'canfly', 'canguard', 'canloopbackattack', 'canmove', 'canpatrol', 'canreclaim', 'canrepair', 'canrepeat',
'canrestore', 'canresurrect', 'canselfdestruct', 'cansubmerge', 'cantbetransported', 'capturable', 'capturespeed', 'category',
'cloakcost', 'cloakcostmoving', 'collide', 'collisionvolumeoffsets', 'collisionvolumescales', 
'collisionvolumetype', 'commander', 'corpse', 'crashdrag', 'cruisealt', 'crushresistance', 'customparams', 'damagemodifier',
'decloakspherical', 'decoyfor', 'defaultmissiontype', 'description', 'energymake', 'energystorage', 'energyuse', 
'explodeas', 'extractsmetal', 'flankingbonusmode', 'flankingbonusdir', 'flankingbonusmin', 'flankingbonusmax',
'flarereload', 'flaredelay', 'flareefficiency', 'flaredropvector', 'flaretime', 'flaresalvosize', 'flaresalvodelay',
'featuredefs', 'firestate', 'floater', 'footprintx', 'footprintz', 'hidedamage',
'hightrajectory', 'hoverattack', 'icontype', 'idleautoheal', 'idletime', 'initcloaked', 'isairbase', 'isfeature',
'isfireplatform', 'istargetingupgrade', 'kamikaze', 'kamikazedistance', 'leavetracks', 'levelground', 'loadingradius', 'losemitheight',
'mass', 'maxacc', 'maxelevator', 'maxrudder', 'maxaileron' ,'maxbank', 'maxdamage', 'maxpitch', 'maxrepairspeed', 'maxslope', 'maxvelocity', 
'maxreversevelocity', 'maxwaterdepth', 'metalmake', 
'metalstorage', 'mincloakdistance', 'minwaterdepth', 'movementclass', 'moverate1', 'movestate', 'mygravity', 
'noautofire', 'nochasecategory', 'norestrict', 'objectname', 'onoffable', 'power', 'pushresistant', 'radardistance', 
'radardistancejam', 'radaremitheight', 'radius', 'reclaimable', 'reclaimspeed', 'releaseheld', 'repairable', 'repairspeed', 'script', 
'seismicdistance', 'seismicsignature', 'selectionvolume', 'selfdestructas', 'selfdestructcountdown', 'shownanospray', 'showplayername', 
'sightdistance', 'sonardistance', 'sonarstealth', 'sounds', 'stealth', 'steeringmode', 'stoptoattack', 'fronttospeed',
'speedtofront', 'terraformspeed', 'tidalgenerator', 'trackoffset', 'trackstrength', 'trackstretch', 'tracktype', 'trackwidth', 
'transportbyenemy', 'transportcapacity', 'transportmass', 'transportsize', 'transportunloadmethod', 'turninplace', 
'turninplaceanglelimit', 'turninplacespeedlimit', 'turnradius', 'turnrate', 'unitname', 'unloadspread', 'upright', 'unitrestricted',
'usebuildinggrounddecal', 'usepiececollisionvolumes', 'usesmoothmesh', 'verticalspeed', 'cruisealt', 'waterline', 
'weapondefs', 'weapons', 'windgenerator', 'workertime', 'yardmap',
] // 'sfxtypes',
var customParamsToExport = [
'tier', 'tedclass', 'func', 'specialty', 'providetech', 'requiretech', 'morphdef', 'iscommander', 'isorechunk', 'ishq',
'groupdef', 'paralyzemultiplier', 'canareaattack', 'minrange', 'maxrange', 'maxammo','maxorestorage','cantuseairpads','rearmtime','rearmweapons', 'movingsprayangle',
'normaltex', 'modelradius', 'icontag', 'hastreads', 'minunloaddistance', 'vertdisp'
]

//Lookup table for header cells (key) and their A1 notation
//eg.: 'buildcostmetal': 'N1',
var HeadersLUT = {}

var SDE = SpreadsheetApp.getActiveSpreadsheet()                           // Spreadsheet
var Sheet = SDE.getSheetByName('UnitDefs')                                // Target tab (sheet)
var Headers //= Sheet.getDataRange().getValues().shift()                  // First Row (now manually init'd in function below)

//## Initializes the headers table
//Eg.: [['buildcostmetal', ]]
function initializeHeadersTable() {

  var data = Sheet.getDataRange().getValues()
  if (data.length <= 1)
    return
  Headers = data[0]

  HeadersLUT = {} // Clear LUT
  Headers.forEach(function(header) {
    // buildcostmetal -> N1
    const columnIndex = columnToLetter(getColByName(header), 1) // BC1, D1
    HeadersLUT[header] = columnIndex
  })
  //Logger.log(JSON.stringify(HeadersLUT))
}

//## Initializes global variables and the headers table
function updateReferences() {
  SDE = SpreadsheetApp.getActiveSpreadsheet()
  Sheet = SDE.getSheetByName('UnitDefs')
  Headers = Sheet.getDataRange().getValues().shift()
  initializeHeadersTable()
}

/*-=-=-=-=-=-= Spreadsheet Events -=-=-=-=-=-=-*/

//## Initialization steps when the spreadsheet is opened
function onOpen() {
  SDE = SpreadsheetApp.getActiveSpreadsheet()                           // Spreadsheet
  Sheet = SDE.getSheetByName('UnitDefs')                                // Target tab (sheet)
  var ui = SpreadsheetApp.getUi()
  ui.createMenu('Spring Data Edit')
      .addItem('Export Data', 'exportData')
      .addItem('Export IconTypes', 'exportIconTypes')
      .addItem('Show Sidebar', 'showSidebar')
      .addSeparator()
      .addSubMenu(ui.createMenu('Visibility')
          .addItem('Hide All', 'hideAll')
          .addItem('Show All', 'showAll')
          .addItem('Show basic data', 'showBasicData')
          .addItem('Show weapon data', 'showWeaponData')
          //.addItem('Hide sea units', 'hideSeaUnits')
          )
      .addToUi() 
   //Initialization
   //updateReferences()
}

//## Updates the 'selection' namedRange when one or more cells are edited or, say, set to bold then undone
function onEdit(e) {
  var range = e.range
  //range.setNote('Updated: ' + new Date())
  //ssheet.removeNamedRange("selection");
  
  SpreadsheetApp.getActiveSpreadsheet().setNamedRange("selection", SpreadsheetApp.getActiveRange())
  //SpreadsheetApp.getUi().alert( "New Selection Range: "+SpreadsheetApp.getActiveRange().getA1Notation())
}


/*-=-=-=-=-=-= Menu Functions -=-=-=-=-=-=-*/

function showSidebar() {
  var html = HtmlService.createHtmlOutputFromFile('SDEsidebar')
      .setTitle('SDE Tools')
      .setWidth(300)
  
  SpreadsheetApp.getUi() // Or DocumentApp or FormApp.
      .showSidebar(html)
}

// ## Formats a string replacing backspace characters with line breaks
function getTableFromSheet() {
  //var tableStr = getSelectedRange().getValues()[0]
  var tableStr = SpreadsheetApp.getActiveSpreadsheet().getActiveRange().getValues()[0]  //2026 Fix
  tableStr = (tableStr+"").replace(/\x08/g, '\n');    //08 = `Backspace` char  
  return tableStr;
}

// ## Updates the first value in the 'selection' named range to what's in editTableField (html)
function putTableToSheet(val) {
  var selRange = SpreadsheetApp.getActiveSpreadsheet().getActiveRange() //getSelectedRange()
  var tableStr = (val+"").replace(/\n/g, '\b');
  
  var rangeValues = selRange.getValues()
  var values = createCellArray(rangeValues.length, 1)
  values[0] = [tableStr]
  selRange.setValues(values)
}

// ## Multiply the cells within the 'selection' named range by a certain value
function multiplyValues(val) {
  var range = getSelectedRange()
  var text = ""
   
  var numRows = range.getNumRows()
  var numCols = range.getNumColumns()
  for (var i = 1; i <= numRows; i++) {
    for (var j = 1; j <= numCols; j++) {
      var oldValue = parseInt(range.getCell(i,j).getValue())
      var newValue = "" + Math.round(oldValue * val)
      text += newValue + ", "            // Returns list of new values to console
      var cell = range.getCell(i,j)
      cell.setValue(newValue)
      //-- Add comment & style to cell
      var currNote = cell.getNote()
      cell.setNote((!currNote ? "" : currNote+"; ")+ oldValue)
      cell.setFontWeight("bold");
    }
  }   
  return text
}


/*-=-=-=-=-=-= Helper Functions -=-=-=-=-=-=-*/

// # Gets the named range 'selection', which may be updated by setting a cell to bold and undoing the action
// PS.: getActiveRange doesn't work when fired from a sidebar, so we'll do the second best thing
function getSelectedRange() {
  return SDE.getRangeByName(selectionId)
}
  
function getSelectedRangeA1() {
  return getSelectedRange().getA1Notation()
}

// # Creates an empty multi-cell array from a given number of rows and cols
// PS.: Outer array = rows; Inner array = cell values within each row
function createCellArray(rows, cols) {
  var result = []
  var emptyRow = []
  for (var j = 0; j < cols; j++) {
    emptyRow[j] = 0
  }
  for (var i = 0; i < rows; i++) {
    result[i] = [emptyRow];
  }
  return result
}

// # Transforms a column index into a letter (ex.: 1 -> A)
function columnToLetter(column, row) {
  var temp, letter = '';
  while (column > 0) {
    temp = (column - 1) % 26;
    letter = String.fromCharCode(temp + 65) + letter;
    column = (column - temp - 1) / 26;
  }
  return letter + row;
}


//############################### LUA EXPORT ####################

// Exports the icontypes data to icontypes.lua
function exportIconTypes() {  
  var fileName = "icontypes.lua"
  var myFolder = DriveApp.getFolderById(gdriveID);
  
  // Prevent generating dups - icontypes(1).lua, etc
  var files = myFolder.getFilesByName(fileName);
  while (files.hasNext()) {
    var nextFile = files.next()
    myFolder.removeFile(nextFile)
  }
  
  var sde = SpreadsheetApp.getActiveSpreadsheet();
  
  var iconTypesRange = sde.getRangeByName('icontype');
  var iconTypesData = iconTypesRange ? iconTypesRange.getValues() : [];
  
  var baseSizesRange = sde.getRangeByName('iconbasesizes');
  var baseSizesData = baseSizesRange ? baseSizesRange.getValues() : [];
  var baseSizesMap = {};
  for (var i = 0; i < baseSizesData.length; i++) {
    var key = String(baseSizesData[i][0]).trim();
    if (key) {
      baseSizesMap[key] = parseFloat(baseSizesData[i][1]);
    }
  }
  
  var tierMultRange = sde.getRangeByName('icontiersizemults');
  var tierMultData = tierMultRange ? tierMultRange.getValues() : [];
  var tierMultMap = {};
  for (var i = 0; i < tierMultData.length; i++) {
    var key = String(tierMultData[i][0]).trim();
    if (key !== "") {
      tierMultMap[key] = parseFloat(tierMultData[i][1]);
    }
  }

  var uniqueIconsMap = {};
  
  for (var i = 0; i < iconTypesData.length; i++) {
    var rawValue = iconTypesData[i][0];
    if (rawValue === undefined || rawValue === null) continue;
    
    var icontypeRaw = String(rawValue).trim();
    if (icontypeRaw === "" || icontypeRaw.toLowerCase() === "icontype") continue;
    
    var tierMatch = icontypeRaw.match(/\d$/);
    var tierStr = "0";
    var baseIcon = icontypeRaw;
    var fullIconId = icontypeRaw + "0";
    
    if (tierMatch) {
      tierStr = tierMatch[0];
      baseIcon = icontypeRaw.slice(0, -1);
      fullIconId = icontypeRaw;
    }
    
    if (baseIcon === "" || baseIcon === "0" || baseIcon === "false") continue;
    
    if (!uniqueIconsMap[fullIconId]) {
      var baseSize = baseSizesMap[baseIcon];
      if (isNaN(baseSize) || baseSize === undefined) baseSize = 1.0;
      
      var tierMult = tierMultMap[tierStr];
      if (isNaN(tierMult) || tierMult === undefined) tierMult = 1.0;
      
      var calcSize = baseSize * tierMult;
      
      uniqueIconsMap[fullIconId] = {
        baseIcon: baseIcon,
        calcSize: calcSize
      };
    }
  }
  
  var txt = "return {\n";
  for (var fullIconId in uniqueIconsMap) {
    txt += "\t" + fullIconId + " = {\n";
    txt += "\t\tbitmap='LuaUI/icons/" + uniqueIconsMap[fullIconId].baseIcon + ".png',\n";
    txt += "\t\tsize=" + uniqueIconsMap[fullIconId].calcSize + ",\n";
    txt += "\t},\n";
  }
  txt += "}\n";
  
  myFolder.createFile(fileName, txt);
}

// Glues up the 'header', 'data' and 'footer' sections of the lua file then exports it to Google Drive
function exportData() {  
  var fileName = "unitdefs_data.lua"
  var myFolder = DriveApp.getFolderById(gdriveID);
  //var myFolder = DriveApp.getRootFolder()
  
  // Prevent generating dups - unitdefs_data(1).lua, etc
  files = myFolder.getFilesByName(fileName);
  while (files.hasNext()) {
    var nextFile = files.next()
    var idToDLET = nextFile.getId()
    myFolder.removeFile(nextFile)
  }
    
  var data = getHeader()+getData()+getFooter()
  // Create a file in the root of my Drive with the given name and the data
  //DriveApp.createFile(fileName, data);
  myFolder.createFile(fileName, data)
}

// Returns only the string of the unitdefs_data.lua (to be placed in TAPrime.sdd gamedata folder)
function getExportData(){
  return getHeader()+getData()+getFooter()
}

function getHeader() {
//	customfields = { groupsize = 0, },\n
  return '--\n-- Created by IntelliJ IDEA.\n-- User: MaDDoX\n-- Date: 24/05/17\n-- Time: 18:55\n-- All SDE Overrides used in TAP go here (processed @alldefs_post)\n--\n\nlocal SDEData = {\n	-- These are all the fields present in unit .lua definitions, with default types/values ("", {}, false or 0)\n	fields = {\n		acceleration=0,\n		activatewhenbuilt=false,\n		activatewhenbuilt=false,\n		airsightdistance=0,\n		airstrafe=false,\n		autoheal=0,\n		bankingallowed=false, \n		bankscale=0,\n		blocking=false,\n		brakerate=0,\n		buildcostenergy=0,\n		buildcostmetal=0,\n		builddistance=0,\n		builder=false,\n		buildinggrounddecaldecayspeed=0,\n		buildinggrounddecalsizex=0,\n		buildinggrounddecalsizey=0,\n		buildinggrounddecaltype="",\n		buildoptions={},\n		buildpic="",\n		buildtime=0,\n		canassist=false,\n		canattack=false,\n		cancapture=false,\n		candgun=false,\n		candropflare=false,\n		canfight=true,\n		canfly=false,\n		canguard=false,\n		canmanualfire=false,\n		canmove=false,\n		canpatrol=false,\n		canreclaim=false,\n		canrepair=false,\n		canrepeat=false,\n		canrestore=false,\n		canresurrect=false,\n		canselfdestruct=false,\n		cansubmerge=false,\n		cantbetransported=false,\n		capturable=false,\n		capturespeed=0,\n		category="",\n		cloakcost=0,\n		cloakcostmoving=0,\n		collide=false,\n		collisionvolumeoffsets="",\n		collisionvolumescales="",\n		collisionvolumetype="",\n		commander=false,\n		corpse="",\n		crashdrag=0,\n		cruisealt=0,\n		crushresistance=0,\n		customparams={},\n		damagemodifier=0,\n		decoyfor="",\n		defaultmissiontype="",\n		description="",\n		energymake=0,\n		energystorage=0,\n		energyuse=0,\n		explodeas="",\n		extractsmetal=0,\n		flankingbonusmode=0,\n		flankingbonusdir="",\n		flankingbonusmin=0,\n		flankingbonusmax=0,\n		featuredefs={},\n		firestate=0,\n		firestate=0,\n		floater=false,\n		footprintx=0,\n		footprintz=0,\n		harvestmetalstorage=0,\n		hidedamage=0,\n		hightrajectory=0,\n		hoverattack=false,\n		icontype="",\n		idleautoheal=0,\n		idletime=0,\n		initcloaked=false,\n		isairbase=false,\n		istargetingupgrade=false,\n		kamikaze=false,\n		kamikazedistance=0,\n		leavetracks=false,\n		levelground=false,\n		loadingradius=0,\n		losemitheight=0,\n		maneuverleashlength="",\n		mass=0,\n		maxbank=0,\n		maxelevator=0,\n		maxrudder=0,\n		maxaileron=0,\n		maxdamage=0,\n		maxpitch=0,\n		maxslope=0,\n		maxvelocity=0,\n		maxreversevelocity=0,\n		maxwaterdepth=0,\n		metalmake=0,\n		metalstorage=0,\n		mincloakdistance=0,\n		minwaterdepth=0,\n		movementclass="",\n		moverate1="",\n		movestate=0,\n		mygravity=0,\n		name="",\n		noautofire=0,\n		nochasecategory="",\n		norestrict=0,\n		objectname="",\n		onoffable=false,\n		power=0,\n		pushresistant=false,\n		radardistance=0,\n		radardistancejam=0,\n		radaremitheight=0,\n		radius=0,\n		reclaimable=true,\n		releaseheld=false,\n		repairable=false,\n		repairspeed=0,\n		script="",\n		seismicdistance=0,\n		seismicsignature=0,\n		selectionvolume={},\n		selfdestructas="",\n		selfdestructcountdown=0,\n		sfxtypes={},\n		showplayername=false,\n		side="",\n		sightdistance=0,\n		sonardistance=0,\n		sonarstealth=false,\n		sounds={},\n		speedtofront=0, \n		fronttospeed=0,\n		stealth=false,\n		steeringmode="",\n		stoptoattack=false,\n		tedclass="",\n		terraformspeed=0,\n		tidalgenerator=0,\n		trackoffset=0,\n		trackstrength=0,\n		trackstretch=0,\n		tracktype="",\n		trackwidth=0,\n		transportbyenemy=false,\n		transportcapacity=0,\n		transportmass=0,\n		transportsize=0,\n		transportunloadmethod=0,\n		turninplace=0,\n		turninplaceanglelimit=0,\n		turninplacespeedlimit=0,\n		turnradius=0,\n		turnrate=0,\n		unitrestricted=0,\n		unitname="",\n		unloadspread=0,\n		upright=false,\n		usebuildinggrounddecal=false,\n		usebuildinggrounddecal=false,\n		usepiececollisionvolumes=0,\n		usesmoothmesh=0,\n		verticalspeed=0,\n		cruisealt=0,\n		waterline=0,\n		weapondefs={},\n		weapons={},\n		windgenerator=0,\n		workertime=0,\n		yardmap="",\n	}\n	,\n';
}

// That's the big 'Units' table section of the SDE.lua file
function getData() {
    var txt = undefined;

    var dataRange = Sheet.getDataRange();
    var data = dataRange.getValues()
    
    // Loop through the cells data and build a string with the data
    // Eg.: [1]={"armfatf",{capturable=false,maxwaterdepth=0,...}}
    if (data.length <= 1)
      return txt;
    
    var txt = '\tdata =\n	{';
    var idx = 0;
    var maxCols = data[0].length;
    
    // Let's skip first row (header), only referencing it for cell type validation
    for (var row = 2; row < data.length; row++) {
      idx++
      txt += '\t\t['+idx+']={"'+data[row][0]+'",{'
      var cparms = []
      // Column one data was already assigned above, so we start at 1 again
      for (var col = 1; col < maxCols; col++) {
        var label = data[1][col]; //Skip top header
        if (label == undefined)
          continue;
        if (label == "customparams") {
          continue;
          //TODO: Store original custom params. Currently they're ignored
        }
        var value = data[row][col];         
        if ((value+"").trim() != "") {
          // Add custom fields to the customProperty list (will be added to txt in the end)
          if (customParamsToExport.indexOf(label) != -1) {
  //        if (row == 1)
  //          Logger.log("row:"+row+" col:"+col+" "+label +'='+ formatValue(label,value) +', ')
            cparms.push( label +'='+ formatValue(label,value) +', ' )
            continue;
          }
          // If label is in valid 'regular' fields list, add it
          if (fieldsToExport.indexOf(label) != -1) {
            txt += label +'='+ formatValue(label,value) +','
          }
        }
      }
      // Add cparms to the customparams field at the end
      if (cparms.length >= 1){
        var cparmsstr = "customparams={"            //customParams does *NOT* work. Don't try it.
        for (var i = 0; i < cparms.length; i++) {
          cparmsstr += cparms[i];
        }
        txt += cparmsstr + "}, "
      }
      txt += '}},\n';
    }
    txt += '\t}';
    return txt                          //.replace(/[\b\t]+/g, '');   // [\x08\t]+/g
}

// ### Footer to be written to the unitdefs.lua
function getFooter() {
  return '	,\n}\n\nreturn SDEData';
}

// ### Formats a given value, adding quotes if needed and replacing backspace and tab
function formatValue(label,val) {
  val = (val+"").replace(/[\b\t]+/g, '')
  if (isStringParam(label))
    return '"' +val+ '"';
  else
    return val;
}

// Checks if a certain property is a string type in Spring
function isStringParam(val) {
  return (val in {
             "buildinggrounddecaltype":"", 
             "buildpic":"", 
             "category":"",
             "collisionvolumeoffsets":"", 
             "collisionvolumescales":"", 
             "collisionvolumetype":"",
             "corpse":"", 
             "decoyfor":"", 
             "defaultmissiontype":"",
             "description":"", 
             "explodeas":"", 
             "flankingbonusdir":"", 
             "icontype":"",
             "maneuverleashlength":"", 
             "movementclass":"", 
             "moverate1":"",
             "name":"", 
             "nochasecategory":"",
             "objectname":"", 
             "script":"",
             "selfdestructas":"",
             "side":"",
             "steeringmode":"", 
             "tedclass":"", 
             "tracktype":"",
             "unitname":"", 
             "yardmap":"",
             
             // String params go below (will be surrounded by quotes)
             "providetech":"",
             "requiretech":"",
             "tedclass":"",
             "func":"",
             "specialty":"",             
             "normaltex":"",
             //"morphdef":"",
          }
         )
}

/*-=-=-=-=-=-= Cell Functions -=-=-=-=-=-=-*/

//function SELECTED_RANGE(input) {
//  return SpreadsheetApp.getActive().getActiveRange().getA1Notation();
//}
  
// Rounds an integer value to the tens, hundreds or thousands
//(number + 50) / 100 * 100;
function CUSTOMROUND(input) {
  var value = parseInt(input);
  // 1 must be 1
  if (value < 6)
    return value;
  if (value < 100)
    return Math.round(value / 10) * 10;
  if (value < 1000)
    return Math.round(value / 50) * 50;
        // 780 => 800 ; 325 => 350 ; 234 => 250
  if (value < 10000)      
    return Math.round(value / 100) * 100;
          // 98200 => 98000; 98720 => 98500  
  if (value < 100000)
    return Math.round(value / 500) * 500;
            // Maximum rounding precision is to the thousands
            // 137240 => 137000
  return Math.round(value / 1000) * 1000;   
}

/*-=-=-=-=-=-= Visibility Functions -=-=-=-=-=-=-*/

function getColByName(name){
  var colindex = Headers.indexOf(name)
  return colindex+1
}


function hideAll() {
  Sheet.hideColumn(SDE.getRangeByName("allFields"));
}

// Show (unhide) columns according to a list of header names
function showColumns(val) {
  //Logger.log('In!')
  initializeHeadersTable()
  var desiredHeaders = val.split(',')

  hideAll()
  for(var i = 0; i < desiredHeaders.length; i++)
  {
    var thisHeader = desiredHeaders[i].trim()

    var colToShow = HeadersLUT[thisHeader]
    Logger.log(thisHeader+' :: '+colToShow)
    Sheet.unhideColumn(SDE.getRange(colToShow))
  }
}

function showAll() {
  var range = Sheet.getRange("1:1");
  Sheet.unhideColumn(range);
}

function showBasicData() {
  //sheet.hideColumns(10,2);  // J-F, two columns starting from 10th
  
  //sheet.hideColumn(sheet.getRange("B1:FF"));            //everything
  Sheet.hideColumn(SDE.getRangeByName("allFields"));
 
  Sheet.unhideColumn(SDE.getRangeByName("name"));
  Sheet.unhideColumn(SDE.getRangeByName("buildcostmetal"));
  Sheet.unhideColumn(SDE.getRangeByName("buildcostenergy"));
  Sheet.unhideColumn(SDE.getRangeByName("maxDamage"));
  Sheet.unhideColumn(SDE.getRangeByName("sightDistance"));
  Sheet.unhideColumn(SDE.getRangeByName("maxVelocity")); 
  Sheet.unhideColumn(SDE.getRangeByName("category"));
  Sheet.unhideColumn(SDE.getRangeByName("side"));  
 
  Sheet.unhideColumn(SDE.getRangeByName("tedclass"));  // 'Type'
  Sheet.unhideColumn(SDE.getRangeByName("armortype"));
  Sheet.unhideColumn(SDE.getRangeByName("damagetype"));  
  
//  sheet.unhideColumn(sheet.getRange("CH1"));            //maxDamage
//  sheet.unhideColumn(sheet.getRange("DQ1"));             //sightDistance
//  sheet.unhideColumn(sheet.getRange("CK1"));             //maxVelocity
//  sheet.unhideColumn(sheet.getRange("AP1"));             //category
//  sheet.unhideColumn(sheet.getRange("DP1"));             //side
}

function showWeaponData() {
  Sheet.unhideColumn(SDE.getRangeByName("weapons"));
  Sheet.unhideColumn(SDE.getRangeByName("weapondefs"));  
}

function WORDS(input) {
  var input = input.toString();
  var inputSplit = input.split(" ");
  Logger.log(inputSplit);
  inputSplit = inputSplit.toString();

  var punctuationless = inputSplit.replace(/[.,\/#!$%\?^&\*;:{}=\-_`~()]/g," ");
  var finalString = punctuationless.replace(/\s{2,}/g," ");
  finalString = finalString.toLowerCase();
  return finalString.split(" ") ;
}

function REMOVEUNUSEDCATS(input) {
  var input = input.toString();
  input = input.replace(/ NOTHOVER/g,'');
  input = input.replace(/ ANTIFLAME/g,'');
  input = input.replace(/ ANTIEMG/g,'');  
  input = input.replace(/ ANTILASER/g,'');  
  input = input.replace(/ PHIB/g,'');
  input = input.replace(/COMMANDERS/g,'');
  input = input.replace(/ STATIC/g,'');  
  input = input.replace(/UNDERWATER/g,'SUB');
  return input
}

//name,buildcostmetal,buildcostenergy,maxdamage,weapondefs,weapons

//Newunit:
//name,c_costmetal,buildcostmetal,buildcostenergy,maxdamage,featuredefs,energystorage,buildpic,description,objectname,sightdistance,windgenerator