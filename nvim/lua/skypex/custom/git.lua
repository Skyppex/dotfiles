local M = {}

M.fugitive = function()
	vim.keymap.set("n", "<leader>gs", vim.cmd.Git, {
		desc = "Git Status",
		noremap = true,
		silent = true,
	})

	vim.keymap.set("n", "<leader>gl", function()
		vim.cmd("Git log")
	end, {
		desc = "Git Log",
		noremap = true,
		silent = true,
	})

	vim.keymap.set("n", "<leader>gB", function()
		vim.cmd("Git blame")
	end, {
		desc = "Git Blame",
		noremap = true,
		silent = true,
	})
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
		"<leader>gp",
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
end

M.octo = function()
	require("octo").setup({
		right_bubble_delimiter = "❮", -- bubble delimiter
		left_bubble_delimiter = "❯",
		suppress_missing_scope = {
			projects_v2 = true,
		},
		colors = { -- used for highlight groups (see Colors section below)
			white = "#D5CED9",
			grey = "#23262E",
			black = "#282a36",
			red = "##000000",
			dark_red = "#da3633",
			green = "#96e072",
			dark_green = "#238636",
			yellow = "#ffe66d",
			dark_yellow = "#735c0f",
			blue = "#7cb7ff",
			dark_blue = "#0366d6",
			purple = "#c74ded",
		},
		mappings = {
			issue = {
				close_issue = { lhs = "<leader>ic", desc = "close issue" },
				reopen_issue = { lhs = "<leader>io", desc = "reopen issue" },
				list_issues = { lhs = "<leader>il", desc = "list open issues on same repo" },
				reload = { lhs = "<leader>R", desc = "reload issue" },
				add_comment = { lhs = "<leader>ca", desc = "add comment" },
				delete_comment = { lhs = "<leader>cd", desc = "delete comment" },
				next_comment = { lhs = "æc", desc = "go to next comment" },
				prev_comment = { lhs = "åc", desc = "go to previous comment" },
			},
			pull_request = {
				checkout_pr = { lhs = "<leader>pc", desc = "checkout PR" },
				merge_pr = { lhs = "<leader>pm", desc = "merge commit PR" },
				reload = { lhs = "<leader>R", desc = "reload PR" },
				add_comment = { lhs = "<leader>ca", desc = "add comment" },
				delete_comment = { lhs = "<leader>cd", desc = "delete comment" },
				next_comment = { lhs = "æc", desc = "go to next comment" },
				prev_comment = { lhs = "åc", desc = "go to previous comment" },
				review_start = { lhs = "<leader>vs", desc = "start a review for the current PR" },
				review_resume = { lhs = "<leader>vr", desc = "resume a pending review for the current PR" },
				react_hooray = { lhs = "<leader>rp", desc = "add/remove 🎉 reaction" },
				react_heart = { lhs = "<leader>rh", desc = "add/remove ❤️ reaction" },
				react_eyes = { lhs = "<leader>re", desc = "add/remove 👀 reaction" },
				react_thumbs_up = { lhs = "<leader>r+", desc = "add/remove 👍 reaction" },
				react_thumbs_down = { lhs = "<leader>r-", desc = "add/remove 👎 reaction" },
				react_rocket = { lhs = "<leader>rr", desc = "add/remove 🚀 reaction" },
				react_laugh = { lhs = "<leader>rl", desc = "add/remove 😄 reaction" },
				react_confused = { lhs = "<leader>rc", desc = "add/remove 😕 reaction" },
			},
			review_thread = {
				goto_issue = { lhs = "<leader>gi", desc = "navigate to a local repo issue" },
				add_comment = { lhs = "<leader>ca", desc = "add comment" },
				delete_comment = { lhs = "<leader>cd", desc = "delete comment" },
				next_comment = { lhs = "æc", desc = "go to next comment" },
				prev_comment = { lhs = "åc", desc = "go to previous comment" },
				select_next_entry = { lhs = "æq", desc = "move to next changed file" },
				select_prev_entry = { lhs = "åq", desc = "move to previous changed file" },
				close_review_tab = { lhs = "<leader>vc", desc = "close review tab" },
				react_hooray = { lhs = "<leader>rp", desc = "add/remove 🎉 reaction" },
				react_heart = { lhs = "<leader>rh", desc = "add/remove ❤️ reaction" },
				react_eyes = { lhs = "<leader>re", desc = "add/remove 👀 reaction" },
				react_thumbs_up = { lhs = "<leader>r+", desc = "add/remove 👍 reaction" },
				react_thumbs_down = { lhs = "<leader>r-", desc = "add/remove 👎 reaction" },
				react_rocket = { lhs = "<leader>rr", desc = "add/remove 🚀 reaction" },
				react_laugh = { lhs = "<leader>rl", desc = "add/remove 😄 reaction" },
				react_confused = { lhs = "<leader>rc", desc = "add/remove 😕 reaction" },
			},
			submit_win = {
				approve_review = { lhs = "<leader>sa", desc = "approve review" },
				comment_review = { lhs = "<leader>sc", desc = "comment review" },
				request_changes = { lhs = "<leader>sr", desc = "request changes review" },
				close_review_tab = { lhs = "<leader>vc", desc = "close review tab" },
			},
			review_diff = {
				submit_review = { lhs = "<leader>vs", desc = "submit review" },
				discard_review = { lhs = "<leader>vd", desc = "discard review" },
				add_review_comment = { lhs = "<leader>ca", desc = "add a new review comment" },
				toggle_files = { lhs = "<leader>tf", desc = "hide/show changed files panel" },
				next_thread = { lhs = "æt", desc = "move to next thread" },
				prev_thread = { lhs = "åt", desc = "move to previous thread" },
				select_next_entry = { lhs = "æq", desc = "move to next changed file" },
				select_prev_entry = { lhs = "åq", desc = "move to previous changed file" },
				close_review_tab = { lhs = "<leader>vc", desc = "close review tab" },
				toggle_viewed = { lhs = "<leader>tv", desc = "toggle viewer viewed state" },
				goto_file = { lhs = "gf", desc = "go to file" },
			},
			file_panel = {
				submit_review = { lhs = "<leader>vs", desc = "submit review" },
				discard_review = { lhs = "<leader>vd", desc = "discard review" },
				next_entry = { lhs = "j", desc = "move to next changed file" },
				prev_entry = { lhs = "k", desc = "move to previous changed file" },
				select_entry = { lhs = "<cr>", desc = "show selected changed file diffs" },
				refresh_files = { lhs = "<leader>R", desc = "refresh changed files panel" },
				toggle_files = { lhs = "<leader>tf", desc = "hide/show changed files panel" },
				select_next_entry = { lhs = "æq", desc = "move to next changed file" },
				select_prev_entry = { lhs = "åq", desc = "move to previous changed file" },
				close_review_tab = { lhs = "<leader>vc", desc = "close review tab" },
				toggle_viewed = { lhs = "<leader>tv", desc = "toggle viewer viewed state" },
			},
		},
	})

	vim.keymap.set("n", "<leader>o", "<cmd>Octo actions<CR>", {
		desc = "Octo",
		noremap = true,
		silent = true,
	})
end

M.all = function()
	M.fugitive()
	M.conflict()
	M.gitsigns()
	M.octo()
end

return M
