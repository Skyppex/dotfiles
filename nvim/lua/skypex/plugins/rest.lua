return {
	"blacklight/nvim-http",
	lazy = false,
	ft = { "http" },
	config = function()
		vim.keymap.set(
			{ "n", "v" },
			"<leader>rr",
			"<cmd>Http<cr>",
			{ desc = "Run http request", noremap = true, silent = true }
		)
		vim.keymap.set(
			{ "n", "v" },
			"<leader>rs",
			"<cmd>HttpStop<cr>",
			{ desc = "Stop http request", noremap = true, silent = true }
		)
	end,
}
