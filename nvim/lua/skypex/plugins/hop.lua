return {
	{
		"smoka7/hop.nvim",
		event = { "BufReadPre", "BufNewFile" },
		version = "v2",
		config = function()
			require("skypex.custom.hop")
		end,
	},
}
