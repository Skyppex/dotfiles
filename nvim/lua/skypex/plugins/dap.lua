return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
		},
		ft = { "cs", "rust", "go" },
		config = function()
			require("skypex.custom.dap").dap()
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		event = "BufReadPre",
		config = function()
			require("skypex.custom.dap").dapui()
		end,
	},
	{ "nvim-neotest/nvim-nio" },
}
