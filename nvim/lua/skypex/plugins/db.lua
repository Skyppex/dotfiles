local config = {
	build = function()
		require("dbee").install()
	end,
	config = function()
		require("skypex.custom.db")
	end,
}

return require("skypex.utils").local_plugin("nvim-dbee", config, function()
	return vim.tbl_deep_extend("keep", {
		"skyppex/nvim-dbee",
	}, config)
end)
