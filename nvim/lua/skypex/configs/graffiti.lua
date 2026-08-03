local Path = require("plenary.path")

local bin_path = Path:new(vim.fn.stdpath("data") .. "/graffiti-rs/target/release/graffiti-rs")

if not bin_path:is_file() then
	bin_path = Path:new(vim.fn.stdpath("data") .. "/graffiti-rs/result/bin/graffiti-rs")

	if not bin_path:is_file() then
		bin_path = Path:new(vim.fn.exepath("graffiti-rs"))

		if not bin_path:is_file() then
			return
		end
	end
end

local utils = require("skypex.utils")

local colors = require("skypex.colors")

require("graffiti").setup({
	server_executable = bin_path.filename,
	authorized_keys = "~/.ssh/authorized_keys",
	client_key = "~/.ssh/id_25519-self",
	cursors = {
		hi1 = "guifg=" .. colors.background1 .. " guibg=" .. colors.dark_yellow,
	},
})

local map = utils.map
map("n", "<leader>Gh", "<cmd>GraffitiHost<cr>", "Host graffiti session")
map("n", "<leader>Gj", "<cmd>GraffitiJoin<cr>", "Join graffiti session")
map("n", "<leader>Gq", "<cmd>GraffitiStop<cr>", "Stop graffiti session")
map("n", "<leader>GQ", "<cmd>GraffitiKill<cr>", "Kill graffiti server")
