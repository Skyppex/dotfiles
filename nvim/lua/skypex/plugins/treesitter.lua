return {
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		event = "VeryLazy",
		build = ":TSUpdate",
		dependencies = {
			"tree-sitter/tree-sitter-c-sharp",
		},
		config = function()
			require("skypex.custom.treesitter")
		end,
	},
	{
		"nvim-treesitter/playground",
		cmd = "TSPlaygroundToggle",
		dependencies = "nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = "nvim-treesitter/nvim-treesitter",
	},
	{
		"dariuscorvus/tree-sitter-surrealdb.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = true,
	},
}
