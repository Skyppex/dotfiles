return {
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		config = function()
			local gitsigns = require("gitsigns")
			gitsigns.setup({
				signs = {
					add = { text = "|" },
					change = { text = "|" },
					delete = { text = "|" },
					topdelete = { text = "|" },
					changedelete = { text = "|" },
					untracked = { test = "┆" },
				},
				current_line_blame = false,
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol",
					virt_text_priority = 100,
					delay = 0,
					ignore_whitespace = true,
				},
			})

			local c = require("andromeda.colors")
			vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = c.gray, bg = "NONE" })

			vim.keymap.set(
				"n",
				"åg",
				"<cmd>Gitsigns nav_hunk prev<CR>zz",
				{ desc = "Previous Git Hunk", noremap = true, silent = true }
			)
			vim.keymap.set(
				"n",
				"æg",
				"<cmd>Gitsigns nav_hunk next<CR>zz",
				{ desc = "Next Git Hunk", noremap = true, silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>gr",
				"<cmd>Gitsigns reset_hunk<CR>",
				{ desc = "Git Reset Hunk", noremap = true, silent = true }
			)
			vim.keymap.set(
				"n",
				"gp",
				"<cmd>Gitsigns preview_hunk<CR>",
				{ desc = "Git Preview hunk", noremap = true, silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>gs",
				"<cmd>Gitsigns stage_hunk<CR>",
				{ desc = "Git Stage Hunk", noremap = true, silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>gu",
				"<cmd>Gitsigns undo_stage_hunk<CR>",
				{ desc = "Git Undo Staged Hunk", noremap = true, silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>gb",
				"<cmd>Gitsigns toggle_current_line_blame<CR>",
				{ desc = "Git Blame Line", noremap = true, silent = true }
			)
		end,
	},
}
