return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"archibate/lualine-time",
		},
		event = "VeryLazy",
		config = function()
			require("skypex.custom.lualine")
		end,
	},
}
