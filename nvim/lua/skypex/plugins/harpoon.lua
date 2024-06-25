return {
	{
		"theprimeagen/harpoon",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("harpoon").setup({
				global_settings = {
					-- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
					save_on_toggle = false,

					-- saves the harpoon file upon every change. disabling is unrecommended.
					save_on_change = true,

					-- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
					enter_on_sendcmd = false,

					-- filetypes that you want to prevent from adding to the harpoon list menu.
					excluded_filetypes = {},

					-- set marks specific to each git branch inside git repository
					mark_branch = true,

					-- enable tabline with harpoon marks
					tabline = false,
					tabline_prefix = "   ",
					tabline_suffix = "   ",
				},
			})

			local mark = require("harpoon.mark")
			local ui = require("harpoon.ui")

			vim.keymap.set(
				"n",
				"<leader>a",
				mark.add_file,
				{ desc = "Add File to Harpoon", noremap = true, silent = true }
			)

			vim.keymap.set(
				"n",
				"<leader>e",
				ui.toggle_quick_menu,
				{ desc = "Toggle Harpoon Menu", noremap = true, silent = true }
			)

			vim.keymap.set("n", "<A-h>", function()
				ui.nav_file(1)
			end, { desc = "Navigate to Harpoon File 1", noremap = true, silent = true })

			vim.keymap.set("n", "<A-j>", function()
				ui.nav_file(2)
			end, { desc = "Navigate to Harpoon File 2", noremap = true, silent = true })

			vim.keymap.set("n", "<A-k>", function()
				ui.nav_file(3)
			end, { desc = "Navigate to Harpoon File 3", noremap = true, silent = true })

			vim.keymap.set("n", "<A-l>", function()
				ui.nav_file(4)
			end, { desc = "Navigate to Harpoon File 4", noremap = true, silent = true })

			vim.keymap.set("n", "<A-n>", function()
				ui.nav_file(5)
			end, { desc = "Navigate to Harpoon File 5", noremap = true, silent = true })

			vim.keymap.set("n", "<A-m>", function()
				ui.nav_file(6)
			end, { desc = "Navigate to Harpoon File 6", noremap = true, silent = true })

			vim.keymap.set("n", "<A-,>", function()
				ui.nav_file(7)
			end, { desc = "Navigate to Harpoon File 7", noremap = true, silent = true })

			vim.keymap.set("n", "<A-.>", function()
				ui.nav_file(8)
			end, { desc = "Navigate to Harpoon File 8", noremap = true, silent = true })
		end,
	},
}
