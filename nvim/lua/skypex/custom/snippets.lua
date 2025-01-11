local nmap = require("skypex.utils").nmap
local ls = require("luasnip")
local s, t, i = ls.snippet, ls.text_node, ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local lsex = require("luasnip.extras")
local rep = lsex.rep

local M = {}

local function all_snippets()
	ls.add_snippets("all", {
		s("tag", fmt("<{}>{}</{}>", { i(1, "name"), i(2), rep(1) })),
	})
end

local function js_snippets()
	ls.add_snippets("js", {
		s("jsdoc", t("/**\n * ${1}\n */")),
	})
end

local function cs_snippets()
	ls.add_snippets("cs", {
		s("sf", fmt("[SerializeField] private ${1} ${2};", { i(1, "Type"), i(2, "name") })),
		s("sp", fmt("[field: SerializeField] public ${1} ${2} {{ get; set; }}", { i(1, "Type"), i(2, "name") })),
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
	ls.setup({
		history = true,
		update_events = { "TextChanged", "TextChangedI" },
		enable_autosnippets = true,
	})

	all_snippets()
	js_snippets()
	cs_snippets()

	nmap("<leader><leader>s", "<cmd>lua require('skypex.custom.snippets').all()<cr>", "Source snippets")
end

M.all = function()
	M.friendly_snippets()
	M.telescope()
	M.luasnip()
end

M.all()

return M
