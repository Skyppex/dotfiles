local client = vim.lsp.start_client({
	name = "proof",
	cmd = { "D:/code/proof/proof.exe" },
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
