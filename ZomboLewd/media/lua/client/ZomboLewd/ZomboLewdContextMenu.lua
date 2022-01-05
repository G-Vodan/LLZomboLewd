--- Creates context menus relevant to ZomboLewd
-- @author QueuedResonance 2022

require "ISUI/ISContextMenu"
require "ISUI/ISToolTip"
require "ISUI/ISWorldObjectContextMenu"

local ContextMenu = {}
local ISWorldObjectContextMenu = ISWorldObjectContextMenu

local CONTEXT_MENU_MODULES = { --- Add more if there will be more context menu options
	"ZLMasturbation",
	"ZLDebugMenu",
	"ZLAskForSex",
}

--- Internal function that creates a world context menu for masturbation
-- @param player number for which the context menu will be filled for
-- @context Context menu object to be filled for
-- @worldobjects table of world objects nearby the player
-- @test boolean returns whether this context menu is in testing or not
function ContextMenu._createContextMenu(player, context, worldobjects, test)
	--- Testing purposes
	if test and ISWorldObjectContextMenu.Test then return true end
	if test then return ISWorldObjectContextMenu.setTest() end

	local playerObj = getSpecificPlayer(player)

	--- Make sure the player isn't doing any actions that impedes their self-touching abilities
	if playerObj:isAsleep() then return end
	if playerObj:getVehicle() then return end

	--- Lazy load other ContextMenu modules if it hasn't been initialized already
	if not ContextMenu.Modules then
		ContextMenu.Modules = {} do
			for _, module in ipairs(CONTEXT_MENU_MODULES) do
				table.insert(ContextMenu.Modules, require(string.format("ZomboLewd/ContextMenu/%s", module)))
			end
		end
	end

	--- Activates all ContextMenu codes
	for i = 1, #CONTEXT_MENU_MODULES do --- Using the old iterator style for slightly more performance
		ContextMenu.Modules[i](ContextMenu, playerObj, context, worldobjects)
	end
end

--- Hook event listeners
Events.OnPreFillWorldObjectContextMenu.Add(ContextMenu._createContextMenu)

return ContextMenu