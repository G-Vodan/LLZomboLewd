-- @author QueuedResonance

return function(args)
	local message = args[1]
	print(string.format("Client received message from Server: %s", message))
end