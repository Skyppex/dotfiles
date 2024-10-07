require("zen-mode").setup({
	window = {
		width = 140,
	},
	plugins = {
		options = {
			laststatus = 3,
		},
		twilight = { enabled = false },
		wezterm = {
			enabled = true,
			-- can be either an absolute font size or the number of incremental steps
			font = "+4", -- (10% increase per step)
		},
	},
})

require("skypex.utils").nmap("<leader>z", ":ZenMode<CR>", "Toggle Zen Mode")
