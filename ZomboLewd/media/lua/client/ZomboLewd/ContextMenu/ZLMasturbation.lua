--- Handles a player's own masturbation tendencies in their own context menu
-- @author QueuedResonance 2022

local ISContextMenu = ISContextMenu
local ISToolTip = ISToolTip

local ZomboLewdConfig = ZomboLewdConfig
local ZomboLewdAnimationList = ZomboLewdAnimationList

local getText = getText
local getTexture = getTexture
local string = string

--- Creates a masturbation context menu
-- @param ContextMenu object injected from ZomboLewdContextMenu, can access ZomboLewd functionalities with this
-- @param IsoPlayer object
-- @context Context menu object to be filled for
-- @worldobjects table of world objects nearby the player
return function(ContextMenu, playerObj, context, worldobjects)
	local animationList = playerObj:isFemale() and ZomboLewdAnimationList.Solo.Female or ZomboLewdAnimationList.Solo.Male --- No futa support yet

	--- Create an option in the right-click menu, and then creates a submenu for that
	local masturbateOption = context:addOption(getText("ContextMenu_Masturbate"), worldobjects)
	local masturbationSubMenu = ISContextMenu:getNew(context)
	context:addSubMenu(masturbateOption, masturbationSubMenu)

	--- Start creating our submenus based on the player's gender
	for i = 1, #animationList do
		local anim = animationList[i]
		local text, textureID = getText(string.format("ContextMenu_Solo_%s", anim)), string.format("media/ui/ZomboLewd/%s%s", anim, ZomboLewdConfig.IconImageExtension)
		
		if text then
			--- Create a new tooltip when the player hovers over the sub option
			local toolTip = ISToolTip:new()
			toolTip.description = "" --- Make tooltip description in the future
			toolTip:setName(text)
			toolTip:setTexture(textureID)
			toolTip:initialise()
			toolTip:setVisible(false)

			--- Create the new sub option
			local animationOption = masturbationSubMenu:addOption(text, worldobjects, ContextMenu.Client.AnimationHandler.PlaySolo, playerObj, anim)
			animationOption.toolTip = toolTip
		else
			print(string.format("Missing Text: %s", anim))
		end
	end
end