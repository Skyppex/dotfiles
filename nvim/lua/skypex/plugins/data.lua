local function config()
	require("skypex.custom.data")
end

return require("skypex.utils").local_plugin("jq-playground.nvim", config, function()
	return {
		"skyppex/jq-playground.nvim",
		config = config,
	}
end)
