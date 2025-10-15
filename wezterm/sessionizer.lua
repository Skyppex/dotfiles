local wezterm = require("wezterm")
local utils = require("utils")
local act = wezterm.action
local mux = wezterm.mux

local M = {}

local home = utils.get_home()
local chezmoi_path = utils.get_chezmoi_path()
local temp_path = utils.get_temp_path()
local code_path = utils.get_code_path()
local carweb_path
local obsidian_path
local game_dev_path = utils.get_game_dev_path()

if utils.is_home_computer_windows() then
	carweb_path = code_path .. "/sentinel/commoncarweb"
	obsidian_path = home .. "/OneDrive/Obsidian"
else
	carweb_path = code_path .. "/commoncarweb"
	obsidian_path = home .. "/obsidian"
end

M.toggle = function(window, pane)
	local projects = {}

	local fd_process = {
		"fd",
		"-HI",
		"-td",
		"^.git$",
		"--max-depth=4",
		"--prune",
		temp_path,
		code_path,
		carweb_path,
		chezmoi_path,
		obsidian_path,
		-- add more paths here
	}

	if game_dev_path ~= nil then
		table.insert(fd_process, game_dev_path)
	end

	local success, stdout, stderr = wezterm.run_child_process(fd_process)

	if not success then
		wezterm.log_error("Failed to run fd: " .. stderr)
		return
	end

	for line in stdout:gmatch("([^\n]*)\n?") do
		local project = line:gsub("[\\/].git[\\/]", ""):gsub("\\", "/")
		local label = project
		local id = project:gsub(".*/", "")
		projects[tostring(label)] = tostring(id)
	end

	local choices = {}

	for k, v in pairs(projects) do
		table.insert(choices, { label = k, id = v })
	end

	window:perform_action(
		act.InputSelector({
			fuzzy = true,
			title = "Select project",
			choices = choices,
			action = wezterm.action_callback(function(win, _, id, label)
				if not id and not label then
					wezterm.log_info("Cancelled")
				else
					wezterm.log_info("Selected " .. label)
					wezterm.log_info("Id " .. id)

					local nu_args = { "nu" }
					local nvim_args = { "nvim" }

					win:perform_action(
						act.SwitchToWorkspace({
							name = id,
							spawn = {
								label = "nu",
								cwd = label,
								args = nu_args,
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

					if #target:tabs() == 1 then
						wezterm.log_info("Creating tab")

						local tab = target:tabs()[1]

						if tab:get_title() == nil or tab:get_title() == "" then
							tab:set_title("nu")
						end

						wezterm.log_info("Tab " .. tab:get_title())

						local prog
						local args

						if tab:get_title() == "nu" then
							prog = "nvim"
							args = nvim_args
						else
							prog = "nu"
							args = nu_args
						end

						win:perform_action(
							act.SpawnCommandInNewTab({
								label = prog,
								cwd = label,
								args = args,
							}),
							pane
						)

						target:tabs()[2]:set_title(prog)

						if prog == "nu" then
							target:gui_window():perform_action(act.ActivateTabRelative(1), pane)
						end
					end
				end
			end),
		}),
		pane
	)
end

M.create_session_hook = function()
	wezterm.on("gui-attached", function()
		local window = mux.all_windows()[1]

		if not window then
			wezterm.log_info("No initial window found")
			return
		end

		local tab = window:tabs()[1]
		local pane = tab:active_pane()

		local cwd = pane:get_current_working_dir().file_path

		wezterm.log_info(cwd)

		if not cwd then
			wezterm.log_info("No CWD detected for pane")
			return
		end

		local id = utils.basename(cwd)

		wezterm.log_info("Rebinding default tab to workspace " .. id)
		window:set_workspace(id)

		-- Update the workspace name
		window:set_workspace(id)

		-- Update the tab title to indicate Nu shell
		tab:set_title("nu")

		local nvim_tab, _, _ = window:spawn_tab({
			args = { "nvim" },
			cwd = cwd,
		})

		nvim_tab:set_title("nvim")
	end)
end

return M
