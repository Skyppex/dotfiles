local kikao = require("kikao")

kikao.setup({
	deny_on_path = {
		".git/COMMIT_EDITMSG",
		".git/rebase-merge/git-rebase-todo",
		"NeovimTree_",
		"NeogitStatus",
		"fugitive://",
		"git://",
		"term://",
		"toggleterm://",
		"dap-repl://",
		"dapui://",
		"kulala://",
		"tandem://",
	},
})

local map = require("skypex.utils").map

map("n", "<leader>SX", kikao.clear, "clear session")
