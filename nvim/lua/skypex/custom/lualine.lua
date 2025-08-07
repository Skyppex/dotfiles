local andromeda_colors = require("skypex.utils").andromeda

local andromeda_theme = {
	normal = {
		a = { bg = andromeda_colors.light_gray, fg = andromeda_colors.pink, gui = "bold" },
		b = { bg = andromeda_colors.gray, fg = andromeda_colors.white },
		c = { bg = andromeda_colors.black, fg = andromeda_colors.white },
	},
	insert = {
		a = { bg = andromeda_colors.light_gray, fg = andromeda_colors.green, gui = "bold" },
		b = { bg = andromeda_colors.gray, fg = andromeda_colors.white },
		c = { bg = andromeda_colors.black, fg = andromeda_colors.white },
	},
	visual = {
		a = { bg = andromeda_colors.light_gray, fg = andromeda_colors.yellow, gui = "bold" },
		b = { bg = andromeda_colors.gray, fg = andromeda_colors.white },
		c = { bg = andromeda_colors.black, fg = andromeda_colors.white },
	},
	replace = {
		a = { bg = andromeda_colors.light_gray, fg = andromeda_colors.blue, gui = "bold" },
		b = { bg = andromeda_colors.gray, fg = andromeda_colors.white },
		c = { bg = andromeda_colors.black, fg = andromeda_colors.white },
	},
	command = {
		a = { bg = andromeda_colors.light_gray, fg = andromeda_colors.orange, gui = "bold" },
		b = { bg = andromeda_colors.gray, fg = andromeda_colors.white },
		c = { bg = andromeda_colors.black, fg = andromeda_colors.white },
	},
	inactive = {
		a = { bg = andromeda_colors.light_gray, fg = andromeda_colors.gray, gui = "bold" },
		b = { bg = andromeda_colors.gray, fg = andromeda_colors.white },
		c = { bg = andromeda_colors.black, fg = andromeda_colors.white },
	},
}

local colors = require("skypex.colors")

local theme = {
	normal = {
		a = { bg = colors.background2, fg = colors.pink, gui = "bold" },
		b = { bg = colors.background1, fg = colors.primary },
		c = { bg = colors.background0, fg = colors.primary },
	},
	insert = {
		a = { bg = colors.background2, fg = colors.green, gui = "bold" },
		b = { bg = colors.background1, fg = colors.primary },
		c = { bg = colors.background0, fg = colors.primary },
	},
	visual = {
		a = { bg = colors.background2, fg = colors.yellow, gui = "bold" },
		b = { bg = colors.background1, fg = colors.primary },
		c = { bg = colors.background0, fg = colors.primary },
	},
	replace = {
		a = { bg = colors.background2, fg = colors.blue, gui = "bold" },
		b = { bg = colors.background1, fg = colors.primary },
		c = { bg = colors.background0, fg = colors.primary },
	},
	command = {
		a = { bg = colors.background2, fg = colors.orange, gui = "bold" },
		b = { bg = colors.background1, fg = colors.primary },
		c = { bg = colors.background0, fg = colors.primary },
	},
	inactive = {
		a = { bg = colors.background2, fg = colors.gray, gui = "bold" },
		b = { bg = colors.background1, fg = colors.primary },
		c = { bg = colors.background0, fg = colors.primary },
	},
}

require("lualine").setup({
	options = {
		theme = theme,
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
