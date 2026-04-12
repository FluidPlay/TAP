---
name: springrts gadget
description: Gadget file structure to be used in SpringRTS/Recoil engine games
---

# Skill: springrts gadget

**Description**: Gadget file structure to be used in SpringRTS/Recoil engine games

## When to use
When creating or editing lua gadget files, commonly within the `Luarules/gadgets` folder.

## General Information
* There are two types of addons for SpringRTS/Recoil: widgets (UI-related, run only locally, called "unsynced") and gadgets (gameplay-related, must be multiplayer-replicated, called "synced").
* The engine API commands which may be called by widgets and gadgets on demand, like `Spring.GetUnitTeam(unitID)`, are called "callouts".
* The system events ("callins") shared by both (common), widget-only (unsynced) and gadget-only ('Synced Only' section), are listed in `springrts-wiki/Lua_Callins.html`. Synced callins should be preceded with `gadget:`, eg: `gadget:AllowCommand(unitID, ...)`.
* Widget to Gadget and Gadget to Widget communication is described in `springrts-wiki/LuaTutorials__InterCommunications.html`.

## How to
* Gadgets must be stored within `Luarules/gadgets`. There are many good examples of gadgets to be found there.
* Gadgets may have a synced *and* unsynced part, commonly to allow communication of variable passing between synced and unsynced contexts. When that happens, unsynced variables *must* be declared in the unsynced section, as the synced variables are not 'seen' by default. Common callins, like `gadget:Initialize()`, have to be declared again in the unsynced section, when required. There's an example in `LuaRules/Gadgets/eco_builder_harvest.lua`.

### Minimal gadget example:
```lua
function gadget:GetInfo()
    return {
        name      = "Example Gadget",
        desc      = "Does something cool",
        author    = "MaDDoX",
        date      = "2026",
        license   = "GNU GPL, v2 or later",
        layer     = 0,
        enabled   = true  -- loaded by default?
    }
end

-- The following lines are only necessary if the gadget has functionality
if gadgetHandler:IsSyncedCode() then
---------
-- Callins
---------
local gadgetName = "Example Gadget Loaded - Synced"

function gadget:Initialize()
    Spring.Echo(gadgetName)
end

function gadget:GameFrame(n)
    -- Code here runs every frame (30 times per second)
end

function gadget:Shutdown()
    -- Cleanup code
end

else -- Unsynced code running on the gadget starts here
---------
-- Callins
---------
local gadgetName = "Example Gadget Loaded - Unsynced"

function gadget:Initialize()
    Spring.Echo(gadgetName)
end

end
```

## Best practices
* If there's no 'unsynced' part in the gadget, better just have, after `gadget:GetInfo()`:
  ```lua
  if not gadgetHandler:IsSyncedCode() then
      return false  -- No unsynced code here
  end
  ```
* Cache all `Spring.*` calls at the top, right after `gadget:GetInfo()` - the "local variables declaration section". For instance, instead of using `Spring.GetMyTeamID`, add a `local spGetMyTeamID = Spring.GetMyTeamID` at the local variable declaration section and later reference it like, eg: `if teamID ~= spGetMyTeamID()`.
* `return` commands should *always* be in a single line, for legibility. So instead of: 
  ```lua
  if teamID ~= Spring.GetMyTeamID() then return end
  ```
  make it:
  ```lua
  if teamID ~= Spring.GetMyTeamID() then 
      return end
  ```
* don't use 'magic numbers' in the code, always create local references at the local variables declaration section. For instance, `local PI = 3.1416`
* whenever there's a function which already exists in `gamedata/taptools.lua`, eg: `IsValidUnit`, include the file in the gadget (using springrts's specific include command - `VFS.Include("gamedata/taptools.lua")` - before the variable declaration section) and use it instead.
* whenever `taptools.lua` is included, make sure to not "re-include" the cached `Spring.*` commands, like `spGetUnitPosition`, in the gadget file.
* remember that, in lua, all auxiliary functions have to be defined *before* the point where they're called. Add all auxiliary functions before the main system functions like `function gadget:Initialize()`
