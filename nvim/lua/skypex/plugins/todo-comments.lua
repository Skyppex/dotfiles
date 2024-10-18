return {
	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VeryLazy",
		config = function()
			require("skypex.custom.todo-comments")
		end,
	},
}
