-- @author QueuedResonance 2022

local Callbacks = {}

local ServerCommands = {}
local IgnoredCommands = {}

local CommandName = ZomboLewdConfig.CommandName

--- Internal function for listening to server commands
-- @param module string, should be default "ZomboLewd"
-- @param command string should be the name as the command in ZomboLewdCommands
-- @param IsoPlayer player that sent the command
local function onClientCommand(module, command, player, args)
	if not isServer() or module ~= CommandName then return end

	if not ServerCommands[command] and not IgnoredCommands[command] then
		ServerCommands[moduleName] = require(string.format("ZomboLewd/ServerCommands/%s", moduleName))
	end

	if ServerCommands[command] then
		ServerCommands[command](player, args)
	elseif not IgnoredCommands[command] then
		IgnoredCommands[command] = true
	end
end

--- Sends server commands to all the clients
-- @param command string should be the name of the command located in the client's ZomboLewdCommands
function Callbacks:sendServerCommand(command, ...)
	if not isServer() then return end

	sendServerCommand(CommandName, command, {...})
end

--- Hook up event listeners
Events.OnClientCommand.Add(onClientCommand)

return Callbacks