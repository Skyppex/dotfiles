local M = {}

---@param dir "next"|"prev"
local function goto_breakpoint(dir)
	local dap_bps = require("dap.breakpoints").get()

	local bufnr = vim.api.nvim_get_current_buf()
	local current_line = vim.api.nvim_win_get_cursor(0)[1]

	local buffer_bps = dap_bps[bufnr] or {}
	if #buffer_bps == 0 then
		vim.notify("No breakpoints in current buffer", vim.log.levels.WARN)
		return
	end

	local lines = {}
	for _, bp in ipairs(buffer_bps) do
		if bp.line then
			table.insert(lines, bp.line)
		end
	end
	table.sort(lines)

	local target_line

	if dir == "next" then
		for _, l in ipairs(lines) do
			if l > current_line then
				target_line = l
				break
			end
		end
		if not target_line then
			-- already at/after the last breakpoint
			return
			-- or:
			-- vim.notify("No next breakpoint", vim.log.levels.INFO); return
		end
	else -- "prev"
		for i = #lines, 1, -1 do
			local l = lines[i]
			if l < current_line then
				target_line = l
				break
			end
		end
		if not target_line then
			-- already at/before the first breakpoint
			return
			-- or:
			-- vim.notify("No previous breakpoint", vim.log.levels.INFO); return
		end
	end

	vim.api.nvim_win_set_cursor(0, { target_line, 0 })
end

M.dap = function()
	local dap = require("dap")
	dap.set_log_level("INFO")

	require("nvim-dap-virtual-text").setup()

	local map = require("skypex.utils").map
	map("n", "<leader>dr", function()
		dap.continue()
	end, "Continue")

	map("n", "<leader>dl", function()
		dap.step_over()
	end, "Step Over")

	map("n", "<leader>dj", function()
		dap.step_into()
	end, "Step Into")

	map("n", "<leader>dk", function()
		dap.step_out()
	end, "Step Out")

	map("n", "<leader>db", function()
		dap.toggle_breakpoint()
	end, "Toggle Breakpoint")

	map("n", "<leader>dc", function()
		dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
	end, "Set Conditional Breakpoint")

	map("n", "<leader>dB", function()
		dap.clear_breakpoints()
	end, "Clear Breakpoints")

	map("n", "<leader>dp", function()
		dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
	end, "Log Point")

	map("n", "<leader>ds", function()
		dap.terminate()
	end, "Terminate")

	map("n", "<leader>do", function()
		dap.repl.toggle()
	end, "Open REPL")

	map("n", "<leader>dh", function()
		dap.run_last()
	end, "Run Last")

	map("nxo", "æb", function()
		goto_breakpoint("next")
	end, "Goto next breakpoint")

	map("nxo", "åb", function()
		goto_breakpoint("prev")
	end, "Goto previous breakpoint")
end

M.dapui = function()
	local dap, dap_ui = require("dap"), require("dapui")

	dap_ui.setup({
		icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
		mappings = {
			-- Use a table to apply multiple mappings
			expand = { "<CR>", "<2-LeftMouse>" },
			open = "o",
			remove = "d",
			edit = "e",
			repl = "r",
			toggle = "t",
		},
		-- Use this to override mappings for specific elements
		element_mappings = {
			-- Example:
			-- stacks = {
			--   open = "<CR>",
			--   expand = "o",
			-- }
		},
		-- Expand lines larger than the window
		-- Requires >= 0.7
		expand_lines = vim.fn.has("nvim-0.7") == 1,
		-- Layouts define sections of the screen to place windows.
		-- The position can be "left", "right", "top" or "bottom".
		-- The size specifies the height/width depending on position. It can be an Int
		-- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
		-- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
		-- Elements are the elements shown in the layout (in order).
		-- Layouts are opened in order so that earlier layouts take priority in window sizing.
		layouts = {
			{
				elements = {
					-- Elements can be strings or table with id and size keys.
					{ id = "scopes", size = 0.25 },
					"breakpoints",
					"stacks",
					"watches",
				},
				size = 40, -- 40 columns
				position = "left",
			},
			{
				elements = {
					"repl",
					"console",
				},
				size = 0.25, -- 25% of total lines
				position = "bottom",
			},
		},
		controls = {
			-- Requires Neovim nightly (or 0.8 when released)
			enabled = true,
			-- Display controls in this element
			element = "repl",
			icons = {
				pause = "",
				play = "",
				step_into = "↓",
				step_over = "↷",
				step_out = "↑",
				step_back = "",
				run_last = "↻",
				terminate = "■",
			},
		},
		floating = {
			max_height = nil, -- These can be integers or a float between 0 and 1.
			max_width = nil, -- Floats will be treated as percentage of your screen.
			border = "single", -- Border style. Can be "single", "double" or "rounded"
			mappings = {
				close = { "q", "<Esc>" },
			},
		},
		windows = { indent = 1 },
		render = {
			max_type_length = nil, -- Can be integer or nil.
			max_value_lines = 100, -- Can be integer or nil.
		},
	})

	dap.listeners.after.event_initialized["dapui_config"] = function()
		dap_ui.open()
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dap_ui.close()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dap_ui.close()
	end
end

local function get_dll()
	require("skypex.utils").run_command("dotnet", { "build" }, true)

	return coroutine.create(function(dap_run_co)
		local items = vim.fn.globpath(vim.fn.getcwd(), "**/bin/Debug/**/*.dll", 0, 1)
		vim.notify("number of dlls found in CWD '" .. vim.fn.getcwd() .. "': " .. #items)

		local opts = {
			format_item = function(path)
				return vim.fn.fnamemodify(path, ":t")
			end,
		}

		local function cont(choice)
			if choice == nil then
				return nil
			else
				coroutine.resume(dap_run_co, choice)
			end
		end

		vim.ui.select(items, opts, cont)
	end)
end

M.mason = function()
	require("mason-nvim-dap").setup({
		ensure_installed = {
			"coreclr",
			"codelldb",
			"delve",
		},
		automatic_installation = false,
		handlers = {
			function(config)
				-- all sources with no handler get passed here
				-- Keep original functionality
				require("mason-nvim-dap").default_setup(config)
			end,
			coreclr = function(config)
				config.configurations = {
					{
						type = "coreclr",
						name = "NetCoreDbg: Launch",
						request = "launch",
						cwd = "${fileDirname}",
						program = get_dll,
					},
				}
				require("mason-nvim-dap").default_setup(config)
			end,
			codelldb = function(config)
				config.adapters = {
					render = {
						max_type_length = 0,
					},
				}
			end,
		},
	})
end

M.all = function()
	M.dap()
	M.dapui()
	M.mason()
end

M.all()

return M
