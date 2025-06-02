local colors = require("skypex.utils").andromeda

local andromeda_theme = {
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

require("lualine").setup({
	options = {
		theme = andromeda_theme,
		component_separators = { left = "│", right = "" },
	},
	sections = {
		lualine_b = { {
			"filename",
			path = 1,
		}, "filetype" },
		lualine_c = {},
		lualine_x = { "cdate", "ctime" },
	},
})
