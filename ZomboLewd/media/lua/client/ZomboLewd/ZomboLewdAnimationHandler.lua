--- Animation handler for all lewd things
-- @author QueuedResonance

local AnimationHandler = {}

--- Plays a solo (usually masturbation) animation on this specific character
-- @param worldObjects is a table of all nearby objects
-- @param IsoPlayer character object
-- @param string of the animation name indicated in ZomboLewdAnimationList
function AnimationHandler.PlaySolo(worldObjects, character, animationName)
	character:playEmote(animationName)
end

--- Plays duo animations (usually a sex animation between two individuals) between two characters
-- @param worldObjects is a table of all nearby objects
-- @param IsoPlayer of the first character
-- @param IsoPlayer of the second character
-- @param string of the first animation for which character1 will be playing
-- @param string of the second animation for which character2 will be playing
function AnimationHandler.PlayDuo(worldObjects, character1, character2, animation1, animation2)
	--- TBA, need some animations with two people copulating before I can start this
end

return AnimationHandler