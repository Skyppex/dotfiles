pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property bool healthy
    property real averageDiskUsage
    property var disks

    Process {
        id: diskProc
        command: ["nu", "-c", "sys disks | uniq-by device | where type != vfat and total != 0B | each {|it| { mount: $it.mount, usage: ((1 - $it.free / $it.total) * 100) } } | to json"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const parsed = JSON.parse(this.text);
                    root.averageDiskUsage = parsed.reduce((sum, d) => sum + d.usage, 0) / parsed.length;
                    root.disks = parsed;
                } catch (e) {
                    console.warn("Failed to parse disk JSON:", e);
                }
            }
        }

        onExited: function (exitCode, exitStatus) {
            root.healthy = exitCode == 0;
        }
    }

    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: diskProc.running = true
    }
}
