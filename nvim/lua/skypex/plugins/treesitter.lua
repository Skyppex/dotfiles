return {
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
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		event = "VeryLazy",
		build = ":TSUpdate",
		dependencies = {
			"nushell/tree-sitter-nu",
			"tree-sitter/tree-sitter-c-sharp",
		},
		config = function()
			require("skypex.custom.treesitter")
		end,
	},
	{
		"dariuscorvus/tree-sitter-surrealdb.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = true,
	},
}
