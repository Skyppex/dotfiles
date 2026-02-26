return {
	{
		"akinsho/git-conflict.nvim",
		event = "VeryLazy",
		version = "*",
		config = function()
			require("skypex.custom.git").conflict()
			require("skypex.custom.git").cmd()
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		config = function()
			require("skypex.custom.git").gitsigns()
		end,
	},
}
