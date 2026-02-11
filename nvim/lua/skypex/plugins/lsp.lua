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
			"Issafalcon/lsp-overloads.nvim",
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
