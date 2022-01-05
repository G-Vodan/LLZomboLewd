--- Activates the server and their modules
-- @author QueuedResonance 2022

local Server = {
	Commands = require("ZomboLewd/ZomboLewdServerCommands"),
	Callbacks = require("ZomboLewd/ZomboLewdServerCallbacks"),
}

--- Injects the server into all the modules so they too can access server-sided modules without going through global
for _, module in pairs(Server) do
	module.Server = Server
end

return Server