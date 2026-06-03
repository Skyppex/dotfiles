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
	local signcolumn = require("skypex.signcolumn")

	signcolumn.add_reason("breakpoints", function()
		local breakpoints = require("dap.breakpoints").get()

		local count = 0

		for _ in pairs(breakpoints) do
			count = count + 1
		end

		return count > 0
	end)

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
		signcolumn.update_signcolumn()
	end, "Toggle Breakpoint")

	map("n", "<leader>dc", function()
		dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		signcolumn.update_signcolumn()
	end, "Set Conditional Breakpoint")

	map("n", "<leader>dB", function()
		dap.clear_breakpoints()
		signcolumn.update_signcolumn()
	end, "Clear Breakpoints")

	map("n", "<leader>dp", function()
		dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
		signcolumn.update_signcolumn()
	end, "Log Point")

	map("n", "<leader>dq", function()
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
	M.mason()
end

M.all()

return M
