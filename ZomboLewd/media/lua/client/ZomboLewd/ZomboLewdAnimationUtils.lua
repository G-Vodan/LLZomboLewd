-- @author QueuedResonance 2022

local Animations = {}

local ZomboLewdActType = ZomboLewdActType
local ZomboLewdAnimationData = ZomboLewdAnimationData

local string = string
local pairs = pairs
local type = type

--- Returns the first occurrence of this element, if not, returned nil
-- @param list: array of the list to search the element in
-- @param element: the object to search for in the list
function Animations:tableFind(list, element)
	for i = 1, #list do
		local item = list[i]
		if item == element then
			return item
		end
	end
end

--- Returns a list of viable animations to fetch depending on factors listed below
-- @param actorCount: number of actors participating in the animation
-- @param males: number of males present in the animation
-- @param females: number of females present in the animation
-- @param tagsToSearch: an array of tags used to return animations containing them (ie. {"Missionary", "Doggystyle"} will return all animations with these tags)
-- @param tagsBlacklist: an array of tags used to ignore animations with these tags (ie. {"Aggressive", "Blowjob"} will ignore animations with these tags)
-- @param allTagsRequired: defaults to true, all tags in tagsToSearch must be valid in the animation to be returned, false will return the animation if one tag is valid
function Animations:getAnimations(actorCount, males, females, tagsToSearch, tagsBlacklist, allTagsRequired)
	males = males or -1
	females = females or -1
	tagsToSearch = tagsToSearch or {}
	tagsBlacklist = tagsBlacklist or {}
	allTagsRequired = allTagsRequired or true

	local viableAnimations = {}

	--- Loop through all the animations
	for i = 1, #ZomboLewdAnimationData do
		local animation = ZomboLewdAnimationData[i]
		local tags = animation.tags
		local tagsFound = 0
		local canAdd = true

		if #animation.actors == actorCount then
			--- See if it contains any blacklisted tags, ignore this animation if it does
			for tagBlacklistIndex = 1, #tagsBlacklist do
				if Animations:tableFind(tags, tagsBlacklist[tagBlacklistIndex]) then
					canAdd = false
					break
				end
			end

			--- Check if this animation contains the tags
			for tagSearchIndex = 1, #tagsToSearch do
				local tagSearch = tagsToSearch[tagSearchIndex]
				if Animations:tableFind(tags, tagSearch) then
					tagsFound = tagsFound + 1
				end
			end

			--- Check if allTagsRequired is true
			if allTagsRequired then
				if tagsFound < #tagsToSearch then
					canAdd = false
				end
			end

			local maleCount = 0
			local femaleCount = 0

			--- Check if the actor gender count is right
			for actorIndex = 1, #animation.actors do
				local actor = animation.actors[actorIndex]
				if actor.gender == "Male" then
					maleCount = maleCount + 1
				elseif actor.gender == "Female" then
					femaleCount = femaleCount + 1
				end
			end

			if males >= 0 then
				if maleCount ~= males then
					canAdd = false
				end
			end
			
			if females >= 0 then
				if femaleCount ~= females then
					canAdd = false
				end
			end

			if canAdd then
				table.insert(viableAnimations, animation)
			end
		end
	end

	return viableAnimations
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