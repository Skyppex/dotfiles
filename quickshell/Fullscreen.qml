pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    signal fullscreenChanged

    Process {
        id: ncProc
        command: ["nc", "-U", Quickshell.env("XDG_RUNTIME_DIR") + "/hypr/" + Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE") + "/.socket2.sock"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                if (data.startsWith("fullscreen")) {
                    fullscreenChanged();
                }
            }
        }
    }
}
