local map = function(mode, left, right, desc)
	vim.keymap.set(mode, left, right, { desc = desc, noremap = true, silent = true })
end

map("n", "<leader>pv", vim.cmd.Ex)

-- Reverse j and k
map({ "n", "v", "o" }, "j", "<up>")
map({ "n", "v", "o" }, "k", "<down>")

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
map("v", "J", ":m '<-2<CR>gv=gv")
map("v", "K", ":m '>+1<CR>gv=gv")

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

-- Set highlight on search, but clear on pressing <Esc> in normal mode
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Alias ctrl+c to Esc
map({ "i", "v", "s" }, "<C-c>", "<Esc>")

-- Diagnostic keymaps
map("n", "åd", vim.diagnostic.goto_prev, "Go to previous [D]iagnostic message")
map("n", "æd", vim.diagnostic.goto_next, "Go to next [D]iagnostic message")
map("n", "<leader>de", vim.diagnostic.open_float, "Show diagnostic [E]rror messages")
map("n", "<leader>dq", vim.diagnostic.setloclist, "Open diagnostic [Q]uickfix list")

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
-- map("t", "<Esc><Esc>", "<C-\\><C-n>", "Exit terminal mode")

-- TIP: Disable arrow keys in normal mode
map("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
map("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
map("n", "<up>", '<cmd>echo "Use j to move!!"<CR>')
map("n", "<down>", '<cmd>echo "Use k to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
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
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Camel case motion
map("n", "<leader>cC", "<left>/\\u<CR>N", "Camel/Pascal Case Word Back")
map("n", "<leader>cc", "/\\u<CR>", "Camel/Pascal Case Word")

map("o", "<leader>cc", "/\\u<CR>", "Camel/Pascal Case Word")

map("n", "<leader>ciC", "<left>/\\u<CR>N<right>", "Camel/Pascal Case Word Back")
map("n", "<leader>cic", "/\\u<CR><left>", "Camel/Pascal Case Word")

map("v", "<leader>cC", "<left>/\\u<CR>N", "Camel/Pascal Case Word Back")
map("v", "<leader>cc", "/\\u<CR>", "Camel/Pascal Case Word")

map("v", "<leader>ciC", "<left>/\\u<CR>N<right>", "Camel/Pascal Case Word Back")
map("v", "<leader>cic", "/\\u<CR><left>", "Camel/Pascal Case Word")

-- Snake case motion
map("n", "<leader>cS", "<left>/_<CR>N", "Snake Case Word Back")
map("n", "<leader>cs", "/_<CR>", "Snake Case Word")

map("o", "<leader>cs", "/_<CR>", "Snake Case Word")

map("n", "<leader>ciS", "<left>/_<CR>N<right>", "Snake Case Word Back")
map("n", "<leader>cis", "/_<CR><left>", "Snake Case Word")

map("v", "<leader>cS", "<left>/_<CR>N", "Snake Case Word Back")
map("v", "<leader>cs", "/_<CR>", "Snake Case Word")

map("v", "<leader>ciS", "<left>/_<CR>N<right>", "Snake Case Word Back")
map("v", "<leader>cis", "/_<CR><left>", "Snake Case Word")

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

-- Increment and decrement numbers
map({ "n", "v" }, "<leader>+", "<C-a>", "Increment number")
map({ "n", "v" }, "<leader>-", "<C-x>", "Decrement number")
