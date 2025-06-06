return {
	{
		"olimorris/codecompanion.nvim",
		opts = {},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			{
				"ravitemer/mcphub.nvim",
				build = "npm install -g mcp-hub@latest",
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
