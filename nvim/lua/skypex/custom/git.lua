local map = require("skypex.utils").map

local M = {}

M.fugitive = function()
	map("n", "<leader>gs", vim.cmd.Git, "Git Status")

	map("n", "<leader>gl", function()
		vim.cmd("Git log")
	end, "Git Log")

	map("n", "<leader>gB", function()
		vim.cmd("Git blame")
	end, "Git Blame")
end

M.conflict = function()
	require("git-conflict").setup({
		default_mappings = true,
		default_commands = true,
		disable_diagnostics = true,
		list_opener = "copen",
		highlights = {
			incoming = "DiffAdd",
			current = "DiffChange",
		},
	})

	map("n", "<leader>gc", "<cmd>GitConflictRefresh<CR>", "Git Conflict Refresh")
	map("n", "<leader>gq", "<cmd>GitConflictListQf<CR>", "Git Conflict Quickfix")
	map("n", "åG", "<cmd>GitConflictPrevConflict<CR>", "Previous Conflict")
	map("n", "æG", "<cmd>GitConflictNextConflict<CR>", "Next Conflict")

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
end

M.gitsigns = function()
	local gitsigns = require("gitsigns")
	gitsigns.setup({
		signs = {
			add = { text = "│" },
			change = { text = "│" },
			delete = { text = "│" },
			topdelete = { text = "│" },
			changedelete = { text = "│" },
			untracked = { test = "┆" },
		},
		signs_staged = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "┃" },
			topdelete = { text = "┃" },
			changedelete = { text = "┃" },
			untracked = { test = "┇" },
		},
		sign_priority = 100,
		current_line_blame = false,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol",
			virt_text_priority = 100,
			delay = 0,
			ignore_whitespace = true,
		},
		preview_config = {
			border = "rounded",
		},
	})

	map("n", "åg", "<cmd>Gitsigns nav_hunk prev<CR>zz", "Previous Git Hunk")
	map("n", "æg", "<cmd>Gitsigns nav_hunk next<CR>zz", "Next Git Hunk")
	map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", "Git Reset Hunk")
	map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", "Git Preview hunk")
	map("n", "<leader>gg", "<cmd>Gitsigns stage_hunk<CR>", "Git Stage Hunk")
	map("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>", "Git Undo Staged Hunk")
	map("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<CR>", "Git Blame Line")
end

M.cmd = function()
	vim.api.nvim_create_user_command("GitTrackAll", function()
		vim.notify("Tracking all files", vim.log.levels.DEBUG)

		require("skypex.utils").run_command("git", { "add", "--intent-to-add", "." }, false, function(_, exit_code)
			if exit_code == 0 then
				vim.notify("Tracked all files", vim.log.levels.INFO)
			else
				vim.notify("Failed to track all files", vim.log.levels.ERROR)
			end
		end)
	end, {
		desc = "Git Track All",
		bang = false,
	})

	map("n", "<leader>gt", "<cmd>GitTrackAll<CR>", "Git Track All")
end

M.all = function()
	M.fugitive()
	M.conflict()
	M.gitsigns()
	M.cmd()
end

M.all()

return M
