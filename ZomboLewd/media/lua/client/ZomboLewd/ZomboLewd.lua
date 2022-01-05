--- Activates the client and their modules
-- @author QueuedResonance 2022

local Client = {
	AnimationUtils = require("ZomboLewd/ZomboLewdAnimationPreload"),
	Commands = require("ZomboLewd/ZomboLewdCommands"),
	Callbacks = require("ZomboLewd/ZomboLewdCallbacks"),
	ContextMenu = require("ZomboLewd/ZomboLewdContextMenu"),
	AnimationHandler = require("ZomboLewd/ZomboLewdAnimationHandler"),
	ZombieHandler = require("ZomboLewd/ZomboLewdZombieHandler"),
}

local function Init()
	--- Injects the Client data to all modules so they too can access the other modules without going through global
	for name, module in pairs(Client) do
		module.Client = Client
	end

	Client.AnimationUtils:refreshAnimations()

	--- Create mod options if the user installed the mod
	--[[
	if ModOptions and ModOptions.getInstance then
		ModOptions:getInstance(ZomboLewdConfig)
		print("CREATED MOD OPTIONS")
	end
	]]
end

Init()

--- Helper function to determine if this is a solo or multiplayer game
function Client:IsMultiplayer()
	if isClient() == false and isServer() == false then
		return false
	end
	return true
end

return Client