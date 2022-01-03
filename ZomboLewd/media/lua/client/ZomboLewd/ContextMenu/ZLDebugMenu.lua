--- Handles debugging stuff for ZomboLewd
-- @author QueuedResonance 2022

local ISContextMenu = ISContextMenu
local ISToolTip = ISToolTip

local SurvivorFactory = SurvivorFactory
local ZomboLewdConfig = ZomboLewdConfig

local getText = getText
local string = string

--- Spawns a comfort survivor at the position of the player
-- @worldobjects table of world objects nearby the player
-- @param IsoPlayer object
local function spawnComfortSurvivor(worldobjects, playerObj)
	local desc = SurvivorFactory.CreateSurvivor(nil, not playerObj:isFemale())
	SurvivorFactory.randomName(desc)

	local survivorModel = IsoPlayer.new(getWorld():getCell(), desc, playerObj:getX(), playerObj:getY(), playerObj:getZ())
	survivorModel:getInventory():emptyIt()
	survivorModel:setSceneCulled(false)
	survivorModel:setBlockMovement(true)
	survivorModel:setNPC(true)
	survivorModel:dressInRandomOutfit()
	survivorModel:resetModelNextFrame()
	survivorModel:setDir(playerObj:getDir())
end

--- Creates a debug context menu
-- @param ContextMenu object injected from ZomboLewdContextMenu, can access ZomboLewd functionalities with this
-- @param IsoPlayer object
-- @context Context menu object to be filled for
-- @worldobjects table of world objects nearby the player
return function(ContextMenu, playerObj, context, worldobjects)
	if not ZomboLewdConfig.DebugMode then return end

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