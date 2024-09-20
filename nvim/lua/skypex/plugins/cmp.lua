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
				"DasGandlaf/nvim-autohotkey",
				lazy = true,
				event = "InsertEnter",
			},
			{
				"hrsh7th/cmp-nvim-lsp-signature-help",
				lazy = true,
				event = "InsertEnter",
			},
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
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
					["<C-space>"] = cmp.mapping.complete(),
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
				sources = {
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "luasnip" },
					{
						name = "path",
						option = { get_cwd = vim.fn.getcwd },
					},
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
					},
					{ name = "spell" },
					{ name = "autohotkey", filetypes = { "ahk", "autohotkey" } },
				},
			})
		end,
	},
}
