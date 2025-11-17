local utils = require("skypex.utils")
local nmap = utils.nmap
local xmap = utils.xmap
local nxmap = utils.nxmap
local nxomap = utils.nxomap
local ximap = utils.ximap
local xismap = utils.xismap

nmap("<leader>v", vim.cmd.Ex)

-- TIP: Disable arrow keys in insert mode and x mode
ximap("<left>", '<cmd>echo "Use normal mode to move!!"<CR>')
ximap("<right>", '<cmd>echo "Use normal mode to move!!"<CR>')
ximap("<up>", '<cmd>echo "Use normal mode to move!!"<CR>')
ximap("<down>", '<cmd>echo "Use normal mode to move!!"<CR>')

-- Disable arrow keys in normal mode
nmap("<left>", '<cmd>echo "Use h to move!!"<CR>')
nmap("<right>", '<cmd>echo "Use l to move!!"<CR>')
nmap("<up>", '<cmd>echo "Use k to move!!"<CR>')
nmap("<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Save file
nmap("<C-s>", "<cmd>wa<CR>")

-- Move lines of code in visual mode
xmap("K", ":m '<-2<cr><cmd>normal! gv=gv<cr>")
xmap("J", ":m '>+1<cr><cmd>normal! gv=gv<cr>")

nmap("J", "mzJ`z")
nmap("<C-d>", "<C-d>zz")
nmap("<C-u>", "<C-u>zz")
nmap("n", "nzz")
nmap("N", "Nzz")

xmap("<leader>p", '"_dP')

-- Just don't do this apparently'
nmap("Q", "<nop>")
nmap("q:", "<nop>")

-- Alias ctrl+c to Esc
xismap("<C-c>", "<Esc>")

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

nmap("åd", function()
	jump_to_diagnostic(vim.diagnostic.goto_prev)
end, "Go to previous diagnostic by severity")

nmap("æd", function()
	jump_to_diagnostic(vim.diagnostic.goto_next)
end, "Go to next diagnostic by severity")

nmap("åD", function()
	vim.diagnostic.goto_prev({ wrap = true })
end, "Go to previous diagnostic")

nmap("æD", function()
	vim.diagnostic.goto_next({ wrap = true })
end, "Go to next diagnostic")

nmap("<C-w>-", '<cmd>echo "Use <C-w>, to split buffer below!!"<CR>')
nmap("<C-w>|", '<cmd>echo "Use <C-w>. to split buffer right!!"<CR>')

nmap("<C-w>,", "<C-w>s", "Split buffer below")
nmap("<C-w>.", "<C-w>v", "Split buffer right")

nxomap("gh", "^", "Go to start of line")
nxomap("gl", "$", "Go to end of line")
nxomap("_", "<cmd>echo 'Use gh to go to start of line!!'<CR>")
nxomap("^", "<cmd>echo 'Use gh to go to start of line!!'<CR>")
nxomap("$", "<cmd>echo 'Use gl to go to end of line!!'<CR>")

-- Macros
nmap("ø", "@")
nmap("øø", "@@")

-- Registers
nxmap("'", '"')

-- Indent in visual mode stays in visual mode
xmap("<", "<gv")
xmap(">", ">gv")

-- Redo
nmap("U", "<C-r>", "Redo")

-- Newline before .
nmap("<leader>.", function()
	local count = vim.v.count1 -- Get the count prefix, default to 1 if none is provided
	for _ = 1, count do
		local keys = vim.api.nvim_replace_termcodes("f.i<CR><Esc>l==", true, true, true)
		vim.api.nvim_feedkeys(keys, "n", false)
	end
end)

-- Newline before :
nmap("<leader>:", function()
	local count = vim.v.count1 -- Get the count prefix, default to 1 if none is provided
	for _ = 1, count do
		local keys = vim.api.nvim_replace_termcodes("f:i<CR><Esc>l==", true, true, true)
		vim.api.nvim_feedkeys(keys, "n", false)
	end
end)

-- Newline after ,
nmap("<leader>,", function()
	local count = vim.v.count1 -- Get the count prefix, default to 1 if none is provided
	for _ = 1, count do
		local keys = vim.api.nvim_replace_termcodes("f,a<CR><Esc>l==", true, true, true)
		vim.api.nvim_feedkeys(keys, "n", false)
	end
end)

-- Newline before |
nmap("<leader>|", function()
	local count = vim.v.count1 -- Get the count prefix, default to 1 if none is provided
	for _ = 1, count do
		local keys = vim.api.nvim_replace_termcodes("f|i<CR><Esc>l==", true, true, true)
		vim.api.nvim_feedkeys(keys, "n", false)
	end
end)

-- Disable jump list for some motions
nxmap("{", function()
	vim.cmd('execute "keepjumps norm! " .. v:count1 .. "{"')
end)

nxmap("}", function()
	vim.cmd('execute "keepjumps norm! " .. v:count1 .. "}"')
end)

nxmap("(", function()
	vim.cmd('execute "keepjumps norm! " .. v:count1 .. "("')
end)

nxmap(")", function()
	vim.cmd('execute "keepjumps norm! " .. v:count1 .. ")"')
end)

vim.opt.relativenumber = true

nxmap("<leader>tr", function()
	vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, "Toggle relative line numbers")

-- Increment and decrement numbers
nxmap("+", "<C-a>", "Increment number")
nxmap("-", "<C-x>", "Decrement number")

-- System clipboard
nxmap("<leader>y", '"+y', "Yank to system clipboard")
nxmap("<leader>p", '"+p', "Paste from system clipboard")
nxmap("<leader>d", '"+d', "Cut to system clipboard")

-- Diff mode
nmap("<leader>Do", "<cmd>windo diffthis<CR>", "Diff buffers")
nmap("<leader>Dc", "<cmd>windo diffoff<CR>", "Diff buffers")

-- inspect highlight
nmap("<leader>ih", function()
	vim.notify(vim.inspect(vim.treesitter.get_captures_at_cursor(0)))
end)

-- Source config
nmap("<leader><leader>c", function()
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
