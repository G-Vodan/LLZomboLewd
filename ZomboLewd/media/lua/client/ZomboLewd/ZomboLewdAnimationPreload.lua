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

function Animations:getZLAnimations(list, isFemale)
	local viableAnimations = {}

	for _, animation in ipairs(list) do
		local data = ZomboLewdAnimationData[animation]

		if data then
			if isFemale then
				if data.Animations.Female then
					table.insert(viableAnimations, {Key = animation, Data = data})
				end
			else
				if data.Animations.Male then
					table.insert(viableAnimations, {Key = animation, Data = data})
				end
			end
		end
	end

	return viableAnimations
end

return Animations