return {
	{
		"tpope/vim-fugitive",
		event = "VeryLazy",
		config = function()
			require("skypex.custom.git").fugitive()
		end,
	},
	{
		"akinsho/git-conflict.nvim",
		event = "VeryLazy",
		version = "*",
		config = function()
			require("skypex.custom.git").conflict()
		end,
	},
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		config = function()
			require("skypex.custom.git").gitsigns()
		end,
	},
	{
		"pwntester/octo.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("skypex.custom.git").octo()
		end,
	},
}
