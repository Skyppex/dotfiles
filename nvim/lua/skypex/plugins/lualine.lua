-- Define the endswith function
local function endswith(s, ending)
	return ending == "" or s:sub(-#ending) == ending
end

-- Return the lualine configuration
return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"archibate/lualine-time",
		},
		event = "VeryLazy",
		opts = {
			options = {
				theme = "dracula",
				component_separators = { left = "│", right = "" },
			},
			sections = {
				lualine_c = { {
					"filename",
					path = 1,
				}, "filetype" },
				lualine_x = { "cdate", "ctime" },
			},
		},
	},
}
