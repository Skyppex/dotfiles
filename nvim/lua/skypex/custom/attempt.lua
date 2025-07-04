local attempt = require("attempt")
local Job = require("plenary.job")

local function get_or_create_attempt_buf()
	local buf_name = "attempt://output"
	local bufnr = nil

	-- Iterate over all buffers to check if the buffer already exists
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		local bn = vim.api.nvim_buf_get_name(buf)

		if bn == buf_name then
			bufnr = buf
			break
		end
	end

	-- If the buffer doesn't exist, create it
	if not bufnr then
		bufnr = vim.api.nvim_create_buf(false, true) -- Create a scratch buffer
		vim.api.nvim_buf_set_name(bufnr, buf_name)
	end

	return bufnr
end

local function overwrite_buffer_with_string(bufnr, data)
	-- Split the content string into lines
	local lines = {}

	for line in data:gmatch("([^\n]*)\n?") do
		table.insert(lines, line)
	end

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end

local function get_win_aspect_ratio(win)
	-- Get the window's width and height
	local width = vim.api.nvim_win_get_width(win) / 2 -- Divide by 2 to get the actual width
	local height = vim.api.nvim_win_get_height(win)

	-- Calculate the aspect ratio
	local aspect_ratio = width / height

	return aspect_ratio
end

local function open_buffer_in_split_no_focus(bufnr, split)
	-- Check if the buffer is already visible in any window
	local buffer_visible = false

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == bufnr then
			buffer_visible = true
			break
		end
	end

	-- If the buffer is not visible, open a vertical split
	if not buffer_visible then
		-- Save the current window
		local current_win = vim.api.nvim_get_current_win()

		-- Open a vertical split
		vim.cmd(split)

		-- Set the buffer in the new window
		vim.api.nvim_set_current_buf(bufnr)

		-- Return focus to the original window
		vim.api.nvim_set_current_win(current_win)
	end
end

local function run_attempt(cmd, args)
	vim.cmd("w")
	local data_buffer = ""

	local job = Job:new({
		command = cmd,
		args = args,
		on_stdout = function(_, data)
			if data then
				data_buffer = data_buffer .. data .. "\n"
			end
		end,
		on_stderr = function(_, data)
			if data then
				vim.schedule(function()
					vim.notify(data, vim.log.levels.ERROR)
				end)
			end
		end,
		on_exit = function(_, code)
			if code == 0 then
				vim.schedule(function()
					local attempt_buf = get_or_create_attempt_buf()
					overwrite_buffer_with_string(attempt_buf, data_buffer)
					local aspect_ratio = get_win_aspect_ratio(vim.api.nvim_get_current_win())
					local split = aspect_ratio > 1.0 and "vsplit" or "split" -- Adjust the split type based on aspect ratio
					open_buffer_in_split_no_focus(attempt_buf, split)
				end)
			end
		end,
	})

	job:start() -- This will run the job asynchronously
end

attempt.setup({
	ext_options = { "lua", "py", "cs", "js", "rs", "ar", "http", "" },
	run = {
		-- cs = { "w", "!dotnet script %" },
		cs = function(_, bufnr)
			run_attempt("dotnet script %", { vim.api.nvim_buf_get_name(bufnr) })
		end,
		-- py = { "w !python" }, -- Either table of strings or lua functions
		py = function(_, bufnr)
			run_attempt("python", { vim.api.nvim_buf_get_name(bufnr) })
		end,
		-- js = { "w !node" },
		js = function(_, bufnr)
			run_attempt("node", { vim.api.nvim_buf_get_name(bufnr) })
		end,
		lua = { "w", "luafile %" },
		rs = { "w", "!rustc % && nu -c 'let ex = (echo %' | str replace '.rs' ''); exec $ex" },
		ar = function(_, bufnr)
			run_attempt("mage", { vim.api.nvim_buf_get_name(bufnr) })
		end,
	},
})

require("telescope").load_extension("attempt")

local utils = require("skypex.utils")
local nmap = utils.nmap
local xmap = utils.xmap

nmap("<leader>AN", attempt.new_select, "New Attempt")
nmap("<leader>AI", attempt.new_input_ext, "New Attempt By Extension")
nmap("<leader>AR", attempt.run, "Run Attempt")
nmap("<leader>AD", attempt.delete_buf, "Delete Attempt")
nmap("<leader>AC", attempt.rename_buf, "Rename Attempt")
nmap("<leader>AS", "<cmd>Telescope attempt<CR>", "Search Attempts")

local function get_keys(tbl)
	local keys = {}
	for key, _ in pairs(tbl) do
		table.insert(keys, key)
	end
	return keys
end

local function get_visual_selection(start_pos, end_pos)
	local lines = vim.fn.getline(start_pos[2], end_pos[2])

	if not lines then
		return {}
	end

	-- Adjust for partial lines
	lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
	lines[1] = string.sub(lines[1], start_pos[3], -1)

	return lines
end

local attempt_config = require("attempt.config").opts

xmap("<leader>AR", function()
	if not attempt_config then
		attempt_config = require("attempt.config").opts

		if not attempt_config then
			vim.notify("Attempt configuration not found", vim.log.levels.ERROR)
			return
		end
	end

	local current_buf = vim.api.nvim_get_current_buf()
	vim.cmd("normal! gv")
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")

	if start_pos[2] == 0 or end_pos[2] == 0 then
		vim.notify("No visual selection found", vim.log.levels.WARN)
		return
	end

	local lines = get_visual_selection(start_pos, end_pos)
	if #lines == 0 then
		vim.notify("No lines selected", vim.log.levels.WARN)
		return
	end

	local options = get_keys(attempt_config.run)

	vim.ui.select(options, {}, function(choice)
		if not choice then
			return
		end

		local autoformat_disabled = vim.g.disable_autoformat or false
		vim.g.disable_autoformat = true
		attempt.new({
			ext = choice,
		}, function(file_entry)
			local path = file_entry.path
			local bufnr = vim.fn.bufnr(path, false)

			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
			vim.api.nvim_buf_call(bufnr, function()
				vim.cmd("write")
			end)

			attempt.run(bufnr)
			vim.api.nvim_set_current_buf(current_buf)
			attempt.delete_buf(true, bufnr)
			vim.g.disable_autoformat = autoformat_disabled
		end)
	end)
end, "Run Selection as Attempt")
