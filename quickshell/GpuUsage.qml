pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import "utils"

Singleton {
    id: root
    property bool healthy
    property real gpu

    Nu {
        id: gpuProc

        code: "
        fd 'card\\d$' '/sys/class/drm'
        | lines
        | each { |it|
            open --raw ($it | path join 'device/gpu_busy_percent')
        }
        | into float
        | math avg
        | math round"

        running: true

        stdout: StdioCollector {
            onStreamFinished: root.gpu = this.text
        }

        onExited: function (exitCode, exitStatus) {
            root.healthy = exitCode == 0;
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: gpuProc.running = true
    }
}
