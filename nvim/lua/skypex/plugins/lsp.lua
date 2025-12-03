return {
	{
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
		dependencies = {
			{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"j-hui/fidget.nvim",
			"Decodetalkers/csharpls-extended-lsp.nvim",
			{
				"aznhe21/actions-preview.nvim",
				opts = {
					telescope = {
						sorting_strategy = "ascending",
						layout_strategy = "vertical",
						layout_config = {
							width = 0.3,
							height = 0.4,
							prompt_position = "top",
							preview_cutoff = 20,
							preview_height = function(_, _, max_lines)
								return max_lines - 15
							end,
						},
					},
				},
			},
			"Issafalcon/lsp-overloads.nvim",
			"nvim-telescope/telescope.nvim",
		},
		opts = {
			setup = {
				rust_analyzer = function()
					return true
				end,
			},
		},
		config = function()
			local direnv_status = require("skypex.utils").direnv_status

			while true do
				if direnv_status() ~= "pending" then
					break
				end
			end

			require("skypex.custom.lsp")
		end,
	},
}
