return {
	{
		"simrat39/rust-tools.nvim",
		dependencies = { "hrsh7th/cmp-nvim-lsp" },
		event = { "BufReadPre", "BufNewFile" },
		ft = "rust",
		config = function()
			local rt = require("rust-tools")

			rt.setup({
				server = {
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
					on_attach = function(client, bufnr)
						vim.keymap.set(
							"n",
							"<leader>5",
							rt.hover_actions.hover_actions,
							{ noremap = true, silent = true, buffer = bufnr }
						)

						vim.keymap.set(
							"n",
							"<leader>4",
							rt.code_action_group.code_action_group,
							{ noremap = true, silent = true, buffer = bufnr }
						)
					end,
				},
				tools = {
					hover_actions = {
						auto_focus = true,
					},
					autoSetHints = true,
					hoverWithActions = true,
					runnables = {
						use_telescope = true,
					},
					inlay_hints = {
						show_parameter_hints = true,
						parameter_hints_prefix = ": ",
						other_hints_prefix = ": ",
					},
				},
				dap = {
					adapter = function()
						local codelldb_root = require("mason-registry").get_package("codelldb"):get_install_path()
							.. "/extension/"
						local codelldb_path = codelldb_root .. "adapter/codelldb"
						local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"
						return require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
					end,
				},
			})
		end,
	},
}
