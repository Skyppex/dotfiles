pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

import "utils"

Singleton {
    id: root
    property bool healthy
    property real mem

    Nu {
        id: memProc

        code: "
        sys mem
        | each { |it|
            ($it.used / $it.total) * 100
        }"

        running: true

        stdout: StdioCollector {
            onStreamFinished: root.mem = this.text
        }

        onExited: function (exitCode, exitStatus) {
            root.healthy = exitCode == 0;
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: memProc.running = true
    }
}
