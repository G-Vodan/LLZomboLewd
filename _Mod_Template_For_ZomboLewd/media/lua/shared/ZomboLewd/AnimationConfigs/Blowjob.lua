require "ZomboLewd/ZomboLewdAnimationList" --- Always include this at the top


ZomboLewdAnimationData["ZomboLewd_Bob_Standing_Blowjob"] = {
	ActType = ZomboLewdActType.Intercourse,

	Animations = {
		Male = "StandingBJM",
		Female = "StandingBJF",
	},
	
	TimedDuration = 500,
	
	IsConsensual = true, --- Used for external mods to determine consensual / non-consensual. Framework will play all animations, regardless of this setting.
	IsZombieAllowed = true, --- Used to determine if zombies are able to use this animation
}