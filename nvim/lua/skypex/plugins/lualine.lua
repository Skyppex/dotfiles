return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		config = function()
			require("skypex.custom.lualine")
		end,
	},
}
