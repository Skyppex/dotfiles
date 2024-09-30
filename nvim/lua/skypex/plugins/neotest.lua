return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"Issafalcon/neotest-dotnet",
	},
	config = function()
		local neotest = require("neotest")

		neotest.setup({
			adapters = {
				require("neotest-dotnet")({
					dap = {
						-- Set to false to debug decompiled code
						args = { justMyCode = true },
						-- Enter the name of your dap adapter, the default value is netcoredbg
						adapter_name = "netcoredbg",
					},
				}),
			},
		})

		vim.keymap.set("n", "<leader>tr", function()
			neotest.run.run()
		end, {
			desc = "Run test",
			noremap = true,
			silent = true,
		})

		vim.keymap.set("n", "<leader>ta", function()
			neotest.run.run(vim.fn.expand("%"))
		end, {
			desc = "Run tests in file",
			noremap = true,
			silent = true,
		})

		vim.keymap.set("n", "<leader>td", function()
			neotest.run.run({ strategy = "dap" })
		end, {
			desc = "Debug test",
			noremap = true,
			silent = true,
		})

		vim.keymap.set("n", "<leader>ts", function()
			neotest.run.stop()
		end, {
			desc = "Stop test",
			noremap = true,
			silent = true,
		})

		vim.keymap.set("n", "<leader>tsa", function()
			neotest.run.stop(vim.fn.expand("%"))
		end, {
			desc = "Stop test",
			noremap = true,
			silent = true,
		})

		vim.keymap.set("n", "<leader>ta", function()
			neotest.run.attach()
		end, {
			desc = "Attach to test",
			noremap = true,
			silent = true,
		})
	end,
}
