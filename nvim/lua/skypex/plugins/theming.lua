return {
	{ -- You can easily change to a different colorscheme.
		-- Change the name of the colorscheme plugin below, and then
		-- change the command in the config to whatever the name of that colorscheme is.
		--
		-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
		"nobbmaestro/nvim-andromeda",
		event = "VimEnter",
		lazy = true,
		dependencies = {
			"tjdevries/colorbuddy.nvim",
			"m4xshen/smartcolumn.nvim",
			{
				"goolord/alpha-nvim",
				event = "VimEnter",
				dependencies = {
					"echasnovski/mini.icons",
					{
						"MaximilianLloyd/ascii.nvim",
						dependencies = { "MunifTanjim/nui.nvim", "nvim-telescope/telescope.nvim" },
					},
				},
			},
		},
		priority = 1000, -- Make sure to load this before all the other start plugins.
		init = function()
			require("andromeda").setup({
				preset = "andromeda",
				transparent_bg = true,
			})

			-- Load the colorscheme here.
			-- Like many other themes, this one has different styles, and you could load
			-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
			vim.cmd.colorscheme("andromeda")
			local colors = require("skypex.colors")

			-- You can configure highlights by doing something like:
			vim.cmd.hi("Comment gui=none")
			vim.cmd.hi("CursorLine guibg=none")
			vim.cmd.hi("CursorLineNr guibg=none")
			vim.cmd.hi("Visual guibg=#2e2e2e")
			vim.cmd.hi("LspInlayHint guifg=#464959")

			-- gitsigns highlights
			vim.cmd.hi("gitsignscurrentlineblame guifg=#ff8800 guibg=none")
			vim.cmd("hi link GitSignsStagedAdd GitSignsAdd")
			vim.cmd("hi link GitSignsStagedChange GitSignsChange")
			vim.cmd("hi link GitSignsStagedDelete GitSignsDelete")
			vim.cmd("hi link GitSignsStagedChangedelete GitSignsChangedelete")
			vim.cmd("hi link GitSignsStagedTopdelete GitSignsTopdelete")
			vim.cmd("hi link GitSignsStagedAddNr GitSignsAddNr")
			vim.cmd("hi link GitSignsStagedChangeNr GitSignsChangeNr")
			vim.cmd("hi link GitSignsStagedDeleteNr GitSignsDeleteNr")
			vim.cmd("hi link GitSignsStagedChangedeleteNr GitSignsChangedeleteNr")
			vim.cmd("hi link GitSignsStagedTopdeleteNr GitSignsTopdeleteNr")
			vim.cmd("hi link GitSignsStagedAddLn GitSignsAddLn")
			vim.cmd("hi link GitSignsStagedChangeLn GitSignsChangeLn")
			vim.cmd("hi link GitSignsStagedDeleteLn GitSignsDeleteLn")
		end,
		config = function()
			require("skypex.custom.theming")
		end,
	},
}
