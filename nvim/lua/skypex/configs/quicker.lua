local map = require("skypex.utils").map

local quicker = require("quicker")

quicker.setup({})

-- Quickfix list navigation
map("n", "åq", "<cmd>cprev<CR>zz")
map("n", "æq", "<cmd>cnext<CR>zz")

map("n", "<leader>tq", function()
	quicker.toggle()
end, "Toggle Quickfix List")
