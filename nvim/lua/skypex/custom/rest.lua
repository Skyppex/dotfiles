local M = {}

M.kulala = function()
	vim.filetype.add({
		extension = {
			["http"] = "http",
		},
	})

	local kulala = require("kulala")

	kulala.setup({
		default_env = "local",
	})

	vim.keymap.set("n", "<leader>rr", kulala.run, {
		desc = "Run http request",
		noremap = true,
		silent = true,
	})

	vim.keymap.set("n", "ær", kulala.jump_next, {
		desc = "Run http request",
		noremap = true,
		silent = true,
	})

	vim.keymap.set("n", "år", kulala.jump_prev, {
		desc = "Run http request",
		noremap = true,
		silent = true,
	})

	vim.keymap.set("n", "<leader>ri", kulala.inspect, {
		desc = "Inspect last request",
		noremap = true,
		silent = true,
	})

	vim.keymap.set("n", "<leader>rss", kulala.show_stats, {
		desc = "Show stats for last request",
		noremap = true,
		silent = true,
	})

	vim.keymap.set("n", "<leader>rse", kulala.set_selected_env, {
		desc = "Set selected environment",
		noremap = true,
		silent = true,
	})

	vim.keymap.set("n", "<leader>tr", kulala.toggle_view, {
		desc = "Toggle headers view",
		noremap = true,
		silent = true,
	})
end

M.all = M.kulala

return M
