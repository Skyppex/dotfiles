require("conform").setup({
	notify_on_error = false,
	async = true,
	format_on_save = function(bufnr)
		-- Disable "format_on_save lsp_fallback" for languages that don't
		-- have a well standardized coding style. You can add additional
		-- languages here or re-enable it for the disabled ones.
		local disable_filetypes = { c = true, cpp = true }
		return {
			lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
			timeout = 5000,
		}
	end,
	formatters = {
		csharpier = {
			inherit = true,
			prepend_args = { "--config-path", vim.fn.stdpath("config") .. "/.csharpierrc.json" },
		},
		gofmt = {
			command = "gofmt",
		},
		json = {
			command = "jq",
		},
		nufmt = {
			command = "nufmt",
		},
	},
	formatters_by_ft = {
		lua = { "stylua" },
		-- Runs each formatter sequentially
		python = { "isort", "black" },

		-- Tries to run each formatter until one succeeds
		javascript = { { "prettierd", "prettier" } },
		javascriptreact = { { "prettierd", "prettier" } },
		typescript = { { "prettierd", "prettier" } },
		typescriptreact = { { "prettierd", "prettier" } },
		css = { { "prettierd", "prettier" } },
		scss = { { "prettierd", "prettier" } },
		json = { { "jq", "prettierd", "prettier" } },
		cs = { "csharpier" },
		csx = { "csharpier" },
		go = { "gofmt" },
		xml = { "xmlformatter" },
		yaml = { { "yamlfix", "prettierd", "prettier" } },
		markdown = { { "markdownlint", "prettierd", "prettier" } },
		nu = { "nufmt" },
	},
})
