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

    property real size: activeScreen.physicalPixelDensity / 4.250980392156863

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

        implicitHeight: {
            Math.round(32 * size);
        }

        Album {
            anchors.left: parent.left
            size: root.size
        }

        Clock {
            anchors.centerIn: parent
            size: root.size
        }

        Metrics {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 12 * root.size
            anchors.rightMargin: 10 * root.size
            size: root.size
        }
    }
}
