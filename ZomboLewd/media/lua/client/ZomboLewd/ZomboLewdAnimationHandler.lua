--- Animation handler for all lewd things
--- future todo task for me in the far future: have support for 3somes, 4somes, possibly more if we want to be extra steamy
-- @author QueuedResonance

require "TimedActions/ISBaseTimedAction"

local AnimationHandler = {EventMarkerModules = {}}

local ZomboLewdConfig = ZomboLewdConfig
local ZomboLewdAnimationData = ZomboLewdAnimationData
local ISBaseTimedAction = ISBaseTimedAction
local ISTimedActionQueue = ISTimedActionQueue
local IsoDirections = IsoDirections

ISAnimationAction = ISBaseTimedAction:derive("ISZomboLewdAnimationAction")

--- Plays a solo (usually masturbation) animation on this specific character
-- @param worldObjects is a table of all nearby objects
-- @param IsoPlayer character object
-- @param animationdata
-- @param seconds in how long the act should be
function AnimationHandler.PlaySolo(worldObjects, character, animationData)
	local isFemale = character:isFemale()
	local data = animationData.Data
	local duration = data.TimedDuration
	local animation = isFemale and data.Animations.Female or data.Animations.Male

	ISTimedActionQueue.add(ISAnimationAction:new(character, animation, duration))
end

--- Plays duo animations (usually a sex animation between two individuals) between two characters
-- @param worldObjects is a table of all nearby objects
-- @param IsoPlayer of the first character
-- @param IsoPlayer of the second character
-- @param animationdata for which the actors will be playing
-- @param seconds in how long the act should be
function AnimationHandler.PlayDuo(worldObjects, character1, character2, animationData)
	if not character1 or not character2 then return end
	if not character2:getSquare() or not luautils.walkAdj(character1, character2:getSquare(), true) then
		return
	end

	--- Get the position of the original character, then get the facing position of the second character
	local x, y, z = character2:getX(), character2:getY(), character2:getZ()
	local facing = character2:getDir()

	--- Sets the Action to save the position and facing directions
	local isFemale1 = character1:isFemale()
	local isFemale2 = character2:isFemale()

	local animation1 = isFemale1 and animationData.Data.Animations.Female or animationData.Data.Animations.Male
	local animation2 = isFemale2 and animationData.Data.Animations.Female or animationData.Data.Animations.Male

	local action1 = ISAnimationAction:new(character1, animation1, animationData.Data.TimedDuration)
	action1.position = {x = x, y = y, z = z}
	action1.facing = facing
	action1.waitingStarted = false

	local action2 = ISAnimationAction:new(character2, animation2, animationData.Data.TimedDuration)
	action2.position = {x = x, y = y, z = z}
	action2.facing = facing
	action2.waitingStarted = false

	--- Activate the animations
	action1.otherAction = action2
	action2.otherAction = action1

	ISTimedActionQueue.add(action1)
	ISTimedActionQueue.add(action2)
end

function ISAnimationAction:isValid()
	--- Make sure to keep the TimedAction running
	return true
end

function ISAnimationAction:waitToStart()
	--- false = starts the timedaction
	--- true = delay the timedaction

	local continueWaiting = self.character:shouldBeTurning()

	if self.otherAction then
		self.character:faceThisObject(self.otherAction.character)

		if self.otherAction.waitingStarted == false or self.otherAction.character:shouldBeTurning() == true then
			continueWaiting = true
		end
	end

	self.waitingStarted = true

	return continueWaiting
end

function ISAnimationAction:update()
	--- Runs every frame
	if self.facing then
		self.character:setDir(self.facing)
	end

	if self.position then
		self.character:setX(self.position.x)
		self.character:setY(self.position.y)
		self.character:setZ(self.position.z)
	end
end

function ISAnimationAction:perform()
	ISBaseTimedAction.perform(self)
end

function ISAnimationAction:stop()
	--- What happens if the actor cancels this action?
	if self.otherAction then
		self.otherAction:forceComplete()
	end

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