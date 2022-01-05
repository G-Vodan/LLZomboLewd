local ZomboLewdConfig = ZomboLewdConfig

--- Setup ModOptions
local ZomboLewdModOptions = {
	options = {
		box1 = true,
		box2 = false,
	},
	names = {
		box1 = getText("IGUI_Ask_Survivor_Sex"),
		box2 = getText("IGUI_Debug_Mode"),
	},
	mod_id = "ZomboLewd",	
	mod_shortname = "Project ZomboLewd Options",
}

ZomboLewdConfig.ModOptions = ZomboLewdModOptions

if ModOptions and ModOptions.getInstance then
	ModOptions:getInstance(ZomboLewdConfig.ModOptions)
	ModOptions:loadFile()
end