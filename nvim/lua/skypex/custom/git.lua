local nmap = require("skypex.utils").nmap

local M = {}

M.fugitive = function()
	nmap("<leader>gs", vim.cmd.Git, "Git Status")

	nmap("<leader>gl", function()
		vim.cmd()
	end, "Git Log")

	nmap("<leader>gB", function()
		vim.cmd()
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

	nmap("<leader>gc", "<cmd>GitConflictRefresh<CR>", "Git Conflict Refresh")
	nmap("<leader>gq", "<cmd>GitConflictListQf<CR>", "Git Conflict Quickfix")
	nmap("åG", "<cmd>GitConflictPrevConflict<CR>", "Previous Conflict")
	nmap("æG", "<cmd>GitConflictNextConflict<CR>", "Next Conflict")

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

	nmap("åg", "<cmd>Gitsigns nav_hunk prev<CR>zz", "Previous Git Hunk")
	nmap("æg", "<cmd>Gitsigns nav_hunk next<CR>zz", "Next Git Hunk")
	nmap("<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", "Git Reset Hunk")
	nmap("<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", "Git Preview hunk")
	nmap("<leader>gg", "<cmd>Gitsigns stage_hunk<CR>", "Git Stage Hunk")
	nmap("<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>", "Git Undo Staged Hunk")
	nmap("<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<CR>", "Git Blame Line")
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

	nmap("<leader>gt", "<cmd>GitTrackAll<CR>", "Git Track All")
end

M.all = function()
	M.fugitive()
	M.conflict()
	M.gitsigns()
	M.cmd()
end

M.all()

return M
