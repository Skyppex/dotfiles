local function config()
	require("skypex.custom.direnv")
end

return require("skypex.utils").local_plugin("direnv.nvim", config, function()
	return { "NotAShelf/direnv.nvim", config = config }
end)
