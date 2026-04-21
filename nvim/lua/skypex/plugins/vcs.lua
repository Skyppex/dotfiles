return {
	{
		"akinsho/git-conflict.nvim",
		event = "VeryLazy",
		version = "*",
		config = function()
			require("skypex.custom.vcs").conflict()
			require("skypex.custom.vcs").cmd()
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		config = function()
			require("skypex.custom.vcs").gitsigns()
		end,
	},
}
