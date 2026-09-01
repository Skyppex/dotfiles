local M = {}

function M.replace_from_register()
	local text = vim.fn.getreg('"')

	local start = vim.fn.getpos("'[")
	local finish = vim.fn.getpos("']")

	vim.api.nvim_buf_set_text(
		0,
		start[2] - 1,
		start[3] - 1,
		finish[2] - 1,
		finish[3],
		vim.split(text, "\n", { plain = true })
	)
end

_G.replace_from_register = M.replace_from_register

function M.replace()
	vim.go.operatorfunc = "v:lua.replace_from_register"
	vim.api.nvim_feedkeys("g@", "n", false)
end

return M
