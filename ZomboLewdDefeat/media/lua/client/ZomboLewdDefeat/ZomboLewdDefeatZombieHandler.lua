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

local bodyParts = {
	Belt = {"box1", "dropdown3"},
	Pants = {"box2", "dropdown4"},
	Tshirt = {"box3", "dropdown5"},
	Shoes = {"box1", "dropdown6"},
}

--- Check if this target can be defeated due to armor and clothing
-- @param target
local function checkForClothingDamage(zombie, target)
	--- Copied from ISInventoryPaneContextMenu.lua
	local previousBiteDefense = 0
	local previousScratchDefense = 0
	local previousCombatModifier = 0

	local wornItems = target:getWornItems()

	if wornItems then
		local bodyLocationGroup = wornItems:getBodyLocationGroup()

		for i = 1, wornItems:size() do
			local wornItem = wornItems:get(i - 1)

			if wornItem then
				local item = wornItem:getItem()
				local location = wornItem:getLocation()

				if item:IsClothing() then
					for bodyLocation, option in pairs(bodyParts) do
						if location == bodyLocation then
							local conditionDamage = ZomboLewdDefeatConfig.ModOptions.options[option[2]]

							if ZomboLewdDefeatConfig.ModOptions.options[option[1]] then
								item:setCondition(item:getCondition() - conditionDamage)
							end
						end
					end

					previousBiteDefense = previousBiteDefense + item:getBiteDefense();
					previousScratchDefense = previousScratchDefense + item:getScratchDefense();
					previousCombatModifier = previousCombatModifier + item:getCombatSpeedModifier();
				end
			end
		end
	end

	local minimumScratch = (ZomboLewdDefeatConfig.ModOptions.options.dropdown2 * 10)
---	print(minimumScratch)

	local hasLoweredScratch = previousScratchDefense <= minimumScratch

	if not hasLoweredScratch then
		isoPlayersInAct[target] = {Ended = true, Tick = 0}
		return false
	else
		return true
	end
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
			dummy:setX(dummy:getX() + 999999)

			local function _deleteDummy(tick)
				if tick >= 25 then
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