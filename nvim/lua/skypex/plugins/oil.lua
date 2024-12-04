return {
	{
		"stevearc/oil.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons", "j-hui/fidget.nvim" },
		config = function()
			require("skypex.custom.oil").oil()
		end,
	},
	{
		"SirZenith/oil-vcs-status",
		event = "VeryLazy",
		dependencies = {
			"stevearc/oil.nvim",
		},
		config = function()
			require("skypex.custom.oil").oil_vcs()
		end,
	},
}
