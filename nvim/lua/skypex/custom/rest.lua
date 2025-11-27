local map = require("skypex.utils").map

vim.filetype.add({
	extension = {
		["http"] = "http",
	},
})

local kulala = require("kulala")

kulala.setup({
	default_env = "local",
	ui = {
		winbar = false,
		show_request_summary = false,
		disable_news_popup = true,
		win_opts = {
			wo = { foldmethod = "manual" },
		},
		max_response_size = 1048576,
	},
	global_keymaps = false,
	kulala_keymaps = false,
})

local ui = require("kulala.ui")

map("n", "<leader>rr", kulala.run, "Run http request")
map("n", "ær", ui.jump_next, "Goto the next request")
map("n", "år", ui.jump_prev, "Goto the previous request")
map("n", "<leader>rb", ui.show_body, "Show response body")
map("n", "<leader>rv", ui.show_verbose, "Show verbose response body")
map("n", "<leader>rh", ui.show_headers_body, "Show headers")
map("n", "<leader>rj", ui.show_next, "Show next request")
map("n", "<leader>rk", ui.show_previous, "Show previous request")
map("n", "<leader>ri", ui.inspect, "Inspect last request")
map("n", "<leader>rs", ui.show_stats, "Show stats for last request")
map("n", "<leader>re", kulala.set_selected_env, "Set selected environment")
map("n", "<leader>tr", ui.toggle_headers, "Toggle headers view")
