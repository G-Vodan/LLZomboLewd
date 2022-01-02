local ZombieHandler = {}

--[[
local ZomboLewdAnimationList = ZomboLewdAnimationList

function ZombieHandler.OnHitZombie(zombie, character, bodyPartType, handWeapon)
	local isMainHeroFemale = character:isFemale()
	local isZombieFemale = zombie:isFemale()

	--- No lesbian or gay zombie sex at the moment, sorry!
	if isMainHeroFemale == isZombieFemale then return end

	local heroAnimList = isMainHeroFemale and ZomboLewdAnimationList.Intercourse.Female or ZomboLewdAnimationList.Intercourse.Male
	local zombAnimList = isZombieFemale and ZomboLewdAnimationList.Intercourse.Female or ZomboLewdAnimationList.Intercourse.Male

	--- Choose random animation as a test
	local index = ZombRand(1, #heroAnimList)
	local chosenAnimation = heroAnimList[index]
	local zombieAnimation = zombAnimList[index]

	ZombieHandler.Client.AnimationHandler.PlayDuo({}, character, zombie, chosenAnimation, zombieAnimation)
end

function ZombieHandler.OnWeaponHitCharacter(wielder, character, handWeapon, damage)
	-- Your code here
	print("I GOT HIT")
end

local function OnZombieUpdate(zombie)
	-- Your code here
	zombie:setUseless(true)
--	ISTimedActionQueue.add(ISAnimationAction:new(zombie, "StandingFuckF", 600))
end

Events.OnHitZombie.Add(ZombieHandler.OnHitZombie)
Events.OnWeaponHitCharacter.Add(ZombieHandler.OnWeaponHitCharacter)
Events.OnZombieUpdate.Add(OnZombieUpdate)
]]
return ZombieHandler