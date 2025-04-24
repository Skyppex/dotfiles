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

	vim.notify("Width: " .. width .. ", Height: " .. height)

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
		cs = { "w", "!dotnet script %" },
		py = { "w !python" }, -- Either table of strings or lua functions
		js = { "w !node" },
		lua = { "w", "luafile %" },
		rs = { "w", "!rustc % && nu -c 'let ex = (echo %' | str replace '.rs' ''); exec $ex" },
		ar = function(_, bufnr)
			run_attempt("mage", { vim.api.nvim_buf_get_name(bufnr) })
		end,
	},
})

require("telescope").load_extension("attempt")

local nmap = require("skypex.utils").nmap

nmap("<leader>AN", attempt.new_select, "New Attempt")
nmap("<leader>AI", attempt.new_input_ext, "New Attempt By Extension")
nmap("<leader>AR", attempt.run, "Run Attempt")
nmap("<leader>AD", attempt.delete_buf, "Delete Attempt")
nmap("<leader>AC", attempt.rename_buf, "Rename Attempt")
nmap("<leader>AS", "<cmd>Telescope attempt<CR>", "Search Attempts")
