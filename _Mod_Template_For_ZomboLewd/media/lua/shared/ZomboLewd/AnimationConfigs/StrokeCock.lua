require "ZomboLewd/ZomboLewdAnimationList" --- Always include this at the top

ZomboLewdAnimationData["ZomboLewd_Bob_Stroke_Cock"] = {

	ActType = ZomboLewdActType.Masturbation,

	Animations = {
		Male = "StrokeCock",
	},
	
	TimedDuration = 300,

	IsConsensual = true, --- Used for external mods to determine consensual / non-consensual. Framework will play all animations, regardless of this setting.
	IsZombieAllowed = false, --- Used to determine if zombies are able to use this animation
}