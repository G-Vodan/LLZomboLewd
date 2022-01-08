--- Adds extra traits for the players to choose from
-- @author QueuedResonance 2022

require('NPCs/MainCreationMethods')

local TraitFactory = TraitFactory
local Perks = Perks

local getText = getText
local string = string

--- Table of all the traits relevant to ZomboLewd
local TRAITS_LIST = {
	{
		IdentifierType = "Sexaddict",
		Cost = -4,
		Profession = false,
		MutualExclusives = {},
	},
	{
		IdentifierType = "Masochist",
		Cost = 5,
		Profession = false,
		MutualExclusives = {},
		Callback = function(trait)
			trait:addXPBoost(Perks.Lightfoot, 1)
		end
	},
	{
		IdentifierType = "Rapist",
		Cost = 5,
		Profession = false,
		MutualExclusives = {},
		Callback = function(trait)
			trait:addXPBoost(Perks.Sneak, 1)
		end
	},
	{
		IdentifierType = "Wimp", --- Fear of rape
		Cost = -4,
		Profession = false,
		MutualExclusives = {"Masochist", "Rapist"},
	},
	{
		IdentifierType = "Necrophiliac",
		Cost = 3,
		Profession = false,
		MutualExclusives = {},
	},
	{
		IdentifierType = "Misogynist",
		Cost = -1,
		Profession = false,
		MutualExclusives = {},
	},
	{
		IdentifierType = "Misandrist",
		Cost = -1,
		Profession = false,
		MutualExclusives = {"Misogynist"},
	},
}

--- Load ZomboLewd specific traits
local function _initTraits()
	for i = 1, #TRAITS_LIST do
		local data = TRAITS_LIST[i]

		local name = getText(string.format("UI_ZL_Trait_%s", data.IdentifierType))
		local desc = getText(string.format("UI_ZL_Trait_%s_Description", data.IdentifierType))
		local newTrait = TraitFactory.addTrait(data.IdentifierType, name, data.Cost, desc, data.Profession)

		--- Activate optional callbacks
		if data.Callback then
			data.Callback(newTrait)
		end

		--- Make it so traits with mutual exclusivity can't select each other
		for v = 1, #data.MutualExclusives do
			TraitFactory.setMutualExclusive(data.IdentifierType, data.MutualExclusives[v])
		end
	end
end

--- Hook up event listeners
Events.OnGameBoot.Add(_initTraits)