require "ZomboLewd/ZomboLewdAnimationList" --- Always include this at the top

--[[
	SEX_ACT_NAME is a unique identifier for the framework to use when choosing this animation. It serves no
	purpose other than to index it. Make sure this value is unique. if another animation sex mod uses the same SEX_ACT_NAME,
	it may potentially overwrite your own animation. A good way to make it unique is to include your creator name and the sex act name.
	It will also help organize and separate your own animations from the others.

	Example:
			ZomboLewdAnimationList["QueuedResonance_Doggy_Style"] = {
]]

ZomboLewdAnimationData["SEX_ACT_NAME"] = {
	--[[
		Determines the type of sex act this animation is. Here are some values you can set on this parameter:
				ZomboLewdActType.Masturbation
				ZomboLewdActType.Intercourse
	
		Refer to shared/ZomboLewd/ZomboLewdAnimationList for more Act types you can set. If the ActType is Intercourse, make sure
		you have another 
	]]
	ActType = ZomboLewdActType.Intercourse,

	--[[
		ANIMATION_STRING_NAME should be the same value as your animation's xml PerformingAction string.

		Your XML file should have these values:
				<m_Name>PerformingAction</m_Name>
				<m_Type>STRING</m_Type>
				<m_StringValue>ANIMATION_STRING_NAME</m_StringValue>  <--- USE THIS FOR ANIMATION_STRING_NAME

		-------------------------------------------------------------------------------------------------------

		You can optionally erase the Male or Female line in Animations to prevent the framework from using this animation for that
		specific gender.

		Example:
				Animations = {
					Male = "Bob_Stroke_Cock", --- Only men can play this since Female is omitted
				}

		-------------------------------------------------------------------------------------------------------

		Optional: Translation for masturbation acts
			If the ActType is ZomboLewd.Masturbation, make sure to add your english and relevant language to the shared/Translate since the
			ContextMenu needs it to display the correct text.

			Proper format in shared/Translate to display properly:
					ContextMenu_Masturbation_ANIMATION_STRING_NAME = "Text Here"
	]]
	Animations = {
		Male = "ANIMATION_STRING_NAME",
		Female = "ANIMATION_STRING_NAME",
	},
	
	--[[
		TimedDuration specifies how long you want this animation to play during the TimedAction sequences. TimedActions are the green
		progress bar you see on top of your head whenever you do an action that requires "time" to complete. TimedDuration does not
		necessarily equal to the actual animation length (but you can make it so if you like). If TimedDuration is longer than the
		actual animation length itself, the animation will loop (useful if you want to make a looping animation without animating the entire thing)

		If the ActType is not Masturbation (so pretty much 2+ actors), make sure all animations are of the same length when exporting, else
		you risk them desyncing
	]]
	TimedDuration = 300,
	
	--[[
		Boolean values. These only take true or false (yes, with all lowercase).
	]]
	IsConsensual = true, --- Used for external mods to determine consensual / non-consensual. Framework will play all animations, regardless of this setting.
	IsZombieAllowed = true, --- Used to determine if zombies are able to use this animation
}