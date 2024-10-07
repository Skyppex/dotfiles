local utils = require("skypex.utils")
local nmap = utils.nmap
local xmap = utils.xmap
local omap = utils.omap
local nxmap = utils.nxmap
local ximap = utils.ximap
local xismap = utils.xismap

local nvim_config_path = string.gsub(vim.fn.stdpath("config") .. "", "\\", "/")
local skypex_config_path = nvim_config_path .. "/lua/skypex/config.lua"
local remap_path = nvim_config_path .. "/lua/skypex/remap.lua"

nmap("<leader>v", vim.cmd.Ex)
nmap("<leader>so", function()
	vim.cmd("source " .. skypex_config_path)
	vim.cmd("source " .. remap_path)
end, "Source config")

-- TIP: Disable arrow keys in insert mode and x mode
ximap("<left>", '<cmd>echo "Use normal mode to move!!"<CR>')
ximap("<right>", '<cmd>echo "Use normal mode to move!!"<CR>')
ximap("<up>", '<cmd>echo "Use normal mode to move!!"<CR>')
ximap("<down>", '<cmd>echo "Use normal mode to move!!"<CR>')

-- Quickfix list navigation
nmap("<S-A-k>", "<cmd>cprev<CR>zz")
nmap("<S-A-j>", "<cmd>cnext<CR>zz")

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
nmap("åd", vim.diagnostic.goto_prev, "Go to previous Diagnostic message")
nmap("æd", vim.diagnostic.goto_next, "Go to next Diagnostic message")
nmap("<leader>de", vim.diagnostic.open_float, "Show diagnostic Error messages")
nmap("<leader>dq", vim.diagnostic.setloclist, "Open diagnostic Quickfix list")

-- Disable arrow keys in normal mode
nmap("<left>", '<cmd>echo "Use h to move!!"<CR>')
nmap("<right>", '<cmd>echo "Use l to move!!"<CR>')
nmap("<up>", '<cmd>echo "Use k to move!!"<CR>')
nmap("<down>", '<cmd>echo "Use j to move!!"<CR>')

nmap("<C-w>h", "<C-w><C-h>", "Move focus to the left window")
nmap("<C-w>j", "<C-w><C-j>", "Move focus to the lower window")
nmap("<C-w>k", "<C-w><C-k>", "Move focus to the upper window")
nmap("<C-w>l", "<C-w><C-l>", "Move focus to the right window")

nmap("<C-w>-", "<C-w>s", "Split window below")
nmap("<C-w>|", "<C-w>v", "Split window right")

nmap("<C-w><C-y>", "3<C-w><", "Shrink window horizontal")
nmap("<C-w><C-u>", "3<C-w>-", "Grow window horizontal")
nmap("<C-w><C-i>", "3<C-w>+", "Grow window vertical")
nmap("<C-w><C-o>", "3<C-w>>", "Shrink window vertical")

-- Macros
nmap("ø", "@")
nmap("øø", "@@")

-- Registers
nxmap("'", '"')

-- Indent in visual mode stays in visual mode
xmap("<", "<gv")
xmap(">", ">gv")

-- Camel case motion
nmap("<leader>cC", "<left>/\\u<CR>N", "Camel/Pascal Case Word Back")
nmap("<leader>cc", "/\\u<CR>", "Camel/Pascal Case Word")

omap("<leader>cc", "/\\u<CR>", "Camel/Pascal Case Word")

nmap("<leader>ciC", "<left>/\\u<CR>N<right>", "Camel/Pascal Case Word Back")
nmap("<leader>cic", "/\\u<CR><left>", "Camel/Pascal Case Word")

xmap("<leader>cC", "<left>/\\u<CR>N", "Camel/Pascal Case Word Back")
xmap("<leader>cc", "/\\u<CR>", "Camel/Pascal Case Word")

xmap("<leader>ciC", "<left>/\\u<CR>N<right>", "Camel/Pascal Case Word Back")
xmap("<leader>cic", "/\\u<CR><left>", "Camel/Pascal Case Word")

-- Snake case motion
nmap("<leader>cS", "<left>/_<CR>N", "Snake Case Word Back")
nmap("<leader>cs", "/_<CR>", "Snake Case Word")

omap("<leader>cs", "/_<CR>", "Snake Case Word")

nmap("<leader>ciS", "<left>/_<CR>N<right>", "Snake Case Word Back")
nmap("<leader>cis", "/_<CR><left>", "Snake Case Word")

xmap("<leader>cS", "<left>/_<CR>N", "Snake Case Word Back")
xmap("<leader>cs", "/_<CR>", "Snake Case Word")

xmap("<leader>ciS", "<left>/_<CR>N<right>", "Snake Case Word Back")
xmap("<leader>cis", "/_<CR><left>", "Snake Case Word")

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
	require("skypex.custom.attempt")
	require("skypex.custom.cmp")
	require("skypex.custom.dap").all()
	require("skypex.custom.format")
	require("skypex.custom.fun").all()
	require("skypex.custom.git").all()
	require("skypex.custom.harpoon")
	require("skypex.custom.hop")
	require("skypex.custom.lint").all()
	require("skypex.custom.lsp")
	require("skypex.custom.lualine")
	require("skypex.custom.markdown-preview")
	require("skypex.custom.mini")
	require("skypex.custom.noice")
	require("skypex.custom.oil").all()
	require("skypex.custom.rainbow-delimiters")
	require("skypex.custom.rest").all()
	require("skypex.custom.snippets").all()
	require("skypex.custom.surround")
	require("skypex.custom.telescope")
	require("skypex.custom.theming").all()
	require("skypex.custom.treesitter")
	require("skypex.custom.twilight")
	require("skypex.custom.undotree")
	require("skypex.custom.which-key")
	require("skypex.custom.zen-mode")
end, "Source config")
