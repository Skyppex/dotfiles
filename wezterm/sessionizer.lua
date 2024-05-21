local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local fd = "C:/Users/brage.ingebrigtsen/scoop/apps/fd/current/fd.exe"
local rootPath = "C:/Users/brage.ingebrigtsen/dev/code"
local rootPath2 = "C:/Users/brage.ingebrigtsen/.config"

M.toggle = function(window, pane)
	local projects = {}

	local success, stdout, stderr = wezterm.run_child_process({
		fd,
		"-HI",
		"-td",
		"^.git$",
		"--max-depth=4",
		"--prune",
		rootPath,
		rootPath2,
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
								args = { "nvim", "." },
							},
						}),
						pane
					)
					-- pane:send_text("vim .\r\n")
				end
			end),
			fuzzy = true,
			title = "Select project",
			choices = projects,
		}),
		pane
	)
end

return M
