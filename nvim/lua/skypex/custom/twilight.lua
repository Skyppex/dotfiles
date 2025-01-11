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

require("skypex.utils").nmap("<leader>x", "<cmd>Twilight<CR>", "Toggle Twilight")
