local M = {}

local function all_snippets(ls)
	ls.add_snippets("all", {})
end

M.friendly_snippets = function()
	require("luasnip.loaders.from_vscode").lazy_load()
end

M.telescope = function()
	require("telescope").load_extension("luasnip")

	vim.keymap.set("n", "<leader>sn", "<cmd>Telescope luasnip<CR>", {
		desc = "Search Snippets",
		noremap = true,
		silent = true,
	})
end

M.luasnip = function()
	local ls = require("luasnip")
	ls.setup()

	all_snippets(ls)

	vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/lua/skypex/plugins/snippets.lua<cr>")
end

M.all = function()
	M.friendly_snippets()
	M.telescope()
	M.luasnip()
end

return M
