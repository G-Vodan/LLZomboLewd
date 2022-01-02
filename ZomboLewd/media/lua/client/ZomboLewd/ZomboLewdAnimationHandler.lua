--- Animation handler for all lewd things
--- future todo task for me in the far future: have support for 3somes, 4somes, possibly more if we want to be extra steamy
-- @author QueuedResonance

require "TimedActions/ISBaseTimedAction"

local AnimationHandler = {EventMarkerModules = {}}

local ZomboLewdConfig = ZomboLewdConfig
local ISBaseTimedAction = ISBaseTimedAction
local ISTimedActionQueue = ISTimedActionQueue

ISAnimationAction = ISBaseTimedAction:derive("ISZomboLewdAnimationAction")

--- Plays a solo (usually masturbation) animation on this specific character
-- @param worldObjects is a table of all nearby objects
-- @param IsoPlayer character object
-- @param string of the animation name indicated in ZomboLewdAnimationList
-- @param seconds in how long the act should be
function AnimationHandler.PlaySolo(worldObjects, character, animationName, duration)
	ISTimedActionQueue.add(ISAnimationAction:new(character, animationName, duration))
end

--- Plays duo animations (usually a sex animation between two individuals) between two characters
-- @param worldObjects is a table of all nearby objects
-- @param IsoPlayer of the first character
-- @param IsoPlayer of the second character
-- @param string of the first animation for which character1 will be playing
-- @param string of the second animation for which character2 will be playing
-- @param seconds in how long the act should be
function AnimationHandler.PlayDuo(worldObjects, character1, character2, animation1, animation2, duration)
	--- TBA, need some animations with two people copulating before I can start this
	--- todo: position both actors at the exact same position then play
	ISTimedActionQueue.add(ISAnimationAction:new(character1, animation1, duration))
	ISTimedActionQueue.add(ISAnimationAction:new(character2, animation2, duration))
end

function ISAnimationAction:isValid()
	--- Make sure to keep the TimedAction running
	return true
end

function ISAnimationAction:update()
	--- Runs every frame
end

function ISAnimationAction:perform()
	ISBaseTimedAction.perform(self)
end

function ISAnimationAction:stop()
	--- What happens if the actor cancels this action?
	ISBaseTimedAction.stop(self)
end

function ISAnimationAction:start()
	--- What happens when the animation starts?
	self.maxTime = self.duration
	self.action:setTime(self.maxTime)
	self:setActionAnim(self.animation)
	self:setOverrideHandModels(nil, nil)
end

--- Determine animation events when played. Useful for sounds, saucy effects, or misc things
-- @param event string value determining the type of animation
-- @param parameter string that is the value given from the xml file
function ISAnimationAction:animEvent(event, parameter)
	if not AnimationHandler.EventMarkerModules[event] then
		--- See if we can lazy load it (Another mod might have added more event markers)
		AnimationHandler.EventMarkerModules[event] = require(string.format("ZomboLewd/AnimationEvents/%s", event))
	end

	if AnimationHandler.EventMarkerModules[event] then
		AnimationHandler.EventMarkerModules[event](self, parameter)
	end
end

--- Creates a new animation object with inheritance from ISBaseTimedAction
-- @param IsoPlayer character object
-- @param string of the animation to be played on this actor
-- @param seconds in how long the act should be
function ISAnimationAction:new(character, animation, duration)
	local object = {
		character = character,
		animation = animation,
		stopOnWalk = false,
		stopOnRun = true,
		ignoreHandsWounds = true,
		maxTime = -1, --- Gets set in start()
		duration = duration or ZomboLewdConfig.DefaultSexDuration,
		ended = false,
	}
	setmetatable(object, self)
	self.__index = self
	return object
end

return AnimationHandler