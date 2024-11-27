local M = {}

M.dap = function()
	local dap = require("dap")
	dap.set_log_level("TRACE")

	--
	-- dap.adapters.coreclr = {
	-- 	type = "executable",
	-- 	command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg.cmd",
	-- 	args = { "--interpreter=vscode", "--engineLogging=~/netcoredbg.log" },
	-- }
	--
	-- dap.configurations.cs = {
	-- 	{
	-- 		type = "coreclr",
	-- 		name = "launch - netcoredbg",
	-- 		request = "launch",
	-- 		program = function()
	-- 			local project_file = io.popen("fd -HI -e .csproj | fzf", "r")
	--
	-- 			if project_file == nil then
	-- 				return nil
	-- 			end
	--
	-- 			local project = project_file:read("*a")
	-- 			project = project:gsub(".csproj", "")
	-- 			project = project:gsub(".*[\\/]", "")
	-- 			local query = project .. "binDebug"
	-- 			local pipe = io.popen("fd -HI -a -e .dll | fzf --query " .. query, "r")
	--
	-- 			if pipe == nil then
	-- 				return nil
	-- 			end
	--
	-- 			local result = pipe:read("*a")
	-- 			result = result:match("^%s*(.-)%s*$")
	--
	-- 			return vim.fn.input("Path to dll: ", result, "file")
	-- 		end,
	-- 	},
	-- }
	--
	-- dap.adapters.netcoredbg = {
	-- 	type = "executable",
	-- 	command = vim.fn.stdpath("data") .. "/mason" .. "/bin" .. "/netcoredbg.CMD",
	-- 	args = { "--interpreter=vscode" },
	-- }
	--
	-- dap.adapters.codelldb = {
	-- 	type = "server",
	-- 	port = "3500",
	-- 	executable = {
	-- 		command = vim.fn.stdpath("data") .. "/mason/bin/codelldb.CMD",
	-- 		args = { "--port", "3500" },
	-- 	},
	-- }
	--
	-- dap.configurations.cs = {
	-- 	{
	-- 		type = "coreclr",
	-- 		name = "launch - netcoredbg",
	-- 		request = "launch",
	-- 		program = function()
	-- 			local project_file = io.popen("fd -HI -e .csproj | fzf", "r")
	--
	-- 			if project_file == nil then
	-- 				return nil
	-- 			end
	--
	-- 			local project = project_file:read("*a")
	-- 			project = project:gsub(".csproj", "")
	-- 			project = project:gsub(".*[\\/]", "")
	-- 			local query = project .. "binDebug"
	-- 			local pipe = io.popen("fd -HI -a -e .dll | fzf --query " .. query, "r")
	--
	-- 			if pipe == nil then
	-- 				return nil
	-- 			end
	--
	-- 			local result = pipe:read("*a")
	-- 			result = result:match("^%s*(.-)%s*$")
	--
	-- 			return vim.fn.input("Path to dll: ", result, "file")
	-- 		end,
	-- 	},
	-- }
	--
	-- dap.configurations.rust = {
	-- 	{
	-- 		name = "Debug with codelldb",
	-- 		type = "codelldb",
	-- 		request = "launch",
	-- 		program = function()
	-- 			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
	-- 		end,
	-- 		cwd = "${workspaceFolder}",
	-- 		stopOnEntry = false,
	-- 	},
	-- }

	local nmap = require("skypex.utils").nmap
	nmap("<leader>dr", function()
		dap.continue()
	end, "Continue")

	nmap("<leader>dl", function()
		dap.step_over()
	end, "Step Over")

	nmap("<leader>dj", function()
		dap.step_into()
	end, "Step Into")

	nmap("<leader>dk", function()
		dap.step_out()
	end, "Step Out")

	nmap("<leader>db", function()
		dap.toggle_breakpoint()
	end, "Toggle Breakpoint")

	nmap("<leader>dB", function()
		dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
	end, "Set Breakpoint")

	nmap("<leader>dp", function()
		dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
	end, "Log Point")

	nmap("<leader>ds", function()
		dap.terminate()
	end, "Terminate")

	nmap("<leader>do", function()
		dap.repl.open()
	end, "Open REPL")

	nmap("<leader>dh", function()
		dap.run_last()
	end, "Run Last")

	nmap("<leader>dt", function()
		vim.cmd("RustLsp testables")
	end, "Test")
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
		},
	})
end

M.all = function()
	M.dap()
	M.dapui()
	M.mason()
end

return M
