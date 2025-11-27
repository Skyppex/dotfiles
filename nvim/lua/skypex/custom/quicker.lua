local map = require("skypex.utils").map

local quicker = require("quicker")

quicker.setup({})

-- Quickfix list navigation
map("n", "<leader>qk", "<cmd>cprev<CR>zz")
map("n", "<leader>qj", "<cmd>cnext<CR>zz")

map("n", "<leader>tq", function()
	quicker.toggle()
end, "Toggle Quickfix List")
