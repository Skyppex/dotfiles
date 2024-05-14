local wezterm = require("wezterm")

local config = {
    audible_bell = "Disabled",
    check_for_updates = false,
    color_scheme = "Catppuccin Frappe",
    inactive_pane_hsb = {
        hue = 1.0,
        saturation = 1.0,
        brightness = 1.0,
    },
    font_size = 10.0,
    launch_menu = {},
    leader = { key="a", mods="CTRL" },
    disable_default_key_bindings = true,
    keys = {
        -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
        { key = "a", mods = "LEADER|CTRL",  action=wezterm.action{SendString="\x01"}},
        { key = ",", mods = "CTRL",       action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
        { key = ".",mods = "CTRL",       action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
        { key = "z", mods = "LEADER",       action="TogglePaneZoomState" },
        { key = "n", mods = "CTRL",       action=wezterm.action{SpawnTab="CurrentPaneDomain"}},
        { key = "n", mods = "SHIFT|CTRL",       action=wezterm.action.ShowLauncher},
        { key = "h", mods = "CTRL",       action=wezterm.action{ActivatePaneDirection="Left"}},
        { key = "j", mods = "CTRL",       action=wezterm.action{ActivatePaneDirection="Up"}},
        { key = "k", mods = "CTRL",       action=wezterm.action{ActivatePaneDirection="Down"}},
        { key = "l", mods = "CTRL",       action=wezterm.action{ActivatePaneDirection="Right"}},
        { key = "H", mods = "CTRL|SHIFT", action=wezterm.action{AdjustPaneSize={"Left", 5}}},
        { key = "J", mods = "CTRL|SHIFT", action=wezterm.action{AdjustPaneSize={"Up", 5}}},
        { key = "K", mods = "CTRL|SHIFT", action=wezterm.action{AdjustPaneSize={"Down", 5}}},
        { key = "L", mods = "CTRL|SHIFT", action=wezterm.action{AdjustPaneSize={"Right", 5}}},
        { key = "1", mods = "CTRL",       action=wezterm.action{ActivateTab=0}},
        { key = "2", mods = "CTRL",       action=wezterm.action{ActivateTab=1}},
        { key = "3", mods = "CTRL",       action=wezterm.action{ActivateTab=2}},
        { key = "4", mods = "CTRL",       action=wezterm.action{ActivateTab=3}},
        { key = "5", mods = "CTRL",       action=wezterm.action{ActivateTab=4}},
        { key = "6", mods = "CTRL",       action=wezterm.action{ActivateTab=5}},
        { key = "7", mods = "CTRL",       action=wezterm.action{ActivateTab=6}},
        { key = "8", mods = "CTRL",       action=wezterm.action{ActivateTab=7}},
        { key = "9", mods = "CTRL",       action=wezterm.action{ActivateTab=8}},
        { key = "X", mods = "SHIFT|CTRL", action=wezterm.action{CloseCurrentTab={confirm=true}}},
        { key = "x", mods = "CTRL",       action=wezterm.action{CloseCurrentPane={confirm=true}}},

        { key = "F", mods="SHIFT|CTRL",     action="ToggleFullScreen" },
        { key ="v",  mods="LEADER|CTRL",    action=wezterm.action.PasteFrom 'Clipboard'},
        { key ="c",  mods="LEADER|CTRL",    action=wezterm.action.CopyTo 'Clipboard'},
        { key = "+", mods="CTRL",     action="IncreaseFontSize" },
        { key = "-", mods="CTRL",     action="DecreaseFontSize" },
        { key = "0", mods="CTRL",     action="ResetFontSize" },
    },
    set_environment_variables = {},
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    -- config.front_end = "Software" -- OpenGL doesn't work quite well with RDP.

    config.default_prog = { 'nu' }
    table.insert(config.launch_menu, { label = "nu", args = {"nu"} })
    table.insert(config.launch_menu, { label = "powershell", args = {"powershell.exe", "-NoLogo"} })

    -- Find installed visual studio version(s) and add their compilation
    -- environment command prompts to the menu
    for _, vsvers in ipairs(wezterm.glob("Microsoft Visual Studio/20*", "C:/Program Files (x86)")) do
        local year = vsvers:gsub("Microsoft Visual Studio/", "")
        table.insert(config.launch_menu, {
            label = "x64 Native Tools VS " .. year,
            args = {"cmd.exe", "/k", "C:/Program Files (x86)/" .. vsvers .. "/BuildTools/VC/Auxiliary/Build/vcvars64.bat"},
        })
    end
else
    config.default_prog = { 'nu' }
    table.insert(config.launch_menu, { label = "nu", args = {"nu"} })
end

return config