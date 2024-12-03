return {
	{
		"stevearc/oil.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local file_tree = require("skypex.custom.file-tree")
			file_tree.oil()
			file_tree.hook()
		end,
	},
	{
		"SirZenith/oil-vcs-status",
		event = "VeryLazy",
		dependencies = {
			"stevearc/oil.nvim",
		},
		config = function()
			require("skypex.custom.file-tree").oil_vcs()
		end,
	},
}
