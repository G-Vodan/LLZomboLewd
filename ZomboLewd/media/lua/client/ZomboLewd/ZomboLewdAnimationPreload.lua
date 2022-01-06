-- @author QueuedResonance 2022

local Animations = {}

local ZomboLewdActType = ZomboLewdActType
local ZomboLewdAnimationData = ZomboLewdAnimationData

local string = string
local pairs = pairs
local type = type

--- Preloads all animations inserted by ZomboLewd and external mods
function Animations:refreshAnimations()
	Animations.Client.Animations = {}

	--- Use the act type enums to make the base tables
	for enum, index in pairs(ZomboLewdActType) do
		Animations.Client.Animations[index] = {}
	end

	--- Load all animations into the respective act
	for actIdentifier, actData in pairs(ZomboLewdAnimationData) do
		if not actData.Animations.Male and not actData.Animations.Female then
			print(string.format("[ZomboLewd] - Could not load data %s due to missing both Animations.Male/Female parameters", actIdentifier))
			return
		end

		if type(actData.ActType) ~= "number" then
			print(string.format("[ZomboLewd] - Could not load data %s due to incorrect act type enum", actIdentifier))
			return
		end

		table.insert(Animations.Client.Animations[actData.ActType], actIdentifier)
	end
end

--- Returns a list of viable animations to fetch depending on factors listed below
-- @param the animation list, usually Animations.Client.Animations
-- @param boolean is it le... female?
-- @param boolean is the act consensual
-- @param boolean can this act be used with zombies
function Animations:getZLAnimations(list, isFemale, isConsensual, isZombie)
	local viableAnimations = {}

	for _, animation in ipairs(list) do
		local data = ZomboLewdAnimationData[animation]

		if data then
			local canAdd = true

			--- Check if the animations are gender compatible
			if isFemale then
				if not data.Animations.Female then
					canAdd = false
				end
			else
				if not data.Animations.Male then
					canAdd = false
				end
			end

			--- Check if the animations can be used with zombie
			if isZombie ~= nil and isZombie ~= data.IsZombieAllowed then
				canAdd = false
			end

			--- Check if the animations are consensual
			if isConsensual ~= nil and isConsensual ~= data.IsConsensual then
				canAdd = false
			end

			if canAdd then
				table.insert(viableAnimations, {Key = animation, Data = data})
			end
		end
	end

	return viableAnimations
end

return Animations