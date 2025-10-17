local punch_card_dir = require("skypex.utils").get_code_path() .. "/punch-card.nvim"

local Path = require("plenary.path")
local path = Path:new(punch_card_dir)

if path:is_dir() then
	return {
		"punch-card.nvim",
		dir = punch_card_dir,
		config = function()
			require("skypex.custom.punch-card")
		end,
	}
end

return {
	"skyppex/punch-card.nvim",
	config = function()
		require("skypex.custom.punch-card")
	end,
}
