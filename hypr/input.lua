local sensitivity = 0

if os.getenv("HOSTNAME") == "pod" then
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
