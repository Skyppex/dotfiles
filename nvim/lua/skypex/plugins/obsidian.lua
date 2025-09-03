return {
	"obsidian-nvim/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	conf = function()
		local path = vim.fn.expand("%:p")
		return path:match(vim.fn.expand("~") .. "/OneDrive/Obsidian/Vaults/")
	end,
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
		"nvim-telescope/telescope.nvim",
		"nvim-treesitter/nvim-treesitter",

		-- see below for full list of optional dependencies 👇
	},
	config = function()
		require("skypex.custom.obsidian")
	end,
}
