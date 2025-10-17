return {
	{ -- You can easily change to a different colorscheme.
		-- Change the name of the colorscheme plugin below, and then
		-- change the command in the config to whatever the name of that colorscheme is.
		--
		-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
		"tjdevries/colorbuddy.nvim",
		event = "VimEnter",
		dependencies = {
			"m4xshen/smartcolumn.nvim",
			{
				"goolord/alpha-nvim",
				event = "VimEnter",
				dependencies = {
					"echasnovski/mini.icons",
					{
						"MaximilianLloyd/ascii.nvim",
						dependencies = {
							"MunifTanjim/nui.nvim",
							"nvim-telescope/telescope.nvim",
						},
					},
				},
			},
		},
		priority = 1000, -- Make sure to load this before all the other start plugins.
		init = function()
			-- Load the colorscheme here.
			-- Like many other themes, this one has different styles, and you could load
			-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
			require("skypex.colorbuddy")

			-- You can configure highlights by doing something like:
			-- vim.cmd.hi("LspInlayHint guifg=#464959")
		end,
		config = function()
			require("skypex.custom.theming")
		end,
	},
}
