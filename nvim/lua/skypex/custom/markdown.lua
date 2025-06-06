local rmd = require("render-markdown")

rmd.setup({
	code = {
		disable_background = true,
		highlight_border = false,
	},
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
