function gadget:GetInfo()
    return {
        name      = "Air Units Wanted Max Speed",
        desc      = "Sets the wanted max speed of air units",
        author    = "MaDDoX",
        date      = "July 2022",
        license   = "GPL v3 or later",
        layer     = 221,
        enabled   = true,
    }
end

if gadgetHandler:IsSyncedCode() then
    local airUnits = {
        [UnitDefNames["armfig"].id] = true,
        --UnitDefNames['armsfig'].id,
        --UnitDefNames['armhawk'].id,
        --UnitDefNames['corveng'].id,
        --UnitDefNames['corsfig'].id,
        --UnitDefNames['corvamp'].id
        --UnitDefNames['armthund'].id
    }

    local trackedUnits = {}
    --function gadget:Initialize()
    --	local count = 0
    --	for i, unitDefID in ipairs(fighters) do
    --		if UnitDefs[unitDefID].collide == true then
    --			local unitDimensions = Spring.GetUnitDefDimensions(unitDefID)
    --			collisionFighters[unitDefID] = { unitDimensions['radius'] * radiusMult, unitDimensions['height'] * heightMult }
    --			count = count + 1
    --		end
    --	end
    --	if count == 0 then
    --		gadgetHandler:RemoveGadget(self)
    --	end
    --	for ct, unitID in pairs(Spring.GetAllUnits()) do
    --		gadget:UnitCreated(unitID, Spring.GetUnitDefID(unitID))
    --	end
    --end

    function gadget:UnitCreated(unitID, unitDefID)
        if airUnits[unitDefID] and Spring.ValidUnitID(unitID) then
            trackedUnits[unitID] = true
        end
    end

    function gadget:Update()
        for unitID, v in pairs(trackedUnits) do
            Spring.MoveCtrl.SetAirMoveTypeData (unitID, "maxWantedSpeed", 9)
        end
        --if airUnits[unitDefID] then
        --    Spring.Echo("Adjusting maxWantedSpeed of unit: "..unitID.." to 9")
        --end
    end

end
