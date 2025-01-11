return {
	{
		"tpope/vim-fugitive",
		event = "VeryLazy",
		dependencies = {
			{
				"akinsho/git-conflict.nvim",
				event = "VeryLazy",
				version = "*",
			},
			{ -- Adds git related signs to the gutter, as well as utilities for managing changes
				"lewis6991/gitsigns.nvim",
				event = "BufReadPre",
			},
		},
		config = function()
			require("skypex.custom.git")
		end,
	},
}
