local keymaps = {
	insert = false,
	insert_line = false,
	normal = "s",
	normal_cur = "sc",
	normal_line = "sl",
	normal_cur_line = "so",
	visual = "s",
	visual_cur = "sc",
	delete = "ds",
	change = "cs",
}

local config = require("nvim-surround.config")

local surrounds = {
	["("] = {
		add = { "(", ")" },
		find = function()
			return config.get_selection({ motion = "a)" })
		end,
		delete = "^(.)().-(.)()$",
	},
	["{"] = {
		add = { "{", "}" },
		find = function()
			return config.get_selection({ motion = "a}" })
		end,
		delete = "^(.)().-(.)()$",
	},
	["["] = {
		add = { "[", "]" },
		find = function()
			return config.get_selection({ motion = "a]" })
		end,
		delete = "^(.)().-(.)()$",
	},
	["<"] = {
		add = { "<", ">" },
		find = function()
			return config.get_selection({ motion = "a>" })
		end,
		delete = "^(.)().-(.)()$",
	},
}

local surround = require("nvim-surround")

surround.setup({
	keymaps = keymaps,
	surrounds = surrounds,
})
