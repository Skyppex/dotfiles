return {
	{
		"stevearc/oil.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				win_options = {
					signcolumn = "yes:2",
				},
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
					["<CR>"] = "actions.select",
					["<leader>"] = "actions.preview",
					["-"] = "actions.parent",
					["<C-r>"] = "actions.refresh",
				},
			})

			vim.keymap.set("n", "<leader>v", "<cmd>Oil<CR>", { desc = "Project View" })
		end,
	},
	{
		"SirZenith/oil-vcs-status",
		event = "VeryLazy",
		dependencies = {
			"stevearc/oil.nvim",
		},
		config = function()
			local status_const = require("oil-vcs-status.constant.status")
			local StatusType = status_const.StatusType

			require("oil-vcs-status").setup({
				status_symbol = {
					[StatusType.Added] = "",
					[StatusType.Copied] = "󰆏",
					[StatusType.Deleted] = "",
					[StatusType.Ignored] = "",
					[StatusType.Modified] = "",
					[StatusType.Renamed] = "",
					[StatusType.TypeChanged] = "󰉺",
					[StatusType.Unmodified] = " ",
					[StatusType.Unmerged] = "",
					[StatusType.Untracked] = "",
					[StatusType.External] = "",

					[StatusType.UpstreamAdded] = "󰈞",
					[StatusType.UpstreamCopied] = "󰈢",
					[StatusType.UpstreamDeleted] = "",
					[StatusType.UpstreamIgnored] = " ",
					[StatusType.UpstreamModified] = "󰏫",
					[StatusType.UpstreamRenamed] = "",
					[StatusType.UpstreamTypeChanged] = "󱧶",
					[StatusType.UpstreamUnmodified] = " ",
					[StatusType.UpstreamUnmerged] = "",
					[StatusType.UpstreamUntracked] = " ",
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
		end,
	},
}
