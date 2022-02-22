require "ZomboLewd/ZomboLewdConfig" --- Always include this at the top to forceload ZomboLewd prior to this animation file

--[[
	prefix: this word will be combined with id to create a unique identifier. Recommend using your name here (ie. prefix = "QueuedResonance_")
	id: the id of the animation used to fetch its name, will differ depending on the user's language.
	tags: a list of tags, can be custom or established, such as "Masturbation", "Aggressive", etc. Used for mods to determine animations
	actors: a list of actors in the animation. 
		gender: the gender of the actor in this scene
		stages: a list of animations to be played in order
	
			perform: 
				Your XML file should have these values:
				<m_Name>PerformingAction</m_Name>
				<m_Type>STRING</m_Type>
				<m_StringValue>ANIMATION_STRING_NAME</m_StringValue>  <--- USE THIS FOR PERFORM
			
			duration: specifies how long you want this animation to play during the TimedAction sequences. TimedActions are the green
				progress bar you see on top of your head whenever you do an action that requires "time" to complete. Duration does not
				necessarily equal to the actual animation length (but you can make it so if you like). If Duration is longer than the
				actual animation length itself, the animation will loop (useful if you want to make a looping animation without animating the entire thing)
]]

table.insert(ZomboLewdAnimationData, {
	prefix = "Prefix_",
	id = "Sex_Act_Name",
	tags = {"Masturbation", "MyTag"},
	actors = {
		{
			gender = "Female",
			stages = {
				{
					perform = "ANIMATION_STRING_NAME",
					duration = 300
				}
			}
		},
		{
			gender = "Male",
			stages = {
				{
					perform = "ANIMATION_STRING_NAME",
					duration = 300
				}
			}
		}
	}
})