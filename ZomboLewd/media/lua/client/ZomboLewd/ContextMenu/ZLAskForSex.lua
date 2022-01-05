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
	local intercourseList = contextMenu.Client.Animations[ZomboLewdActType.Intercourse]
	local animationList = contextMenu.Client.AnimationUtils:getZLAnimations(intercourseList, isMainHeroFemale)

	--- Choose random animation as a test
	local index = ZombRand(1, #animationList)
	local chosenAnimation = animationList[index]

	contextMenu.Client.AnimationHandler.PlayDuo(worldobjects, requestor, target, chosenAnimation)
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