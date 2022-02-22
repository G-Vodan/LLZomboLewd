require "ZomboLewd/ZomboLewdConfig" --- Always include this at the top to forceload ZomboLewd prior to this animation file

table.insert(ZomboLewdAnimationData, {
	prefix = "ZomboLewd_",
	id = "Blowjob",
	tags = {"Blowjob", "Sex", "MF"},
	actors = {
		{
			gender = "Female",
			stages = {
				{
					perform = "StandingBJF",
					duration = 1000
				}
			}
		},
		{
			gender = "Male",
			stages = {
				{
					perform = "StandingBJM",
					duration = 1000
				}
			}
		}
	}
})