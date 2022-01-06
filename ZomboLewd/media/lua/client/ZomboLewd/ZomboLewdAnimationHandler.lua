--- Animation handler for all lewd things
--- future todo task for me in the far future: have support for 3somes, 4somes, possibly more if we want to be extra steamy
-- @author QueuedResonance

require "TimedActions/ISBaseTimedAction"

local AnimationHandler = {EventMarkerModules = {}}

local ZomboLewdConfig = ZomboLewdConfig
local ZomboLewdAnimationData = ZomboLewdAnimationData
local ISBaseTimedAction = ISBaseTimedAction
local ISTimedActionQueue = ISTimedActionQueue

local luautils = luautils
local ignoredKeyframeNames = {}

ISAnimationAction = ISBaseTimedAction:derive("ISZomboLewdAnimationAction")

--- Plays a solo (usually masturbation) animation on this specific character
-- @param worldObjects is a table of all nearby objects
-- @param IsoPlayer character object
-- @param animationdata
-- @param callbacks - table of functions with WaitToStart, Start, Stop, Update and Perform
function AnimationHandler.PlaySolo(worldObjects, character, animationData, callbacks)
	if not character then return end
	if not instanceof(character, "IsoPlayer") then return end

	local isFemale = character:isFemale()
	local data = animationData.Data
	local duration = data.TimedDuration
	local animation = isFemale and data.Animations.Female or data.Animations.Male
	local action = ISAnimationAction:new(character, animation, duration)
	action.callbacks = callbacks

	ISTimedActionQueue.clear(character)
	ISTimedActionQueue.add(action)
end

--- Plays duo animations (usually a sex animation between two individuals) between two characters
-- @param worldObjects is a table of all nearby objects
-- @param IsoPlayer of the first character
-- @param IsoPlayer of the second character
-- @param animationdata for which the actors will be playing
-- @param boolean, prevents cancellation of this action if set to true (for example, non-consensual actions)
-- @param boolean, disables the initial walk of the animation (both actors will teleport to eachother instantly for the scene)
-- @param callbacks - table of functions with WaitToStart, Start, Stop, Update, and Perform
function AnimationHandler.PlayDuo(worldObjects, character1, character2, animationData, disableCancel, disableWalk, callbacks)
	disableWalk = disableWalk or false

	if not character1 or not character2 then return end
	if not instanceof(character1, "IsoPlayer") or not instanceof(character2, "IsoPlayer") then return end
	if not disableWalk then
		if not luautils.walkAdj(character1, character2:getSquare(), true) then
			return
		end
	end

	disableCancel = disableCancel or false

	--- Get the position of the original character, then get the facing position of the second character
	local x, y, z = character2:getX(), character2:getY(), character2:getZ()
	local facing = character2:getDir()

	--- Sets the Action to save the position and facing directions
	local isFemale1 = character1:isFemale()
	local isFemale2 = character2:isFemale()

	local animation1 = isFemale1 and animationData.Data.Animations.Female or animationData.Data.Animations.Male
	local animation2 = isFemale2 and animationData.Data.Animations.Female or animationData.Data.Animations.Male

	local action1 = ISAnimationAction:new(character1, animation1, animationData.Data.TimedDuration)
	action1.originalPosition = {x = character1:getX(), y = character1:getY(), z = character1:getY()}
	action1.position = {x = x, y = y, z = z}
	action1.facing = facing
	action1.waitingStarted = false
	action1.callbacks = callbacks

	local action2 = ISAnimationAction:new(character2, animation2, animationData.Data.TimedDuration)
	action1.originalPosition = {x = x, y = y, z = z}
	action2.position = {x = x, y = y, z = z}
	action2.facing = facing
	action2.waitingStarted = false
	action1.callbacks = callbacks

	if disableCancel == true then
		action1.stopOnRun = false
		action1.stopOnAim = false
		action2.stopOnRun = false
		action2.stopOnAim = false
	end

	action1.otherAction = action2
	action2.otherAction = action1

	--- Activate the animations
	if disableWalk then
		ISTimedActionQueue.clear(character1)
		ISTimedActionQueue.clear(character2)
	end

	ISTimedActionQueue.add(action1)
	ISTimedActionQueue.add(action2)

	return action1, action2
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

	if self.callbacks then
		if self.callbacks.WaitToStart then
			self.callbacks.WaitToStart(self)
		end
	end

	self.waitingStarted = true

	return continueWaiting
end

function ISAnimationAction:update()
	--- Runs every frame during the animations
	if self.facing then
		self.character:setDir(self.facing)
	end

	if self.position then
		self.character:setX(self.position.x)
		self.character:setY(self.position.y)
		self.character:setZ(self.position.z)
	end

	if self.callbacks then
		if self.callbacks.Update then
			self.callbacks.Update(self)
		end
	end

	--- Check if the other actor somehow got a bugged action
	if self.otherAction then
		if not ISTimedActionQueue.hasAction(self.otherAction) then
			self:forceStop()
		end
	end

	if not self.character:getCharacterActions():contains(self.action) then
		self:forceStop()
	end
end

function ISAnimationAction:perform()
	--- What happens once the timedaction completes?
	if self.otherAction then
		self.otherAction:forceComplete()
	end

	if self.originalPosition then
		self.character:setX(self.originalPosition.x)
		self.character:setY(self.originalPosition.y)
		self.character:setZ(self.originalPosition.z)
	end

	self.character:getModData().zomboLewdSexScene = nil

	if self.callbacks then
		if self.callbacks.Perform then
			self.callbacks.Perform(self)
		end
	end

	ISBaseTimedAction.perform(self)
end

function ISAnimationAction:stop()
	--- What happens if the actor cancels this action?
	if self.otherAction then
		self.otherAction:forceStop()
	end

	self.character:getModData().zomboLewdSexScene = nil

	if self.callbacks then
		if self.callbacks.Stop then
			self.callbacks.Stop(self)
		end
	end

	ISBaseTimedAction.stop(self)
end

function ISAnimationAction:start()
	--- What happens when the animation starts?
	if self.callbacks then
		if self.callbacks.Start then
			self.callbacks.Start(self)
		end
	end

	self.maxTime = self.duration
	self.action:setTime(self.maxTime)
	self:setActionAnim(self.animation)
	self:setOverrideHandModels(nil, nil)

	self.character:getModData().zomboLewdSexScene = true
end

--- Determine animation events when played. Useful for sounds, saucy effects, or misc things
-- @param event string value determining the type of animation
-- @param parameter string that is the value given from the xml file
function ISAnimationAction:animEvent(event, parameter)
	if not AnimationHandler.EventMarkerModules[event] and not ignoredKeyframeNames[event] then
		--- See if we can lazy load it (Another mod might have added more event markers)
		AnimationHandler.EventMarkerModules[event] = require(string.format("ZomboLewd/AnimationEvents/%s", event))
	end

	if AnimationHandler.EventMarkerModules[event] then
		AnimationHandler.EventMarkerModules[event](self, parameter)
	elseif not ignoredKeyframeNames[event] then
		--- There probably isn't a file named this keyframe anywhere, lets ignore it from now on
		ignoredKeyframeNames[event] = true
		print(string.format("ZomboLewd - Ignoring %s events from now on", event))
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