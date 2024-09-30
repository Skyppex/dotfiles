local M = {}

M.oil = function()
	require("oil").setup({
		default_file_explorer = true,
		win_options = {
			signcolumn = "yes:2",
		},
		view_options = {
			show_hidden = false,
			is_hidden_file = function(name, _)
				return vim.startswith(name, "..")
			end,
		},
		case_insensitive = true,
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
			["L"] = "actions.select",
			["<leader>"] = "actions.preview",
			["H"] = "actions.parent",
			["<C-r>"] = "actions.refresh",
		},
	})

	vim.keymap.set("n", "<leader>v", "<cmd>Oil<CR>", { desc = "Project View" })
end

M.oil_vcs = function()
	local status_const = require("oil-vcs-status.constant.status")
	local StatusType = status_const.StatusType

	require("oil-vcs-status").setup({
		status_symbol = {

			[StatusType.Added] = "+",
			[StatusType.Copied] = "c",
			[StatusType.Deleted] = "✘",
			[StatusType.Ignored] = "i",
			[StatusType.Modified] = "!",
			[StatusType.Renamed] = "m",
			[StatusType.TypeChanged] = "t",
			[StatusType.Unmodified] = " ",
			[StatusType.Unmerged] = "",
			[StatusType.Untracked] = "?",
			[StatusType.External] = "e",

			[StatusType.UpstreamAdded] = "󰈞",
			[StatusType.UpstreamCopied] = "󰈢",
			[StatusType.UpstreamDeleted] = "",
			[StatusType.UpstreamIgnored] = " ",
			[StatusType.UpstreamModified] = "󰏫",
			[StatusType.UpstreamRenamed] = "",
			[StatusType.UpstreamTypeChanged] = "󱧶",
			[StatusType.UpstreamUnmodified] = " ",
			[StatusType.UpstreamUnmerged] = "",
			[StatusType.UpstreamUntracked] = "",
			[StatusType.UpstreamExternal] = "",
		},
		status_priority = {
			[StatusType.UpstreamIgnored] = 0,
			[StatusType.UpstreamUntracked] = 1,
			[StatusType.UpstreamUnmodified] = 2,

			[StatusType.UpstreamCopied] = 3,
			[StatusType.UpstreamRenamed] = 3,
			[StatusType.UpstreamTypeChanged] = 3,

			[StatusType.UpstreamDeleted] = 4,
			[StatusType.UpstreamModified] = 4,
			[StatusType.UpstreamAdded] = 4,

			[StatusType.UpstreamUnmerged] = 5,

			[StatusType.Ignored] = 10,
			[StatusType.Untracked] = 11,
			[StatusType.Unmodified] = 12,

			[StatusType.Copied] = 13,
			[StatusType.Renamed] = 13,
			[StatusType.TypeChanged] = 13,

			[StatusType.Deleted] = 14,
			[StatusType.Modified] = 14,
			[StatusType.Added] = 14,

			[StatusType.Unmerged] = 15,
		},
	})
end

M.all = function()
	M.oil()
	M.oil_vcs()
end

return M
