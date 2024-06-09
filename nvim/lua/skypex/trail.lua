local buffer_stack = {}
local current_position = 0

function save_buffer_position()
	current_position = current_position + 1
	print("Saving buffer position: " .. current_position)
	local buf = vim.api.nvim_get_current_buf()
	local pos = vim.api.nvim_win_get_cursor(0)
	buffer_stack[current_position] = { buf = buf, pos = pos }
end

function go_back()
	if current_position > 1 then
		current_position = current_position - 1
		print("Going back: " .. current_position)
		local entry = buffer_stack[current_position]
		vim.api.nvim_set_current_buf(entry.buf)
		vim.api.nvim_win_set_cursor(0, entry.pos)
	end
end

function go_forward()
	if current_position < #buffer_stack then
		current_position = current_position + 1
		print("Going forward: " .. current_position)
		local entry = buffer_stack[current_position]
		vim.api.nvim_set_current_buf(entry.buf)
		vim.api.nvim_win_set_cursor(0, entry.pos)
	end
end

function clear_buffer_stack()
	print("Clearing buffer stack")
	buffer_stack = {}
	current_position = 1
end

vim.keymap.set("n", "<Leader>tn", save_buffer_position, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>td", clear_buffer_stack, { noremap = true, silent = true })
vim.keymap.set("n", "åt", go_back, { noremap = true, silent = true })
vim.keymap.set("n", "æt", go_forward, { noremap = true, silent = true })

local hop_commands = { "HopChar1", "HopChar2", "HopPattern", "HopWord", "HopLineStart" }

for _, cmd in ipairs(hop_commands) do
	vim.api.nvim_create_autocmd("User", {
		pattern = cmd,
		callback = save_buffer_position,
		desc = "Trigger before using Hop commands",
	})
end
