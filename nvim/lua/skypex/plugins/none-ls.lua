return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				-- Lua
				null_ls.builtins.formatting.stylua,

				-- JavaScript / TypeScript
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.diagnostics.eslint_d,

				-- Python
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.isort,
			},
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = vim.lsp.buf.format,
		})
	end,
}
