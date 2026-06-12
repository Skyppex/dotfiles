local monitor_configs = {
	pod = function()
		hl.monitor({
			output = "eDP-1",
			mode = "preferred",
			position = "auto",
			scale = 1,
		})

		hl.workspace_rule({ workspace = "1", monitor = "eDP-1" })
		require("dyn").primary_monitor = "eDP-1"
	end,
	tower = function()
		local first = "desc:ASUSTek COMPUTER INC VG27A LALMQS229442"
		local second = "desc:Dell Inc. DELL 2408WFP CX26885928HS"

		hl.monitor({
			output = first,
			mode = "2560x1440@165",
			position = "1200x200",
			scale = 1,
		})

		hl.monitor({
			output = second,
			mode = "1920x1200@60",
			position = "0x0",
			scale = 1,
			transform = 1,
		})

		hl.workspace_rule({ workspace = "1", monitor = first })
		hl.workspace_rule({ workspace = "2", monitor = second })

		require("dyn").primary_monitor = first
	end,
}

local utils = require("utils")
local hostname = utils.hostname()

if hostname == nil then
	return
end

monitor_configs[hostname]()
