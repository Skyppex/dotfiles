---@diagnostic disable: undefined-field
return {
	"rcarriga/nvim-notify",
	config = function()
		local notify = require("notify")

		notify.setup({
			render = "minimal",
			timeout = 1000,
			max_width = 30,
			minimum_width = 0,
			level = 3,
		})

		vim.keymap.set("n", "<leader>n", function()
			local user_input = vim.fn.input("Set log level (" .. notify.Config.level .. "): ")
			notify.Config.level = tonumber(user_input)
		end, {
			desc = "Set log level",
			noremap = true,
			silent = true,
		})
	end,
}
