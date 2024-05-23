return {
	{
		"hoffs/omnisharp-extended-lsp",
		on_attach = function(_, _)
			-- Disable omnisharp formatting
			-- client.resolved_capabilities.document_formatting = false
			-- client.resolved_capabilities.document_range_formatting = false

			-- Replaces vim.lsp.buf.definition()
			local osex = require("omnisharp_extended").lsp_definition()
			vim.keymap.set("n", "gd", function()
				osex.lsp_definition()
			end, { noremap = true, silent = true })

			-- Replaces vim.lsp.buf.type_definition()
			vim.keymap.set("n", "<leader>D", function()
				osex.lsp_type_definition()
			end, { noremap = true, silent = true })

			-- Replaces vim.lsp.buf.references()
			vim.keymap.set("n", "gr", function()
				osex.lsp_references()
			end, { noremap = true, silent = true })

			-- Replaces vim.lsp.buf.implementation()
			vim.keymap.set("n", "gi", function()
				osex.lsp_implementation()
			end, { noremap = true, silent = true })
		end,
	},
}
