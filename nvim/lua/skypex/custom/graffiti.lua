require("graffiti").setup()

local map = require("skypex.utils").map
map("n", "<leader>Gh", "<cmd>GraffitiHost<cr>", "Host graffiti session")
map("n", "<leader>Gj", "<cmd>GraffitiJoin<cr>", "Join graffiti session")
map("n", "<leader>Gq", "<cmd>GraffitiStop<cr>", "Stop graffiti session")
map("n", "<leader>GQ", "<cmd>GraffitiKill<cr>", "Kill graffiti server")
