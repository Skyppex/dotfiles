local map = function(mode, left, right, desc)
	vim.keymap.set(mode, left, right, { desc = desc, noremap = true, silent = true })
end

local nvim_config_path = string.gsub(vim.fn.stdpath("config") .. "", "\\", "/")
local skypex_config_path = nvim_config_path .. "/lua/skypex/config.lua"
local remap_path = nvim_config_path .. "/lua/skypex/remap.lua"

map("n", "<leader>v", vim.cmd.Ex)
map("n", "<leader>so", function()
	vim.cmd("source " .. skypex_config_path)
	vim.cmd("source " .. remap_path)
end, "Source config")

-- Reverse j and k
map({ "n", "x", "o" }, "j", "<up>")
map({ "n", "x", "o" }, "k", "<down>")

-- TIP: Disable arrow keys in insert mode and x mode
map({ "i", "x" }, "<left>", '<cmd>echo "Use normal mode to move!!"<CR>')
map({ "i", "x" }, "<right>", '<cmd>echo "Use normal mode to move!!"<CR>')
map({ "i", "x" }, "<up>", '<cmd>echo "Use normal mode to move!!"<CR>')
map({ "i", "x" }, "<down>", '<cmd>echo "Use normal mode to move!!"<CR>')

-- Quickfix list navigation
map("n", "<S-A-j>", "<cmd>cprev<CR>zz")
map("n", "<S-A-k>", "<cmd>cnext<CR>zz")

-- map("n", "<S-A-x>", "<cmd>cclose<CR>")
-- map("n" "<S-A-x>", "<cmd>copen<CR>")

-- Save file
map("n", "<C-s>", "<cmd>wa<CR>")

-- Move lines of code in visual mode
map("x", "J", ":m '<-2<CR>gv=gv")
map("x", "K", ":m '>+1<CR>gv=gv")

map("n", "J", "mzJ`z")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzz")
map("n", "N", "Nzz")

map("x", "<leader>p", '"_dP')

-- Just don't do this apparently'
map("n", "Q", "<nop>")

map("n", "<leader>sp", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left>")

-- Buffer navigation
map("n", "åb", "<cmd>bprevious<CR>zz")
map("n", "æb", "<cmd>bnext<CR>zz")
map("n", "<leader>b", "<cmd>b#<CR>zz")

-- Spell check navigation
map("n", "ås", "[s")
map("n", "æs", "]s")

-- Set highlight on search, but clear on pressing <Esc> in normal mode
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Alias ctrl+c to Esc
map({ "i", "x", "s" }, "<C-c>", "<Esc>")

-- Diagnostic keymaps
map("n", "åd", vim.diagnostic.goto_prev, "Go to previous Diagnostic message")
map("n", "æd", vim.diagnostic.goto_next, "Go to next Diagnostic message")
map("n", "<leader>de", vim.diagnostic.open_float, "Show diagnostic Error messages")
map("n", "<leader>dq", vim.diagnostic.setloclist, "Open diagnostic Quickfix list")

-- TIP: Disable arrow keys in normal mode
map("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
map("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
map("n", "<up>", '<cmd>echo "Use j to move!!"<CR>')
map("n", "<down>", '<cmd>echo "Use k to move!!"<CR>')

map("n", "<C-w>h", "<C-w><C-h>", "Move focus to the left window")
map("n", "<C-w>j", "<C-w><C-k>", "Move focus to the upper window")
map("n", "<C-w>l", "<C-w><C-l>", "Move focus to the right window")
map("n", "<C-w>k", "<C-w><C-j>", "Move focus to the lower window")

map("n", "<C-w>-", "<C-w>s", "Split window below")
map("n", "<C-w>|", "<C-w>v", "Split window right")

map("n", "<C-w><C-y>", "3<C-w><", "Shrink window horizontal")
map("n", "<C-w><C-u>", "3<C-w>+", "Grow window vertical")
map("n", "<C-w><C-i>", "3<C-w>-", "Grow window horizontal")
map("n", "<C-w><C-o>", "3<C-w>>", "Shrink window vertical")

-- Macros
map("n", "ø", "@")
map("n", "øø", "@@")

-- Registers
map({ "n", "x" }, "'", '"')

-- Indent in visual mode stays in visual mode
map("x", "<", "<gv")
map("x", ">", ">gv")

-- CreateVehicleIDAsGUID

-- Camel case motion
map("n", "<leader>cC", "<left>/\\u<CR>N", "Camel/Pascal Case Word Back")
map("n", "<leader>cc", "/\\u<CR>", "Camel/Pascal Case Word")

map("o", "<leader>cc", "/\\u<CR>", "Camel/Pascal Case Word")

map("n", "<leader>ciC", "<left>/\\u<CR>N<right>", "Camel/Pascal Case Word Back")
map("n", "<leader>cic", "/\\u<CR><left>", "Camel/Pascal Case Word")

map("x", "<leader>cC", "<left>/\\u<CR>N", "Camel/Pascal Case Word Back")
map("x", "<leader>cc", "/\\u<CR>", "Camel/Pascal Case Word")

map("x", "<leader>ciC", "<left>/\\u<CR>N<right>", "Camel/Pascal Case Word Back")
map("x", "<leader>cic", "/\\u<CR><left>", "Camel/Pascal Case Word")

-- Snake case motion
map("n", "<leader>cS", "<left>/_<CR>N", "Snake Case Word Back")
map("n", "<leader>cs", "/_<CR>", "Snake Case Word")

map("o", "<leader>cs", "/_<CR>", "Snake Case Word")

map("n", "<leader>ciS", "<left>/_<CR>N<right>", "Snake Case Word Back")
map("n", "<leader>cis", "/_<CR><left>", "Snake Case Word")

map("x", "<leader>cS", "<left>/_<CR>N", "Snake Case Word Back")
map("x", "<leader>cs", "/_<CR>", "Snake Case Word")

map("x", "<leader>ciS", "<left>/_<CR>N<right>", "Snake Case Word Back")
map("x", "<leader>cis", "/_<CR><left>", "Snake Case Word")

-- Redo
map("n", "U", "<C-r>", "Redo")

-- Newline before .
map("n", "<leader>.", function()
	local count = vim.v.count1 -- Get the count prefix, default to 1 if none is provided
	for _ = 1, count do
		local keys = vim.api.nvim_replace_termcodes("f.i<CR><Esc>l==", true, true, true)
		vim.api.nvim_feedkeys(keys, "n", false)
	end
end)

-- Newline after ,
map("n", "<leader>,", function()
	local count = vim.v.count1 -- Get the count prefix, default to 1 if none is provided
	for _ = 1, count do
		local keys = vim.api.nvim_replace_termcodes("f,a<CR><Esc>l==", true, true, true)
		vim.api.nvim_feedkeys(keys, "n", false)
	end
end)

-- Increment and decrement numbers
map({ "n", "x" }, "+", "<C-a>", "Increment number")
map({ "n", "x" }, "-", "<C-x>", "Decrement number")

-- System clipboard
map({ "n", "x" }, "<leader>y", '"+y', "Yank to system clipboard")
map({ "n", "x" }, "<leader>p", '"+p', "Paste from system clipboard")
