local Client = require("ZomboLewd/ZomboLewd")

--- Sends a message to server after some ticks. Only works in multiplayer
function Client.Ticks(tick)
	if not tick then return end

	if tick >= 10000 then
		print("Client sending a command...")
		Client.Callbacks:sendClientCommand("ExampleCommand", "Hi There! Example message!!")
		Events.OnTick.Remove(Client.Ticks)
	end
end

Events.OnTick.Add(Client.Ticks)
