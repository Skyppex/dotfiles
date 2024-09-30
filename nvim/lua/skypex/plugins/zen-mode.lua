return {
	{
		"folke/zen-mode.nvim",
		event = "VeryLazy",
		config = function()
			require("skypex.custom.zen-mode")
		end,
	},
}
