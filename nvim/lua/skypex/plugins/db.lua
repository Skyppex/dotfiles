local function config()
	require("skypex.custom.db")
end

return require("skypex.utils").local_plugin("nvim-dbee", config, function()
	return {
		"skyppex/nvim-dbee",
		build = function()
			require("dbee").install()
		end,
		config = config,
	}
end)
