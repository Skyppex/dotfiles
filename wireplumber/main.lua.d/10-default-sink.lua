default_audio_sink = "alsa_card.usb-Yamaha_Corporation_AG06_AG03-00"
default_audio_source = "alsa_card.usb-Yamaha_Corporation_AG06_AG03-00"

table.insert(alsa_monitor.rules, {
	matches = {
		{
			{ "device.name", "equals", default_audio_sink },
		},
	},
	apply_properties = {
		["device.profile"] = "output:analog-stereo",
		["device.priority"] = 1000,
	},
})

table.insert(alsa_monitor.rules, {
	matches = {
		{
			{ "device.name", "equals", default_audio_source },
		},
	},
	apply_properties = {
		["device.profile"] = "input:analog-stereo",
		["device.priority"] = 1000,
	},
})

alsa_monitor.default_sink = default_audio_sink
alsa_monitor.default_source = default_audio_source
