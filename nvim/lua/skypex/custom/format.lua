local conform = require("conform")

---@param ... string
---@return string | table<string>
local function first(bufnr, ...)
	if not bufnr then
		return select(1, ...)
	end

	for i = 1, select("#", ...) do
		local formatter = select(i, ...)
		if conform.get_formatter_info(formatter, bufnr).available then
			return formatter
		end
	end
	return select(1, ...)
end

local function first_then_injected(...)
	local list = ...

	return function(bufnr)
		return { first(bufnr, list), "injected" }
	end
end

local formatters_by_ft = {
	-- Runs the single formatter
	lua = { "stylua", "injected" },
	-- Runs each formatter sequentially
	python = { "black", "injected" },

	-- Tries to run each formatter until one succeeds
	javascript = first_then_injected("prettierd", "prettier"),
	javascriptreact = first_then_injected("prettierd", "prettier"),
	typescript = first_then_injected("prettierd", "prettier"),
	typescriptreact = first_then_injected("prettierd", "prettier"),
	css = first_then_injected("prettierd", "prettier"),
	scss = first_then_injected("prettierd", "prettier"),
	json = first_then_injected("jq", "prettierd", "prettier"),
	graphql = first_then_injected("prettierd", "prettier"),
	cs = { "csharpier", "injected" },
	csx = { "csharpier", "injected" },
	go = { "gofmt", "injected" },
	xml = { "xmlformatter", "injected" },
	yaml = first_then_injected("yamlfix", "prettierd", "prettier"),
	toml = first_then_injected("taplo", "prettierd", "prettier"),
	markdown = first_then_injected("markdownlint", "prettierd", "prettier"),
	codecompanion = first_then_injected("markdownlint", "prettierd", "prettier"),
	sh = { "beautysh", "injected" },
	bash = { "beautysh", "injected" },
	http = { "kulala-fmt", "injected" },
	rest = { "kulala-fmt", "injected" },
	kotlin = { "ktfmt", "injected" },
	nix = { "alejandra", "injected" },
	-- nu = { "nufmt", "injected" }, Disabled because it breaks the code
}

local formatters = {
	csharpier = {
		command = "csharpier",
		args = { "format", "--write-stdout" },
		stdin = true,
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
}

local function extract_formatters()
	local formatters_to_install = {}

	for _, formatters in pairs(formatters_by_ft) do
		if type(formatters) == "function" then
			formatters = formatters(nil)
		end

		for _, formatter in pairs(formatters) do
			-- support case where the user has defined multiple formatters
			-- for said filetype. E.g javascript = { { "prettierd", "prettier" } }
			-- this only happens when using a function as the formatter
			if type(formatter) == "table" then
				for _, f in pairs(formatter) do
					formatters_to_install[f] = 1
				end
			else
				formatters_to_install[formatter] = 1
			end
		end
	end

	return formatters_to_install
end

local ensure_installed = extract_formatters()

for formatter, _ in pairs(formatters) do
	ensure_installed[formatter] = nil
end

vim.tbl_extend("keep", ensure_installed, {
	"csharpier",
})

require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

---@param bufnr integer
conform.setup({
	notify_on_error = true,
	async = true,
	format_after_save = function(bufnr)
		-- Disable with a global or buffer-local variable
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end

		-- Disable "format_on_save lsp_fallback" for languages that don't
		-- have a well standardized coding style. You can add additional
		-- languages here or re-enable it for the disabled ones.
		local disable_filetypes = { c = true, cpp = true }
		return {
			lsp_format = (function()
				if not disable_filetypes[vim.bo[bufnr].filetype] then
					return "fallback"
				end

				return "never"
			end)(),
			timeout = 5000,
		}
	end,
	formatters = formatters,
	formatters_by_ft = formatters_by_ft,
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

local utils = require("skypex.utils")
local nmap = utils.nmap
local xmap = utils.xmap

nmap("<leader>tf", "<cmd>FormatToggle<cr>", "Toggle autoformat on save for current buffer")
nmap("<leader>tF", "<cmd>FormatToggle!<cr>", "Toggle autoformat on save for all buffers")

local function get_format_func(other)
	local args = vim.tbl_extend("keep", {
		lsp_fallback = true,
		timeout = 1000,
		async = true,
	}, other or {})

	return function()
		conform.format(args)
	end
end

nmap("<leader>ff", get_format_func(), "Format file")

-- Set up the operator mapping
xmap("<leader>f", get_format_func(), "Format selection")
-- Define your operator function
local function format_operator(_)
	local start_line, start_col, end_line, end_col

	-- Get the marks set by the operator
	local mark_start = vim.api.nvim_buf_get_mark(0, "[")
	local mark_end = vim.api.nvim_buf_get_mark(0, "]")

	start_line, start_col = mark_start[1], mark_start[2]
	end_line, end_col = mark_end[1], mark_end[2]

	-- Call conform.format with the range
	get_format_func({
		range = {
			["start"] = { start_line, start_col },
			["end"] = { end_line, end_col },
		},
	})()
end

-- Set up the operator mapping
nmap("<leader>f", function()
	vim.o.operatorfunc = "v:lua._G.format_operator"
	return "g@"
end, "Format file", true)

-- Make the function available globally
_G.format_operator = format_operator
