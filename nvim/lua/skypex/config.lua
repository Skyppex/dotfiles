-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local utils = require("skypex.utils")

if not utils.is_linux() then
	vim.cmd("language en_US")
end

vim.opt.cmdheight = 0

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

vim.g.python3_host_prog = "~/scoop/shims/python3"

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.spell = false
vim.opt.spelllang = { "en" }

vim.opt.smartindent = true

vim.opt.wrap = false

-- Make line numbers default
vim.opt.number = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.opt.clipboard = "unnamedplus"

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = utils.get_home() .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 50

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = false
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.fillchars = { eob = " " }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- This option is being set by smartcolumn-nvim
-- vim.opt.colorcolumn = "80"
vim.opt.textwidth = 80

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("apply-chezmoi", { clear = true }),
	callback = function()
		local target_directory = require("skypex.utils").get_chezmoi_path()
		local current_file = vim.fn.expand("%:p")

		if string.find(current_file, target_directory, 1, true) ~= 1 then
			return
		end

		vim.notify("Applying chezmoi changes", vim.log.levels.DEBUG, {
			group = "chezmoi",
		})

		require("plenary.job")
			:new({
				command = "chezmoi",
				args = { "apply", "--force" },
				on_exit = function(_, return_val)
					if return_val == 0 then
						vim.schedule(function()
							vim.notify("Applied chezmoi changes", vim.log.levels.INFO, {
								group = "chezmoi",
							})
						end)
					else
						vim.schedule(function()
							vim.notify("Failed to apply chezmoi changes", vim.log.levels.ERROR, {
								group = "chezmoi",
							})
						end)
					end
				end,
			})
			:start()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"qf",
	},
	callback = function()
		vim.opt_local.textwidth = 0
		vim.opt_local.formatoptions:remove("t")
	end,
})
