return {
	"folke/twilight.nvim",
	config = function()
		require("twilight").setup({
			context = 20,
			expand = {
				"function",
				"method",
				"method_declaration",
				"table",
				"if_statement",
			},
		})

		vim.keymap.set("n", "<leader>x", "<cmd>Twilight<CR>", { noremap = true, silent = true })
	end,
}
