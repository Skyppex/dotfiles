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
		},
		priority = 1000, -- Make sure to load this before all the other start plugins.
		init = function()
			require("skypex.custom.theming").andromeda()
		end,
	},
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
		config = function()
			require("skypex.custom.theming").alpha()
		end,
	},
	{
		"m4xshen/smartcolumn.nvim",
		config = function()
			require("skypex.custom.theming").smartcolumn()
		end,
	},
}
