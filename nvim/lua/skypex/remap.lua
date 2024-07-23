vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { noremap = true, silent = true })

-- Reverse j and k
vim.keymap.set({ "n", "v", "o" }, "j", "<up>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v", "o" }, "k", "<down>", { noremap = true, silent = true })

-- TIP: Disable arrow keys in insert mode and x mode
vim.keymap.set({ "i", "x" }, "<left>", '<cmd>echo "Use normal mode to move!!"<CR>', { noremap = true, silent = true })
vim.keymap.set({ "i", "x" }, "<right>", '<cmd>echo "Use normal mode to move!!"<CR>', { noremap = true, silent = true })
vim.keymap.set({ "i", "x" }, "<up>", '<cmd>echo "Use normal mode to move!!"<CR>', { noremap = true, silent = true })
vim.keymap.set({ "i", "x" }, "<down>", '<cmd>echo "Use normal mode to move!!"<CR>', { noremap = true, silent = true })

-- Quickfix list navigation
vim.keymap.set("n", "<S-A-j>", "<cmd>cprev<CR>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<S-A-k>", "<cmd>cnext<CR>zz", { noremap = true, silent = true })

-- vim.keymap.set("n", "<S-A-x>", "<cmd>cclose<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n" "<S-A-x>", "<cmd>copen<CR>", { noremap = true, silent = true })

-- Save file
vim.keymap.set("n", "<C-s>", "<cmd>wa<CR>", { noremap = true, silent = true })

-- Move lines of code in visual mode
vim.keymap.set("v", "J", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "K", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

vim.keymap.set("n", "J", "mzJ`z", { noremap = true, silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })
vim.keymap.set("n", "n", "nzz", { noremap = true, silent = true })
vim.keymap.set("n", "N", "Nzz", { noremap = true, silent = true })

vim.keymap.set("x", "<leader>p", '"_dP', { noremap = true, silent = true })

-- Just don't do this apparently'
vim.keymap.set("n", "Q", "<nop>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>sp", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left>", { noremap = true, silent = true })

-- Buffer navigation
vim.keymap.set("n", "åb", "<cmd>bprevious<CR>zz", { noremap = true, silent = true })
vim.keymap.set("n", "æb", "<cmd>bnext<CR>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>b", "<cmd>b#<CR>zz", { noremap = true, silent = true })

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { noremap = true, silent = true })

-- Alias ctrl+c to Esc
vim.keymap.set({ "i", "v", "s" }, "<C-c>", "<Esc>", { noremap = true, silent = true })

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

vim.keymap.set("n", "<C-w><C-y>", "3<C-w><", { desc = "Shrink window horizontal", noremap = true, silent = true })
vim.keymap.set("n", "<C-w><C-u>", "3<C-w>+", { desc = "Grow window vertical", noremap = true, silent = true })
vim.keymap.set("n", "<C-w><C-i>", "3<C-w>-", { desc = "Grow window horizontal", noremap = true, silent = true })
vim.keymap.set("n", "<C-w><C-o>", "3<C-w>>", { desc = "Shrink window vertical", noremap = true, silent = true })

-- Macros
vim.keymap.set("n", "ø", "@", { noremap = true, silent = true })
vim.keymap.set("n", "øø", "@@", { noremap = true, silent = true })

-- Indent in visual mode stays in visual mode
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true })

-- Camel case motion
vim.keymap.set(
	"n",
	"<leader>cC",
	"<left>/\\u<CR>N",
	{ desc = "Camel/Pascal Case Word Back", noremap = true, silent = true }
)
vim.keymap.set("n", "<leader>cc", "/\\u<CR>", { desc = "Camel/Pascal Case Word", noremap = true, silent = true })

vim.keymap.set("o", "<leader>cc", "/\\u<CR>", { desc = "Camel/Pascal Case Word", noremap = true, silent = true })

vim.keymap.set(
	"n",
	"<leader>ciC",
	"<left>/\\u<CR>N<right>",
	{ desc = "Camel/Pascal Case Word Back", noremap = true, silent = true }
)
vim.keymap.set("n", "<leader>cic", "/\\u<CR><left>", { desc = "Camel/Pascal Case Word", noremap = true, silent = true })

vim.keymap.set("v", "cC", "<left>/\\u<CR>N", { desc = "Camel/Pascal Case Word Back", noremap = true, silent = true })
vim.keymap.set("v", "cc", "/\\u<CR>", { desc = "Camel/Pascal Case Word", noremap = true, silent = true })

vim.keymap.set(
	"v",
	"ciC",
	"<left>/\\u<CR>N<right>",
	{ desc = "Camel/Pascal Case Word Back", noremap = true, silent = true }
)
vim.keymap.set("v", "cic", "/\\u<CR><left>", { desc = "Camel/Pascal Case Word", noremap = true, silent = true })

-- Snake case motion
vim.keymap.set("n", "<leader>cS", "<left>/_<CR>N", { desc = "Snake Case Word Back", noremap = true, silent = true })
vim.keymap.set("n", "<leader>cs", "/_<CR>", { desc = "Snake Case Word", noremap = true, silent = true })

vim.keymap.set("o", "<leader>cs", "/_<CR>", { desc = "Snake Case Word", noremap = true, silent = true })

vim.keymap.set(
	"n",
	"<leader>ciS",
	"<left>/_<CR>N<right>",
	{ desc = "Snake Case Word Back", noremap = true, silent = true }
)
vim.keymap.set("n", "<leader>cis", "/_<CR><left>", { desc = "Snake Case Word", noremap = true, silent = true })

vim.keymap.set("v", "cS", "<left>/_<CR>N", { desc = "Snake Case Word Back", noremap = true, silent = true })
vim.keymap.set("v", "cs", "/_<CR>", { desc = "Snake Case Word", noremap = true, silent = true })

vim.keymap.set("v", "ciS", "<left>/_<CR>N<right>", { desc = "Snake Case Word Back", noremap = true, silent = true })
vim.keymap.set("v", "cis", "/_<CR><left>", { desc = "Snake Case Word", noremap = true, silent = true })

-- Redo
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo", noremap = true, silent = true })

-- Newline before .
vim.keymap.set("n", "<leader>.", function()
	local count = vim.v.count1 -- Get the count prefix, default to 1 if none is provided
	for _ = 1, count do
		vim.cmd("normal! f.i<cr><esc>")
	end
end)
