vim.filetype.add({
	extension = {
		["http"] = "http",
	},
})

return {
	"mistweaverco/kulala.nvim",
	ft = { "http", "rest" },
	config = function()
		local kulala = require("kulala")

		kulala.setup({
			default_env = "local",
		})

		vim.keymap.set("n", "<leader>rr", function()
			kulala.run()
		end, {
			desc = "Run http request",
			noremap = true,
			silent = true,
		})

		vim.keymap.set("n", "ær", function()
			kulala.jump_next()
		end, {
			desc = "Run http request",
			noremap = true,
			silent = true,
		})

		vim.keymap.set("n", "år", function()
			kulala.jump_prev()
		end, {
			desc = "Run http request",
			noremap = true,
			silent = true,
		})
	end,
}
