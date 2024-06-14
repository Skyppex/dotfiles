return {
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git Status", noremap = true, silent = true })
			vim.keymap.set("n", "<leader>gl", function()
				vim.cmd("Git log")
			end, { desc = "Git Log", noremap = true, silent = true })
			vim.keymap.set("n", "<leader>gB", function()
				vim.cmd("Git blame")
			end, { desc = "Git Blame", noremap = true, silent = true })
		end,
	},
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		config = function()
			require("git-conflict").setup({
				default_mappings = true,
				default_comands = true,
				disable_diagnostics = true,
				list_opener = "copen",
				highlights = {
					incoming = "DiffAdd",
					current = "DiffChange",
				},
			})

			vim.keymap.set(
				"n",
				"<leader>gc",
				"<cmd>GitConflictRefresh<CR>",
				{ desc = "Git Conflict Refresh", noremap = true, silent = true }
			)

			vim.keymap.set(
				"n",
				"<leader>gq",
				"<cmd>GitConflictListQf<CR>",
				{ desc = "Git Conflict Quickfix", noremap = true, silent = true }
			)

			vim.keymap.set(
				"n",
				"åc",
				"<cmd>GitConflictPrevConflict<CR>",
				{ desc = "Previous Conflict", noremap = true, silent = true }
			)

			vim.keymap.set(
				"n",
				"æc",
				"<cmd>GitConflictNextConflict<CR>",
				{ desc = "Next Conflict", noremap = true, silent = true }
			)

			vim.api.nvim_create_autocmd("User", {
				pattern = "GitConflictDetected",
				callback = function()
					vim.notify("Conflict detected in file" .. vim.api.nvim_buf_get_name(0))
					vim.cmd("LspStop")
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "GitConflictResolved",
				callback = function()
					vim.cmd("LspRestart")
				end,
			})
		end,
	},
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
				"<leader>gg",
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
