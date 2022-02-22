-- @author QueuedResonance 2022

local Callbacks = {}

local ClientCommands = {}
local IgnoredCommands = {}

local CommandName = ZomboLewdConfig.CommandName

--- Internal function for listening to server commands
-- @param module string, should be default "ZomboLewd"
-- @param command string should be the name as the command in ZomboLewdCommands
local function onServerCommand(module, command, args)
	if not isClient() or module ~= CommandName then return end

	if not ClientCommands[command] and not IgnoredCommands[command] then
		ClientCommands[moduleName] = require(string.format("ZomboLewd/ClientCommands/%s", moduleName))
	end

	if ClientCommands[command] then
		ClientCommands[command](args)
	elseif not IgnoredCommands[command] then
		IgnoredCommands[command] = true
	end
end

--- Sends client commands to the server
-- @param command string should be the name of the command located in ZomboLewdServerCommands
function Callbacks:sendClientCommand(command, ...)
	if not isClient() then return end

	sendClientCommand(getPlayer(), CommandName, command, {...})
end

--- Hook up event listeners
Events.OnServerCommand.Add(onServerCommand)

return Callbacks