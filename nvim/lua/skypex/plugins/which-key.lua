return {
	"folke/which-key.nvim",
	event = "VimEnter",
	config = function()
		require("skypex.custom.which-key")
	end,
}
