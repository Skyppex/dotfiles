local wezterm = require("wezterm")
local sessionizer = require("sessionizer")
local background = require("background")

local config = {
	audible_bell = "Disabled",
	check_for_updates = false,
	color_scheme = "Andromeda",
	enable_tab_bar = false,
	window_decorations = "RESIZE",
	background = background,
	-- window_background_opacity = 0.5,
	-- win32_system_backdrop = "Tabbed",
	window_padding = {
		left = 2,
		right = 0,
		top = 2,
		bottom = 0,
	},
	inactive_pane_hsb = {
		hue = 1.0,
		saturation = 1.0,
		brightness = 1.0,
	},
	font_size = 10.0,
	launch_menu = {},
	leader = { key = "a", mods = "CTRL" },
	disable_default_key_bindings = true,
	keys = {
		-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
		{ key = "a", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\x01" }) },
		{ key = "r", mods = "CTRL", action = wezterm.action({ SendString = "history-fzf\x0D" }) },
		{ key = ",", mods = "CTRL", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
		{ key = ".", mods = "CTRL", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
		{ key = "z", mods = "LEADER|CTRL", action = "TogglePaneZoomState" },
		{ key = "n", mods = "CTRL", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
		{ key = "n", mods = "SHIFT|CTRL", action = wezterm.action.ShowLauncher },
		{ key = "h", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
		{ key = "j", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
		{ key = "k", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
		{ key = "l", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
		{ key = "H", mods = "CTRL|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }) },
		{ key = "J", mods = "CTRL|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }) },
		{ key = "K", mods = "CTRL|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }) },
		{ key = "L", mods = "CTRL|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }) },
		{ key = "1", mods = "CTRL", action = wezterm.action({ ActivateTab = 0 }) },
		{ key = "2", mods = "CTRL", action = wezterm.action({ ActivateTab = 1 }) },
		{ key = "3", mods = "CTRL", action = wezterm.action({ ActivateTab = 2 }) },
		{ key = "4", mods = "CTRL", action = wezterm.action({ ActivateTab = 3 }) },
		{ key = "5", mods = "CTRL", action = wezterm.action({ ActivateTab = 4 }) },
		{ key = "6", mods = "CTRL", action = wezterm.action({ ActivateTab = 5 }) },
		{ key = "7", mods = "CTRL", action = wezterm.action({ ActivateTab = 6 }) },
		{ key = "8", mods = "CTRL", action = wezterm.action({ ActivateTab = 7 }) },
		{ key = "9", mods = "CTRL", action = wezterm.action({ ActivateTab = 8 }) },
		{ key = "0", mods = "CTRL", action = wezterm.action({ ActivateTab = 9 }) },
		{ key = "1", mods = "CTRL|ALT", action = wezterm.action({ MoveTab = 0 }) },
		{ key = "2", mods = "CTRL|ALT", action = wezterm.action({ MoveTab = 1 }) },
		{ key = "3", mods = "CTRL|ALT", action = wezterm.action({ MoveTab = 2 }) },
		{ key = "4", mods = "CTRL|ALT", action = wezterm.action({ MoveTab = 3 }) },
		{ key = "5", mods = "CTRL|ALT", action = wezterm.action({ MoveTab = 4 }) },
		{ key = "6", mods = "CTRL|ALT", action = wezterm.action({ MoveTab = 5 }) },
		{ key = "7", mods = "CTRL|ALT", action = wezterm.action({ MoveTab = 6 }) },
		{ key = "8", mods = "CTRL|ALT", action = wezterm.action({ MoveTab = 7 }) },
		{ key = "9", mods = "CTRL|ALT", action = wezterm.action({ MoveTab = 8 }) },
		{ key = "0", mods = "CTRL|ALT", action = wezterm.action({ MoveTab = 9 }) },
		{ key = "X", mods = "SHIFT|CTRL", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
		{ key = "x", mods = "CTRL", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },

		{ key = "F", mods = "SHIFT|CTRL", action = "ToggleFullScreen" },
		{ key = "v", mods = "LEADER|CTRL", action = wezterm.action.PasteFrom("Clipboard") },
		{ key = "c", mods = "LEADER|CTRL", action = wezterm.action.CopyTo("Clipboard") },
		{ key = "c", mods = "CTRL", action = wezterm.action.SendString("\x03") },
		{ key = "+", mods = "CTRL", action = "IncreaseFontSize" },
		{ key = "-", mods = "CTRL", action = "DecreaseFontSize" },
		{ key = "'", mods = "CTRL", action = "ResetFontSize" },
		{ key = "PageUp", mods = "SHIFT|ALT", action = wezterm.action.ScrollByPage(-0.1) },
		{ key = "PageDown", mods = "SHIFT|ALT", action = wezterm.action.ScrollByPage(0.1) },
		{ key = "PageUp", mods = "SHIFT", action = wezterm.action.ScrollByLine(-1) },
		{ key = "PageDown", mods = "SHIFT", action = wezterm.action.ScrollByLine(1) },
		{ key = "f", mods = "CTRL", action = wezterm.action_callback(sessionizer.toggle) },

		{ key = "i", mods = "CTRL|ALT", action = wezterm.action.ActivateCopyMode },

		{
			key = "h",
			mods = "LEADER|CTRL",
			action = wezterm.action.QuickSelectArgs({
				label = "open url",
				patterns = {
					"https?://\\S+",
					"github.com:.*.git",
				},
				action = wezterm.action_callback(function(window, pane)
					local url = window:get_selection_text_for_pane(pane)

					if url:find("github.com") then
						url = url:gsub("github.com:", "")
						url = url:gsub(".git", "")
						url = "https://github.com/" .. url
					end
					wezterm.open_with(url)
				end),
			}),
		},
	},
	key_tables = {
		copy_mode = {
			{ key = "Tab", mods = "NONE", action = wezterm.action.CopyMode("MoveForwardWord") },
			{
				key = "Tab",
				mods = "SHIFT",
				action = wezterm.action.CopyMode("MoveBackwardWord"),
			},
			{
				key = "Enter",
				mods = "NONE",
				action = wezterm.action.CopyMode("MoveToStartOfNextLine"),
			},
			{
				key = "Space",
				mods = "NONE",
				action = wezterm.action.CopyMode({ SetSelectionMode = "Cell" }),
			},
			{
				key = "$",
				mods = "NONE",
				action = wezterm.action.CopyMode("MoveToEndOfLineContent"),
			},
			{
				key = "$",
				mods = "SHIFT",
				action = wezterm.action.CopyMode("MoveToEndOfLineContent"),
			},
			{ key = ",", mods = "NONE", action = wezterm.action.CopyMode("JumpReverse") },
			{ key = "0", mods = "NONE", action = wezterm.action.CopyMode("MoveToStartOfLine") },
			{ key = ";", mods = "NONE", action = wezterm.action.CopyMode("JumpAgain") },
			{
				key = "F",
				mods = "NONE",
				action = wezterm.action.CopyMode({ JumpBackward = { prev_char = false } }),
			},
			{
				key = "F",
				mods = "SHIFT",
				action = wezterm.action.CopyMode({ JumpBackward = { prev_char = false } }),
			},
			{
				key = "G",
				mods = "NONE",
				action = wezterm.action.CopyMode("MoveToScrollbackBottom"),
			},
			{
				key = "G",
				mods = "SHIFT",
				action = wezterm.action.CopyMode("MoveToScrollbackBottom"),
			},
			{
				key = "M",
				mods = "NONE",
				action = wezterm.action.CopyMode("MoveToViewportMiddle"),
			},
			{
				key = "M",
				mods = "SHIFT",
				action = wezterm.action.CopyMode("MoveToViewportMiddle"),
			},
			{
				key = "O",
				mods = "NONE",
				action = wezterm.action.CopyMode("MoveToSelectionOtherEndHoriz"),
			},
			{
				key = "O",
				mods = "SHIFT",
				action = wezterm.action.CopyMode("MoveToSelectionOtherEndHoriz"),
			},
			{
				key = "T",
				mods = "NONE",
				action = wezterm.action.CopyMode({ JumpBackward = { prev_char = true } }),
			},
			{
				key = "T",
				mods = "SHIFT",
				action = wezterm.action.CopyMode({ JumpBackward = { prev_char = true } }),
			},
			{
				key = "V",
				mods = "NONE",
				action = wezterm.action.CopyMode({ SetSelectionMode = "Line" }),
			},
			{
				key = "V",
				mods = "SHIFT",
				action = wezterm.action.CopyMode({ SetSelectionMode = "Line" }),
			},
			{
				key = "^",
				mods = "NONE",
				action = wezterm.action.CopyMode("MoveToStartOfLineContent"),
			},
			{
				key = "^",
				mods = "SHIFT",
				action = wezterm.action.CopyMode("MoveToStartOfLineContent"),
			},
			{ key = "b", mods = "NONE", action = wezterm.action.CopyMode("MoveBackwardWord") },
			{ key = "b", mods = "ALT", action = wezterm.action.CopyMode("MoveBackwardWord") },
			{ key = "b", mods = "CTRL", action = wezterm.action.CopyMode("PageUp") },
			{
				key = "c",
				mods = "CTRL",
				action = wezterm.action.CopyMode("Close"),
			},
			{
				key = "d",
				mods = "CTRL",
				action = wezterm.action.CopyMode({ MoveByPage = 0.5 }),
			},
			{
				key = "e",
				mods = "NONE",
				action = wezterm.action.CopyMode("MoveForwardWordEnd"),
			},
			{
				key = "f",
				mods = "NONE",
				action = wezterm.action.CopyMode({ JumpForward = { prev_char = false } }),
			},
			{ key = "f", mods = "ALT", action = wezterm.action.CopyMode("MoveForwardWord") },
			{ key = "f", mods = "CTRL", action = wezterm.action.CopyMode("PageDown") },
			{
				key = "g",
				mods = "NONE",
				action = wezterm.action.CopyMode("MoveToScrollbackTop"),
			},
			{ key = "h", mods = "NONE", action = wezterm.action.CopyMode("MoveLeft") },
			{ key = "j", mods = "NONE", action = wezterm.action.CopyMode("MoveUp") },
			{ key = "k", mods = "NONE", action = wezterm.action.CopyMode("MoveDown") },
			{ key = "l", mods = "NONE", action = wezterm.action.CopyMode("MoveRight") },
			{
				key = "m",
				mods = "ALT",
				action = wezterm.action.CopyMode("MoveToStartOfLineContent"),
			},
			{
				key = "o",
				mods = "NONE",
				action = wezterm.action.CopyMode("MoveToSelectionOtherEnd"),
			},
			{
				key = "t",
				mods = "NONE",
				action = wezterm.action.CopyMode({ JumpForward = { prev_char = true } }),
			},
			{
				key = "u",
				mods = "CTRL",
				action = wezterm.action.CopyMode({ MoveByPage = -0.5 }),
			},
			{
				key = "v",
				mods = "NONE",
				action = wezterm.action.CopyMode({ SetSelectionMode = "Cell" }),
			},
			{
				key = "v",
				mods = "CTRL",
				action = wezterm.action.CopyMode({ SetSelectionMode = "Block" }),
			},
			{ key = "w", mods = "NONE", action = wezterm.action.CopyMode("MoveForwardWord") },
			{
				key = "y",
				mods = "NONE",
				action = wezterm.action.CopyTo("Clipboard"),
			},
		},
	},
	set_environment_variables = {},
}

wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = false
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	-- config.front_end = "Software" -- OpenGL doesn't work quite well with RDP.

	config.default_prog = { "nu" }
	table.insert(config.launch_menu, { label = "nu", args = { "nu" } })
	table.insert(config.launch_menu, { label = "powershell", args = { "powershell.exe", "-NoLogo" } })

	-- Find installed visual studio version(s) and add their compilation
	-- environment command prompts to the menu
	for _, vsvers in ipairs(wezterm.glob("Microsoft Visual Studio/20*", "C:/Program Files (x86)")) do
		local year = vsvers:gsub("Microsoft Visual Studio/", "")
		table.insert(config.launch_menu, {
			label = "x64 Native Tools VS " .. year,
			args = {
				"cmd.exe",
				"/k",
				"C:/Program Files (x86)/" .. vsvers .. "/BuildTools/VC/Auxiliary/Build/vcvars64.bat",
			},
		})
	end
else
	config.default_prog = { "nu" }
	table.insert(config.launch_menu, { label = "nu", args = { "nu" } })
end

config.scrollback_lines = 3500

return config
