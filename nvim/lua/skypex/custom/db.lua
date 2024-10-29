require("skypex.utils").nmap("<leader>td", "<cmd>DBUIToggle<cr>", "Toggle DB")

vim.g.db_ui_icons = {
	expanded = {
		db = " 󰆼",
		buffers = " ",
		saved_queries = " ",
		schemas = " ",
		schema = " 󰙅",
		tables = " ",
		table = " 󰓫",
	},
	collapsed = {
		db = " 󰆼",
		buffers = " ",
		saved_queries = " ",
		schemas = " ",
		schema = " 󰙅",
		tables = " ",
		table = " 󰓫",
	},
	saved_query = "",
	new_query = "󰓰",
	tables = "",
	buffers = "󱂬",
	add_connection = "󰆺",
	connection_ok = "✓",
	connection_error = "✕",
}
