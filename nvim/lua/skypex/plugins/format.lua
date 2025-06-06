return {
	{
		"stevearc/conform.nvim",
		event = "BufReadPre",
		config = function()
			require("skypex.custom.format")
		end,
	},
	{
		"zapling/mason-conform.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
	},
}
