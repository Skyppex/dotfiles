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
		menu = { auto_show = false },
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
		},
		providers = {
			lsp = {
				score_offset = 10,
			},
		},
	},
})

local no_cmp_names = {
	"tandem://input",
}

local no_cmp_filetypes = {
	"qf",
}

-- always display completion menu in insert mode no matter what happens :)
vim.api.nvim_create_autocmd({ "InsertEnter", "TextChangedI", "CmdlineChanged" }, {
	pattern = "*",
	callback = function(ev)
		local buf = ev.buf
		local name = vim.api.nvim_buf_get_name(buf)
		local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })

		for _, value in ipairs(no_cmp_names) do
			if value == name then
				return
			end
		end

		for _, value in ipairs(no_cmp_filetypes) do
			if value == ft then
				return
			end
		end

		cmp.show()
	end,
})
