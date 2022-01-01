--- Animation handler for all lewd things
--- future todo task for me in the far future: have support for 3somes, 4somes, possibly more if we want to be extra steamy
-- @author QueuedResonance

require "TimedActions/ISBaseTimedAction"

local AnimationHandler = {}

local ZomboLewdConfig = ZomboLewdConfig
local ISBaseTimedAction = ISBaseTimedAction
local ISTimedActionQueue = ISTimedActionQueue

local ISAnimationAction = ISBaseTimedAction:derive("ISZomboLewdAnimationAction")

--- Plays a solo (usually masturbation) animation on this specific character
-- @param worldObjects is a table of all nearby objects
-- @param IsoPlayer character object
-- @param string of the animation name indicated in ZomboLewdAnimationList
-- @param seconds in how long the act should be
function AnimationHandler.PlaySolo(worldObjects, character, animationName, duration)
	local animationObject = ISAnimationAction:new(character, animationName, duration)
	animationObject.type = "Masturbation"
	ISTimedActionQueue.add(animationObject)
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
	local animObject1 = ISAnimationAction:new(character1, animation1)
	animObject1.type = "Sex"
	animObject1:initialise(duration)
	ISTimedActionQueue.add(animObject1)

	local animObject2 = ISAnimationAction:new(character2, animation2)
	animObject2.type = "Sex"
	animObject2:initialise(duration)
	ISTimedActionQueue.add(animObject2)
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

--- Runs once for the first time. Initializes all the EventMarker modules
local function Init()
	AnimationHandler.EventMarkerModules = {}

	for i = 1, #ZomboLewdConfig.EventMarkers do
		local name = ZomboLewdConfig.EventMarkers[i]
		AnimationHandler.EventMarkerModules[name] = require(string.format("ZomboLewd/AnimationEventMarkers/%s", name))
	end
end

Init()

return AnimationHandler