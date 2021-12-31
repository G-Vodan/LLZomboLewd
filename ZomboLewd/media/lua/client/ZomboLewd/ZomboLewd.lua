--- Activates the client and their modules
-- @author QueuedResonance 2022

local Client = {
	Commands = require("ZomboLewd/ZomboLewdCommands"),
	Callbacks = require("ZomboLewd/ZomboLewdCallbacks"),
	ContextMenu = require("ZomboLewd/ZomboLewdContextMenu"),
	AnimationHandler = require("ZomboLewd/ZomboLewdAnimationHandler"),
}

--- Injects the Client data to all modules so they too can access the other modules without going through global
for _, module in pairs(Client) do
	module.Client = Client
end

return Client