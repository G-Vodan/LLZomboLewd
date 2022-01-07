local IsoSprite = IsoSprite

local cumSprites = {
	"cum_floor_large_01",
	"cum_floor_large_02",
	"cum_floor_large_03"
}

return function(action, parameter)
	action.character:playSound("ZomboLewdCum")

	local offsetx = ZombRandFloat(3, 4)
	local offsety = ZombRandFloat(2, 3)

	local square = getCell():getGridSquare(action.character:getX() + offsetx, action.character:getY() + offsety, action.character:getZ())
	local cum = IsoObject.new(square, cumSprites[ZombRand(1, #cumSprites)])

	cum:setCustomColor(1, 1, 1, 1)
	square:AddTileObject(cum)
end