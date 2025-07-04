local rmd = require("render-markdown")

rmd.setup({
	sign = {
		enabled = false,
	},
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
		backgrounds = {
			"RenderMarkdownH1",
			"RenderMarkdownH2Bg",
			"RenderMarkdownH3Bg",
			"RenderMarkdownH4Bg",
			"RenderMarkdownH2Bg",
			"RenderMarkdownH3Bg",
		},
		signs = {},
	},
	checkbox = {
		bullet = true,
	},
})

require("skypex.utils").nmap("<leader>mp", rmd.toggle, "Preview Markdown")
