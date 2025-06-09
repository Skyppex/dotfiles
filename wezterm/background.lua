local wezterm = require("wezterm")
local utils = require("utils")
local toml = require("toml")

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
	if utils.is_home_computer_linux() then
		-- find current.toml and read the dir value
		local current_path = config_path .. "/themes/current.toml"
		wezterm.add_to_config_reload_watch_list(current_path)
		local current_file = io.open(current_path, "r")
		local current_content = current_file:read("*a")
		current_file:close()
		local current = toml.parse(current_content)
		wezterm.log_info(current.dir)

		local theme_config_path = config_path .. "/themes/" .. current.dir .. "/config.toml"
		wezterm.add_to_config_reload_watch_list(theme_config_path)
		local theme_config_file = io.open(theme_config_path, "r")
		local theme_config_content = theme_config_file:read("*a")
		theme_config_file:close()
		local theme_config = toml.parse(theme_config_content)
		wezterm.log_info(theme_config.variant)

		-- find the correct background for current theme
		background = {
			source = {
				File = config_path
					.. "/themes/"
					.. current.dir
					.. "/images/"
					.. current.dir
					.. ":"
					.. theme_config.variant
					.. "-v"
					.. "-term"
					.. ".png",
			},
			width = "100%",
			vertical_align = "Bottom",
			repeat_x = "NoRepeat",
			hsb = { brightness = 0.01 },
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
end

return { background }
