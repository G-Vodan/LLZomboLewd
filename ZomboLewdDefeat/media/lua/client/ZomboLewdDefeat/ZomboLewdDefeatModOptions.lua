local ZomboLewdDefeat = require("ZomboLewdDefeat/ZomboLewdDefeat")
local ZomboLewdDefeatConfig = ZomboLewdDefeatConfig

--- Setup ModOptions
local ZomboLewdDefeatModOptions = {
	options = {
		dropdown1 = 2,
		dropdown2 = 1,
		box1 = true,
		box2 = true,
		box3 = true,
		box4 = true,
		dropdown3 = 5
	},
	names = {
		dropdown1 = getText("IGUI_Cooldown_Grabs"),
		dropdown2 = getText("IGUI_Condition_Damage"),
		box1 = getText("IGUI_Disable_Equipment_Top_Damage"),
		box2 = getText("IGUI_Disable_Equipment_Bottom_Damage"),
		box3 = getText("IGUI_Disable_Equipment_Full_Damage"),
		box4 = getText("IGUI_Disable_Equipment_Hole_Damage"),
		dropdown3 = getText("IGUI_Hole_Damage_Value")
	},
	mod_id = "ZombolewdDefeat",	
	mod_shortname = "ZomboLewd Defeat Options",
}

ZomboLewdDefeatConfig.ModOptions = ZomboLewdDefeatModOptions

if ModOptions and ModOptions.getInstance then
	ModOptions:getInstance(ZomboLewdDefeatConfig.ModOptions)

	--- Initialize options
	do
		local dropdown = ZomboLewdDefeatModOptions.options_data.dropdown1
		table.insert(dropdown, "0 Ticks")
		table.insert(dropdown, "200 Ticks")
		table.insert(dropdown, "400 Ticks")
		table.insert(dropdown, "600 Ticks")
		table.insert(dropdown, "800 Ticks")
		table.insert(dropdown, "1000 Ticks")
		table.insert(dropdown, "1200 Ticks")
		table.insert(dropdown, "1400 Ticks")
		table.insert(dropdown, "1600 Ticks")
		table.insert(dropdown, "1800 Ticks")
		table.insert(dropdown, "2000 Ticks")
	end

	--- CLOTHING DAMAGE
	do
		local dropdown = ZomboLewdDefeatModOptions.options_data.dropdown2
		table.insert(dropdown, "-1 Condition Damage")
		table.insert(dropdown, "-2 Condition Damage")
		table.insert(dropdown, "-3 Condition Damage")
		table.insert(dropdown, "-4 Condition Damage")
		table.insert(dropdown, "-5 Condition Damage")
	end

	--- CLOTHING HOLES
	do
		local dropdown = ZomboLewdDefeatModOptions.options_data.dropdown3
		table.insert(dropdown, "10%")
		table.insert(dropdown, "20%")
		table.insert(dropdown, "30%")
		table.insert(dropdown, "40%")
		table.insert(dropdown, "50%")
		table.insert(dropdown, "60%")
		table.insert(dropdown, "70%")
		table.insert(dropdown, "80%")
		table.insert(dropdown, "90%")
		table.insert(dropdown, "100%")
	end

	ModOptions:loadFile()
end