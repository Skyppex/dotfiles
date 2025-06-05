return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown", "codecompanion" },
	config = function()
		require("skypex.custom.markdown")
	end,
}
