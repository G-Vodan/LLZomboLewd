require "ZomboLewd/ZomboLewdConfig" --- Always include this at the top to forceload ZomboLewd prior to this animation file

table.insert(ZomboLewdAnimationData, {
	prefix = "ZomboLewd_",
	id = "Standing_Fuck",
	tags = {"StandingFuck", "Sex", "MF", "Anal"},
	actors = {
		{
			gender = "Female",
			stages = {
				{
					perform = "StandingFuckF",
					duration = 1000
				}
			}
		},
		{
			gender = "Male",
			stages = {
				{
					perform = "StandingFuckM",
					duration = 1000
				}
			}
		}
	}
})