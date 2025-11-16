return {
	"mrjones2014/smart-splits.nvim",
	event = "VimEnter",
	config = function()
		require("skypex.custom.navigation")
	end,
}
