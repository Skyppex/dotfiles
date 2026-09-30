local kikao = require("kikao")

kikao.setup({})

local map = require("skypex.utils").map

map("n", "<leader>SX", kikao.clear, "clear session")
