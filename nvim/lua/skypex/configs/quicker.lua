local map = require("skypex.utils").map

local quicker = require("quicker")

quicker.setup({})

-- Quickfix list navigation
map("n", "åq", "<cmd>cprev<CR>zz", "previous qf list item")
map("n", "æq", "<cmd>cnext<CR>zz", "next qf list item")

map("nx", "<leader>qt", function()
	quicker.toggle()
end, "Toggle Quickfix List")
