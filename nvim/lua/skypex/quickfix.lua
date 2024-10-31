function toggle_quickfix_list()
	local qf_exists = false
	local current_win = vim.api.nvim_get_current_win()

	for _, win in pairs(vim.fn.getwininfo()) do
		if win["quickfix"] == 1 then
			qf_exists = true
		end
	end

	if qf_exists == true then
		vim.cmd("cclose")
		return
	end

	if not vim.tbl_isempty(vim.fn.getqflist()) then
		vim.cmd("botright copen")
		vim.api.nvim_set_current_win(current_win)
	end
end

-- vim.keymap.set("n", "<S-A-x>", function()
-- 	toggle_quickfix_list()
-- end, { desc = "Toggle Quickfix List", noremap = true, silent = true })
