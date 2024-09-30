return {
	"mistweaverco/kulala.nvim",
	ft = { "http", "rest" },
	config = function()
		require("skypex.custom.rest").kulala()
	end,
}
