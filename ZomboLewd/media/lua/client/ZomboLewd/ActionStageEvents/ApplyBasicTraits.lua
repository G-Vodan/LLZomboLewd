--[[
	Depending on the chosen ActionEvent, you can hook up to certain parts of the animation player, regardless if
	your own mod has initiated the animations first. ActionEvents are overarching functions that deals with
	more general logic and allows you to code in logic even if the animations are not owned by you. 

	ActionEvents.Perform - Runs whenever the animation successfully completes
	ActionEvents.Start - Runs whenever the animation starts
	ActionEvents.Stop - Runs whenever the animation is cancelled
	ActionEvents.Update - Runs whenever the animation is ongoing
	ActionEvents.WaitToStart - Runs whenever the animation is waiting to start

	-- @author QueuedResonance 2022
]]

local ZomboLewd = require("ZomboLewd/ZomboLewd")
local ActionEvents = ZomboLewd.AnimationHandler.ActionEvents

--- Sex addiction
table.insert(ActionEvents.Update, function(action)
	local character = action.character
	local otherAction = action.otherAction

	local stats = character:getStats()
	local bodyDamage = character:getBodyDamage()
	local unhappiness = bodyDamage:getUnhappynessLevel()
	local boredom = bodyDamage:getBoredomLevel()

	--- Gender hating logic
	if otherAction then
		local otherCharacter = otherAction.character

		if character:HasTrait("Misogynist") then
			if otherCharacter:isFemale() then
				stats:setStress(stats:getStress() + 0.002)
				bodyDamage:setUnhappynessLevel(unhappiness + 0.005)
			end
		end

		if character:HasTrait("Misandrist") then
			if not otherCharacter:isFemale() then
				stats:setStress(stats:getStress() + 0.002)
				bodyDamage:setUnhappynessLevel(unhappiness + 0.005)
			end
		end
	end

	if character:HasTrait("Sexaddict") then
		stats:setStress(stats:getStress() - 0.002)
		bodyDamage:setUnhappynessLevel(unhappiness - 0.005)
	end

	--- Decrease boredom
	bodyDamage:setBoredomLevel(boredom - 0.005)
end)

local function _onPlayerUpdate(character)
	local stats = character:getStats()
	local bodyDamage = character:getBodyDamage()
	local unhappiness = bodyDamage:getUnhappynessLevel()
	local boredom = bodyDamage:getBoredomLevel()

	if not character:getModData().zomboLewdSexScene then
		if character:HasTrait("Sexaddict") then
			bodyDamage:setUnhappynessLevel(unhappiness + 0.0002)
		end
	end
end

--- Hook up event listeners
Events.OnPlayerUpdate.Add(_onPlayerUpdate) 