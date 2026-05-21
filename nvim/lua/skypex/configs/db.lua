local db = require("dbee")

db.setup({
	drawer = {
		candies = {
			history = {
				icon = "",
				icon_highlight = "@constant",
				text_highlight = "",
			},
			note = {
				icon = "",
				icon_highlight = "@character",
				text_highlight = "",
			},
			connection = {
				icon = "󱘖",
				icon_highlight = "@field",
				text_highlight = "",
			},
			database_switch = {
				icon = "",
				icon_highlight = "@keyword",
				text_highlight = "",
			},
			schema = {
				icon = "",
				icon_highlight = "@type",
				text_highlight = "",
			},
			table = {
				icon = "",
				icon_highlight = "@property",
				text_highlight = "",
			},
			streaming_table = {
				icon = "",
				icon_highlight = "@property",
				text_highlight = "",
			},
			managed = {
				icon = "",
				icon_highlight = "@property",
				text_highlight = "",
			},
			view = {
				icon = "",
				icon_highlight = "@property",
				text_highlight = "",
			},
			materialized_view = {
				icon = "",
				icon_highlight = "@property",
				text_highlight = "",
			},
			sink = {
				icon = "",
				icon_highlight = "@property",
				text_highlight = "",
			},
			column = {
				icon = "󰠵",
				icon_highlight = "@constant",
				text_highlight = "",
			},
			add = {
				icon = "",
				icon_highlight = "@string",
				text_highlight = "@string",
			},
			edit = {
				icon = "󰏫",
				icon_highlight = "@macro",
				text_highlight = "@macro",
			},
			remove = {
				icon = "󰆴",
				icon_highlight = "DiagnosticError",
				text_highlight = "DiagnosticError",
			},
			help = {
				icon = "󰋖",
				icon_highlight = "DiagnosticWarn",
				text_highlight = "DiagnosticWarn",
			},
			source = {
				icon = "󰃖",
				icon_highlight = "@type",
				text_highlight = "Directory",
			},

			-- if there is no type
			-- use this for normal nodes...
			none = {
				icon = " ",
				icon_highlight = "",
				text_highlight = "",
			},
			-- ...and use this for nodes with children
			none_dir = {
				icon = "",
				icon_highlight = "Type",
				text_highlight = "",
			},

			-- chevron icons for expanded/closed nodes
			node_expanded = {
				icon = "",
				icon_highlight = "@punctuation",
				text_highlight = "",
			},
			node_closed = {
				icon = "",
				icon_highlight = "@punctuation",
				text_highlight = "",
			},
		},
		window_options = {
			number = true,
			relativenumber = true,
		},
	},
	editor = {
		mappings = {},
		window_options = {
			number = true,
			relativenumber = true,
		},
	},
	call_log = {
		window_options = {
			number = true,
			relativenumber = true,
		},
	},
	result = {
		focus_result = false,
		window_options = {
			number = true,
			relativenumber = true,
		},
	},
})

local utils = require("skypex.utils")
local map = utils.map
local pick = require("mini.pick")

local db_ws = require("skypex.workspaces").register({
	name = "db_client",
	on_init = function()
		db.open()
	end,
})

map("n", {
	"<c-w><c-b>",
	"<c-w>b",
}, function()
	db_ws:toggle()
end, "toggle db client")

map("n", "<leader>bl", db.api.ui.next_result_set, "next result set")
map("n", "<leader>bh", db.api.ui.prev_result_set, "previous result set")

vim.api.nvim_create_autocmd("User", {
	pattern = "DbeeNoteOpened",
	callback = function(data)
		local buf = data.buf

		map("n", "<s-c-r>", function()
			db.api.ui.editor_do_action("run_file")
		end, "run file", nil, buf)

		map("x", "<c-r>", function()
			db.api.ui.editor_do_action("run_selection")
		end, "run selection", nil, buf)

		map("n", "<c-r>", function()
			db.api.ui.editor_do_action("run_under_cursor")
		end, "run under cursor", nil, buf)

		map("n", "<leader>sf", function()
			pick.builtin.cli({
				command = {
					"fd",
					"--type=file",
					"--extension=sql",
					"--prune",
				},
			}, {
				source = {
					show = function(bufnr, items, query)
						pick.default_show(bufnr, items, query, {
							show_icons = true,
						})
					end,
				},
			})
		end, "search sql scripts", nil, buf)
	end,
})
