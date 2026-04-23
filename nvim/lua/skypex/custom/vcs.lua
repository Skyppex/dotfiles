local utils = require("skypex.utils")
local map = utils.map

local M = {}

function M.is_git_repo()
	local _, exit_code = utils.run_command_ret("git", { "rev-parse", "--is-inside-work-tree" })
	return exit_code == 0
end

function M.is_jj_repo()
	local _, exit_code = utils.run_command_ret("jj", { "root" })
	return exit_code == 0
end

function M.jj_then_git()
	if M.is_jj_repo() then
		return "jj"
	end

	if M.is_git_repo() then
		return "git"
	end

	return nil
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

	map("n", "<leader>vc", "<cmd>GitConflictRefresh<CR>", "Git Conflict Refresh")
	map("n", "<leader>vq", "<cmd>GitConflictListQf<CR>", "Git Conflict Quickfix")
	map("n", "åV", "<cmd>GitConflictPrevConflict<CR>", "Previous Conflict")
	map("n", "æV", "<cmd>GitConflictNextConflict<CR>", "Next Conflict")

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
	if M.jj_then_git() ~= "git" then
		return
	end

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

	map("n", "åv", "<cmd>Gitsigns nav_hunk prev<cr>zz", "Previous Git Hunk")
	map("n", "æv", "<cmd>Gitsigns nav_hunk next<cr>zz", "Next Git Hunk")
	map("n", "<leader>vr", "<cmd>Gitsigns reset_hunk<cr>", "Git Reset Hunk")
	map("n", "<leader>vp", "<cmd>Gitsigns preview_hunk<cr>", "Git Preview hunk")
	map("n", "<leader>vg", "<cmd>Gitsigns stage_hunk<cr>", "Git Stage Hunk")
	map("n", "<leader>vu", "<cmd>Gitsigns undo_stage_hunk<cr>", "Git Undo Staged Hunk")
	map("n", "<leader>vb", "<cmd>Gitsigns toggle_current_line_blame<cr>", "Git Blame Line")
	map("n", "<leader>vB", "<cmd>Gitsigns blame<cr>", "Git Blame")
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

M.kanji = function()
	if M.jj_then_git() ~= "jj" then
		return
	end

	local kanji = require("kanji")
	kanji.setup({
		signs = {
			add = { text = "│" },
			change = { text = "│" },
			delete = { text = "│" },
		},
	})

	map("n", "åv", kanji.prev_hunk, "Previous JJ Hunk")
	map("n", "æv", kanji.next_hunk, "Next JJ Hunk")
end

return M
