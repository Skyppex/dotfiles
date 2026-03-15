local map = require("skypex.utils").map
---@type rustaceanvim.Opts
vim.g.rustaceanvim = {
	-- ---@type rustaceanvim.tools.Opts
	-- tools = {},
	---@type rustaceanvim.lsp.ClientOpts
	server = {
		on_attach = function(client, bufnr)
			map("n", "K", function()
				vim.cmd.RustLsp({ "hover", "actions" })
			end, "rust-analyzer: hover", nil, bufnr)
		end,
	},
	---@type rustaceanvim.dap.Opts
	-- dap = {},
}
