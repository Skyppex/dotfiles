return {
	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		event = "VeryLazy",
		config = function()
			require("skypex.custom.mini")
		end,
	},
}
