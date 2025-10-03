import Quickshell
import QtQuick

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData
      color: "#00000000"

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: 32

      Album {
        anchors.left: parent.left
      }

      Clock {
        anchors.centerIn: parent
      }

      Metrics {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 12
        anchors.rightMargin: 10
      }
    }
  }
}
