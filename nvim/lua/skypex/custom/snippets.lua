local nmap = require("skypex.utils").nmap

local M = {}

local function all_snippets(ls)
	local s, t, i, rep = ls.snippet, ls.text_node, ls.insert_node, ls.rep

	ls.add_snippets("all", {
		s("tag", {
			t("<"),
			i(1, "name"),
			t(">"),
			i("2"),
			t("</"),
			rep(1),
			t(">"),
		}),
	})
end

local function js_snippets(ls)
	local t = ls.text_node

	ls.add_snippets("js", {
		trig = "jsdoc",
		t("/**\n * ${1}\n */"),
	})
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
	-- js_snippets(ls)

	nmap("<leader><leader>s", "<cmd>lua require('skypex.custom.snippets').all()<cr>", "Source snippets")
end

M.all = function()
	M.friendly_snippets()
	M.telescope()
	M.luasnip()
end

return M
