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

      Clock {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 14
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
