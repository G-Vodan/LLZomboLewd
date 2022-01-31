--- Handles a player's own masturbation tendencies in their own context menu
-- @author QueuedResonance 2022

local ISContextMenu = ISContextMenu
local ISToolTip = ISToolTip

local ZomboLewdConfig = ZomboLewdConfig
local ZomboLewdActType = ZomboLewdActType

local getText = getText
local string = string
local ipairs = ipairs

--- Creates a masturbation context menu
-- @param ContextMenu object injected from ZomboLewdContextMenu, can access ZomboLewd functionalities with this
-- @param IsoPlayer object
-- @context Context menu object to be filled for
-- @worldobjects table of world objects nearby the player
return function(ContextMenu, playerObj, context, worldobjects)
	local isFemale = playerObj:isFemale()
	local animationList = ContextMenu.Client.AnimationUtils:getAnimations(1, isFemale and 0 or 1, isFemale and 1 or 0, {"Masturbation"})

	--- Create an option in the right-click menu, and then creates a submenu for that
	local masturbateOption = context:addOption(getText("ContextMenu_Masturbate"), worldobjects)
	local masturbationSubMenu = ISContextMenu:getNew(context)
	context:addSubMenu(masturbateOption, masturbationSubMenu)

	--- Start creating our submenus based on the player's gender
	for i = 1, #animationList do
		local animation = animationList[i]
		local contextMenu_translate_text = string.format("ContextMenu_%s%s", animation.prefix, animation.id)
		local text = getText(contextMenu_translate_text)
		
		if text then
			--- Create a new tooltip when the player hovers over the sub option
			local toolTip = ISToolTip:new()
			toolTip.description = "" --- Make tooltip description in the future
			toolTip:setName(text)
			toolTip:initialise()
			toolTip:setVisible(false)

			--- Create the new sub option
			local animationOption = masturbationSubMenu:addOption(text, worldobjects, ContextMenu.Client.AnimationHandler.Play, {playerObj}, animation)
			animationOption.toolTip = toolTip
		else
			print(string.format("Missing Text: %s", contextMenu_translate_text))
		end
	end
end