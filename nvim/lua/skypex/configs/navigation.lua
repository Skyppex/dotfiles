local ss = require("smart-splits")

ss.setup({
	default_amount = 5,
	at_edge = "stop",
})

local map = require("skypex.utils").map

map("nxiso", "<a-h>", ss.move_cursor_left, "Move focus to the left buffer")
map("nxiso", "<a-j>", ss.move_cursor_down, "Move focus to the lower buffer")
map("nxiso", "<a-k>", ss.move_cursor_up, "Move focus to the upper buffer")
map("nxiso", "<a-l>", ss.move_cursor_right, "Move focus to the right buffer")

-- Resize buffers
local change = 5

map("nxiso", "<s-a-h>", function()
	local count = vim.v.count1
	ss.resize_left(change * count)
	-- local current_width = vim.api.nvim_win_get_width(0)
	-- vim.api.nvim_win_set_width(0, current_width + change * count)
end, "Grow buffer horizontal")

map("nxiso", "<s-a-j>", function()
	local count = vim.v.count1
	ss.resize_down(change * count)
	-- local current_width = vim.api.nvim_win_get_width(0)
	-- vim.api.nvim_win_set_width(0, current_width - change * count)
end, "Shrink buffer horizontal")

map("nxiso", "<s-a-k>", function()
	local count = vim.v.count1
	ss.resize_up(change * count)
	-- local current_height = vim.api.nvim_win_get_height(0)
	-- vim.api.nvim_win_set_height(0, current_height + change * count)
end, "Grow buffer vertical")

map("nxiso", "<s-a-l>", function()
	local count = vim.v.count1
	ss.resize_right(change * count)
	-- local current_height = vim.api.nvim_win_get_height(0)
	-- vim.api.nvim_win_set_height(0, current_height - change * count)
end, "Shrink buffer vertical")
