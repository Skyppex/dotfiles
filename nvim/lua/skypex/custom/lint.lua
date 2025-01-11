local M = {}

M.lint = function()
	local lint = require("lint")

	lint.linters_by_ft = {
		go = { "golangcilint" },
		javascript = { "eslint_d" },
		typescript = { "eslint_d" },
		javascriptreact = { "eslint_d" },
		typescriptreact = { "eslint_d" },
		json = { "jsonlint" },
		yaml = { "yamllint" },
	}

	require("skypex.utils").nmap("<leader>l", function()
		lint.try_lint()
	end, "Lint current file")

	local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

	vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
		group = lint_augroup,
		callback = function()
			lint.try_lint()
		end,
	})
end

M.mason = function()
	require("mason-nvim-lint").setup({
		ensure_installed = {
			"eslint_d",
			"golangci-lint",
			"jsonlint",
			"shellcheck",
			"yamllint",
		},
		automatic_installation = true,
	})
end

M.all = function()
	M.lint()
	M.mason()
end

M.all()

return M
