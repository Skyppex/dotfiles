local utils = require("skypex.utils")
local nmap = utils.nmap
local xmap = utils.xmap
local nxmap = utils.nxmap
local ximap = utils.ximap
local xismap = utils.xismap

nmap("<leader>v", vim.cmd.Ex)

-- TIP: Disable arrow keys in insert mode and x mode
ximap("<left>", '<cmd>echo "Use normal mode to move!!"<CR>')
ximap("<right>", '<cmd>echo "Use normal mode to move!!"<CR>')
ximap("<up>", '<cmd>echo "Use normal mode to move!!"<CR>')
ximap("<down>", '<cmd>echo "Use normal mode to move!!"<CR>')

-- Save file
nmap("<C-s>", "<cmd>wa<CR>")

-- Move lines of code in visual mode
xmap("K", ":m '<-2<CR>gv=gv")
xmap("J", ":m '>+1<CR>gv=gv")

nmap("J", "mzJ`z")
nmap("<C-d>", "<C-d>zz")
nmap("<C-u>", "<C-u>zz")
nmap("n", "nzz")
nmap("N", "Nzz")

xmap("<leader>p", '"_dP')

-- Just don't do this apparently'
nmap("Q", "<nop>")

nmap("<leader>sp", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left>")

-- Buffer navigation
nmap("åb", "<cmd>bprevious<CR>zz")
nmap("æb", "<cmd>bnext<CR>zz")
nmap("<leader>b", "<cmd>b#<CR>zz")

-- Set highlight on search, but clear on pressing <Esc> in normal mode
nmap("<Esc>", "<cmd>nohlsearch<CR>")

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

-- Disable arrow keys in normal mode
nmap("<left>", '<cmd>echo "Use h to move!!"<CR>')
nmap("<right>", '<cmd>echo "Use l to move!!"<CR>')
nmap("<up>", '<cmd>echo "Use k to move!!"<CR>')
nmap("<down>", '<cmd>echo "Use j to move!!"<CR>')

nmap("<C-w>h", "<C-w><C-h>", "Move focus to the left buffer")
nmap("<C-w>j", "<C-w><C-j>", "Move focus to the lower buffer")
nmap("<C-w>k", "<C-w><C-k>", "Move focus to the upper buffer")
nmap("<C-w>l", "<C-w><C-l>", "Move focus to the right buffer")

nmap("<C-w>-", '<cmd>echo "Use <C-w>, to split buffer below!!"<CR>')
nmap("<C-w>|", '<cmd>echo "Use <C-w>. to split buffer right!!"<CR>')

nmap("<C-w>,", "<C-w>s", "Split buffer below")
nmap("<C-w>.", "<C-w>v", "Split buffer right")

-- Resize buffers
local change = 5

nmap("<C-w>+", function()
	local count = vim.v.count1
	local current_width = vim.api.nvim_win_get_width(0)
	vim.api.nvim_win_set_width(0, current_width + change * count)
end, "Grow buffer horizontal")

nmap("<C-w>-", function()
	local count = vim.v.count1
	local current_width = vim.api.nvim_win_get_width(0)
	vim.api.nvim_win_set_width(0, current_width - change * count)
end, "Shrink buffer horizontal")

nmap("<C-w>?", function()
	local count = vim.v.count1
	local current_height = vim.api.nvim_win_get_height(0)
	vim.api.nvim_win_set_height(0, current_height + change * count)
end, "Grow buffer vertical")

nmap("<C-w>_", function()
	local count = vim.v.count1
	local current_height = vim.api.nvim_win_get_height(0)
	vim.api.nvim_win_set_height(0, current_height - change * count)
end, "Shrink buffer vertical")

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

-- Source config
nmap("<leader><leader>c", function()
	-- Config
	package.loaded["skypex.config"] = nil
	require("skypex.config")
	package.loaded["skypex.proof"] = nil
	require("skypex.proof")
	package.loaded["skypex.quickfix"] = nil
	require("skypex.quickfix")
	package.loaded["skypex.remap"] = nil
	require("skypex.remap")
	package.loaded["skypex.utils"] = nil
	require("skypex.utils")

	-- Plugins
	package.loaded["skypex.custom.attempt"] = nil
	require("skypex.custom.attempt")
	package.loaded["skypex.custom.cmp"] = nil
	require("skypex.custom.cmp")
	package.loaded["skypex.custom.dap"] = nil
	require("skypex.custom.dap").all()
	package.loaded["skypex.custom.db"] = nil
	require("skypex.custom.db").all()
	package.loaded["skypex.custom.format"] = nil
	require("skypex.custom.format")
	package.loaded["skypex.custom.fun"] = nil
	require("skypex.custom.fun").all()
	package.loaded["skypex.custom.git"] = nil
	require("skypex.custom.git").all()
	package.loaded["skypex.custom.harpoon"] = nil
	require("skypex.custom.harpoon")
	package.loaded["skypex.custom.hop"] = nil
	require("skypex.custom.hop")
	package.loaded["skypex.custom.lint"] = nil
	require("skypex.custom.lint").all()
	package.loaded["skypex.custom.lsp"] = nil
	require("skypex.custom.lsp")
	package.loaded["skypex.custom.lualine"] = nil
	require("skypex.custom.lualine")
	package.loaded["skypex.custom.markdown-preview"] = nil
	require("skypex.custom.markdown-preview")
	package.loaded["skypex.custom.mini"] = nil
	require("skypex.custom.mini")
	package.loaded["skypex.custom.noice"] = nil
	require("skypex.custom.noice")
	package.loaded["skypex.custom.file-tree"] = nil
	require("skypex.custom.file-tree").all()
	package.loaded["skypex.custom.rainbow-delimiters"] = nil
	require("skypex.custom.rainbow-delimiters")
	package.loaded["skypex.custom.rest"] = nil
	require("skypex.custom.rest").all()
	package.loaded["skypex.custom.snippets"] = nil
	require("skypex.custom.snippets").all()
	package.loaded["skypex.custom.surround"] = nil
	require("skypex.custom.surround")
	package.loaded["skypex.custom.telescope"] = nil
	require("skypex.custom.telescope")
	package.loaded["skypex.custom.test"] = nil
	require("skypex.custom.test")
	package.loaded["skypex.custom.theming"] = nil
	require("skypex.custom.theming").all()
	package.loaded["skypex.custom.treesitter"] = nil
	require("skypex.custom.treesitter")
	package.loaded["skypex.custom.twilight"] = nil
	require("skypex.custom.twilight")
	package.loaded["skypex.custom.undotree"] = nil
	require("skypex.custom.undotree")
	package.loaded["skypex.custom.which-key"] = nil
	require("skypex.custom.which-key")
	package.loaded["skypex.custom.zen-mode"] = nil
	require("skypex.custom.zen-mode")
end, "Source config")
