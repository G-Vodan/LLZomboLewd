-- @author QueuedResonance 2022

local ZombieHandler = {}

local SurvivorFactory = SurvivorFactory
local IsoPlayer = IsoPlayer

local instanceof = instanceof

--- Zombies are unable to be played animations directly, so we need to spawn a dummy survivor to act like the zombie
-- @param IsoZombie of the zombie we want to convert
function ZombieHandler:convertZombieToSurvivor(zombie)
	if not instanceof(zombie, "IsoZombie") then return end

	--- Disable actual zombie AI, make them invincible, and set them to invisible
	zombie:setUseless(true)
	zombie:setInvincible(true)
	zombie:setNoDamage(true)

	local desc = SurvivorFactory.CreateSurvivor(nil, zombie:isFemale())
	desc:dressInNamedOutfit(zombie:getOutfitName())

	local survivorModel = IsoPlayer.new(getWorld():getCell(), desc, zombie:getX(), zombie:getY(), zombie:getZ())
	survivorModel:getInventory():emptyIt()
	survivorModel:setSceneCulled(false)
	survivorModel:setBlockMovement(true)
	survivorModel:setNPC(true)
	survivorModel:setDir(zombie:getDir())

	--- Dress the dummy survivor with the same stuff as the zombie
	survivorModel:getVisual():setHairModel(zombie:getVisual():getHairModel())
	survivorModel:getVisual():setHairColor(zombie:getVisual():getHairColor())
	survivorModel:getVisual():setSkinTextureIndex(zombie:getVisual():getSkinTextureIndex())

	--- Model settings
	survivorModel:resetModelNextFrame()
	survivorModel:setInvincible(true)
	survivorModel:setGhostMode(true)
	survivorModel:setInvisible(true)

	for _ = 0, 15 do
        survivorModel:addBlood(nil, false, true, false);
    end

	return survivorModel
end

return ZombieHandler