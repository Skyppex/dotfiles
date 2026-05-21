local map = require("skypex.utils").map

require("todo-comments").setup({
	signs = false,
})

map("n", "<leader>sl", "<cmd>TodoTelescope<CR>", "Search Todo Comments")
