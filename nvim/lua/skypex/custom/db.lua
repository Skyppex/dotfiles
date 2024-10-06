require("dbee").setup(--[[optional config]])

vim.keymap.set("n", "<leader>td", require("dbee").toggle, {
	desc = "Toggle DB",
	noremap = true,
	silent = true,
})
