local function config()
	require("skypex.custom.punch-card")
end

return require("skypex.utils").local_plugin("punch-card.nvim", config, function()
	return { "skyppex/punch-card.nvim", config = config }
end)
