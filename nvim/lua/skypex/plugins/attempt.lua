return {
	"m-demare/attempt.nvim",
	event = "VeryLazy",
	dependencies = "nvim-telescope/telescope.nvim",
	config = function()
		require("skypex.custom.attempt")
	end,
}
