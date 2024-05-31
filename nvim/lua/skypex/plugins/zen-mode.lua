return {
	{
		"folke/zen-mode.nvim",
		config = function()
			require("zen-mode").setup({
				window = {
					width = 140,
				},
				plugins = {
					options = {
						laststatus = 3,
					},
					wezterm = {
						enabled = true,
						-- can be either an absolute font size or the number of incremental steps
						font = "+4", -- (10% increase per step)
					},
				},
			})

			vim.keymap.set("n", "<leader>z", ":ZenMode<CR>", {
				noremap = true,
				silent = true,
				desc = "Zen Mode",
			})
		end,
	},
}
