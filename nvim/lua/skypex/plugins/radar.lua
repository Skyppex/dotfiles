local radar_dir = require("skypex.utils").get_code_path() .. "/radar/radar.nvim"

local Path = require("plenary.path")
local path = Path:new(radar_dir)

if not path:is_dir() then
	return {
		"skyppex/radar.nvim",
		name = "radar",
		config = true,
	}
end

return {
	"radar",
	dir = radar_dir,
	config = true,
}
