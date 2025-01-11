return {
	{
		"stevearc/oil.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons", "j-hui/fidget.nvim" },
	},
	{
		"SirZenith/oil-vcs-status",
		event = "VeryLazy",
		dependencies = {
			"stevearc/oil.nvim",
		},
		config = function()
			require("skypex.custom.oil")
		end,
	},
}
