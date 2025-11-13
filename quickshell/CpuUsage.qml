pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property bool healthy
    property real cpu

    Process {
        id: cpuProc
        command: ["nu", "-c", "sys cpu -l | get cpu_usage | math avg"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.cpu = this.text
        }

        onExited: function (exitCode, exitStatus) {
            root.healthy = exitCode == 0;
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: cpuProc.running = true
    }
}
