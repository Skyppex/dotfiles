return {
	{
		"hrsh7th/nvim-cmp",
		lazy = true,
		event = "InsertEnter",
		dependencies = {
			{ "L3MON4D3/LuaSnip" },
			{
				"hrsh7th/cmp-nvim-lsp",
				lazy = true,
				event = { "BufReadPre", "BufNewFile" },
			},
			{
				"hrsh7th/cmp-path",
				lazy = true,
				event = "InsertEnter",
			},
			{
				"hrsh7th/cmp-buffer",
				lazy = true,
				event = "InsertEnter",
			},
			{
				"f3fora/cmp-spell",
				lazy = true,
				event = "InsertEnter",
			},
			{
				"hrsh7th/cmp-nvim-lsp-signature-help",
				lazy = true,
				event = "InsertEnter",
			},
			{
				"zbirenbaum/copilot-cmp",
				config = true,
			},
			{
				"zbirenbaum/copilot.lua",
				lazy = true,
				cmd = "Copilot",
				event = "InsertEnter",
			},
			{
				"onsails/lspkind.nvim",
				lazy = true,
				event = "InsertEnter",
			},
		},
		config = function()
			require("skypex.custom.cmp")
		end,
	},
}
