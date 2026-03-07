--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    unitdefs.lua
--  brief:   unitdef parser
--  author:  Dave Rodgers
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local unitDefs = {}

local shared = {} -- shared amongst the lua unitdef enviroments

local preProcFile  = 'gamedata/unitdefs_pre.lua'
local postProcFile = 'gamedata/unitdefs_post.lua'

--local FBI = FBIparser or VFS.Include('gamedata/parse_fbi.lua')
--local TDF = TDFparser or VFS.Include('gamedata/parse_tdf.lua')
local DownloadBuilds = VFS.Include('gamedata/download_builds.lua')

local system = VFS.Include('gamedata/system.lua')
VFS.Include('gamedata/VFSUtils.lua')
local section = 'unitdefs.lua'

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Run a pre-processing script if one exists
--

if (VFS.FileExists(preProcFile)) then
  Shared   = shared    -- make it global
  UnitDefs = unitDefs  -- make it global
  VFS.Include(preProcFile)
  UnitDefs = nil
  Shared   = nil
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Load UnitDefs Data
--
local unitDefsData = VFS.Include("gamedata/configs/unitdefs_data.lua")

local minimumbuilddistancerange = 155

local function ApplyGroupCosts(name, uDef)
  if not uDef.customParams then
    return  end
  local groupSize = tonumber(uDef.customParams.groupdef__size)
  if not groupSize then
    return end

  local groupSize = groupSize or 1
  Spring.Echo(uDef.name .." Group Size: "..groupSize)
  if (uDef.buildcostmetal ~= nil) then
    uDef.buildcostmetal = uDef.buildcostmetal * groupSize
  end
  if (uDef.buildcostenergy ~= nil) then
    uDef.buildcostenergy = uDef.buildcostenergy * groupSize end
  if (uDef.buildtime ~= nil) then
    uDef.buildtime = uDef.buildtime * groupSize end
  --Spring.Echo(uDef.name.." group size = "..groupSize..", total m: "..uDef.buildcostmetal..", total e: "..uDef.buildcostenergy..", total buildtime: "..uDef.buildtime)
end

