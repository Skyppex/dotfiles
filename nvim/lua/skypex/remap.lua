vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Alias ctrl+c to Esc
vim.keymap.set({ "i", "v" }, "<C-c>", "<Esc>")

-- Reverse j and k in normal mode
vim.keymap.set({ "n", "v" }, "j", "<up>")
vim.keymap.set({ "n", "v" }, "k", "<down>")

-- Navigation in insert mode and x mode
vim.keymap.set({ "i", "x" }, "<A-h>", "<left>")
vim.keymap.set({ "i", "x" }, "<A-j>", "<up>")
vim.keymap.set({ "i", "x" }, "<A-k>", "<down>")
vim.keymap.set({ "i", "x" }, "<A-l>", "<right>")

-- TIP: Disable arrow keys in insert mode and x mode
vim.keymap.set({ "i", "x" }, "<left>", '<cmd>echo "Use alt+h to move in insert mode!!"<CR>')
vim.keymap.set({ "i", "x" }, "<right>", '<cmd>echo "Use alt+l to move in insert mode!!"<CR>')
vim.keymap.set({ "i", "x" }, "<up>", '<cmd>echo "Use alt+j to move in insert mode!!"<CR>')
vim.keymap.set({ "i", "x" }, "<down>", '<cmd>echo "Use alt+k to move in insert mode!!"<CR>')

-- Quickfix list navigation
vim.keymap.set("n", "<S-A-j>", ":cprev<CR>zz")
vim.keymap.set("n", "<S-A-k>", ":cnext<CR>zz")

vim.keymap.set("n", "<leader>j", ":lprev<CR>zz")
vim.keymap.set("n", "<leader>k", ":lnext<CR>zz")

vim.keymap.set("n", "<C-s>", "<cmd>w<CR>")

vim.keymap.set("v", "J", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>+1<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", '"_dP')

vim.keymap.set("n", "yj", "y<up>", { desc = "Up" })
vim.keymap.set("n", "yk", "y<down>", { desc = "Down" })

vim.keymap.set("n", "dj", "d<up>", { desc = "Up" })
vim.keymap.set("n", "dk", "d<down>", { desc = "Down" })

vim.keymap.set("n", "cj", "c<up>", { desc = "Up" })
vim.keymap.set("n", "ck", "c<down>", { desc = "Down" })

-- Just don't do this apparently'
vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left>")

-- Handle simple things in normal mode
vim.keymap.set("n", "<leader><CR>", "A<CR><ESC>")
vim.keymap.set("n", "<leader><BS>", "i<BS><ESC>")
vim.keymap.set("n", "<leader><DEL>", "i<Del><ESC>")

-- Autoclose brackets
vim.keymap.set("i", '"', '""<left>')
vim.keymap.set("i", '""', '""')
vim.keymap.set("i", '"<CR>', '"<CR>"<up><End><CR>')
vim.keymap.set("i", '";<CR>', '"<CR>";<up><End><CR>')

vim.keymap.set("i", "'", "''<left>")
vim.keymap.set("i", "''", "''")
vim.keymap.set("i", "'<CR>", "'<CR>'<up><End><CR>")
vim.keymap.set("i", "';<CR>", "'<CR>;'<up><End><CR>")

vim.keymap.set("i", "(", "()<left>")
vim.keymap.set("i", "()", "()")
vim.keymap.set("i", "(<CR>", "(<CR>)<up><End><CR>")
vim.keymap.set("i", "(;<CR>", "(<CR>);<up><End><CR>")

vim.keymap.set("i", "[", "[]<left>")
vim.keymap.set("i", "[]", "[]")
vim.keymap.set("i", "[<CR>", "[<CR>]<up><End><CR>")
vim.keymap.set("i", "[;<CR>", "[<CR>];<up><End><CR>")

vim.keymap.set("i", "{", "{}<left>")
vim.keymap.set("i", "{}", "{}")
vim.keymap.set("i", "{<CR>", "{<CR>}<up><End><CR>")
vim.keymap.set("i", "{;<CR>", "{<CR>};<up><End><CR>")

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("i", "qq", "<Esc>")

-- Diagnostic keymaps
vim.keymap.set("n", "åd", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "¨d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
-- vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use j to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use k to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-w>h", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-w>j", "<C-w><C-k>", { desc = "Move focus to the upper window" })
vim.keymap.set("n", "<C-w>k", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-w>j", "<C-w><C-j>", { desc = "Move focus to the lower window" })
