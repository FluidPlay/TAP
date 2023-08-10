
local AC0 = 0.00625 --was 0.005 or 1/200    -- 1 metal/tick (was 1/70)
local AC1 = 1/250
local AC2 = 1/220 --1/58

-- Up to 'c' energy amount into 'e' ratio (eg.: c=1000, e=1/100, gives 10 metal)
local convertCapacities = {
    [UnitDefNames.armmakr.id]  = { c = (187.5), e = (AC0) }, --c=150 => 187.5 (25% more)
    [UnitDefNames.cormakr.id]  = { c = (187.5), e = (AC0) },
    [UnitDefNames.armmmkr.id]  = { c = (2000), e = (AC2) }, --c=600
    [UnitDefNames.cormmkr.id]  = { c = (2000), e = (AC2) },
    --[UnitDefNames.armuwmmm.id] = { c = (2000), e = (AC2) },
    --[UnitDefNames.coruwmmm.id] = { c = (2000), e = (AC2) },
}

return convertCapacities

