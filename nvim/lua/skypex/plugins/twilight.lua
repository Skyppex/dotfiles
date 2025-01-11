return {
	"folke/twilight.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("skypex.custom.twilight")
	end,
}
