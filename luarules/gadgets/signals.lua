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

Setting up a Signal:end
GG.SetupSignal(unitID, signalkey, func) -- number, str, function

Sending (executing) a Signal:
GG.SendSignal(unitID, signalKey)	-- number, str

Accessing a Signal function directly:
GG.Signal[unitID]

]]

if (not gadgetHandler:IsSyncedCode()) then
	return end

local function isfunc(x)
	return (type(x) == 'function') end

local Signals = {}

local function SetupSignal(unitID, signalKey, func)
	if not isfunc(func) then
		Spring.Log("Signals", LOG.WARNING, "Signal: "..tostring(signalKey or "nil").."'s function is not set properly")
	end
	if not Signals[unitID] then
		Signals[unitID] = {}
	end
	Signals[unitID][signalKey] = func
end

local function SendSignal(unitID, signalKey)	-- str, str
	if Signals[unitID] then
		local signal = Signals[unitID][signalKey]
		if signal and isfunc(signal) then
			signal()	-- Execute the signal if it's set
		end
	end
end

function gadget:Initialize()
	GG.Signals = Signals
	GG.SetupSignal = SetupSignal
	GG.SendSignal = SendSignal
end