pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import "utils"

Singleton {
    id: root
    property bool healthy
    property real volume

    Nu {
        id: volumeProc

        code: "
        wpctl get-volume @DEFAULT_AUDIO_SINK@
        | awk '{print $2}'
        | into float
        | $in * 100"

        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text !== volume) {
                    root.volume = this.text;
                }
            }
        }

        onExited: function (exitCode, exitStatus) {
            root.healthy = exitCode == 0;
        }
    }

    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: volumeProc.running = true
    }
}
