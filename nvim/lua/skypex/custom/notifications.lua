local fidget = require("fidget")

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

local log_levels = {
	"TRACE",
	"DEBUG",
	"INFO",
	"WARN",
	"ERROR",
	"OFF",
}

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local function set_fidget_log_level(level)
	-- Assuming fidget is configured with a log level option
	require("fidget").setup({
		notification = {
			filter = vim.log.levels[level],
		},
	})

	vim.lsp.set_log_level(level)
	vim.notify("Set log level to " .. level, vim.log.levels.INFO .. " for fidget and LSP")
end

local nmap = require("skypex.utils").nmap

nmap("<leader>tl", function()
	pickers
		.new({}, {
			prompt_title = "Select Fidget Log Level",
			finder = finders.new_table({
				results = log_levels,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				map("i", "<CR>", function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					set_fidget_log_level(selection[1])
				end)
				return true
			end,
		})
		:find()
end, "Set fidget log level")
