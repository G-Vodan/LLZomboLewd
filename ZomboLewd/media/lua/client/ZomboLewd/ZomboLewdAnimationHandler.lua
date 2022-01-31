--- Animation handler for all lewd things
--- future todo task for me in the far future: have support for 3somes, 4somes, possibly more if we want to be extra steamy
-- @author QueuedResonance

require "TimedActions/ISBaseTimedAction"

-- Initialize external tables
local AnimationHandler = {EventMarkerModules = {}, ActionEvents = {Perform = {}, WaitToStart = {}, Start = {}, Stop = {}, Update = {}}}

local ZomboLewdConfig = ZomboLewdConfig
local ZomboLewdAnimationData = ZomboLewdAnimationData
local ISBaseTimedAction = ISBaseTimedAction
local ISTimedActionQueue = ISTimedActionQueue

local luautils = luautils
local ignoredKeyframeNames = {}

local ipairs = ipairs

ISAnimationAction = ISBaseTimedAction:derive("ISZomboLewdAnimationAction")

--- Plays an animation using the given animation data
-- @param worldobjects: an array of all nearby objects, usually returned through a contextMenu
-- @param actors: an array of actors to be played in this scene. Must be IsoPlayer types. First actor will usually be the position where the act takes place
-- @param animationData: the animation object passed from AnimationUtils:getAnimations()
-- @param disableCancel boolean: prevents cancellation of this action if set to true (for example, non-consensual actions)
-- @param disableWalk boolean: disables the initial walk of the animation (actors will teleport to eachother instantly for the scene)
function AnimationHandler.Play(worldobjects, actors, animationData, disableCancel, disableWalk, callbacks)
	disableWalk = disableWalk or false

	if #actors < 1 then return end
	if not disableWalk then
		for _, actor in ipairs(actors) do
		---	if actor ~= actors[1] then
				if not luautils.walkAdj(actor, actors[1]:getSquare(), true) then
					return
				end
		---	end
		end
	end

	disableCancel = disableCancel or false

	--- Get the position of the original character, then get the facing position of the second character
	local x, y, z = actors[1]:getX(), actors[1]:getY(), actors[1]:getZ()
	local facing = actors[1]:getDir()
	local otherActions = {}

	--- Cache the available actor positions
	local availablePositions = {} do
		for _, actor in ipairs(animationData.actors) do
			table.insert(availablePositions, actor)
		end
	end

	for i, actor in ipairs(actors) do
		local isFemale = actor:isFemale()
		local job
		
		--- Check for a valid position in the animation dependent on gender
		for i = #availablePositions, 1, -1 do
			local canUsePosition = true

			--- If its a male animation, prevent them from playing this animation if female
			if isFemale and availablePositions[i].gender == "Male" then
				canUsePosition = false
			end

			if canUsePosition then
				job = table.remove(availablePositions, i)
				break
			end
		end

		--- Create animation data
		local action = ISAnimationAction:new(actor, job.stages[1].perform, job.stages[1].duration)
		action.currentStage = 1
		action.originalPosition = {x = actor:getX(), y = actor:getY(), z = actor:getZ()}
		action.originalActor = actors[1]
		action.position = {x = x, y = y, z = z}
		action.facing = #actors > 1 and facing
		action.waitingStarted = false
		action.callbacks = callbacks
		action.otherActions = #actors > 1 and otherActions

		if disableCancel == true then
			action.stopOnRun = false
			action.stopOnAim = false
		end

		table.insert(otherActions, action)
	end

	--- Activate the animations simultaneously
	for i = 1, #otherActions do
		local otherAction = otherActions[i]

		if disableWalk then
			ISTimedActionQueue.clear(otherAction.character)
		end
		
		ISTimedActionQueue.add(otherAction)
	end

	return otherActions
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
	local otherActionLength = #self.otherActions

	--- Check if other characters are still turning towards the original actor
	if otherActionLength > 1 then
		for i = 1, otherActionLength do
			local otherAction = self.otherActions[i]

			--- Wait till the other actors has finished their turning
			if otherAction.character ~= self.character then
				self.character:faceThisObject(otherAction.character)
			
				if(otherAction.waitingStarted == false or otherAction.character:shouldBeTurning() == true) then
					continueWaiting = true
				end
			end
		end
	end

	if self.callbacks then
		if self.callbacks.WaitToStart then
			self.callbacks.WaitToStart(self)
		end
	end

	--- Activate ActionEvents
	for i = 1, #AnimationHandler.ActionEvents.WaitToStart do
		AnimationHandler.ActionEvents.WaitToStart[i](self)
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

	--- Activate ActionEvents
	for i = 1, #AnimationHandler.ActionEvents.Update do
		AnimationHandler.ActionEvents.Update[i](self)
	end

	--- Check if the other actor somehow got a bugged action
	if self.otherActions then
		for i = 1, #self.otherActions do
			local otherAction = self.otherActions[i]
			if otherAction.character ~= self.character and not ISTimedActionQueue.hasAction(otherAction) then
				self:forceStop()
			end
		end
	end

	if not self.character:getCharacterActions():contains(self.action) then
		self:forceStop()
	end
end

function ISAnimationAction:perform()
	--- What happens once the timedaction completes?
	if self.otherActions then
		for i = 1, #self.otherActions do
			if self.otherActions[i].character ~= self.character then
				self.otherActions[i]:forceComplete()
			end
		end
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

	--- Activate ActionEvents
	for i = 1, #AnimationHandler.ActionEvents.Perform do
		AnimationHandler.ActionEvents.Perform[i](self)
	end

	ISBaseTimedAction.perform(self)
end

function ISAnimationAction:stop()
	--- What happens if the actor cancels this action?
	if self.otherActions then
		for i = 1, #self.otherActions do
			if self.otherActions[i].character ~= self.character then
				self.otherActions[i]:forceStop()
			end
		end
	end

	self.character:getModData().zomboLewdSexScene = nil

	if self.callbacks then
		if self.callbacks.Stop then
			self.callbacks.Stop(self)
		end
	end

	--- Activate ActionEvents
	for i = 1, #AnimationHandler.ActionEvents.Stop do
		AnimationHandler.ActionEvents.Stop[i](self)
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