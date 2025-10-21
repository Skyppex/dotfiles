return {
	{
		"mfussenegger/nvim-lint",
		dependencies = {
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			dependencies = {
				"williamboman/mason.nvim",
			},
		},
		event = { "BufWritePre", "BufNewFile" },
		config = function()
			require("skypex.custom.lint")
		end,
	},
}
