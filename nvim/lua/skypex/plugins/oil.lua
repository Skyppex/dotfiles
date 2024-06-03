return {
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				use_default_keymaps = false,
				float = {
					-- Padding around the floating window
					padding = 10,
					max_width = 0,
					max_height = 0,
					border = "rounded",
					win_options = {
						winblend = 0,
					},
					-- This is the config that will be passed to nvim_open_win.
					-- Change values here to customize the layout
					override = function(conf)
						return conf
					end,
				},
				keymaps = {
					["<CR>"] = "actions.select",
					["<leader>"] = "actions.preview",
					["-"] = "actions.parent",
					["<C-r>"] = "actions.refresh",
				},
			})

			vim.keymap.set("n", "<leader>pv", "<cmd>Oil<CR>", { desc = "Project View" })
		end,
	},
}
