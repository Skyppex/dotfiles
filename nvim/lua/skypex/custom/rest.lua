local nmap = require("skypex.utils").nmap

vim.filetype.add({
	extension = {
		["http"] = "http",
	},
})

local kulala = require("kulala")

kulala.setup({
	default_env = "local",
})

nmap("<leader>rr", kulala.run, "Run http request")
nmap("ær", kulala.jump_next, "Run http request")
nmap("år", kulala.jump_prev, "Run http request")
nmap("<leader>ri", kulala.inspect, "Inspect last request")
nmap("<leader>rss", kulala.show_stats, "Show stats for last request")
nmap("<leader>rse", kulala.set_selected_env, "Set selected environment")
nmap("<leader>tr", kulala.toggle_view, "Toggle headers view")
