-- @author QueuedResonance 2022

local ZombieHandler = {}

local ZomboLewd = require("ZomboLewd/ZomboLewd")

local ZomboLewdActType = ZomboLewdActType
local ZomboLewdDefeatConfig = ZomboLewdDefeatConfig

local ISTimedActionQueue = ISTimedActionQueue
local SurvivorFactory = SurvivorFactory
local IsoPlayer = IsoPlayer

local instanceof = instanceof
local ZombRand = ZombRand
local pairs = pairs

local isoPlayersInAct = {}

--- The zombie will choose between these three tables to strip
-- After choosing it, it will try to strip the clothing from left to right
ZombieHandler.CheckPartsInTheseOrder = {
	{"Jacket", "FullTop", "Sweater", "Shirt", "ShortSleeveShirt", "Tshirt", "TorsoExtra", "TankTop", "BathRobe", "UnderwearTop"},
	{"Belt", "Pants", "Legs1", "Skirt", "UnderwearBottom"},
	{"FullSuit", "Torso1Legs1", "Dress", "UnderwearTop", "UnderwearBottom"},
}

local holeType = {
	{"ForeArm_L", "ForeArm_R", "Torso_Upper", "Torso_Lower", "UpperArm_L", "UpperArm_R"},
	{"Groin", "LowerLeg_L", "LowerLeg_R", "UpperLeg_L", "UpperLeg_R", "Torso_Lower"},
	{"Torso_Upper", "Torso_Lower", "Groin"},
}

--- Check if this target can be defeated due to armor and clothing
-- @param zombie (not sure what to do with this yet)
-- @param target
local function checkForClothingDamage(zombie, target)
	--- Copied from ISInventoryPaneContextMenu.lua
	local wornItems = target:getWornItems()
	local index = ZombRand(1, #ZombieHandler.CheckPartsInTheseOrder)
	local randomClothingList = ZombieHandler.CheckPartsInTheseOrder[index]
	local canGrape = true

	--- ModOptions
	local conditionDamage = ZomboLewdDefeatConfig.ModOptions.options.dropdown2

	--- For some reason PZ can return nil for wornItems
	if wornItems then
		--- Loop through the character's currently equipped items
		for i = 1, wornItems:size() do
			local wornItem = wornItems:get(i - 1) --- Get the current worn item

			if wornItem then
				local item = wornItem:getItem() --- Receive item data
				local location = wornItem:getLocation() --- Receive location of where this item is located on the body

				if item:IsClothing() then --- Make sure it is a clothing piece
					--- Iterate through the major clothing list the zombie will want to strip
					for v = 1, #randomClothingList do
						if canGrape then
							local bodyPart = randomClothingList[v]

							if location == bodyPart then
								canGrape = false

								if ZomboLewdDefeatConfig.ModOptions.options[string.format("box%s", tostring(index))] == true then
									item:setCondition(item:getCondition() - conditionDamage)

									if ZomboLewdDefeatConfig.ModOptions.options.box4 then
										if ZombRand(0, 100) < ZomboLewdDefeatConfig.ModOptions.options.dropdown3 * 10 then
											local holeIndex = holeType[index]
											local chosenHole = holeIndex[ZombRand(1, #holeIndex)]
											local bloodPart = BloodBodyPartType.FromString(chosenHole)

											target:addHole(bloodPart)
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	local minimumScratch = (ZomboLewdDefeatConfig.ModOptions.options.dropdown2 * 10)

	if not canGrape then
		isoPlayersInAct[target] = {Ended = true, Tick = 0}
	end

	return canGrape
end

--- Make the zombie do lewd things to the target
-- @param IsoZombie
-- @param IsoPlayer
local function attemptToDefeatTarget(zombie, target)
	local isMainHeroFemale = target:isFemale()
	local zombieIsFemale = zombie:isFemale()

	--- Only straight sex for now
	if isMainHeroFemale == zombieIsFemale then return end
	if target:getModData().zomboLewdSexScene then return end
	if target:getModData().dontDefeat then return end

	if not isoPlayersInAct[target] and zombie:DistTo(target) < 1 then
		isoPlayersInAct[target] = {Ended = false, Tick = 0, TimeOut = 0}

		if not checkForClothingDamage(zombie, target) then return end

		--- Time to grape em
		local dummy = ZomboLewd.ZombieHandler:convertZombieToSurvivor(zombie)
		dummy:getModData().dontDefeat = true

		local intercourseList = ZomboLewd.Animations[ZomboLewdActType.Intercourse]
		local animationList = ZomboLewd.AnimationUtils:getZLAnimations(intercourseList, isMainHeroFemale)

		--- Choose random animation as a test
		local index = ZombRand(1, #animationList)
		local chosenAnimation = animationList[index]

		local function cleanup()
			isoPlayersInAct[target].Ended = true

			--- Temporarily set 'em far away
			dummy:setX(dummy:getX() + 9999999)

			local function _deleteDummy(tick)
				if tick >= 100 then
					ISTimedActionQueue.clear(target)
					dummy:setInvincible(false)
					dummy:setInvisible(false)
					dummy:setGhostMode(false)
					dummy:removeFromWorld()
					dummy:removeFromSquare()
					Events.OnTick.Remove(_deleteDummy)
				end
			end

			Events.OnTick.Add(_deleteDummy)

			zombie:setUseless(false)
			zombie:setInvincible(false)
			zombie:setInvisible(false)
			zombie:setNoDamage(false)
		end

		ZomboLewd.AnimationHandler.PlayDuo(nil, dummy, target, chosenAnimation, true, true, {
			Update = function(action)
				isoPlayersInAct[target].TimeOut = 0
			end,
			WaitToStart = function(action)
				zombie:setInvisible(true)
				dummy:setGhostMode(true)
				dummy:setInvisible(false)

				--- Fix bugged character if the dummy zombie despawns
				if not action.TimeOut then
					action.TimeOut = 0
				end

				action.TimeOut = action.TimeOut + 1

				if action.TimeOut > 250 then
					action:forceStop()
				end
			end,
			Start = function(action)
				zombie:setInvisible(true)
				dummy:setInvisible(false)
				isoPlayersInAct[dummy] = nil
			end,
			Stop = function(action)
				cleanup()
			end,
			Perform = function(action)
				cleanup()
			end
		})

		isoPlayersInAct[dummy] = {Dummy = dummy, TimeOut = 0, Callback = cleanup}
	end
end

local function OnZombieUpdate(zombie)
	if zombie:isUseless() then return end

	local target = zombie:getTarget()
	if not target then return end

	--- Check if this zombie is attacking this target
	if zombie:isZombieAttacking(target) then
		attemptToDefeatTarget(zombie, target)
	end
end

local function OnGrabImmunity(tick)
	local cooldown = (ZomboLewdDefeatConfig.ModOptions.options.dropdown1 * 200) - 200

	for key, data in pairs(isoPlayersInAct) do
		if data.Dummy then
			--- Delete glitched animation dummies
			data.TimeOut = data.TimeOut + 1

			if data.TimeOut > 100 then
				data.Callback(data.Dummy)
				isoPlayersInAct[key] = nil
			end
		else
			if data.Ended then
				data.Tick = data.Tick + 1

				if data.Tick >= cooldown then
					isoPlayersInAct[key] = nil
				end
			else
				data.TimeOut = data.TimeOut + 1

				if data.TimeOut > 1000 then
					isoPlayersInAct[key] = nil
				end
			end
		end
	end
end

--- Hook up event listeners
Events.OnZombieUpdate.Add(OnZombieUpdate)
Events.OnTick.Add(OnGrabImmunity)

return ZombieHandler