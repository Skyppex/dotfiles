require("skypex.config")
require("skypex.remap")
require("skypex.signcolumn")
skate = require("skypex.skate")

vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/tjdevries/colorbuddy.nvim",
	"https://github.com/goolord/alpha-nvim",
	"https://github.com/MaximilianLloyd/ascii.nvim",
}, { confirm = false })

require("skypex.colorbuddy")
require("skypex.configs.theming")

local utils = require("skypex.utils")
utils.local_plugin("direnv.nvim", "https://github.com/skyppex/direnv.nvim")

require("skypex.configs.direnv")

vim.defer_fn(function()
	vim.pack.add({
		-- core
		"https://github.com/echasnovski/mini.nvim",
		"https://github.com/stevearc/oil.nvim",
		"https://github.com/SirZenith/oil-vcs-status",
		"https://github.com/nvim-treesitter/nvim-treesitter",
		"https://github.com/tree-sitter/tree-sitter-c-sharp",
		"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
		"https://github.com/mbbill/undotree",
	}, { confirm = false })

	require("skypex.configs.undotree")
	require("skypex.configs.mini")
	require("skypex.configs.treesitter")
	require("skypex.configs.oil")

	vim.pack.add({
		"https://github.com/mrjones2014/smart-splits.nvim",
	}, { confirm = false })

	require("skypex.configs.navigation")

	vim.pack.add({
		-- deps
		"https://github.com/williamboman/mason.nvim",
		"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
		"https://github.com/MunifTanjim/nui.nvim",
	}, { confirm = false })

	vim.pack.add({
		-- completion
		"https://github.com/saghen/blink.lib",
		"https://github.com/saghen/blink.cmp",
		"https://github.com/L3MON4D3/LuaSnip",
		"https://github.com/rafamadriz/friendly-snippets",
	}, { confirm = false })

	require("skypex.configs.cmp")
	require("skypex.blink-dbee")

	vim.pack.add({
		-- lsp
		"https://github.com/neovim/nvim-lspconfig",
		"https://github.com/williamboman/mason-lspconfig.nvim",
		"https://github.com/Decodetalkers/csharpls-extended-lsp.nvim",
	}, { confirm = false })

	require("skypex.configs.lsp")

	vim.pack.add({
		-- vcs
		"https://github.com/akinsho/git-conflict.nvim",
		"https://github.com/lewis6991/gitsigns.nvim",
	}, { confirm = false })

	utils.local_plugin("kanji.nvim", "https://github.com/skyppex/kanji.nvim")

	require("skypex.configs.vcs")

	vim.pack.add({
		-- automation
		"https://github.com/stevearc/conform.nvim",
		"https://github.com/mfussenegger/nvim-lint",
	}, { confirm = false })

	require("skypex.configs.lint")
	require("skypex.configs.format")

	vim.pack.add({
		-- notifications
		"https://github.com/j-hui/fidget.nvim",
	}, { confirm = false })

	require("skypex.configs.notifications")

	vim.pack.add({
		-- clients
		"https://github.com/mistweaverco/kulala.nvim",
	}, { confirm = false })

	utils.local_plugin("nvim-dbee", "https://github.com/skyppex/nvim-dbee")
	utils.local_plugin("attempt.nvim", "https://github.com/skyppex/attempt.nvim")

	local code_ws = require("skypex.workspaces").setup() -- sets up the initial tab as a workspace

	if code_ws then
		utils.map("n", {
			"<c-w><c-w>",
			"<c-w>w",
		}, function()
			code_ws:activate()
		end, "toggle coding workspace")

		require("skypex.configs.rest")
		require("skypex.configs.db")
		require("skypex.configs.attempt")
	end

	vim.pack.add({
		-- dap
		"https://github.com/mfussenegger/nvim-dap",
		"https://github.com/theHamsta/nvim-dap-virtual-text",
		"https://github.com/jay-babu/mason-nvim-dap.nvim",
	}, { confirm = false })

	require("skypex.configs.dap")

	-- data
	utils.local_plugin("bellows.nvim", "https://github.com/skyppex/bellows.nvim")
	utils.local_plugin("jq-playground.nvim", "https://github.com/skyppex/jq-playground.nvim")

	vim.pack.add({
		-- testing
		"https://github.com/nvim-neotest/neotest",
		"https://github.com/nvim-neotest/nvim-nio",
		"https://github.com/antoinemadec/FixCursorHold.nvim",
		"https://github.com/Issafalcon/neotest-dotnet",

		-- other
		"https://github.com/laytan/cloak.nvim",
		"https://github.com/NvChad/nvim-colorizer.lua",
		"https://github.com/saecki/crates.nvim",
		"https://github.com/hat0uma/csvview.nvim",
		"https://github.com/eandrju/cellular-automaton.nvim",
		"https://github.com/nvim-lualine/lualine.nvim",
		"https://github.com/MeanderingProgrammer/render-markdown.nvim",
		"https://github.com/obsidian-nvim/obsidian.nvim",
		"https://github.com/stevearc/quicker.nvim",
		"https://github.com/HiPhish/rainbow-delimiters.nvim",
		"https://github.com/mrcjkb/rustaceanvim",
		"https://github.com/windwp/nvim-ts-autotag",
		"https://github.com/folke/todo-comments.nvim",
		"https://github.com/tpope/vim-sleuth",
		"https://github.com/folke/which-key.nvim",
	}, { confirm = false })

	utils.local_plugin("graffiti.nvim", "https://github.com/skyppex/graffiti.nvim")
	utils.local_plugin("punch-card.nvim", "https://github.com/skyppex/punch-card.nvim")

	require("skypex.configs.bellows")
	require("skypex.configs.cloak")
	require("skypex.configs.colorizer")
	require("skypex.configs.csv")
	require("skypex.configs.data")
	require("skypex.configs.fun")
	require("skypex.configs.graffiti")
	require("skypex.configs.lualine")
	require("skypex.configs.markdown")
	require("skypex.configs.obsidian")
	require("skypex.configs.punch-card")
	require("skypex.configs.quicker")
	require("skypex.configs.rainbow-delimiters")
	require("skypex.configs.rust")
	require("skypex.configs.snippets")
	require("skypex.configs.tags")
	require("skypex.configs.todo-comments")
	require("skypex.configs.which-key")
	require("skypex.configs.testing")

	-- apply funky environment fix to prioritize nix/direnv over mason
	if utils.is_linux() then
		local paths = vim.split(vim.env.PATH or "", ":")

		local normal = {}
		local mason = {}

		for _, p in ipairs(paths) do
			if p:match("mason/bin$") then
				table.insert(mason, p)
			else
				table.insert(normal, p)
			end
		end

		vim.env.PATH = table.concat(vim.list_extend(normal, mason), ":")
	end
end, 0)
