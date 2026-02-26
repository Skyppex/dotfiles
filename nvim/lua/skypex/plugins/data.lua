local config = {
	config = function()
		require("skypex.custom.data")
	end,
}

return require("skypex.utils").local_plugin("jq-playground.nvim", config, function()
	return vim.tbl_deep_extend("keep", {
		"skyppex/jq-playground.nvim",
	}, config)
end)
