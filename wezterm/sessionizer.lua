local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local home_drive = os.getenv("HOMEDRIVE")
local home_path = os.getenv("HOMEPATH")
local home = home_drive .. home_path
local fd = home .. "/scoop/apps/fd/current/fd.exe"
local code_path
local code_path_2
local config_path = home .. "/.config"

if home == nil then
	home = "C:/Users/brage"
end
wezterm.log_info("Home: " .. home)
if home:find("brage.ingebrigtsen") then
	code_path = home .. "/dev/code/"
	code_path_2 = home .. "/dev/code/commoncarweb"
else
	code_path = "D:/code/"
	code_path_2 = "D:/code/sentinel/commoncarweb"
end

M.toggle = function(window, pane)
	local projects = {}

	local success, stdout, stderr = wezterm.run_child_process({
		fd,
		"-HI",
		"-td",
		"^.git$",
		"--max-depth=3",
		"--prune",
		code_path,
		code_path_2,
		config_path,
		-- add more paths here
	})

	if not success then
		wezterm.log_error("Failed to run fd: " .. stderr)
		return
	end

	for line in stdout:gmatch("([^\n]*)\n?") do
		local project = line:gsub("\\.git\\", "")
		local label = project
		local id = project:gsub(".*/", "")
		table.insert(projects, { label = tostring(label), id = tostring(id) })
	end

	window:perform_action(
		act.InputSelector({
			fuzzy = true,
			title = "Select project",
			choices = projects,
			action = wezterm.action_callback(function(win, _, id, label)
				if not id and not label then
					wezterm.log_info("Cancelled")
				else
					wezterm.log_info("Selected " .. label)
					win:perform_action(
						act.SwitchToWorkspace({
							name = id,
							spawn = {
								cwd = label,
								args = { "nvim" },
							},
						}),
						pane
					)
				end
			end),
		}),
		pane
	)
end

return M
