local config = {
	ft = "json",
	config = function()
		require("skypex.custom.bellows")
	end,
}

return require("skypex.utils").local_plugin("bellows.nvim", config, function()
	return vim.tbl_deep_extend("keep", {
		"skyppex/bellows.nvim",
	}, config)
end)
