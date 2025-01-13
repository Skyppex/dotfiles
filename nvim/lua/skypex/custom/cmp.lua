require("copilot").setup({
	suggestion = { enabled = false },
	panel = { enabled = false },
})

local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")

local sources = {
	path = {
		name = "path",
		max_item_count = 2,
	},
	lsp = {
		name = "nvim_lsp",
		max_item_count = 5,
	},
	lsp_signature_help = {
		name = "nvim_lsp_signature_help",
		max_item_count = 2,
	},
	luasnip = {
		name = "luasnip",
		max_item_count = 2,
	},
	dadbod = { name = "vim-dadbod-completion" },
	buffer = {
		name = "buffer",
		option = {
			keyword_length = 3,
			get_bufnrs = function()
				local bufs = {}
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					bufs[vim.api.nvim_win_get_buf(win)] = true
				end
				return vim.tbl_keys(bufs)
			end,
		},
		max_item_count = 1,
	},
	crates = { name = "crates" },
	copilot = { name = "copilot" },
	obsidian = { name = "obsidian" },
	obsidian_new = { name = "obsidian_new" },
	obsidian_tag = { name = "obsidian_tag" },
}

---@diagnostic disable-next-line: redundant-parameter
cmp.setup({
	sources = {
		sources.path,
		sources.lsp,
		sources.lsp_signature_help,
		sources.luasnip,
		sources.buffer,
		sources.copilot,
	},
	sorting = {
		comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.order,
			cmp.config.compare.kind,
			cmp.config.compare.score,

			-- copied from cmp-under, but I don't think I need the plugin for this.
			-- I might add some more of my own.
			function(entry1, entry2)
				local _, entry1_under = entry1.completion_item.label:find("^_+")
				local _, entry2_under = entry2.completion_item.label:find("^_+")
				entry1_under = entry1_under or 0
				entry2_under = entry2_under or 0
				if entry1_under > entry2_under then
					return false
				elseif entry1_under < entry2_under then
					return true
				end
			end,

			cmp.config.compare.sort_text,
			cmp.config.compare.length,
		},
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	completion = { completeopt = "menu,menuone,noinsert" },
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	view = {
		entries = {
			selection_order = "top_down",
			vertical_positioning = "above",
			follow_cursor = false,
		},
		docs = {
			auto_open = true,
		},
	},
	mapping = cmp.mapping.preset.insert({
		["<S-A-j>"] = cmp.mapping.select_next_item(),
		["<S-A-k>"] = cmp.mapping.select_prev_item(),
		["<A-u>"] = cmp.mapping.scroll_docs(-4),
		["<A-d>"] = cmp.mapping.scroll_docs(4),
		["<TAB>"] = cmp.mapping.confirm({ select = true }),
		["<C-e>"] = cmp.mapping.abort(),
		["<S-A-l>"] = cmp.mapping.complete({}),
		["<A-l>"] = cmp.mapping(function()
			if luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			end
		end, { "i", "s" }),
		["<A-h>"] = cmp.mapping(function()
			if luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			end
		end, { "i", "s" }),
		["<A-j>"] = cmp.mapping(function()
			if luasnip.choice_active() then
				luasnip.change_choice(1)
			end
		end, { "i", "s" }),
		["<A-k>"] = cmp.mapping(function()
			if luasnip.choice_active() then
				luasnip.change_choice(-1)
			end
		end, { "i" }),
	}),
	formatting = {
		expandable_indicator = true,
		format = function(entry, vim_item)
			local kind = lspkind.cmp_format({
				mode = "symbol", -- show only symbol annotations <symbol|text|symbol_text>
				maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
				-- can also be a function to dynamically calculate max width such as
				-- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
				ellipsis_char = "..", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
				show_labelDetails = true, -- show labelDetails in menu. Disabled by default
				symbol_map = {
					Copilot = "",
				},

				-- The function below will be called before any actual modifications from lspkind
				-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
				-- before = function (entry, vim_item)
				-- ...
				-- return vim_item
				-- end
			})

			local tailwind = require("tailwindcss-colorizer-cmp").formatter

			vim_item = kind(entry, vim_item)
			vim_item = tailwind(entry, vim_item)
			vim_item.dup = 0

			return vim_item
		end,
	},
	experimental = {
		ghost_text = true,
	},
})

cmp.setup.filetype({ "sql" }, {
	sources = {
		sources.dadbod,
		sources.buffer,
	},
})

vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "Vaults/**/*.md",
	callback = function()
		cmp.setup.buffer({
			sources = {
				sources.obsidian,
				sources.obsidian_new,
				sources.obsidian_tag,
			},
		})
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "Cargo.toml",
	callback = function()
		cmp.setup.buffer({
			sources = {
				sources.crates,
				sources.buffer,
			},
		})
	end,
})

local andromeda = require("skypex.utils").andromeda

local colors = {
	Unit = andromeda.white,
	Property = andromeda.pink,
	Module = andromeda.purple,
	Interface = andromeda.yellow,
	Class = andromeda.yellow,
	Value = andromeda.cyan,
	Variable = andromeda.cyan,
	Field = andromeda.pink,
	Constructor = andromeda.yellow,
	Function = andromeda.yellow,
	Method = andromeda.yellow,
	TypeParameter = andromeda.yellow,
	Operator = andromeda.orange,
	Event = andromeda.yellow,
	Struct = andromeda.yellow,
	Constant = andromeda.orange,
	EnumMember = andromeda.orange,
	File = andromeda.blue,
	Enum = andromeda.yellow,
	Keyword = andromeda.purple,
	Text = andromeda.green,
	Folder = andromeda.blue,
	Color = andromeda.white,
	Reference = andromeda.purple,
	Snippet = andromeda.blue,
	Copilot = andromeda.blue,
}

for name, color in pairs(colors) do
	vim.cmd.hi("CmpItemKind" .. name .. " guifg=" .. color)
end

require("skypex.utils").nmap("<leader>tc", "<cmd>Copilot toggle<cr>")
