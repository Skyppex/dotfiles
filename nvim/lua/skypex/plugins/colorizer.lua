return {
	{
		"themaxmarchuk/tailwindcss-colors.nvim",
		config = true,
	},
	{
		"NvChad/nvim-colorizer.lua",
		config = function()
			require("skypex.custom.colorizer")
		end,
	},
}
