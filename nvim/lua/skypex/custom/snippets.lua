local nmap = require("skypex.utils").nmap

local M = {}

local function all_snippets(ls)
	ls.add_snippets("all", {})
end

M.friendly_snippets = function()
	require("luasnip.loaders.from_vscode").lazy_load()
end

M.telescope = function()
	require("telescope").load_extension("luasnip")

	nmap("<leader>sn", "<cmd>Telescope luasnip<CR>", "Search Snippets")
end

M.luasnip = function()
	local ls = require("luasnip")
	ls.setup()

	all_snippets(ls)

	nmap("<leader><leader>s", "<cmd>lua require('skypex.custom.snippets').all()<cr>", "Source snippets")
end

M.all = function()
	M.friendly_snippets()
	M.telescope()
	M.luasnip()
end

return M
