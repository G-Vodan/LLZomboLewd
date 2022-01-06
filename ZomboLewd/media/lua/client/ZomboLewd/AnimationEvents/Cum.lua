local IsoSprite = IsoSprite

return function(action, parameter)
	action.character:playSound("ZomboLewdSlap")

	--[[
	if not action.floorSprite then
		action.floorSprite = IsoSprite.new()
		action.floorSprite:LoadFramesNoDirPageSimple('media/ui/FloorTileCursor.png')
	end

	local square = action.character:getSquare()
	action.floorSprite:RenderGhostTile(square:getX(), square:getY(), square:getZ())

	print("rendered square")
	]]
end