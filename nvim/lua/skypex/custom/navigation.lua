local ss = require("smart-splits")

ss.setup({
	default_amount = 5,
	at_edge = "stop",
})

local nmap = require("skypex.utils").nmap

-- Disable arrow keys in normal mode
nmap("<left>", '<cmd>echo "Use h to move!!"<CR>')
nmap("<right>", '<cmd>echo "Use l to move!!"<CR>')
nmap("<up>", '<cmd>echo "Use k to move!!"<CR>')
nmap("<down>", '<cmd>echo "Use j to move!!"<CR>')

nmap("<A-h>", ss.move_cursor_left, "Move focus to the left buffer")
nmap("<A-j>", ss.move_cursor_down, "Move focus to the lower buffer")
nmap("<A-k>", ss.move_cursor_up, "Move focus to the upper buffer")
nmap("<A-l>", ss.move_cursor_right, "Move focus to the right buffer")

-- Resize buffers
local change = 5

nmap("<S-A-h>", function()
	local count = vim.v.count1
	ss.resize_left(change * count)
	-- local current_width = vim.api.nvim_win_get_width(0)
	-- vim.api.nvim_win_set_width(0, current_width + change * count)
end, "Grow buffer horizontal")

nmap("<S-A-j>", function()
	local count = vim.v.count1
	ss.resize_down(change * count)
	-- local current_width = vim.api.nvim_win_get_width(0)
	-- vim.api.nvim_win_set_width(0, current_width - change * count)
end, "Shrink buffer horizontal")

nmap("<S-A-k>", function()
	local count = vim.v.count1
	ss.resize_up(change * count)
	-- local current_height = vim.api.nvim_win_get_height(0)
	-- vim.api.nvim_win_set_height(0, current_height + change * count)
end, "Grow buffer vertical")

nmap("<S-A-l>", function()
	local count = vim.v.count1
	ss.resize_right(change * count)
	-- local current_height = vim.api.nvim_win_get_height(0)
	-- vim.api.nvim_win_set_height(0, current_height - change * count)
end, "Shrink buffer vertical")
