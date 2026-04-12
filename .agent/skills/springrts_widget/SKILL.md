---
name: springrts widget
description: Widget file structure to be used in SpringRTS/Recoil engine games
---

# Skill: springrts widget

**Description**: Widget file structure to be used in SpringRTS/Recoil engine games

## When to use
When creating or editing lua widget files, commonly within the luaui/widget folder and subfolders.

## General Information
* There are two types of addons for SpringRTS/Recoil: widgets (UI-related, run only locally, called "unsynced") and gadgets (gameplay-related, must be multiplayer-replicated, called "synced").
* The engine API commands which may be called by widgets and gadgets on demand, like `Spring.GetUnitTeam(unitID)`, are called "callouts".
* The system events ("callins") shared by both (common), widget-only (unsynced) and gadget-only ('Synced Only' section), are listed in `springrts-wiki/Lua_Callins.html`. Unsynced callins should be preceded with `widget:`, eg: `widget:DefaultCommand(type, id)`.
* Widget to Gadget and Gadget to Widget communication is described in `springrts-wiki/LuaTutorials__InterCommunications.html`.

## How to
Checking similar pre-existing widgets within the `luaui/widgets` folder is a great option. Online docs might be hard to find and access, there's a dump to the official SpringRTS docs within `/springrts-wiki`. For general scripting, `/springrts-wiki/Lua_Scripting.html` is a good starting point.
`/springrts-wiki/Lua_Tutorial_GettingStarted.html` has some basic examples to be used as a reference as well.

## Best practices
* Cache all `Spring.*` calls at the top, right after `widget:GetInfo()` - the "local variables declaration section". For instance, instead of using `Spring.GetMyTeamID`, add a `local spGetMyTeamID = Spring.GetMyTeamID` at the local variable declaration section and later reference it like, eg: `if teamID ~= spGetMyTeamID()`.
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
* whenever there's a function which already exists in `gamedata/taptools.lua`, eg: `IsValidUnit`, include the file in the widget (using springrts's specific include command - `VFS.Include("gamedata/taptools.lua")` - before the variable declaration section) and use it instead.
* whenever `taptools.lua` is included, make sure to not "re-include" the cached `Spring.*` commands, like `spGetUnitPosition`, in the widget file.
* remember that, in lua, all auxiliary functions have to be defined *before* the point where they're called. Add all auxiliary functions before the main system functions like `function widget:Initialize()`
