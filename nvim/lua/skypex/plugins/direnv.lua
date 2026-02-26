local config = {
	config = function()
		require("skypex.custom.direnv")
	end,
}

return require("skypex.utils").local_plugin("direnv.nvim", config, function()
	return vim.tbl_deep_extend("keep", {
		"skyppex/direnv.nvim",
	}, config)
end)
