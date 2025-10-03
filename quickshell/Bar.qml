import Quickshell
import QtQuick

Scope {
    id: root
    property var preferredScreen: Monitor.primary
    property var activeScreen: {
        const primary = Quickshell.screens.find(s => s.name === Monitor.primary);
        const fallback = Quickshell.screens.find(s => s.name === Monitor.fallback);

        // If primary is connected and not fullscreen, use it
        if (primary) {
            if (root.preferredScreen === primary.name) {
                return primary;
            }
        }

        // Otherwise fall back to secondary if connected
        if (fallback) {
            return fallback;
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
        target: Quickshell
        function onScreensChanged() {
            bar.screen = activeScreen;
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
