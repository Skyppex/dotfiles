local conform = require("conform")

conform.setup({
	notify_on_error = false,
	async = true,
	format_on_save = function(bufnr)
		-- Disable with a global or buffer-local variable
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end

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
		},
		gofmt = {
			command = "gofmt",
		},
		jq = {
			command = "jq",
			args = { "--monochrome-output" },
		},
		-- nufmt is not ready to be used yet, it breaks the code
		-- nufmt = {
		-- 	command = "nufmt",
		-- },
	},
	formatters_by_ft = {
		-- Runs the single formatter
		lua = { "stylua" },
		-- Runs each formatter sequentially
		python = { "isort", "black" },

		-- Tries to run each formatter until one succeeds
		javascript = { "prettierd", "prettier", stop_after_first = true },
		javascriptreact = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		typescriptreact = { "prettierd", "prettier", stop_after_first = true },
		css = { "prettierd", "prettier", stop_after_first = true },
		scss = { "prettierd", "prettier", stop_after_first = true },
		json = { "jq", "prettierd", "prettier", stop_after_first = true },
		cs = { "csharpier" },
		csx = { "csharpier" },
		go = { "gofmt" },
		xml = { "xmlformatter" },
		yaml = { "yamlfix", "prettierd", "prettier", stop_after_first = true },
		markdown = { "markdownlint", "prettierd", "prettier", stop_after_first = true },
		-- nu = { "nufmt" }, Disabled because it breaks the code
	},
})

vim.api.nvim_create_user_command("FormatToggle", function(args)
	if args.bang then
		vim.g.disable_autoformat = not vim.g.disable_autoformat

		if vim.g.disable_autoformat then
			print("Disabled autoformat on save for all buffers")
		else
			print("Enabled autoformat on save for all buffers")
		end
	else
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = not vim.b.disable_autoformat

		if vim.b.disable_autoformat then
			print("Disabled autoformat on save for current buffer")
		else
			print("Enabled autoformat on save for current buffer")
		end
	end
end, {
	desc = "Toggle autoformat on save",
	bang = true,
})

local nmap = require("skypex.utils").nmap

nmap("<leader>tf", "<cmd>FormatToggle<cr>", "Toggle autoformat on save for current buffer")
nmap("<leader>tF", "<cmd>FormatToggle!<cr>", "Toggle autoformat on save for all buffers")
