return {
	{
		"tpope/vim-fugitive",
		event = "VeryLazy",
	},
	{
		"akinsho/git-conflict.nvim",
		event = "VeryLazy",
		version = "*",
	},
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
	},
}
