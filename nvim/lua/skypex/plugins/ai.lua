return {
	{
		"olimorris/codecompanion.nvim",
		opts = {},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			{
				"ravitemer/mcphub.nvim",
				build = "bundled_build.lua",
				dependencies = {
					"nvim-lua/plenary.nvim",
				},
			},
		},
		config = function()
			require("skypex.custom.ai")
		end,
	},
}
