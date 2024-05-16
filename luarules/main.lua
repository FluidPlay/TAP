if (select == nil) then
  select = function(n,...) 
    local arg = arg
    if (not arg) then arg = {...}; arg.n = #arg end
    return arg[((n=='#') and 'n')or n]
  end
end

Spring.Echo("Synced LuaRules: starting loading")
VFS.Include(Script.GetName() .. '/gadgets.lua', nil, VFS.ZIP_ONLY)
Spring.Echo("Synced LuaRules: finished loading")