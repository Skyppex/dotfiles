return {
	"eandrju/cellular-automaton.nvim",
	event = "VeryLazy",
	config = function()
		require("skypex.custom.fun").cellular_automation()
	end,
}
