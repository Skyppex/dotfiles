local nmap = require("skypex.utils").nmap
local neotest = require("neotest")

neotest.setup({
	adapters = {
		require("neotest-dotnet"),
		-- require("neotest-rust")({
		-- 	args = { "--no-capture" },
		-- }),
	},
})

nmap("<leader>nr", function()
	neotest.run.run()
end, "Run test")

nmap("<leader>nf", function()
	neotest.run.run(vim.fn.expand("%"))
end, "Run tests in file")

nmap("<leader>nd", function()
	neotest.run.run({ strategy = "dap" })
end, "Debug test")

nmap("<leader>ns", function()
	neotest.run.stop()
end, "Stop test")

nmap("<leader>nsa", function()
	neotest.run.stop(vim.fn.expand("%"))
end, "Stop all tests")

nmap("<leader>na", function()
	neotest.run.attach()
end, "Attach to test")

nmap("<leader>no", function()
	neotest.output.open()
end, "Open test output")

nmap("<leader>tn", function()
	neotest.summary.toggle()
end, "Toggle test summary")
