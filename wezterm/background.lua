-- local wezterm = require("wezterm")
local utils = require("utils")

local config_path = utils.get_config_path()
local background

if utils.is_work_computer() then
	background = {
		source = {
			File = config_path .. "/wezterm/backgrounds/anime landscape 2560x1080.jpg",
		},
		height = "100%",
		vertical_align = "Bottom",
		repeat_x = "NoRepeat",
		hsb = { brightness = 0.02, saturation = 1 },
	}
else
	background = {
		source = {
			File = config_path .. "/wezterm/backgrounds/nier 2b 2250x4000.jpg",
		},
		width = "100%",
		vertical_align = "Bottom",
		repeat_x = "NoRepeat",
		hsb = { brightness = 0.01 },
	}
end

return { background }
