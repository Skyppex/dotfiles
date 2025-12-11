import Quickshell
import QtQuick

Scope {
    id: root
    property var preferredScreen: PreferredBarMonitor.value
    property var activeScreen: {
        for (const monitor of Monitor.prioritized) {
            const screen = Quickshell.screens.find(s => s.name === monitor);
            if (screen && root.preferredScreen === screen.name) {
                return screen;
            }
        }

        // Fallback
        return Quickshell.screens[0];
    }

    PanelWindow {
        id: bar

        required property var modelData

        screen: activeScreen
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

    Connections {
        target: PreferredBarMonitor
        function onPreferredBarMonitorChanged(monitor) {
            root.preferredScreen = monitor;
            bar.screen = activeScreen;
        }
    }
}
