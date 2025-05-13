local rmd = require("render-markdown")

rmd.setup({
	heading = {
		icons = {
			"# ",
			"## ",
			"### ",
			"#### ",
			"##### ",
			"###### ",
		},
		signs = {},
	},
	checkbox = {
		bullet = true,
	},
})

require("skypex.utils").nmap("<leader>mp", rmd.toggle, "Preview Markdown")
