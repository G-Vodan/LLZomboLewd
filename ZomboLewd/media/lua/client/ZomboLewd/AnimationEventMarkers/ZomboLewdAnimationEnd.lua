return function(action, parameter)
	--- May not fire due to some weird issue with the new animation system. Does not break anything but annoying
	--- if I want to add some end logic.
	action.ended = true
end