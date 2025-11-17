local nmap = require("skypex.utils").nmap

local quicker = require("quicker")

quicker.setup({})

-- Quickfix list navigation
nmap("<leader>qk", "<cmd>cprev<CR>zz")
nmap("<leader>qj", "<cmd>cnext<CR>zz")

nmap("<leader>tq", function()
	quicker.toggle()
end, "Toggle Quickfix List")
