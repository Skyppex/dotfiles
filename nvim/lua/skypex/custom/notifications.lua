local fidget = require("fidget")

-- reroute print to fidget
function print(...)
	local args = { ... }
	local message = table.concat(vim.tbl_map(tostring, args), " | ")
	fidget.notify(message, nil, {
		key = "print",
		group = "print",
		annote = "MESSAGE",
	})
end

fidget.setup({
	notification = {
		filter = vim.log.levels.INFO,
		override_vim_notify = true,
		view = {
			stack_upwards = false,
		},
		window = {
			-- The window is always trying to show the start of the message, so it's better to not limit the width
			-- max_width = 50,
			align = "bottom",
			border = "rounded",
		},
	},
})

local log_levels = {
	"trace",
	"debug",
	"info",
	"warn",
	"error",
	"off",
}

local function set_fidget_log_level(level)
	-- Assuming fidget is configured with a log level option
	require("fidget").setup({
		notification = {
			filter = vim.log.levels[level],
		},
	})

	vim.lsp.log.set_level(level)
	vim.notify("Set log level to " .. level, vim.log.levels.INFO .. " for fidget and LSP")
end

local map = require("skypex.utils").map

map("n", "<leader>tl", function()
	vim.ui.select(log_levels, {}, function(selected)
		set_fidget_log_level(selected)
	end)
end, "Set fidget log level")

map("n", "<leader>om", "<cmd>Fidget history<CR>", "Open messages")
