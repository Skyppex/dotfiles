pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  signal preferredBarMonitorChanged(string monitor)

  Process {
    id: getBarMonitorProc
    command: [
      "nu",
      Qt.resolvedUrl("scripts/get-bar-monitor")
        .toString()
        .replace("file://", ""),
      Monitor.primary,
      Monitor.fallback,
    ]
    running: false

    stdout: StdioCollector {
      onStreamFinished: {
        preferredBarMonitorChanged(this.text.trim())
      }
    }
  }

  Connections {
    target: Fullscreen
    function onFullscreenChanged() {
      getBarMonitorProc.running = true
    }
  }
}
