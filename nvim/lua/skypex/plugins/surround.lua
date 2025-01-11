return {
	"kylechui/nvim-surround",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("skypex.custom.surround")
	end,
}
