--- Creates context menus relevant to ZomboLewd
-- @author QueuedResonance 2022

require "ISUI/ISContextMenu"
require "ISUI/ISToolTip"

local ContextMenu = {}

local ISContextMenu = ISContextMenu
local ISToolTip = ISToolTip

local ZomboLewdConfig = ZomboLewdConfig
local ZomboLewdAnimationList = ZomboLewdAnimationList

local getText = getText
local getTexture = getTexture
local string = string

--- Internal function that creates a world context menu for masturbation
-- @param IsoPlayer for which the context menu will be filled for
-- @context Context menu object to be filled for
-- @worldobjects table of world objects nearby the player
-- @test boolean returns whether this context menu is in testing or not
function ContextMenu._createMasturbationMenu(player, context, worldobjects, test)
	--- Testing purposes
	if test and ISWorldObjectContextMenu.Test then return true end
	if test then return ISWorldObjectContextMenu.setTest() end

	local playerObj = getSpecificPlayer(player)
	local animationList = playerObj:isFemale() and ZomboLewdAnimationList.Solo.Female or ZomboLewdAnimationList.Solo.Male

	--- Make sure the player isn't doing any actions that impedes their self-touching abilities
	if playerObj:isAsleep() then return end
	if playerObj:getVehicle() then return end

	--- Create an option in the right-click menu, and then creates a submenu for that
	local masturbateOption = context:addOption(getText("IGUI_Emote_ZLD"), worldobjects)
	local masturbationSubMenu = ISContextMenu:getNew(context)
	context:addSubMenu(masturbateOption, masturbationSubMenu)

	--- Start creating our submenus based on the player's gender
	for _, animationName in ipairs(animationList) do
		local anim = string.gsub(animationName, "%s+", "_")
		local text, textureID = getText(string.format("IGUI_Emote_%s", anim)), string.format("media/ui/ZLDordinary/%s%s", anim, ZomboLewdConfig.IconImageExtension)
		
		if text then
			--- Create a new tooltip when the player hovers over the sub option
			local toolTip = ISToolTip:new()
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


--- Hook event listeners
Events.OnFillWorldObjectContextMenu.Add(ContextMenu._createMasturbationMenu)

return ContextMenu