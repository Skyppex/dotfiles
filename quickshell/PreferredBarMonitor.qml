pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property string value

    signal preferredBarMonitorChanged(string monitor)

    Process {
        id: getBarMonitorProc
        command: ["nu", Qt.resolvedUrl("scripts/get-bar-monitor").toString().replace("file://", ""), Monitor.prioritized]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                value = this.text.trim();
                preferredBarMonitorChanged(this.text.trim());
            }
        }
    }

    Component.onCompleted: {
        getBarMonitorProc.running = true;
    }

    Connections {
        target: Fullscreen
        function onFullscreenChanged() {
            getBarMonitorProc.running = true;
        }
    }
}
