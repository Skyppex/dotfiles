return {
	"saecki/crates.nvim",
	tag = "stable",
	event = "BufRead",
	ft = { "rust", "toml" },
	config = function()
		require("crates").setup()
	end,
}
