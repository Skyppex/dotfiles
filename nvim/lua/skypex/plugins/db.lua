return {
	{
		"tpope/vim-dadbod",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("skypex.custom.db")
		end,
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		event = "VeryLazy",
		dependencies = {
			"tpope/vim-dadbod",
		},
	},
}
