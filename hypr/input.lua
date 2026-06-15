local sensitivity = 0

if require("utils").hostname() == "pod" then
	sensitivity = 0.8
end

hl.config({
	input = {

		kb_layout = "no",
		sensitivity = sensitivity,
		accel_profile = "flat",
		touchpad = {
			natural_scroll = true,
		},
	},
})
