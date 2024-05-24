return {
	{
		"Hoffs/omnisharp-extended-lsp.nvim",
		on_attach = function(_, _)
			local osex = require("omnisharp_extended")

			-- replaces vim.lsp.buf.definition()
			vim.keymap.set("n", "gd", function()
				osex.telescope_lsp_definition()
			end)

			-- replaces vim.lsp.buf.type_definition()
			vim.keymap.set("n", "<leader>D", function()
				osex.telescope_lsp_defenition()
			end)

			-- replaces vim.lsp.buf.references()
			vim.keymap.set("n", "gr", function()
				osex.telescope_lsp_references()
			end)

			-- replaces vim.lsp.buf.implementation()
			vim.keymap.set("n", "gi", function()
				osex.telescope_lsp_implementation()
			end)
		end,
	},
}
