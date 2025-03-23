-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [']quote
--  - ci'  - [C]hange [I]nside [']quote
require("mini.ai").setup({ n_lines = 500 })

-- Use mini.comment to support commenting in injected languages with tree-sitter
require("mini.comment").setup()

-- Auto pairs
require("mini.pairs").setup()

-- Splits and joins
require("mini.splitjoin").setup({
	mappings = {
		toggle = "<leader>tw",
	},
	detect = {
		brackets = {
			"%b()",
			"%b[]",
			"%b{}",
			"%b<>",
		},
		separator = ",",
		exclude_regions = {
			"%b()",
			"%b[]",
			"%b{}",
			"%b<>",
			'%b""',
			"%b''",
		},
	},
})

-- Surround
require("mini.surround").setup({
	custom_surroundings = {
		["{"] = { output = { left = "{ ", right = " }" } },
		["}"] = { output = { left = "{ ", right = " }" } },
		["["] = { output = { left = "[", right = "]" } },
		["]"] = { output = { left = "[", right = "]" } },
		["("] = { output = { left = "(", right = ")" } },
		[")"] = { output = { left = "(", right = ")" } },
		["<"] = { output = { left = "<", right = ">" } },
		[">"] = { output = { left = "<", right = ">" } },
	},
	mappings = {
		add = "s",
		delete = "ds",
		replace = "cs",
		find = "",
		find_left = "",
		highlight = "",
		update_n_lines = "",
	},
})
