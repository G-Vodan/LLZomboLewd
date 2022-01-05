-- @author QueuedResonance 2022

local Callbacks = {}
local ClientCommands = require("ZomboLewd/ZomboLewdCommands")

local CommandName = ZomboLewdConfig.CommandName

--- Internal function for listening to server commands
-- @param module string, should be default "ZomboLewd"
-- @param command string should be the name as the command in ZomboLewdCommands
function Callbacks._onServerCommand(module, command, ...)
	if not isClient() or module ~= CommandName then return end

	if ClientCommands[command] then
		ClientCommands[command](...)
	end
end

--- Sends client commands to the server
-- @param command string should be the name of the command located in ZomboLewdServerCommands
function Callbacks:sendClientCommand(command, ...)
	if not isClient() then return end

	sendClientCommand(getPlayer(), CommandName, command, ...)
end

--- Hook up event listeners
Events.OnServerCommand.Add(Callbacks._onServerCommand)

return Callbacks