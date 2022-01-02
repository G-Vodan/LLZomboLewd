--- Handles asking for sex with players and NPCs
-- @author QueuedResonance 2022

local ISWorldObjectContextMenu = ISWorldObjectContextMenu
local ISContextMenu = ISContextMenu
local ISToolTip = ISToolTip

local getText = getText
local getTexture = getTexture
local string = string

--- Activates when the player clicks ask for seks on the chosen target
-- @worldobjects table of world objects nearby the player
-- @param ContextMenu object injected from ZomboLewdContextMenu, can access ZomboLewd functionalities with this
-- @param IsoPlayer object of the player
-- @param IsoPlayer object of the asked target
local function onAskForSex(worldobjects, contextMenu, requestor, target)
	local isMainHeroFemale = requestor:isFemale()
	local isTargetFemale = target:isFemale()

	local heroAnimList = isMainHeroFemale and ZomboLewdAnimationList.Intercourse.Female or ZomboLewdAnimationList.Intercourse.Male
	local targAnimList = isTargetFemale and ZomboLewdAnimationList.Intercourse.Female or ZomboLewdAnimationList.Intercourse.Male

	--- Choose random animation as a test
	local index = ZombRand(1, #heroAnimList)
	local chosenAnimation = heroAnimList[index]
	local targetAnimation = targAnimList[index]

	contextMenu.Client.AnimationHandler.PlayDuo(worldobjects, requestor, target, chosenAnimation, targetAnimation)
end

--- Creates a ask for seks context menu
-- @param ContextMenu object injected from ZomboLewdContextMenu, can access ZomboLewd functionalities with this
-- @param IsoPlayer object
-- @context Context menu object to be filled for
-- @worldobjects table of world objects nearby the player
return function(ContextMenu, playerObj, context, worldobjects)
	local player = playerObj:getPlayerNum()

	ISWorldObjectContextMenu.clearFetch()
    for i,v in ipairs(worldobjects) do
		ISWorldObjectContextMenu.fetch(v, player, true)
    end

	--- Check if we have moused over a IsoPlayer
	if clickedPlayer then
		--- Create an option in the right-click menu, and then creates a submenu for that
		local askOption = context:addOption(getText("ContextMenu_Ask_For_Sex"), worldobjects, onAskForSex, ContextMenu, playerObj, clickedPlayer)

		if math.abs(playerObj:getX() - clickedPlayer:getX()) > 2 or math.abs(playerObj:getY() - clickedPlayer:getY()) > 2 then
			local toolTip = ISToolTip:new()
			toolTip.description = getText("ContextMenu_Ask_For_Sex_Get_Closer")

			askOption.notAvailable = true
			askOption.toolTip = toolTip
		end
	end
end