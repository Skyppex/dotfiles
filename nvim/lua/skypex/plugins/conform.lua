return {
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			notify_on_error = false,
			async = true,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true }
				return {
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			formatters = {
				csharpier = {
					inherit = true,
					prepend_args = { "--config-path", vim.fn.stdpath("config") .. "/.csharpierrc.json" },
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform can also run multiple formatters sequentially
				python = { "isort", "black" },

				-- You can use a sub-list to tell conform to run *until* a formatter
				-- is found.
				javascript = { { "prettierd", "prettier" } },
				typescript = { { "prettierd", "prettier" } },
				cs = { "csharpier" },
				csx = { "csharpier" },
			},
		},
	},
}
