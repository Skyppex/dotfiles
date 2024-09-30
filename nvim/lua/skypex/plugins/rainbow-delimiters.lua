return {
	"HiPhish/rainbow-delimiters.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("skypex.custom.rainbow-delimiters")
	end,
}
