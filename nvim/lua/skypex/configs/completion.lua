local cmp = require("blink.cmp")
cmp.build():pwait()

local keymap = {
	preset = "none",
	["<c-space>"] = { "show" },
	["<c-j>"] = { "select_next", "fallback" },
	["<c-k>"] = { "select_prev", "fallback" },
	["<c-l>"] = { "select_and_accept", "snippet_forward", "fallback" },
	["<c-u>"] = { "scroll_documentation_up", "fallback" },
	["<c-d>"] = { "scroll_documentation_down", "fallback" },
	["<c-e>"] = { "cancel" },
}

cmp.setup({
	completion = {
		ghost_text = { enabled = true },
		list = {
			selection = { preselect = false, auto_insert = false },
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 0,
		},
		trigger = nil,
	},
	fuzzy = {
		sorts = { "exact", "score", "sort_text" },
	},
	snippets = { preset = "luasnip" },
	keymap = keymap,
	cmdline = {
		keymap = keymap,
	},
	sources = {
		default = {
			"lsp",
			"path",
			"snippets",
			"buffer",
			-- "dbee",
		},
		providers = {
			lsp = {
				score_offset = 10,
			},
			-- dbee = {
			-- 	name = "Dbee",
			-- 	module = "skypex.blink-dbee",
			-- 	enabled = true,
			-- 	async = true,
			-- 	opts = {
			-- 		filetypes = { "sql", "mysql", "plsql" },
			-- 		cache_ttl = 30,
			-- 	},
			-- },
		},
	},
})

-- always display completion menu in insert mode no matter what happens :)
vim.api.nvim_create_autocmd({ "InsertEnter", "TextChangedI", "CmdlineChanged" }, {
	pattern = "*",
	callback = function()
		cmp.show()
	end,
})