-- Here's where the actual spreadsheet-exported data (UnitDefs_Data) is applied to the UnitDefs used in game
local function ApplyUnitDefs_Data(name, uDef)
  if (unitDefsData == nil) then
    return end
  for idx, uData in pairs(unitDefsData.data) do
    if type(uData) == "table" then
      if uData[1] == name then
        Spring.Echo("Processed unit: "..name)
        local newData = uData[2]
        for k, v in pairs (newData) do
          local oldDefVal = uDef[k]
          local newDefVal = v
          -- custom processing of weapondefs
          if oldDefVal and k == "weapondefs" then
            -- weapondefs={[[new or v]]vtol_emg2={craterboost=0,
            -- If we find matching weapondefs in source lua, we keep the orig cegtag and explosiongenerator
            for weapID, weapData in pairs (newDefVal) do
              local oldWeaponDef = oldDefVal[weapID]
              local oldcegtag, oldexpgen
              if oldWeaponDef then
                oldcegtag = oldWeaponDef.cegtag
                oldexpgen = oldWeaponDef.explosiongenerator
              else
                -- We couldn't know which old weapon corresponds to the new one, so we just grab whatever
                for ok, ov in pairs(oldDefVal) do
                  if ov.cegtag then
                    oldcegtag = ov.cegtag end
                  if ov.explosiongenerator then
                    oldexpgen = ov.explosiongenerator end
                end
                --Spring.Echo("Warning: couldn't find newWeap "..tostring(weapID)..
                --		" in "..name.."'s current data.")
                if oldcegtag or oldexpgen then
                  Spring.Echo("Warning: 'Guessed' explosiongenerator and/or cegtag for unit "..name..", as: "
                          ..(oldexpgen or "nil").." and ceg: ".. (oldcegtag or "nil")) end
              end
              if oldcegtag then
                newDefVal[weapID].cegtag = oldcegtag end
              if oldexpgen then
                newDefVal[weapID].explosiongenerator = oldexpgen end
            end
          end
          --customParams table items will become customParams.item__subitem (only string,string supported)
          if k == "customparams" then
            newDefVal = {}
            for cparmkey, cparmvalue in pairs (v) do
              if type(cparmvalue) == "table" then
                --Spring.Echo("Parsed unit: "..name.." table key: "..cparmkey or "nil")
                --newDefVal[cparmkey] = nil                       -- We won't keep the original table
                for cparmsubk, cparmsubv in pairs(cparmvalue) do       -- eg.: { groupDef = { size = 1, .. } }
                  local newKeyName = cparmkey.."__"..cparmsubk
                  newDefVal[newKeyName] = cparmsubv -- => [groupDef__size] = 1
                  --Spring.Echo("New cParm for "..name..": "..(tostring(newKeyName) or "nil").." = "..(tostring(cparmsubv) or "nil"))
                end
              else
                newDefVal[cparmkey] = cparmvalue                -- Not a table, just assign it
              end
            end
          end
          uDef[k] = newDefVal
          --if newDefVal then
          --    UnitDefs[name][k] = newDefVal end
          --if k == "customParams" then
          --    Spring.Echo("Unit: "..name.." Prop: "..k.." was: "..tostringplus(oldDefVal).." now: "..tostringplus(v))
          --end
        end
        --Spring.Echo("\t\t----\n\t\t----")
      end
    end
  end
end

-- process unitdefs
local function UnitDef_Post(name, uDef)
  ApplyUnitDefs_Data(name, uDef)
  ApplyGroupCosts(name, uDef)
  --Set a minimum for builddistance
  if uDef.builddistance ~= nil and uDef.builddistance < minimumbuilddistancerange then
    uDef.builddistance = minimumbuilddistancerange
  end
  if uDef.canfly then
    uDef.crashdrag = 0.012
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Load the raw LUA format unitdef files
--


--//local luaFiles = RecursiveFileSearch('units/', '*.lua')
local luaFiles = VFS.DirList('units/', '*.lua', nil, true)

for _, filename in ipairs(luaFiles) do
  local udEnv = {}
  udEnv._G = udEnv
  udEnv.Shared = shared
  udEnv.GetFilename = function() return filename end
  setmetatable(udEnv, { __index = system })
  local success, uds = pcall(VFS.Include, filename, udEnv, vfs_modes)
  if (not success) then
    Spring.Log(section, LOG.ERROR, 'Error parsing ' .. filename .. ': ' .. tostring(uds))
  elseif (type(uds) ~= 'table') then
    Spring.Log(section, LOG.ERROR, 'Bad return table from: ' .. filename)
  else
    for udName, ud in pairs(uds) do
      if ((type(udName) == 'string') and (type(ud) == 'table')) then
        --Spring.Log(section, LOG.WARNING, 'Procesing: ' .. udName)
        UnitDef_Post(udName,ud) --MaDD
        unitDefs[udName] = ud
      else
        Spring.Log(section, LOG.ERROR, 'Bad return table entry from: ' .. filename)
      end
    end
  end  
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Insert the download build entries
--

--DownloadBuilds.Execute(unitDefs)


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Run a post-processing script if one exists
--

--if (VFS.FileExists(postProcFile)) then
--  Shared   = shared    -- make it global
--  UnitDefs = unitDefs  -- make it global
--  VFS.Include(postProcFile)
--  UnitDefs = nil
--  Shared   = nil
--end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Basic checks to kill unitDefs that will crash ".give all"
--

for name, def in pairs(unitDefs) do
  local cob = 'scripts/'   .. name .. '.cob'

  local obj = def.objectName or def.objectname
  if (obj == nil) then
    unitDefs[name] = nil
    Spring.Log(section, LOG.ERROR, 'removed ' .. name ..
                ' unitDef, missing objectname param')
    for k,v in pairs(def) do print('',k,v) end
  else
    local objfile = 'objects3d/' .. obj
    if ((not VFS.FileExists(objfile))           and
        (not VFS.FileExists(objfile .. '.3do')) and
        (not VFS.FileExists(objfile .. '.s3o'))) then
      unitDefs[name] = nil
      Spring.Log(section, LOG.ERROR, 'removed ' .. name
                  .. ' unitDef, missing model file  (' .. obj .. ')')
    end
  end
end


for name, def in pairs(unitDefs) do
  local badOptions = {}
  local buildOptions = def.buildOptions or def.buildoptions
  if (buildOptions) then
    for i, option in ipairs(buildOptions) do
      if (unitDefs[option] == nil) then
        table.insert(badOptions, i)
        Spring.Log(section, LOG.ERROR, 'removed the "' .. option ..'" entry'
                    .. ' from the "' .. name .. '" build menu')
      end
    end
    if (#badOptions > 0) then
      local removed = 0
      for _, badIndex in ipairs(badOptions) do
        table.remove(buildOptions, badIndex - removed)
        removed = removed + 1
      end
    end
  end
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

return unitDefs

--------------------------------------------------------------------------------
-------------------------------------------------------------------------------- 
