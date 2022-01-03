return function(action, parameter)
	--- May not fire due to some weird issue with the speedscale on the new animation system.
	--- Set speed scale to minimum 1.05 if your animation doesn't fire this event.
	print("Animation Ended") --- This should appear in the output
	action.ended = true
---	action:forceComplete()
end