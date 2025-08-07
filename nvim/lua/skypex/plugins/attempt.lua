local attempt_dir = require("skypex.utils").get_code_path() .. "/attempt.nvim"

local Path = require("plenary.path")
local path = Path:new(attempt_dir)

if path:is_dir() then
	return {
		"attempt.nvim",
		dir = attempt_dir,
		event = "VeryLazy",
		dependencies = "nvim-telescope/telescope.nvim",
		config = function()
			require("skypex.custom.attempt")
		end,
	}
end

return {
	"m-demare/attempt.nvim",
	event = "VeryLazy",
	dependencies = "nvim-telescope/telescope.nvim",
	config = function()
		require("skypex.custom.attempt")
	end,
}
