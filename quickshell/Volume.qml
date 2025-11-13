pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property bool healthy
    property real volume

    Process {
        id: volumeProc
        command: ["nu", "-c", "(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}' | into float) * 100"]
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
