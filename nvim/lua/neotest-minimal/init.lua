vim.opt.runtimepath:remove(vim.fn.expand("~/.config/nvim"))
vim.opt.packpath:remove(vim.fn.expand("~/.local/share/nvim/site"))

local lazypath = "/tmp/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/nvim-nio",
		-- Install adapters here
		"Issafalcon/neotest-dotnet",
	},
	config = function()
		-- Install any required parsers
		require("nvim-treesitter.configs").setup({
			ensure_installed = {},
		})

		require("neotest").setup({
			-- Add adapters to the list
			adapters = {
				require("neotest-dotnet"),
			},
		})
	end,
})

local nmap = function(l, r, d)
	vim.keymap.set("n", l, r, {
		noremap = true,
		silent = true,
		desc = d,
	})
end

local neotest = require("neotest")

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
