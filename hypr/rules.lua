local dyn = require("dyn")
hl.window_rule({
	match = {
		class = ".*",
	},
	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix-xwayland-drag",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

hl.window_rule({
	name = "force-steam-apps-to-primary-monitor",
	match = {
		initial_class = "(^steam_app_.*)",
	},
	tile = true,
	monitor = dyn.primary_monitor,
})

hl.window_rule({
	name = "force-minecraft-to-primary-monitor",
	match = {
		initial_class = "(^Minecraft.*)",
	},
	tile = true,
	monitor = dyn.primary_monitor,
})

hl.window_rule({
	name = "force-factorio-to-primary-monitor",
	match = {
		initial_class = "(^factorio.*)",
	},
	tile = true,
	monitor = dyn.primary_monitor,
})

hl.config({
	debug = {
		disable_logs = false,
		enable_stdout_logs = true,
	},
})
