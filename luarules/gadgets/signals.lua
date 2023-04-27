function gadget:GetInfo()
	return {
		name      = "Signals - Inter-gadget messaging system",
		desc      = "Allows to execute functions set in one gadget, from another gadget",
		author    = "MaDDoX",
		date      = "March 2023",
		license   = "Whatever is free-er",
		layer     = -999,	-- Make sure that all gadget handlers use a higher layer #
		enabled   = true,
	}
end

--[[ USAGE EXAMPLE:

* Setting up (or adding up) a Signal with a given signalkey
GG.SetupSignal(unitID, signalkey, func) -- number, str, function

* Sending (executing) a Signal:
GG.SendSignal(unitID, signalKey)	-- number, str

* Accessing a Signal function table directly:
GG.Signal[unitID]

]]

if (not gadgetHandler:IsSyncedCode()) then
	return end

local function isfunc(x)
	return (type(x) == 'function') end

local function istable(x)
	return (type(x) == 'table') end

local Signals = {}

local function SetupSignal(unitID, signalKey, func)
	if not isfunc(func) then
		--Spring.Log("Signals", LOG.WARNING, "Signal: "..tostring(signalKey or "nil").."'s function is not set properly")
	end
	if not Signals[unitID] then
		Signals[unitID] = {}
	end
	if not Signals[unitID][signalKey] then
		Signals[unitID][signalKey] = {}
	end
	table.insert(Signals[unitID][signalKey],func)
	--local functionTable = Signals[unitID][signalKey]
	--functionTable[#functionTable+1] = func
end

local function SendSignal(unitID, signalKey)	-- str, str
	--Spring.Echo("Signal received: "..(signalKey or "nil"))
	if Signals[unitID] then
		local functionTable = Signals[unitID][signalKey]
		if istable(functionTable) then
			--Spring.Echo("Signal-assigned func count: "..#functionTable)
			for _, signal in ipairs(functionTable) do
				if isfunc(signal) then
					-- Execute the signal if it's set
					signal()
				end
			end
		end
	end
end

function gadget:Initialize()
	GG.Signals = Signals
	GG.SetupSignal = SetupSignal
	GG.SendSignal = SendSignal
end