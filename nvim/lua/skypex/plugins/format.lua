return {
	{
		"stevearc/conform.nvim",
		event = "BufReadPre",
		dependencies = {
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			dependencies = {
				"williamboman/mason.nvim",
			},
		},
		config = function()
			require("skypex.custom.format")
		end,
	},
}
