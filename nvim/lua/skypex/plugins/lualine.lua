local colors = {
	gray = "#23262e",
	light_gray = "#373941",
	orange = "#f39c12",
	pink = "#ff00aa",
	blue = "#7cb7ff",
	cyan = "#00e8c6",
	yellow = "#ffe66d",
	green = "#96e072",
	white = "#d5ced9",
	black = "#181a16",
	purple = "#c74ded",
}

local theme = {
	normal = {
		a = { bg = colors.light_gray, fg = colors.pink, gui = "bold" },
		b = { bg = colors.gray, fg = colors.white },
		c = { bg = colors.black, fg = colors.white },
	},
	insert = {
		a = { bg = colors.light_gray, fg = colors.green, gui = "bold" },
		b = { bg = colors.gray, fg = colors.white },
		c = { bg = colors.black, fg = colors.white },
	},
	visual = {
		a = { bg = colors.light_gray, fg = colors.yellow, gui = "bold" },
		b = { bg = colors.gray, fg = colors.white },
		c = { bg = colors.black, fg = colors.white },
	},
	replace = {
		a = { bg = colors.light_gray, fg = colors.blue, gui = "bold" },
		b = { bg = colors.gray, fg = colors.white },
		c = { bg = colors.black, fg = colors.white },
	},
	command = {
		a = { bg = colors.light_gray, fg = colors.orange, gui = "bold" },
		b = { bg = colors.gray, fg = colors.white },
		c = { bg = colors.black, fg = colors.white },
	},
	inactive = {
		a = { bg = colors.light_gray, fg = colors.gray, gui = "bold" },
		b = { bg = colors.gray, fg = colors.white },
		c = { bg = colors.black, fg = colors.white },
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
