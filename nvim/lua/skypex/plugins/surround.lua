return {
	{
		"kylechui/nvim-surround",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			keymaps = {
				insert = false,
				insert_line = false,
				normal = "<leader>o",
				normal_cur = "<leader>oc",
				normal_line = "<leader>ol",
				normal_cur_line = "<leader>os",
				visual = "<leader>o",
				visual_cur = "<leader>oc",
				delete = "do",
				change = "co",
			},
			surrounds = {
				["("] = {
					add = { "(", ")" },
					find = function()
						local config = require("nvim-surround.config")
						return config.get_selection({ motion = "a)" })
					end,
					delete = "^(.)().-(.)()$",
				},
				["{"] = {
					add = { "{", "}" },
					find = function()
						local config = require("nvim-surround.config")
						return config.get_selection({ motion = "a}" })
					end,
					delete = "^(.)().-(.)()$",
				},
				["["] = {
					add = { "[", "]" },
					find = function()
						local config = require("nvim-surround.config")
						return config.get_selection({ motion = "a]" })
					end,
					delete = "^(.)().-(.)()$",
				},
				["<"] = {
					add = { "<", ">" },
					find = function()
						local config = require("nvim-surround.config")
						return config.get_selection({ motion = "a>" })
					end,
					delete = "^(.)().-(.)()$",
				},
			},
		},
	},
}
