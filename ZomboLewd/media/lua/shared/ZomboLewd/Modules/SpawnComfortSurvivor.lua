require "ZomboLewd/ZomboLewdConfig"

ZomboLewdConfig.Modules.SpawnComfortSurvivor = function(playerObj)
	local desc = SurvivorFactory.CreateSurvivor(nil, not playerObj:isFemale())
	SurvivorFactory.randomName(desc)

	local survivorModel = IsoPlayer.new(getWorld():getCell(), desc, playerObj:getX(), playerObj:getY(), playerObj:getZ())
	survivorModel:getInventory():emptyIt()
	survivorModel:setSceneCulled(false)
---	survivorModel:setBlockMovement(true)
---	survivorModel:setNPC(true)
	survivorModel:dressInRandomOutfit()
	survivorModel:setDir(playerObj:getDir())
	survivorModel:resetModelNextFrame()
end