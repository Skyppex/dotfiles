local function all_snippets(ls)
	ls.add_snippets("all", {})
end

return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	lazy = true,
	event = "InsertEnter",
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
				vim.keymap.set("n", "<leader>sn", "<cmd>Telescope luasnip<CR>", {
					desc = "Search Snippets",
					noremap = true,
					silent = true,
				})
			end,
		},
	},
	config = function()
		local ls = require("luasnip")
		ls.setup()

		all_snippets(ls)

		vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/lua/skypex/plugins/snippets.lua<cr>")
	end,
}
