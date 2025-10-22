local nmap = require("skypex.utils").nmap

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

nmap("<leader>rr", kulala.run, "Run http request")
nmap("ær", ui.jump_next, "Goto the next request")
nmap("år", ui.jump_prev, "Goto the previous request")
nmap("<leader>rb", ui.show_body, "Show response body")
nmap("<leader>rv", ui.show_verbose, "Show verbose response body")
nmap("<leader>rh", ui.show_headers_body, "Show headers")
nmap("<leader>rj", ui.show_next, "Show next request")
nmap("<leader>rk", ui.show_previous, "Show previous request")
nmap("<leader>ri", ui.inspect, "Inspect last request")
nmap("<leader>rs", ui.show_stats, "Show stats for last request")
nmap("<leader>re", kulala.set_selected_env, "Set selected environment")
nmap("<leader>tr", ui.toggle_headers, "Toggle headers view")
