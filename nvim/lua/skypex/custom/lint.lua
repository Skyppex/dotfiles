local M = {}

local linters_by_ft = {
	go = { "golangcilint" },
	javascript = { "eslint_d" },
	typescript = { "eslint_d" },
	javascriptreact = { "eslint_d" },
	typescriptreact = { "eslint_d" },
	json = { "jsonlint" },
	yaml = { "yamllint" },
	sh = { "shellcheck" },
	bash = { "shellcheck" },
	kotlin = { "ktlint" },
	-- markdown = { "markdownlint" },
}

local lint_to_mason = {
	golangcilint = "golangci-lint",
}

M.lint = function()
	local lint = require("lint")

	lint.linters_by_ft = linters_by_ft

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
	local ensure_installed = {}

	for _, linters in pairs(linters_by_ft) do
		for _, linter in pairs(linters) do
			if type(linter) == "table" then
				for _, l in pairs(linter) do
					ensure_installed[l] = 1
				end
			else
				ensure_installed[linter] = 1
			end
		end
	end

	require("mason-nvim-lint").setup({
		ensure_installed = ensure_installed,
		automatic_installation = true,
	})
end

M.all = function()
	M.lint()
	M.mason()
end

M.all()

return M
