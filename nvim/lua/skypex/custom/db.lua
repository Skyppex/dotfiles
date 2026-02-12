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
	},
	editor = {
		mappings = {
			-- run what's currently selected on the active connection
			{ key = "<c-r>", mode = "v", action = "run_selection" },
			-- run the whole file on the active connection
			{ key = "<c-r>", mode = "n", action = "run_file" },
			-- run what's under the cursor to the next newline
			{ key = "<s-r>", mode = "n", action = "run_under_cursor" },
		},
	},
	result = {
		focus_result = false,
	},
})

local map = require("skypex.utils").map

map("n", {
	"<c-w><c-b>",
	"<c-w>b",
}, db.toggle, "toggle db client")
