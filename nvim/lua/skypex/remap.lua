local utils = require("skypex.utils")
local map = utils.map

map("n", "<leader>v", "<cmd>echo Use <leader>x for file explorer!!<cr")

-- TIP: Disable arrow keys in insert mode and x mode
map("xi", "<left>", '<cmd>echo "Use normal mode to move!!"<cr>')
map("xi", "<right>", '<cmd>echo "Use normal mode to move!!"<cr>')
map("xi", "<up>", '<cmd>echo "Use normal mode to move!!"<cr>')
map("xi", "<down>", '<cmd>echo "Use normal mode to move!!"<cr>')

-- Disable arrow keys in normal mode
map("n", "<left>", '<cmd>echo "Use h to move!!"<cr>')
map("n", "<right>", '<cmd>echo "Use l to move!!"<cr>')
map("n", "<up>", '<cmd>echo "Use k to move!!"<cr>')
map("n", "<down>", '<cmd>echo "Use j to move!!"<cr>')

-- Save file
map("n", "<c-s>", "<cmd>wa<cr>")

-- Move lines of code in visual mode
map("x", "K", ":m '<-2<cr><cmd>normal! gv=gv<cr>")
map("x", "J", ":m '>+1<cr><cmd>normal! gv=gv<cr>")

map("n", "J", "mzJ`z")
map("n", "<c-d>", "<c-d>zz")
map("n", "<c-u>", "<c-u>zz")
map("n", "n", "nzz")
map("n", "N", "Nzz")

map("x", "<leader>p", '"_dP')

-- Just don't do this apparently
map("n", "Q", "<nop>")
map("n", "q:", "<nop>")

-- Alias ctrl+c to Esc
map("xis", "<c-c>", "<esc>")

-- Diagnostic keymaps
local function jump_to_diagnostic(direction)
	local diagnostics = vim.diagnostic.get(0)

	if #diagnostics == 0 then
		print("No diagnostics found")
		return
	end

	table.sort(diagnostics, function(a, b)
		return a.severity < b.severity
	end)

	direction({ severity = diagnostics[1].severity })
end

map("n", "åd", function()
	jump_to_diagnostic(vim.diagnostic.goto_prev)
end, "Go to previous diagnostic by severity")

map("n", "æd", function()
	jump_to_diagnostic(vim.diagnostic.goto_next)
end, "Go to next diagnostic by severity")

map("n", "åD", function()
	vim.diagnostic.goto_prev({ wrap = true })
end, "Go to previous diagnostic")

map("n", "æD", function()
	vim.diagnostic.goto_next({ wrap = true })
end, "Go to next diagnostic")

map("n", "<leader>od", function()
	vim.diagnostic.open_float(nil, {
		focusable = true,
		scope = "cursor",
	})
end, "Focus diagnostic window")

map("n", "<c-w>-", '<cmd>echo "Use <c-w>, to split buffer below!!"<cr>')
map("n", "<c-w>|", '<cmd>echo "Use <c-w>. to split buffer right!!"<cr>')

map("n", "<c-w>,", "<c-w>s", "Split buffer below")
map("n", "<c-w>.", "<c-w>v", "Split buffer right")

map("nxo", "gh", "^", "Go to start of line")
map("nxo", "gl", "$", "Go to end of line")
map("nxo", "_", "<cmd>echo 'Use gh to go to start of line!!'<cr>")
map("nxo", "^", "<cmd>echo 'Use gh to go to start of line!!'<cr>")
map("nxo", "$", "<cmd>echo 'Use gl to go to end of line!!'<cr>")

-- Macros
map("n", "ø", "@")

-- Registers
map("nx", "'", '"')

-- Indent in visual mode stays in visual mode
map("x", "<", "<gv")
map("x", ">", ">gv")

-- Redo
map("n", "U", "<c-r>", "Redo")

-- Newline before .
map("n", "<leader>.", function()
	local count = vim.v.count1 -- Get the count prefix, default to 1 if none is provided
	for _ = 1, count do
		local keys = vim.api.nvim_replace_termcodes("f.i<cr><esc>l==", true, true, true)
		vim.api.nvim_feedkeys(keys, "n", false)
	end
end)

-- Newline before :
map("n", "<leader>:", function()
	local count = vim.v.count1 -- Get the count prefix, default to 1 if none is provided
	for _ = 1, count do
		local keys = vim.api.nvim_replace_termcodes("f:i<cr><esc>l==", true, true, true)
		vim.api.nvim_feedkeys(keys, "n", false)
	end
end)

-- Newline after ,
map("n", "<leader>,", function()
	local count = vim.v.count1 -- Get the count prefix, default to 1 if none is provided
	for _ = 1, count do
		local keys = vim.api.nvim_replace_termcodes("f,a<cr><esc>l==", true, true, true)
		vim.api.nvim_feedkeys(keys, "n", false)
	end
end)

-- Newline before |
map("n", "<leader>|", function()
	local count = vim.v.count1 -- Get the count prefix, default to 1 if none is provided
	for _ = 1, count do
		local keys = vim.api.nvim_replace_termcodes("f|i<cr><esc>l==", true, true, true)
		vim.api.nvim_feedkeys(keys, "n", false)
	end
end)

-- Disable jump list for some motions
map("nx", "{", function()
	vim.cmd('execute "keepjumps norm! " .. v:count1 .. "{"')
end)

map("nx", "}", function()
	vim.cmd('execute "keepjumps norm! " .. v:count1 .. "}"')
end)

map("nx", "(", function()
	vim.cmd('execute "keepjumps norm! " .. v:count1 .. "("')
end)

map("nx", ")", function()
	vim.cmd('execute "keepjumps norm! " .. v:count1 .. ")"')
end)

vim.opt.relativenumber = true

map("nx", "<leader>tr", function()
	vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, "Toggle relative line numbers")

-- Increment and decrement numbers
map("nx", "+", "<c-a>", "Increment number")
map("nx", "-", "<c-x>", "Decrement number")

-- System clipboard
map("nx", "<leader>y", '"+y', "Yank to system clipboard")
map("nx", "<leader>p", '"+p', "Paste from system clipboard")
map("nx", "<leader>d", '"+d', "Cut to system clipboard")

-- Diff mode
map("n", "<leader>Do", "<cmd>windo diffthis<cr>", "Diff buffers")
map("n", "<leader>Dc", "<cmd>windo diffoff<cr>", "Diff buffers")

-- inspect highlight
map("n", "<leader>ih", function()
	vim.notify(vim.inspect(vim.treesitter.get_captures_at_cursor(0)))
end)

-- Source config
map("n", "<leader><leader>c", function()
	local files = vim.fn.glob(utils.get_config_path() .. "/**/skypex/custom/*.lua", true, true)

	local loaded = 0

	for _, filename in ipairs(files) do
		local base_filename = vim.fn.fnamemodify(filename, ":t")

		if base_filename ~= vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":t") then
			local module_name = base_filename:gsub("%.lua$", "")
			module_name = "skypex.custom." .. module_name

			if package.loaded[module_name] ~= true then
				vim.notify("Module " .. module_name .. " is not loaded", vim.log.levels.INFO)
				goto continue
			end

			package.loaded[module_name] = nil

			local success = pcall(function()
				require(module_name)
			end)

			if success then
				loaded = loaded + 1
			end
		end

		::continue::
	end

	vim.notify("Reloaded " .. loaded .. " modules", vim.log.levels.INFO)
end, "Source config")
