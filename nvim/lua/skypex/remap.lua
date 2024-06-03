vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { noremap = true, silent = true })

-- Reverse j and k in normal mode
vim.keymap.set({ "n", "v" }, "j", "<up>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "k", "<down>", { noremap = true, silent = true })

-- Navigation in insert mode and x mode
vim.keymap.set({ "i", "x" }, "<A-h>", "<left>", { noremap = true, silent = true })
vim.keymap.set({ "i", "x" }, "<A-j>", "<up>", { noremap = true, silent = true })
vim.keymap.set({ "i", "x" }, "<A-k>", "<down>", { noremap = true, silent = true })
vim.keymap.set({ "i", "x" }, "<A-l>", "<right>", { noremap = true, silent = true })

-- TIP: Disable arrow keys in insert mode and x mode
vim.keymap.set(
	{ "i", "x" },
	"<left>",
	'<cmd>echo "Use alt+h to move in insert mode!!"<CR>',
	{ noremap = true, silent = true }
)
vim.keymap.set(
	{ "i", "x" },
	"<right>",
	'<cmd>echo "Use alt+l to move in insert mode!!"<CR>',
	{ noremap = true, silent = true }
)
vim.keymap.set(
	{ "i", "x" },
	"<up>",
	'<cmd>echo "Use alt+j to move in insert mode!!"<CR>',
	{ noremap = true, silent = true }
)
vim.keymap.set(
	{ "i", "x" },
	"<down>",
	'<cmd>echo "Use alt+k to move in insert mode!!"<CR>',
	{ noremap = true, silent = true }
)

-- Quickfix list navigation
vim.keymap.set("n", "<S-A-j>", ":cprev<CR>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<S-A-k>", ":cnext<CR>zz", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>j", ":lprev<CR>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>k", ":lnext<CR>zz", { noremap = true, silent = true })

vim.keymap.set("n", "<S-A-x>", ":cclose<CR>", { noremap = true, silent = true })

-- Remap end of line
vim.keymap.set({ "n", "v" }, "+", "$", { noremap = true, silent = true })
vim.keymap.set("n", "d+", "d$", { noremap = true, silent = true })
vim.keymap.set("n", "y+", "y$", { noremap = true, silent = true })
vim.keymap.set("n", "c+", "c$", { noremap = true, silent = true })
vim.keymap.set("n", "gc+", "gc$", { noremap = true, silent = true })
vim.keymap.set("n", "gb+", "gc$", { noremap = true, silent = true })

-- Save file
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { noremap = true, silent = true })

-- Move lines of code in visual mode
vim.keymap.set("v", "J", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "K", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

vim.keymap.set("n", "J", "mzJ`z", { noremap = true, silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })
vim.keymap.set("n", "n", "nzzzv", { noremap = true, silent = true })
vim.keymap.set("n", "N", "Nzzzv", { noremap = true, silent = true })

vim.keymap.set("x", "<leader>p", '"_dP', { noremap = true, silent = true })

vim.keymap.set("n", "yj", "y<up>", { desc = "Up", noremap = true, silent = true })
vim.keymap.set("n", "yk", "y<down>", { desc = "Down", noremap = true, silent = true })

vim.keymap.set("n", "dj", "d<up>", { desc = "Up", noremap = true, silent = true })
vim.keymap.set("n", "dk", "d<down>", { desc = "Down", noremap = true, silent = true })

vim.keymap.set("n", "cj", "c<up>", { desc = "Up", noremap = true, silent = true })
vim.keymap.set("n", "ck", "c<down>", { desc = "Down", noremap = true, silent = true })

-- Just don't do this apparently'
vim.keymap.set("n", "Q", "<nop>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>sp", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left>", { noremap = true, silent = true })

-- Handle simple things in normal mode
vim.keymap.set("n", "<leader><CR>", "A<CR><ESC>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>i<CR>", "i<CR><ESC>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>0<CR>", "0<CR><ESC>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader><BS>", "i<BS><ESC>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>i<BS>", "i<BS><ESC>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader><del>", "a<del><ESC>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>i<del>", "i<del><ESC>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader><tab>", function()
	print("use >> to indent")
end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>i<tab>", function()
	print("use >> to indent")
end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>0<tab>", function()
	print("use >> to indent")
end, { noremap = true, silent = true })

-- Buffer navigation
vim.keymap.set("n", "åb", "<cmd>bprevious<CR>zz", { noremap = true, silent = true })
vim.keymap.set("n", "æb", "<cmd>bnext<CR>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>b", "<cmd>b#<CR><<", { noremap = true, silent = true })

-- Autoclose brackets
vim.keymap.set("i", '"', '""<left>', { noremap = true, silent = true })
vim.keymap.set("i", '<A-">', '"', { noremap = true, silent = true })
vim.keymap.set("i", '""', '""', { noremap = true, silent = true })
vim.keymap.set("i", '"<CR>', '"<CR>"<up><End><CR>', { noremap = true, silent = true })
vim.keymap.set("i", '";', '"<CR>";<up><End><CR>', { noremap = true, silent = true })

vim.keymap.set("i", "'", "''<left>", { noremap = true, silent = true })
vim.keymap.set("i", "<A-'>", "'", { noremap = true, silent = true })
vim.keymap.set("i", "''", "''", { noremap = true, silent = true })
vim.keymap.set("i", "'<CR>", "'<CR>'<up><End><CR>", { noremap = true, silent = true })
vim.keymap.set("i", "';", "'<CR>;'<up><End><CR>", { noremap = true, silent = true })

vim.keymap.set("i", "(", "()<left>", { noremap = true, silent = true })
vim.keymap.set("i", "<A-(>", "(", { noremap = true, silent = true })
vim.keymap.set("i", "()", "()", { noremap = true, silent = true })
vim.keymap.set("i", "(<CR>", "(<CR>)<up><End><CR>", { noremap = true, silent = true })
vim.keymap.set("i", "(;", "(<CR>);<up><End><CR>", { noremap = true, silent = true })

vim.keymap.set("i", "[", "[]<left>", { noremap = true, silent = true })
vim.keymap.set("i", "<A-[>", "[", { noremap = true, silent = true })
vim.keymap.set("i", "[]", "[]", { noremap = true, silent = true })
vim.keymap.set("i", "[<CR>", "[<CR>]<up><End><CR>", { noremap = true, silent = true })
vim.keymap.set("i", "[;", "[<CR>];<up><End><CR>", { noremap = true, silent = true })

vim.keymap.set("i", "{", "{}<left>", { noremap = true, silent = true })
vim.keymap.set("i", "<A-{>", "{", { noremap = true, silent = true })
vim.keymap.set("i", "{}", "{}", { noremap = true, silent = true })
vim.keymap.set("i", "{<CR>", "{<CR>}<up><End><CR>", { noremap = true, silent = true })
vim.keymap.set("i", "{;", "{<CR>};<up><End><CR>", { noremap = true, silent = true })

vim.keymap.set("i", "<", "<><left>", { noremap = true, silent = true })
vim.keymap.set("i", "<A-<>", "<", { noremap = true, silent = true })
vim.keymap.set("i", "<>", "<>", { noremap = true, silent = true })
vim.keymap.set("i", "<<CR>", "<<CR>><up><End><CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<;", "<<CR>>;<up><End><CR>", { noremap = true, silent = true })

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { noremap = true, silent = true })

-- Alias ctrl+c to Esc
vim.keymap.set({ "i", "v" }, "<C-c>", "<Esc>", { noremap = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set(
	"n",
	"åd",
	vim.diagnostic.goto_prev,
	{ desc = "Go to previous [D]iagnostic message", noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"æd",
	vim.diagnostic.goto_next,
	{ desc = "Go to next [D]iagnostic message", noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"<leader>de",
	vim.diagnostic.open_float,
	{ desc = "Show diagnostic [E]rror messages", noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"<leader>dq",
	vim.diagnostic.setloclist,
	{ desc = "Open diagnostic [Q]uickfix list", noremap = true, silent = true }
)

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
-- vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>', { noremap = true, silent = true })
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>', { noremap = true, silent = true })
vim.keymap.set("n", "<up>", '<cmd>echo "Use j to move!!"<CR>', { noremap = true, silent = true })
vim.keymap.set("n", "<down>", '<cmd>echo "Use k to move!!"<CR>', { noremap = true, silent = true })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-w>h", "<C-w><C-h>", { desc = "Move focus to the left window", noremap = true, silent = true })
vim.keymap.set("n", "<C-w>j", "<C-w><C-k>", { desc = "Move focus to the upper window", noremap = true, silent = true })
vim.keymap.set("n", "<C-w>l", "<C-w><C-l>", { desc = "Move focus to the right window", noremap = true, silent = true })
vim.keymap.set("n", "<C-w>k", "<C-w><C-j>", { desc = "Move focus to the lower window", noremap = true, silent = true })

vim.keymap.set("n", "<C-w>-", "<C-w>s", { desc = "Split window below", noremap = true, silent = true })
vim.keymap.set("n", "<C-w>|", "<C-w>v", { desc = "Split window right", noremap = true, silent = true })

vim.keymap.set("n", "<C-w><C-y>", "<C-w><", { desc = "Shrink window horizontal", noremap = true, silent = true })
vim.keymap.set("n", "<C-w><C-u>", "<C-w>+", { desc = "Grow window vertical", noremap = true, silent = true })
vim.keymap.set("n", "<C-w><C-i>", "<C-w>-", { desc = "Grow window horizontal", noremap = true, silent = true })
vim.keymap.set("n", "<C-w><C-o>", "<C-w>>", { desc = "Shrink window vertical", noremap = true, silent = true })

-- Macros
vim.keymap.set("n", "ø", "@", { noremap = true, silent = true })
vim.keymap.set("n", "øø", "@@", { noremap = true, silent = true })

-- Indent in visual mode stays in visual mode
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true })

-- Git navigation
vim.keymap.set("n", "åg", "<cmd>Gitsigns prev_hunk<CR>zz", { noremap = true, silent = true })
vim.keymap.set("n", "æg", "<cmd>Gitsigns next_hunk<CR>zz", { noremap = true, silent = true })
vim.keymap.set("n", "guh", "<cmd>Gitsigns reset_hunk<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "gp", "<cmd>Gitsigns preview_hunk<CR>", { noremap = true, silent = true })
