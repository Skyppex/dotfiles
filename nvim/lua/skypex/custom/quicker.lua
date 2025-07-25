local nmap = require("skypex.utils").nmap

local quicker = require("quicker")

quicker.setup({})

-- Quickfix list navigation
nmap("<S-A-k>", "<cmd>cprev<CR>zz")
nmap("<S-A-j>", "<cmd>cnext<CR>zz")

nmap("<S-A-t>", function()
	quicker.toggle()
end, "Toggle Quickfix List")

nmap("<S-A-q>", function()
	quicker.close()
end, "Close Quickfix List")
