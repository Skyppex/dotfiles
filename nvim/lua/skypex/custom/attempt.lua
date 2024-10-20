local attempt = require("attempt")

attempt.setup({
	ext_options = { "lua", "py", "cs", "js", "rs", "ar", "http", "" },
	run = {
		cs = { "w", "!dotnet script %" },
		py = { "w !python" }, -- Either table of strings or lua functions
		js = { "w !node" },
		lua = { "w", "luafile %" },
		rs = { "w", "!rustc % && nu -c 'let ex = (echo %' | str replace '.rs' ''); exec $ex" },
		ar = { "w", "!mage %" },
	},
})

require("telescope").load_extension("attempt")

local nmap = require("skypex.utils").nmap

nmap("<leader>AN", attempt.new_select, "New Attempt")
nmap("<leader>AI", attempt.new_input_ext, "New Attempt By Extension")
nmap("<leader>AR", attempt.run, "Run Attempt")
nmap("<leader>AD", attempt.delete_buf, "Delete Attempt")
nmap("<leader>AC", attempt.rename_buf, "Rename Attempt")
nmap("<leader>AS", "<cmd>Telescope attempt<CR>", "Search Attempts")
