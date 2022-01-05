--- Whenever you add a new server command, remember to add it into the command list table below
-- @author QueuedResonance 2022
local COMMAND_LIST = {"ExampleCommand"}

--- Caching behaviour
local Commands = {}

--- Cache all command modules
for _, moduleName in ipairs(COMMAND_LIST) do
	Commands[moduleName] = require(string.format("ZomboLewd/Commands/%s", moduleName))
end

return Commands