if not require("utils").executable_exists("hyprpm") then
	return
end

local handle = io.popen("hyprpm list | rg hyprgrass")

if handle == nil then
	return false
end

local _ = handle:read("*a")
local ok = handle:close()

if not ok then
	return
end

hl.config({
	plugin = {
		hyprgrass = {
			sensitivity = 4.0,
			long_press_delay = 400,
			resize_on_border_long_press = false,
			edge_margin = 300,
		},
	},
})

local dyn = require("dyn")

hl.plugin.hyprgrass.bind({
	pattern = { kind = "edge", origin = "up", direction = "down" },
	action = hl.dsp.exec_cmd("nu " .. dyn.focus_or_launch .. " obsidian obsidian"),
})

hl.plugin.hyprgrass.bind({
	pattern = { kind = "edge", origin = "up", direction = "left" },
	action = hl.dsp.exec_cmd("nu " .. dyn.focus_or_launch .. " " .. dyn.terminal_class .. " " .. dyn.terminal_exec),
})

hl.plugin.hyprgrass.bind({
	pattern = { kind = "edge", origin = "up", direction = "right" },
	action = hl.dsp.exec_cmd("nu " .. dyn.focus_or_launch .. " " .. dyn.browser_class .. " " .. dyn.browser_exec),
})

hl.plugin.hyprgrass.bind({
	pattern = { kind = "edge", origin = "right", direction = "up" },
	action = hl.dsp.group.prev(),
})

hl.plugin.hyprgrass.bind({
	pattern = { kind = "edge", origin = "right", direction = "down" },
	action = hl.dsp.group.next(),
})

hl.plugin.hyprgrass.bind({
	pattern = { kind = "longpress", fingers = 1 },
	action = hl.dsp.window.drag(),
	mouse = true,
})

hl.plugin.hyprgrass.bind({
	pattern = { kind = "longpress", fingers = 2 },
	action = hl.dsp.window.resize(),
	mouse = true,
})

hl.plugin.hyprgrass.bind({
	pattern = { kind = "tap", fingers = 3 },
	action = hl.dsp.window.move({ out_of_group = true }),
})

hl.plugin.hyprgrass.bind({
	pattern = { kind = "tap", fingers = 4 },
	action = hl.dsp.exec_cmd("nu ~/.config/hypr/scripts/group-workspace"),
})
