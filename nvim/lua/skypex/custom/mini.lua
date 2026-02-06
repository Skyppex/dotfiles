local utils = require("skypex.utils")

local icons = require("mini.icons")
icons.setup({})
icons.mock_nvim_web_devicons()

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

-- Pick
local pick = require("mini.pick")
local extra = require("mini.extra")
pick.setup({
	mappings = {
		quickfix = {
			char = "<c-q>",
			func = function()
				local keys = "<c-a><m-cr>"
				keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
				vim.api.nvim_feedkeys(keys, "n", false)
			end,
		},
	},
})

local map = utils.map

map("n", "<leader>sf", function()
	pick.builtin.files({ tool = "fd", globs = { "*", "!.meta" } })
end, "search files")

map("n", "<leader>sg", function()
	pick.builtin.grep_live({ tool = "rg" })
end, "grep files")

map("n", "<leader>/", function()
	extra.pickers.buf_lines({ scope = "current" })
end, "search lines")

map("n", "<leader>sh", pick.builtin.help, "search help")
map("n", "<leader>sk", extra.pickers.keymaps, "search keymaps")
map("n", "<leader>sc", extra.pickers.colorschemes, "search colorschemes")
map("n", "<leader>sd", extra.pickers.diagnostic, "search diagnostics")
map("n", "<leader>sr", pick.builtin.resume, "resume search")
map("n", "<leader>sb", pick.builtin.buffers, "search buffers")

-- discourage use of gcc over gcl
map("n", "gcc", '<cmd>echo "use gcl to comment out a line"<cr>')
