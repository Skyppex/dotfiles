local config = {
	event = { "BufNewFile", "BufReadPre" },
	config = function()
		require("skypex.custom.punch-card")
	end,
}

return require("skypex.utils").local_plugin("punch-card.nvim", config, function()
	return vim.tbl_deep_extend("keep", {
		"skyppex/punch-card.nvim",
	}, config)
end)
