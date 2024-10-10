return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		-- "Issafalcon/neotest-dotnet",
		"rouge8/neotest-rust",
	},
	config = function()
		require("skypex.custom.neotest")
	end,
	-- "klen/nvim-test",
	-- config = function()
	-- 	require("skypex.custom.test")
	-- end,
}
