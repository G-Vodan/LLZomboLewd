require "ZomboLewd/ZomboLewdConfig"

--- Setup ModOptions
local ZomboLewdModOptions = {
	options = {
		box1 = true,
		box2 = true,
	},
	names = {
		box1 = getText("IGUI_Ask_Survivor_Sex"),
		box2 = getText("IGUI_Debug_Mode"),
	},
	mod_id = "ZomboLewdFramework",	
	mod_shortname = "Project ZomboLewd Options",
}

ZomboLewdConfig.ModOptions = ZomboLewdModOptions

if ModOptions and ModOptions.getInstance then
	local settings = ModOptions:getInstance(ZomboLewdConfig.ModOptions)

	--- Sandbox/Hide the options in multiplayer
	if isClient() then
		for option, _ in pairs(ZomboLewdModOptions.options) do
			local option = settings:getData(option)
			option.sandbox_path = "ZomboLewdSection"
		end
	end
end