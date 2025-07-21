function string:starts_with(start)
	-- It does indeed work even though the linter complains
	---@diagnostic disable-next-line: param-type-mismatch
	return self:sub(1, #start) == start
end

local wezterm = require("wezterm")
local sessionizer = require("sessionizer")
wezterm.log_info("Loaded sessionizer")
local background = require("background")
local utils = require("utils")

local act = wezterm.action

local config = {
	max_fps = 165,
	scrollback_lines = 10000,
	quick_select_alphabet = "hjklyuioasdfqwer",
	audible_bell = "Disabled",
	check_for_updates = false,
	color_scheme = "Andromeda",
	enable_tab_bar = false,
	window_decorations = utils.is_linux_desktop() and "NONE" or "RESIZE",
	background = background,
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
		{ key = "a", mods = "LEADER|CTRL", action = act({ SendString = "\x01" }) },
		{
			key = "w",
			mods = "LEADER|CTRL",
			action = wezterm.action_callback(function(window, pane)
				window:perform_action(act.ActivateTabRelative(1), pane)
				local win = window:mux_window()
				local tabs = win:tabs()

				if #tabs == 1 then
					wezterm.log_info("Creating tab")
					local tab = tabs[1]

					if tab:get_title() == nil or tab:get_title() == "" then
						tab:set_title("nu")
					end

					wezterm.log_info("Tab " .. tab:get_title())

					local prog

					if tab:get_title() == "nu" then
						prog = "nvim"
					else
						prog = "nu"
					end

					wezterm.log_info(window:window_id())

					window:perform_action(
						act.SpawnCommandInNewTab({
							label = prog,
							args = { prog },
						}),
						pane
					)

					win:tabs()[2]:set_title(prog)
				end
			end),
		},
		{
			key = "d",
			mods = "LEADER|CTRL",
			action = act.SendString(utils.is_home_computer_linux() and "clear\n" or "clear\r\n"),
		},
		{ key = " ", mods = "CTRL", action = act({ SendString = "\x00" }) },
		{ key = ",", mods = "CTRL", action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
		{ key = ".", mods = "CTRL", action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
		{ key = "z", mods = "LEADER|CTRL", action = "TogglePaneZoomState" },
		{ key = "n", mods = "SHIFT|CTRL", action = act.ShowLauncher },
		{ key = "h", mods = "CTRL", action = act({ ActivatePaneDirection = "Left" }) },
		{ key = "j", mods = "CTRL", action = act({ ActivatePaneDirection = "Down" }) },
		{ key = "k", mods = "CTRL", action = act({ ActivatePaneDirection = "Up" }) },
		{ key = "l", mods = "CTRL", action = act({ ActivatePaneDirection = "Right" }) },
		{ key = "H", mods = "CTRL|SHIFT", action = act({ AdjustPaneSize = { "Left", 5 } }) },
		{ key = "J", mods = "CTRL|SHIFT", action = act({ AdjustPaneSize = { "Down", 5 } }) },
		{ key = "K", mods = "CTRL|SHIFT", action = act({ AdjustPaneSize = { "Up", 5 } }) },
		{ key = "L", mods = "CTRL|SHIFT", action = act({ AdjustPaneSize = { "Right", 5 } }) },
		{
			key = "h",
			mods = "CTRL|ALT",
			action = act.PaneSelect({
				mode = "SwapWithActive",
			}),
		},
		{ key = "X", mods = "SHIFT|CTRL", action = act({ CloseCurrentTab = { confirm = true } }) },
		{ key = "x", mods = "CTRL", action = act({ CloseCurrentPane = { confirm = true } }) },
		-- { key = "v", mods = "LEADER|CTRL", action = wezterm.action_callback(
		-- 	function(_, _)
		-- 		if utils.is_home_computer_linux() then
		-- 			wezterm.log_info("10000")
		-- 			local success, stdout, stderr = wezterm.run_child_process({ "wl-paste" })
		-- 			wezterm.log_info("10001")
		-- 			wezterm.log_info(success)
		--
		-- 			if not success then
		-- 				wezterm.log_info("10002")
		-- 				wezterm.log_info(stderr)
		-- 				wezterm.log_error("Failed to run wl-paste: " .. stderr)
		-- 				return nil
		-- 			end
		--
		-- 			stdout = stdout:gsub("%s+$", "")
		-- 			wezterm.log_info("10003")
		-- 			wezterm.log_info(stdout)
		-- 			return act.SendString(stdout)
		-- 		else
		-- 			wezterm.log_info("10004")
		-- 			return act.PasteFrom("Clipboard")
		-- 		end
		-- 	end)
		-- },
		{ key = "v", mods = "LEADER|CTRL", action = act.PasteFrom("Clipboard") },
		{ key = "c", mods = "LEADER|CTRL", action = act.CopyTo("Clipboard") },
		{ key = "c", mods = "CTRL", action = act.SendString("\x03") },
		{ key = "+", mods = "LEADER|CTRL", action = "IncreaseFontSize" },
		{ key = "-", mods = "LEADER|CTRL", action = "DecreaseFontSize" },
		{ key = "'", mods = "CTRL", action = "ResetFontSize" },
		{ key = "PageUp", mods = "SHIFT|ALT", action = act.ScrollByPage(-0.1) },
		{ key = "PageDown", mods = "SHIFT|ALT", action = act.ScrollByPage(0.1) },
		{ key = "PageUp", mods = "SHIFT", action = act.ScrollByLine(-1) },
		{ key = "PageDown", mods = "SHIFT", action = act.ScrollByLine(1) },
		{ key = "f", mods = "CTRL", action = wezterm.action_callback(sessionizer.toggle) },

		{ key = "i", mods = "LEADER|CTRL", action = act.ActivateCopyMode },
		{
			key = "h",
			mods = "LEADER|CTRL",
			action = act.QuickSelectArgs({
				label = "open url",
				patterns = {
					"https?://\\S+",
					"github\\.com:.*\\.git",
					'".*/.*"',
				},
				action = wezterm.action_callback(function(window, pane)
					local url = window:get_selection_text_for_pane(pane)

					if url:starts_with("github.com") then
						url = url:gsub("github.com:", "")
						url = url:gsub(".git", "")
						url = "https://github.com/" .. url
					end
					wezterm.open_with(url)
				end),
			}),
		},
		{
			key = "/",
			mods = "LEADER|SHIFT",
			action = act.Search({
				Regex = "",
			}),
		},
	},
	key_tables = {
		copy_mode = {
			{ key = "Tab", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
			{
				key = "Tab",
				mods = "SHIFT",
				action = act.CopyMode("MoveBackwardWord"),
			},
			{
				key = "Enter",
				mods = "NONE",
				action = act.CopyMode("MoveToStartOfNextLine"),
			},
			{
				key = "Space",
				mods = "NONE",
				action = act.CopyMode({ SetSelectionMode = "Cell" }),
			},
			{
				key = "$",
				mods = "NONE",
				action = act.CopyMode("MoveToEndOfLineContent"),
			},
			{
				key = "$",
				mods = "SHIFT",
				action = act.CopyMode("MoveToEndOfLineContent"),
			},
			{ key = ",", mods = "NONE", action = act.CopyMode("JumpReverse") },
			{ key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
			{ key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
			{
				key = "F",
				mods = "NONE",
				action = act.CopyMode({ JumpBackward = { prev_char = false } }),
			},
			{
				key = "F",
				mods = "SHIFT",
				action = act.CopyMode({ JumpBackward = { prev_char = false } }),
			},
			{
				key = "G",
				mods = "NONE",
				action = act.CopyMode("MoveToScrollbackBottom"),
			},
			{
				key = "G",
				mods = "SHIFT",
				action = act.CopyMode("MoveToScrollbackBottom"),
			},
			{
				key = "M",
				mods = "NONE",
				action = act.CopyMode("MoveToViewportMiddle"),
			},
			{
				key = "M",
				mods = "SHIFT",
				action = act.CopyMode("MoveToViewportMiddle"),
			},
			{
				key = "O",
				mods = "NONE",
				action = act.CopyMode("MoveToSelectionOtherEndHoriz"),
			},
			{
				key = "O",
				mods = "SHIFT",
				action = act.CopyMode("MoveToSelectionOtherEndHoriz"),
			},
			{
				key = "T",
				mods = "NONE",
				action = act.CopyMode({ JumpBackward = { prev_char = true } }),
			},
			{
				key = "T",
				mods = "SHIFT",
				action = act.CopyMode({ JumpBackward = { prev_char = true } }),
			},
			{
				key = "V",
				mods = "NONE",
				action = act.CopyMode({ SetSelectionMode = "Line" }),
			},
			{
				key = "V",
				mods = "SHIFT",
				action = act.CopyMode({ SetSelectionMode = "Line" }),
			},
			{
				key = "^",
				mods = "NONE",
				action = act.CopyMode("MoveToStartOfLineContent"),
			},
			{
				key = "^",
				mods = "SHIFT",
				action = act.CopyMode("MoveToStartOfLineContent"),
			},
			{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
			{ key = "b", mods = "ALT", action = act.CopyMode("MoveBackwardWord") },
			{ key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
			{
				key = "c",
				mods = "CTRL",
				action = act.CopyMode("Close"),
			},
			{
				key = "d",
				mods = "CTRL",
				action = act.CopyMode({ MoveByPage = 0.5 }),
			},
			{
				key = "e",
				mods = "NONE",
				action = act.CopyMode("MoveForwardWordEnd"),
			},
			{
				key = "f",
				mods = "NONE",
				action = act.CopyMode({ JumpForward = { prev_char = false } }),
			},
			{ key = "f", mods = "ALT", action = act.CopyMode("MoveForwardWord") },
			{ key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
			{
				key = "g",
				mods = "NONE",
				action = act.CopyMode("MoveToScrollbackTop"),
			},
			{ key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
			{ key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
			{ key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
			{ key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
			{
				key = "m",
				mods = "ALT",
				action = act.CopyMode("MoveToStartOfLineContent"),
			},
			{
				key = "o",
				mods = "NONE",
				action = act.CopyMode("MoveToSelectionOtherEnd"),
			},
			{
				key = "t",
				mods = "NONE",
				action = act.CopyMode({ JumpForward = { prev_char = true } }),
			},
			{
				key = "u",
				mods = "CTRL",
				action = act.CopyMode({ MoveByPage = -0.5 }),
			},
			{
				key = "v",
				mods = "NONE",
				action = act.CopyMode({ SetSelectionMode = "Cell" }),
			},
			{
				key = "v",
				mods = "CTRL",
				action = act.CopyMode({ SetSelectionMode = "Block" }),
			},
			{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
			{
				key = "y",
				mods = "NONE",
				action = act.CopyTo("Clipboard"),
			},
		},
	},
	set_environment_variables = {
		DOTNET_ROOT = utils.get_home() .. "/.nix-profile/share/dotnet",
	},
}

wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(act.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(act.ResetFontSize, pane)
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
	config.default_cwd = "~"
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

return config
