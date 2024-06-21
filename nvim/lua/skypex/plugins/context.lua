return {
	"nvim-treesitter/nvim-treesitter-context",
	config = function()
		local context = require("treesitter-context")

		vim.keymap.set("n", "åc", function()
			context.go_to_context(vim.v.count1)
		end)
	end,
}
