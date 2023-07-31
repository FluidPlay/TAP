function gadget:GetInfo()
  return {
    name      = "Cancel orders on share",
    desc      = "Prevents units carrying on with orders once shared/taken",
    author    = "Bluestone",
    date      = "Jan 2015",
    license   = "SAUSAGE",
    layer     = 0,
    enabled   = false, --true
  }
end


if (not gadgetHandler:IsSyncedCode()) then

  local spGiveOrderToUnit = Spring.GiveOrderToUnit
  local spGetFullBuildQueue = Spring.GetFullBuildQueue
  local spGiveOrderToUnit = Spring.GiveOrderToUnit
 
function gadget:UnitGiven(unitID, unitDefID, unitTeam, oldTeam)
  -- give all shared units a stop command
  spGiveOrderToUnit(unitID, CMD.STOP, {}, {})

  -- remove their build queue
  local buildQ = spGetFullBuildQueue(unitID) or {}
  for _,buildOrder in pairs(buildQ) do
    for uDID,count in pairs(buildOrder) do
        for i = 1, count do
            spGiveOrderToUnit(unitID, -uDID, {}, {"right"})
        end
    end
  end
  
  -- self d commands are removed by prevent_share_self_d
end

end