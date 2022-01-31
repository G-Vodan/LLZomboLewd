--- Handles asking for sex with players and NPCs
-- @author QueuedResonance 2022

local ZomboLewdActType = ZomboLewdActType

local ISWorldObjectContextMenu = ISWorldObjectContextMenu
local ISContextMenu = ISContextMenu
local ISToolTip = ISToolTip

local getText = getText
local string = string

--- Activates when the player clicks ask for seks on the chosen target
-- @worldobjects table of world objects nearby the player
-- @param ContextMenu object injected from ZomboLewdContextMenu, can access ZomboLewd functionalities with this
-- @param IsoPlayer object of the player
-- @param IsoPlayer object of the asked target
local function onAskForSex(worldobjects, contextMenu, requestor, target)
	local isMainHeroFemale = requestor:isFemale()
	local isTargetFemale = target:isFemale()
	local maleCount, femaleCount = 0, 0

	if isMainHeroFemale and isTargetFemale then
		--- Lesbian
		maleCount = 0
		femaleCount = 2
	elseif isMainHeroFemale == false and isTargetFemale == false then
		--- Gay
		maleCount = 2
		femaleCount = 0
	else
		--- Straight
		maleCount = 1
		femaleCount = 1
	end

	--- Choose random animation as a test
	local animationList = contextMenu.Client.AnimationUtils:getAnimations(2, maleCount, femaleCount, {"Sex"})
	local index = ZombRand(1, #animationList + 1)
	local chosenAnimation = animationList[index]

	contextMenu.Client.AnimationHandler.Play(worldobjects, {requestor, target}, chosenAnimation)
end

--- Creates a ask for seks context menu
-- @param ContextMenu object injected from ZomboLewdContextMenu, can access ZomboLewd functionalities with this
-- @param IsoPlayer object
-- @context Context menu object to be filled for
-- @worldobjects table of world objects nearby the player
return function(ContextMenu, playerObj, context, worldobjects)
	if not ZomboLewdConfig.ModOptions.options.box1 then return end

	local player = playerObj:getPlayerNum()

	--- Activate native fetch function to determine if our mouse selected a square containing an IsoPlayer
	ISWorldObjectContextMenu.clearFetch()
	for _, v in ipairs(worldobjects) do
		ISWorldObjectContextMenu.fetch(v, player, true)
	end

	--- Check if we have moused over a IsoPlayer
	if clickedPlayer then
		--- Create an option in the right-click menu, and then creates a submenu for that
		context:addOption(getText("ContextMenu_Ask_For_Sex"), worldobjects, onAskForSex, ContextMenu, playerObj, clickedPlayer)

		--- Placeholder, but can't ask for sex if they are the same gender
		if playerObj:isFemale() == clickedPlayer:isFemale() then
			context:removeLastOption()
		end
	end
end