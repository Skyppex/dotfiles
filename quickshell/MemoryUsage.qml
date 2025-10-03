pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root
  property real mem

  Process {
    id: memProc
    command: ["nu", "-c", "sys mem | each {|it| ($it.used / $it.total) * 100 }"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: root.mem = this.text
    }
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    onTriggered: memProc.running = true
  }
}
