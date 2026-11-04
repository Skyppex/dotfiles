hl.on("hyprland.start", function()
	if require("utils").executable_exists("hyprpm") then
		-- Register plugin bindings after hyprpm has finished loading the plugins.
		hl.exec_cmd("hyprpm reload -n && hyprctl reload config-only")
	end
	hl.exec_cmd("quickshell --daemonize --no-duplicate")
	hl.exec_cmd("wl-paste --watch cliphist store")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("nu ~/.config/hypr/scripts/set-wallpaper")
	hl.exec_cmd("nu ~/.config/hypr/scripts/track-last-used-player")
end)
