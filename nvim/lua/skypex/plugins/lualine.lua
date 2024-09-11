local colors = {
	gray = "#23262E",
	light_gray = "#373941",
	orange = "#f39c12",
	pink = "#ff00aa",
	blue = "#7cb7ff",
	yellow = "#ffe66d",
	green = "#96e072",
	white = "#D5CED9",
	black = "#282a36",
}

local theme = {
	normal = {
		a = { bg = colors.pink, fg = colors.black, gui = "bold" },
		b = { bg = colors.light_gray, fg = colors.white },
		c = { bg = colors.gray, fg = colors.white },
	},
	insert = {
		a = { bg = colors.green, fg = colors.black, gui = "bold" },
		b = { bg = colors.light_gray, fg = colors.white },
		c = { bg = colors.gray, fg = colors.white },
	},
	visual = {
		a = { bg = colors.yellow, fg = colors.black, gui = "bold" },
		b = { bg = colors.light_gray, fg = colors.white },
		c = { bg = colors.gray, fg = colors.white },
	},
	replace = {
		a = { bg = colors.blue, fg = colors.black, gui = "bold" },
		b = { bg = colors.light_gray, fg = colors.white },
		c = { bg = colors.gray, fg = colors.white },
	},
	command = {
		a = { bg = colors.orange, fg = colors.black, gui = "bold" },
		b = { bg = colors.light_gray, fg = colors.white },
		c = { bg = colors.gray, fg = colors.white },
	},
	inactive = {
		a = { bg = colors.gray, fg = colors.white, gui = "bold" },
		b = { bg = colors.light_gray, fg = colors.white },
		c = { bg = colors.gray, fg = colors.white },
	},
}

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
				theme = theme,
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
