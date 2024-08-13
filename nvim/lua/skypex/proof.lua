local code_path = require("skypex.utils").get_code_path()
local proof_path = code_path .. "proof/"
local proof_exe = proof_path .. "proof.exe"
local log_file = proof_path .. "log.txt"

local client = vim.lsp.start_client({
	name = "proof",
	cmd = { proof_exe, log_file },
})

if not client then
	vim.notify("Failed to start proof client", vim.log.levels.ERROR)
	return
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.lsp.buf_attach_client(0, client)
	end,
})
