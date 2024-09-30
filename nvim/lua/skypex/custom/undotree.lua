vim.g.undotree_DiffCommand = "FC"
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, {
	desc = "Toggle Undo Tree",
	noremap = true,
	silent = true,
})
