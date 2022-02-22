require "ZomboLewd/ZomboLewdConfig" --- Always include this at the top to forceload ZomboLewd prior to this animation file

table.insert(ZomboLewdAnimationData, {
	prefix = "ZomboLewd_",
	id = "Sit_Fuck",
	tags = {"Sitfuck", "Sex", "MF", "Vaginal"},
	actors = {
		{
			gender = "Female",
			stages = {
				{
					perform = "SitFuckF",
					duration = 1000
				}
			}
		},
		{
			gender = "Male",
			stages = {
				{
					perform = "SitFuckM",
					duration = 1000
				}
			}
		}
	}
})