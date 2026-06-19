local menu =
	'rofi -display-combi open -case-smart -combi-display-format "{text}" -window-format "{t}" -show combi -modi combi -combi-modi "window,drun,recursivebrowser" '

require("dyn").terminal_exec = "wezterm start --always-new-process"
require("dyn").terminal_class = "org.wezfurlong.wezterm"

if require("utils").hostname() == "tower" then
	require("dyn").browser_exec = "brave --disable-sessions-crashed-bubble"
	require("dyn").browser_class = "brave-browser"
else
	require("dyn").browser_exec = "zen-browser"
	require("dyn").browser_class = "zen"
end
local music_player_exec = "spotify"
local music_player_class = "Spotify"
local games_exec = "steam"
local games_class = "steam"

require("dyn").focus_or_launch = "~/.config/hypr/scripts/focus_or_launch"
require("dyn").focus_game = "~/.config/hypr/scripts/focus_game"

local dyn = require("dyn")
-- system
hl.bind("SUPER + Delete", hl.dsp.exec_cmd("systemctl poweroff"))
hl.bind("SUPER + CTRL + Delete", hl.dsp.exec_cmd("systemctl hybrid-sleep"))
hl.bind("SUPER + CTRL + L", hl.dsp.exec_cmd("hyprlock"))

-- manage apps
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + SHIFT + Q", hl.dsp.exec_cmd("nu ~/.config/hypr/scripts/rofi-kill"))

hl.bind(
	"SUPER + T",
	hl.dsp.exec_cmd(
		"nu " .. dyn.focus_or_launch .. " " .. dyn.terminal_class .. " " .. dyn.terminal_exec,
		{ tile = true }
	)
)

hl.bind("SUPER + SHIFT + T", hl.dsp.exec_cmd(dyn.terminal_exec, { tile = true }))

hl.bind(
	"SUPER + B",
	hl.dsp.exec_cmd(
		"nu " .. dyn.focus_or_launch .. " " .. dyn.browser_class .. " " .. dyn.browser_exec,
		{ tile = true }
	)
)

hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd(dyn.browser_exec, { tile = true }))

hl.bind(
	"SUPER + G",
	hl.dsp.exec_cmd("nu " .. dyn.focus_or_launch .. " " .. games_class .. " " .. games_exec, { tile = true })
)

hl.bind("SUPER + SHIFT + G", hl.dsp.exec_cmd("nu " .. dyn.focus_game, { tile = true }))

hl.bind(
	"SUPER + M",
	hl.dsp.exec_cmd(
		"nu " .. dyn.focus_or_launch .. " " .. music_player_class .. " " .. music_player_exec,
		{ tile = true }
	)
)

hl.bind("SUPER + D", hl.dsp.exec_cmd("nu " .. dyn.focus_or_launch .. " discord discord", { tile = true }))

-- manage windows
hl.bind("SUPER + F", hl.dsp.window.fullscreen())
hl.bind("SUPER + SHIFT + F", hl.dsp.window.float())
hl.bind("SUPER_L", hl.dsp.exec_cmd(menu), { release = true, ignore_mods = true })
hl.bind("SUPER_R", hl.dsp.exec_cmd(menu), { release = true, ignore_mods = true })

hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))

hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

hl.bind("SUPER + left", hl.dsp.exec_cmd("nu ~/.config/hypr/scripts/group left"))
hl.bind("SUPER + down", hl.dsp.exec_cmd("nu ~/.config/hypr/scripts/group down"))
hl.bind("SUPER + up", hl.dsp.exec_cmd("nu ~/.config/hypr/scripts/group up"))
hl.bind("SUPER + right", hl.dsp.exec_cmd("nu ~/.config/hypr/scripts/group right"))

hl.bind("SUPER + code:34", hl.dsp.group.prev())
hl.bind("SUPER + code:48", hl.dsp.group.next())
hl.bind("SUPER + S", hl.dsp.exec_cmd("nu ~/.config/hypr/scripts/group-workspace"))
hl.bind("SUPER + U", hl.dsp.window.move({ out_of_group = true }))

-- clipboard
hl.bind(
	"MOD5 + Y",
	hl.dsp.exec_cmd(
		'cliphist list | rofi -case-smart -dmenu -p "clipboard" -display-columns 2 | cliphist decode | wl-copy'
	)
)

hl.bind("SHIFT + MOD5 + Y", hl.dsp.exec_cmd("nu ~/.config/hypr/scripts/rofi-gen"))

-- screenshot / screen recording
hl.bind("Print", hl.dsp.exec_cmd("nu ~/.config/hypr/scripts/take-screenshot"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("nu ~/.config/hypr/scripts/toggle-recording"))
hl.bind("SHIFT + MOD5 + Print", hl.dsp.exec_cmd("hyprpicker --autocopy --no-fancy --lowercase-hex --format hex"))

-- move/resize with mouse
hl.bind("MOD5 + mouse:272", hl.dsp.window.drag())
hl.bind("ALT + mouse:272", hl.dsp.window.drag())
hl.bind("MOD5 + mouse:273", hl.dsp.window.resize())
hl.bind("ALT + mouse:273", hl.dsp.window.resize())

-- media
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("nu ~/.config/hypr/scripts/player-play-pause"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("nu ~/.config/hypr/scripts/player-play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
