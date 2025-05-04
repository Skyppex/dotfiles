local rmd = require("render-markdown")

rmd.setup({
	heading = {
		icons = {
			" # ",
			" ## ",
			" ### ",
			" #### ",
			" ##### ",
			" ###### ",
		},
		signs = {},
	},
})

require("skypex.utils").nmap("<leader>mp", rmd.toggle, "Preview Markdown")
