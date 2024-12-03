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
				require("skypex.custom.snippets").friendly_snippets()
			end,
		},
		{
			"benfowler/telescope-luasnip.nvim",
			config = function()
				require("skypex.custom.snippets").telescope()
			end,
		},
	},
	run = "make install_jsregexp",
	config = function()
		require("skypex.custom.snippets").luasnip()
	end,
}
