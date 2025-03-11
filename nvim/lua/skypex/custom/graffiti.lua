require("graffiti").setup()

local nmap = require("skypex.utils").nmap
nmap("<leader>Gh", "<cmd>GraffitiHost<cr>", "Host graffiti session")
nmap("<leader>Gq", "<cmd>GraffitiStop<cr>", "Stop graffiti session")
nmap("<leader>GQ", "<cmd>GraffitiKill<cr>", "Kill graffiti server")
