local nmap = require("skypex.utils").nmap

require("todo-comments").setup({
	signs = false,
})

nmap("<leader>sl", "<cmd>TodoTelescope<CR>", "Search Todo Comments")
