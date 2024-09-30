return {
	{
		"mfussenegger/nvim-lint",
		dependencies = {
			"williamboman/mason.nvim",
		},
		event = { "BufWritePre", "BufNewFile" },
		config = function()
			require("skypex.custom.lint").lint()
		end,
	},
	{
		"rshkarin/mason-nvim-lint",
		dependencies = {
			"mfussenegger/nvim-lint",
			"williamboman/mason.nvim",
		},
		event = { "BufWritePre", "BufNewFile" },
		config = function()
			require("skypex.custom.lint").mason()
		end,
	},
}
