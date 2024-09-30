return {
	"saecki/crates.nvim",
	tag = "stable",
	ft = { "rust", "toml" },
	config = function()
		require("crates").setup()
	end,
}
