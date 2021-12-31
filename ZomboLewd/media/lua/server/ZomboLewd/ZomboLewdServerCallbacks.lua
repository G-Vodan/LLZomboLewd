-- @author QueuedResonance 2022

local Callbacks = {}
local ServerCommands = require("ZomboLewd/ZomboLewdServerCommands")

local CommandName = ZomboLewdConfig.CommandName

--- Internal function for listening to server commands
-- @param module string, should be default "ZomboLewd"
-- @param command string should be the name as the command in ZomboLewdCommands
-- @param IsoPlayer player that sent the command
function Callbacks._onClientCommand(module, command, player, ...)
	if not isServer() or module ~= CommandName then return end

	if ServerCommands[command] then
		ServerCommands[command](player, ...)
	end
end

--- Sends server commands to all the clients
-- @param command string should be the name of the command located in the client's ZomboLewdCommands
function Callbacks:sendServerCommand(command, ...)
	if not isServer() then return end

	sendServerCommand(CommandName, command, ...)
end

--- Hook up event listeners
Events.OnClientCommand.Add(Callbacks._onClientCommand)

return Callbacks