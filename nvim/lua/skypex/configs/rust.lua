require("crates").setup({
	lsp = {
		enabled = true,
	},
	completion = {
		blink = {
			use_custom_kind = true,
			kind_text = {
				version = "Version",
				feature = "Feature",
			},
			kind_highlight = {
				version = "BlinkCmpKindVersion",
				feature = "BlinkCmpKindFeature",
			},
			kind_icon = {
				version = " ",
				feature = " ",
			},
		},
	},
})
