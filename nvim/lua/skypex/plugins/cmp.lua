return {
	{
		"hrsh7th/nvim-cmp",
		lazy = true,
		event = "InsertEnter",
		dependencies = {
			{ "L3MON4D3/LuaSnip" },
			{
				"hrsh7th/cmp-nvim-lsp",
				lazy = true,
				event = { "BufReadPre", "BufNewFile" },
			},
			{
				"hrsh7th/cmp-path",
				lazy = true,
				event = "InsertEnter",
			},
			{
				"hrsh7th/cmp-buffer",
				lazy = true,
				event = "InsertEnter",
			},
			{
				"f3fora/cmp-spell",
				lazy = true,
				event = "InsertEnter",
			},
			{
				"hrsh7th/cmp-nvim-lsp-signature-help",
				lazy = true,
				event = "InsertEnter",
			},
			{
				"zbirenbaum/copilot-cmp",
				config = true,
			},
			{
				"zbirenbaum/copilot.lua",
				lazy = true,
				cmd = "Copilot",
				event = "InsertEnter",
			},
			{
				"onsails/lspkind.nvim",
				lazy = true,
				event = "InsertEnter",
			},
		},
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
			})

			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			---@diagnostic disable-next-line: redundant-parameter
			cmp.setup({
				sources = {
					{
						name = "path",
						option = { get_cwd = vim.fn.getcwd },
						max_item_count = 2,
					},
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "luasnip", max_item_count = 3 },
					{
						name = "buffer",
						option = {
							keyword_length = 2,
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
					{ name = "copilot" },
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
					format = lspkind.cmp_format({
						mode = "symbol_text", -- show only symbol annotations
						maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
						-- can also be a function to dynamically calculate max width such as
						-- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
						ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
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
					}),
				},
				experimental = {
					ghost_text = true,
				},
			})

			local colors = {
				Unit = "#d5ced9",
				Property = "#ff00aa",
				Module = "#c74ded",
				Interface = "#ffe66d",
				Class = "#ffe66d",
				Value = "#00e8c6",
				Variable = "#00e8c6",
				Field = "#ff00aa",
				Constructor = "#ffe66d",
				Function = "#ffe66d",
				Method = "#ffe66d",
				TypeParameter = "#ffe66d",
				Operator = "#f39c12",
				Event = "#ffe66d",
				Struct = "#ffe66d",
				Constant = "#f39c12",
				EnumMember = "#f39c12",
				File = "#7cb7ff",
				Enum = "#ffe66d",
				Keyword = "#c74ded",
				Text = "#96e072",
				Folder = "#7cb7ff",
				Color = "#d5ced9",
				Reference = "#c74ded",
				Snippet = "#7cb7ff",
				Copilot = "#7cb7ff",
			}

			for name, color in pairs(colors) do
				local c = "CmpItemKind" .. name .. " guifg=" .. color
				print(c)
				vim.cmd.hi(c)
			end
		end,
	},
}
