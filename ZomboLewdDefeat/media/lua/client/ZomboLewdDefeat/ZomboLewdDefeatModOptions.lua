local ZomboLewdDefeatConfig = ZomboLewdDefeatConfig

--- Setup ModOptions
local ZomboLewdDefeatModOptions = {
	options = {
		dropdown1 = 2,
		dropdown2 = 2,
		box1 = true,
		dropdown3 = 2,
		box2 = true,
		dropdown4 = 2,
		box3 = true,
		dropdown5 = 1,
		box4 = true,
		dropdown6 = 1,
	},
	names = {
		dropdown1 = getText("IGUI_Cooldown_Grabs"),
		dropdown2 = getText("IGUI_Minimum_Scratch"),
		box1 = getText("IGUI_Can_Damage_Belt"),
		dropdown3 = "Belt Condition Damage Value",
		box2 = getText("IGUI_Can_Damage_Pants"),
		dropdown4 = "Pants Condition Damage Value",
		box3 = getText("IGUI_Can_Damage_Tshirt"),
		dropdown5 = "T-Shirt Condition Damage Value",
		box4 = getText("IGUI_Can_Damage_Shoes"),
		dropdown6 = "Shoes Condition Damage Value",
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

	do
		local dropdown = ZomboLewdDefeatModOptions.options_data.dropdown2
		table.insert(dropdown, "10 Scratch Resistance")
		table.insert(dropdown, "20 Scratch Resistance")
		table.insert(dropdown, "30 Scratch Resistance")
		table.insert(dropdown, "40 Scratch Resistance")
		table.insert(dropdown, "50 Scratch Resistance")
		table.insert(dropdown, "60 Scratch Resistance")
		table.insert(dropdown, "70 Scratch Resistance")
		table.insert(dropdown, "80 Scratch Resistance")
		table.insert(dropdown, "90 Scratch Resistance")
		table.insert(dropdown, "100 Scratch Resistance")
	end

	--- CLOTHING DAMAGE
	do
		local dropdown = ZomboLewdDefeatModOptions.options_data.dropdown3
		table.insert(dropdown, "-1 Condition Damage per grab")
		table.insert(dropdown, "-2 Condition Damage per grab")
		table.insert(dropdown, "-3 Condition Damage per grab")
		table.insert(dropdown, "-4 Condition Damage per grab")
		table.insert(dropdown, "-5 Condition Damage per grab")
	end

	do
		local dropdown = ZomboLewdDefeatModOptions.options_data.dropdown4
		table.insert(dropdown, "-1 Condition Damage per grab")
		table.insert(dropdown, "-2 Condition Damage per grab")
		table.insert(dropdown, "-3 Condition Damage per grab")
		table.insert(dropdown, "-4 Condition Damage per grab")
		table.insert(dropdown, "-5 Condition Damage per grab")
	end

	do
		local dropdown = ZomboLewdDefeatModOptions.options_data.dropdown5
		table.insert(dropdown, "-1 Condition Damage per grab")
		table.insert(dropdown, "-2 Condition Damage per grab")
		table.insert(dropdown, "-3 Condition Damage per grab")
		table.insert(dropdown, "-4 Condition Damage per grab")
		table.insert(dropdown, "-5 Condition Damage per grab")
	end

	do
		local dropdown = ZomboLewdDefeatModOptions.options_data.dropdown6
		table.insert(dropdown, "-1 Condition Damage per grab")
		table.insert(dropdown, "-2 Condition Damage per grab")
		table.insert(dropdown, "-3 Condition Damage per grab")
		table.insert(dropdown, "-4 Condition Damage per grab")
		table.insert(dropdown, "-5 Condition Damage per grab")
	end

	ModOptions:loadFile()
end