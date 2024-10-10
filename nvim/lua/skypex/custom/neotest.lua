local nmap = require("skypex.utils").nmap
local neotest = require("neotest")

neotest.setup({
	adapters = {
		-- require("neotest-dotnet")({
		-- 	dap = {
		-- 		-- Set to false to debug decompiled code
		-- 		args = { justMyCode = true },
		-- 		-- Enter the name of your dap adapter, the default value is netcoredbg
		-- 		adapter_name = "netcoredbg",
		-- 	},
		-- }),
		require("neotest-rust")({
			args = { "--no-capture" },
			dap_adapter = "codelldb",
		}),
	},
})

vim.keymap.set("n", "<leader>nr", function()
	neotest.run.run()
end, {
	desc = "Run test",
	noremap = true,
	silent = true,
})

vim.keymap.set("n", "<leader>nf", function()
	neotest.run.run(vim.fn.expand("%"))
end, {
	desc = "Run tests in file",
	noremap = true,
	silent = true,
})

vim.keymap.set("n", "<leader>nd", function()
	neotest.run.run({ strategy = "dap" })
end, {
	desc = "Debug test",
	noremap = true,
	silent = true,
})

vim.keymap.set("n", "<leader>ns", function()
	neotest.run.stop()
end, {
	desc = "Stop test",
	noremap = true,
	silent = true,
})

vim.keymap.set("n", "<leader>nsa", function()
	neotest.run.stop(vim.fn.expand("%"))
end, {
	desc = "Stop all tests",
	noremap = true,
	silent = true,
})

vim.keymap.set("n", "<leader>na", function()
	neotest.run.attach()
end, {
	desc = "Attach to test",
	noremap = true,
	silent = true,
})

vim.keymap.set("n", "<leader>no", function()
	neotest.output.open()
end, {
	desc = "Open test output",
	noremap = true,
	silent = true,
})

vim.keymap.set("n", "<leader>tn", function()
	neotest.summary.toggle()
end, {
	desc = "Toggle test summary",
	noremap = true,
	silent = true,
})
