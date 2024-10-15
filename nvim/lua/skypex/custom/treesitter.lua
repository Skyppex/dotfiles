-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

-- Prefer git instead of curl in order to improve connectivity in some environments
require("nvim-treesitter.install").prefer_git = true
---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"query",
		"rust",
		"nu",
		"diff",
		"lua",
		"luadoc",
		"markdown",
		"markdown_inline",
		"vim",
		"vimdoc",
		"xml",
		"http",
		"json",
		"graphql",
		"regex",
		"bash",
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

require("skypex.utils").nmap("<leader>tt", "<cmd>TSPlaygroundToggle<CR>", "Toggle Treesitter Playground")

-- Add local parser for arcana
local home_drive = os.getenv("HOMEDRIVE")
local home_path = os.getenv("HOMEPATH")
local home = home_drive .. home_path
local path

if home:find("brage.ingebrigtsen") then
	path = home .. "/dev/code/arcana/tree-sitter-arcana/parser.so"
else
	path = "D:/code/arcana/tree-sitter-arcana/parser.so"
end

vim.treesitter.language.add("arcana", {
	path = path,
})

vim.treesitter.language.register("arcana", "arcana")

local filetype_map = {
	{
		pattern = "*.ar",
		filetype = "arcana",
		commentstring = "//%s",
	},
	{
		pattern = "*Dockerfile*",
		filetype = "dockerfile",
		commentstring = "#%s",
	},
	{
		pattern = ".dockerignore",
		filetype = "gitignore",
		commentstring = "#%s",
	},
	{
		pattern = "*.cake",
		filetype = "cs",
		commentstring = "//%s",
	},
	{
		pattern = "*.http",
		filetype = "http",
		commentstring = "#%s",
	},
}

for _, value in ipairs(filetype_map) do
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		pattern = value.pattern,
		callback = function()
			vim.bo.filetype = value.filetype
			vim.bo.commentstring = value.commentstring
		end,
	})
end
