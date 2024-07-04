return {
	"folke/twilight.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("twilight").setup({
			context = 20,
			expand = {
				"function",
				"function_item",
				"method",
				"method_declaration",
				"table",
				"if_statement",
				"decl_def",
				"ctrl_if",
			},
		})

		vim.keymap.set("n", "<leader>x", "<cmd>Twilight<CR>", { noremap = true, silent = true })
	end,
}
