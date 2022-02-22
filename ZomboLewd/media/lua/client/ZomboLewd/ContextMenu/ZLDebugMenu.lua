--- Handles debugging stuff for ZomboLewd
-- @author QueuedResonance 2022

local ISTimedActionQueue = ISTimedActionQueue
local ISContextMenu = ISContextMenu
local ISToolTip = ISToolTip

local SurvivorFactory = SurvivorFactory
local IsoPlayer = IsoPlayer

local ZomboLewdConfig = ZomboLewdConfig

local getText = getText
local string = string

local ZomboLewd

--- Spawns a comfort survivor at the position of the player
-- @worldobjects table of world objects nearby the player
-- @param IsoPlayer object
local function spawnComfortSurvivor(worldobjects, playerObj)
	if isClient() then
		ZomboLewd.Callbacks:sendClientCommand("SpawnComfortSurvivor")
	else
		ZomboLewdConfig.Modules.SpawnComfortSurvivor(playerObj)
	end
end

--- Creates a debug context menu
-- @param ContextMenu object injected from ZomboLewdContextMenu, can access ZomboLewd functionalities with this
-- @param IsoPlayer object
-- @context Context menu object to be filled for
-- @worldobjects table of world objects nearby the player
return function(ContextMenu, playerObj, context, worldobjects)
	if not ZomboLewdConfig.ModOptions.options.box2 then return end

	--- Cache the client
	if not ZomboLewd then
		ZomboLewd = ContextMenu.Client
	end

	--- Create an option in the right-click menu, and then creates a submenu for that
	local debugOption = context:addOption(getText("ContextMenu_Debug_Option"), worldobjects)
	local debugSubMenu = ISContextMenu:getNew(context)
	context:addSubMenu(debugOption, debugSubMenu)

	--- Comfort Survivor option
	do
		local toolTip = ISToolTip:new()
		toolTip.description = getText("ContextMenu_Debug_Spawn_Comfort_Survivor_Description")
		toolTip:initialise()
		toolTip:setVisible(false)

		--- Create the new sub option
		local option = debugSubMenu:addOption(getText("ContextMenu_Debug_Spawn_Comfort_Survivor"), worldobjects, spawnComfortSurvivor, playerObj)
		option.toolTip = toolTip
	end
end