-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

-- Prefer git instead of curl in order to improve connectivity in some environments
require("nvim-treesitter.install").prefer_git = true
---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"bash",
		"diff",
		"git_config",
		"git_rebase",
		"gitattributes",
		"gitcommit",
		"gitignore",
		"gotmpl",
		"graphql",
		"http",
		"json",
		"lua",
		"luadoc",
		"markdown",
		"markdown_inline",
		"nu",
		"query",
		"regex",
		"rust",
		"vim",
		"vimdoc",
		"xml",
	},

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Auto-install languages that are not installed
	auto_install = true,
	highlight = {
		enable = true,
		-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
		--  If you are experiencing weird indenting issues, add the language to
		--  the list of additional_vim_regex_highlighting and disabled languages for indent.
		additional_vim_regex_highlighting = false,
	},
	indent = { enable = true },
	injections = { enable = true },
	textobjects = {
		select = {
			enable = true,

			-- Automatically jump forward to textobject, similar to targets.vim
			lookahead = true,

			keymaps = {
				["if"] = "@function.inner",
				["af"] = "@function.outer",
				["it"] = "@class.inner",
				["at"] = "@class.outer",
				["il"] = "@loop.inner",
				["al"] = "@loop.outer",
				["ic"] = "@comment.inner",
				["ac"] = "@comment.outer",
			},
			include_surrounding_whitespace = true,
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["æf"] = "@function.outer",
				["æt"] = "@class.outer",
				["æc"] = "@comment.outer",
			},
			goto_next_end = {
				["æF"] = "@function.outer",
				["æT"] = "@class.outer",
				["æC"] = "@comment.outer",
			},
			goto_previous_start = {
				["åf"] = "@function.outer",
				["åt"] = "@class.outer",
				["åc"] = "@comment.outer",
			},
			goto_previous_end = {
				["åF"] = "@function.outer",
				["åT"] = "@class.outer",
				["åC"] = "@comment.outer",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["æa"] = "@parameter.inner",
			},
			swap_previous = {
				["åa"] = "@parameter.inner",
			},
		},
	},
})

-- There are additional nvim-treesitter modules that you can use to interact
-- with nvim-treesitter. You should go explore a few and see what interests you:
--
--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
local utils = require("skypex.utils")
utils.nmap("<leader>tt", "<cmd>TSPlaygroundToggle<CR>", "Toggle Treesitter Playground")

-- Add local parser for arcana
local arcana_parser_path = nil

arcana_parser_path = utils.get_code_path() .. "/tree-sitter-arcana/parser.so"

local stat = vim.loop.fs_stat(arcana_parser_path)

if not stat or not stat.type == "file" then
	return
end

vim.treesitter.language.add("arcana", {
	path = arcana_parser_path,
})

-- -- Add generic parse
-- local generic_parser_path = utils.get_code_path() .. "/tree-sitter-generic/parser.so"
--
-- vim.treesitter.language.add("generic", {
-- 	path = generic_parser_path,
-- })
--
-- vim.treesitter.language.register("generic", "cake")

local registry = {
	{
		lang = "arcana",
		filetype = "arcana",
	},
	{
		lang = "arcana",
		filetype = "mage",
	},
}

for _, value in ipairs(registry) do
	vim.treesitter.language.register(value.lang, value.filetype)
end

local filetype_map = {
	{
		pattern = "*.ar",
		ext = "ar",
		filetype = "arcana",
		commentstring = "//%s",
	},
	{
		pattern = "csharp",
		ext = "cs",
		filetype = "cs",
		commentstring = "//%s",
	},
	{
		pattern = "*Dockerfile*",
		filetype = "dockerfile",
		commentstring = "#%s",
	},
	{
		pattern = ".dockerignore",
		ext = "dockerignore",
		filetype = "gitignore",
		commentstring = "#%s",
	},
	{
		pattern = ".chezmoiignore",
		ext = "chezmoiignore",
		filetype = "gitignore",
		commentstring = "#%s",
	},
	{
		pattern = "*.cake",
		ext = "cake",
		filetype = "cs",
		commentstring = "//%s",
	},
	{
		pattern = "*.http",
		ext = "http",
		filetype = "http",
		commentstring = "##%s",
	},
	{
		pattern = "*.env",
		ext = "env",
		filetype = "dotenv",
		commentstring = "#%s",
		parser = "bash",
	},
	{
		pattern = "*.envrc",
		ext = "envrc",
		filetype = "",
		commentstring = "#%s",
	},
	{
		filetype = "template",
		parser = "gotmpl",
	},
}

local parsers = require("nvim-treesitter.parsers")

for _, value in ipairs(filetype_map) do
	if value.parser then
		parsers.list[value.filetype] = parsers.list[value.parser]
		parsers.list[value.filetype].filetype = value.filetype
		parsers.list[value.filetype].maintainers = nil

		vim.treesitter.language.register(value.parser, value.filetype)
	end

	if value.pattern then
		vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
			pattern = value.pattern,
			callback = function()
				vim.bo.filetype = value.filetype
				vim.bo.commentstring = value.commentstring
			end,
		})
	end
end

vim.treesitter.query.add_directive("inject-go-tmpl!", function(_, _, bufnr, _, metadata)
	local fname = vim.fs.basename(vim.api.nvim_buf_get_name(bufnr))
	local _, _, ext, _ = string.find(fname, ".*%.(%a+)(%.%a+)")

	for _, value in ipairs(filetype_map) do
		if value.ext and value.ext == ext then
			metadata["injection.language"] = value.parser or value.filetype
			return
		end
	end

	metadata["injection.language"] = ext
end, {})
