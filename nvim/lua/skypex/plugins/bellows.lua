local function config()
	require("skypex.custom.bellows")
end

return require("skypex.utils").local_plugin("bellows.nvim", config, function()
	return { "skyppex/bellows.nvim", config = config }
end)
