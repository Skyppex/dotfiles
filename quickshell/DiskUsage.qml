pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property real disk

    Process {
        id: diskProc
        command: ["nu", "-c", "sys disks | uniq-by device | where mount != /boot | each {|it| ($it.free / $it.total) * 100 } | get 0"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.disk = this.text
        }
    }

    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: diskProc.running = true
    }
}
