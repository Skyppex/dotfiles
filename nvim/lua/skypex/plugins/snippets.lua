local function all_snippets(ls)
	ls.snippets = {
		all = {},
	}
end

local function config()
	local ls = require("luasnip")
	vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/lua/skypex/plugins/snippets.lua<cr>")
	all_snippets(ls)
end

return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	lazy = true,
	event = "InsertEnter",
	config = config,
	dependencies = {
		{
			"saadparwaiz1/cmp_luasnip",
			lazy = true,
			event = "InsertEnter",
		},
		{
			"rafamadriz/friendly-snippets",
			lazy = true,
			event = "InsertEnter",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
		{
			"benfowler/telescope-luasnip.nvim",
			config = function()
				require("telescope").load_extension("luasnip")
				vim.keymap.set("n", "sn", "<cmd>Telescope luasnip<CR>", {
					desc = "[S]earch S[n]ippets",
					noremap = true,
					silent = true,
				})
			end,
		},
	},
}
