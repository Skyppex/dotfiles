return {
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		event = "VeryLazy",
		build = ":TSUpdate",
		dependencies = {
			"nushell/tree-sitter-nu",
			"tree-sitter/tree-sitter-c-sharp",
			{
				"nvim-treesitter/playground",
				cmd = "TSPlaygroundToggle",
			},
		},
		opts = {
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

			-- Autoinstall languages that are not installed
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
		},
		config = function(_, opts)
			-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

			-- Prefer git instead of curl in order to improve connectivity in some environments
			require("nvim-treesitter.install").prefer_git = true
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup(opts)

			-- There are additional nvim-treesitter modules that you can use to interact
			-- with nvim-treesitter. You should go explore a few and see what interests you:
			--
			--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
			--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
			--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects

			vim.keymap.set(
				"n",
				"<leader>tt",
				"<cmd>TSPlaygroundToggle<CR>",
				{ desc = "Toggle Treesitter Playground", noremap = true, silent = true }
			)

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

			vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
				pattern = "*.ar",
				callback = function()
					vim.bo.filetype = "arcana"
					vim.bo.commentstring = "//%s"
				end,
			})
		end,
	},
}
