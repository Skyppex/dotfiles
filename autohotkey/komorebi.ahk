#Requires AutoHotkey v2.0.2
#SingleInstance Force
DetectHiddenWindows(true)

Komorebic(cmd) {
    RunWait(format("komorebic.exe {}", cmd), , "Hide")
}

; # = Win key or super key
; ^ = Ctrl key
; + = Shift key
; ! = Alt key
; & = Used to combine two hotkeys
; :: = Separates the hotkey from the action
; {} = Used to group actions together
#r::Reload

#^y::RunWait("yasb.exe")
#^s::Komorebic("start --ahk")
#^q::Komorebic("stop")
#q::Komorebic("close")
#i::Komorebic("minimize")
#+f::Komorebic("manage")

; Focus windows
#h::Komorebic("focus left")
#j::Komorebic("focus down")
#k::Komorebic("focus up")
#l::Komorebic("focus right")

#b::{
    if !WinExist("ahk_exe opera.exe") {
        Run("opera.exe")
    } else {
        WinActivate("ahk_exe opera.exe")
    }
}

#+b::Run("opera.exe")

#t::{
    if !WinExist("ahk_exe wezterm-gui.exe") {
        Run("wezterm-gui.exe")
    } else {
        WinActivate("ahk_exe wezterm-gui.exe")
    }
}

#+t::Run("wezterm-gui.exe")

#c::{
    if !WinExist("ahk_exe slack-app.exe") {
        Run("slack-app.exe")
    } else {
        WinActivate("ahk_exe slack-app.exe")
    }
}

#m::{
    if !WinExist("ahk_exe spotify.exe") {
        Run("spotify.exe")
    } else {
        WinActivate("ahk_exe spotify.exe")
    }
}

; Opens existing client if one exists by default
#e::Run("thunderbird.exe")

; Move windows
#+h::Komorebic("move left")
#+j::Komorebic("move down")
#+k::Komorebic("move up")
#+l::Komorebic("move right")

; Stack windows
#Left::Komorebic("stack left")
#Down::Komorebic("stack down")
#Up::Komorebic("stack up")
#Right::Komorebic("stack right")
#s::Komorebic("stack-all")
#u::Komorebic("unstack")
#+u::Komorebic("unstack-all")
#å::Komorebic("cycle-stack previous")
#æ::Komorebic("cycle-stack next")

; Resize
#+::Komorebic("resize-axis horizontal increase")
#-::Komorebic("resize-axis horizontal decrease")
#?::Komorebic("resize-axis vertical increase")
#_::Komorebic("resize-axis vertical decrease")

; Manipulate windows
#f::Komorebic("toggle-float")
#o::Komorebic("toggle-monocle")

; Window manager options
#+r::Komorebic("retile")
#p::Komorebic("toggle-pause")

; Layouts
#x::Komorebic("flip-layout horizontal")
#y::Komorebic("flip-layout vertical")
#^æ::Komorebic("change-layout ultrawide-vertical-stack")
#^h::Komorebic("change-layout vertical-stack")
#^j::Komorebic("change-layout rows")
#^k::Komorebic("change-layout bsp")
#^l::Komorebic("change-layout columns")
#^ø::Komorebic("change-layout grid")
