local wezterm = require("wezterm")
local utils = require("utils")
local act = wezterm.action
local mux = wezterm.mux

local M = {}

local home = utils.get_home()
local fd = home .. "/scoop/apps/fd/current/fd.exe"
local chezmoi_path = utils.get_chezmoi_path()
local temp_path
local code_path
local code_path_2
local obsidian_path = home .. "/OneDrive/Obsidian"

if utils.is_work_computer() then
	temp_path = home .. "/dev/temp/"
	code_path = home .. "/dev/code/"
	code_path_2 = home .. "/dev/code/commoncarweb"
else
	temp_path = "D:/code/temp/"
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
		"--max-depth=4",
		"--prune",
		temp_path,
		code_path,
		code_path_2,
		chezmoi_path,
		obsidian_path,
		-- add more paths here
	})

	if not success then
		wezterm.log_error("Failed to run fd: " .. stderr)
		return
	end

	for line in stdout:gmatch("([^\n]*)\n?") do
		local project = line:gsub("[\\/].git[\\/]", "")
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
								args = { "nu" },
							},
						}),
						pane
					)

					wezterm.log_info("Switched to workspace " .. id)

					local windows = mux.all_windows()

					local target = nil

					for _, w in ipairs(windows) do
						if w:get_workspace() == id then
							target = w
							break
						end
					end

					-- This should never happen since
					-- we just created the workspace
					if target == nil then
						return
					end

					wezterm.log_info("#win:mux_win:tabs: " .. #win:mux_window():tabs())

					if #target:tabs() <= 1 then
						wezterm.log_info("Creating tab")

						win:perform_action(
							act.SpawnCommandInNewTab({
								cwd = label,
								args = { "nvim" },
							}),
							pane
						)
					end
				end
			end),
		}),
		pane
	)
end

return M
