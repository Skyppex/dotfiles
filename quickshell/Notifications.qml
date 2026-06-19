import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

Scope {
    id: root
    property bool centerOpen: false
    property real size: 1

    property ListModel history: ListModel {}

    NotificationServer {
        id: server

        actionsSupported: true
        bodySupported: true
        imageSupported: true

        onNotification: n => {
            console.log("got:", n.summary, n.body);
            console.log(history);

            history.append({
                summary: n.summary,
                body: n.body,
                appName: n.appName,
                urgency: n.urgency,
                time: Qt.formatDateTime(new Date(), "HH:mm")
            });
            n.tracked = true;
        }
    }

    IpcHandler {
        target: "notifications"

        function toggle(): void {
            console.log(history);
            console.log(history.count);
            root.centerOpen = !root.centerOpen;
        }

        function show(): void {
            root.centerOpen = true;
        }

        function hide(): void {
            root.centerOpen = false;
        }
    }

    PanelWindow {
        id: center
        visible: root.centerOpen

        anchors {
            top: true
            right: true
        }

        margins {
            top: 12
            right: 12
        }

        implicitWidth: 380
        implicitHeight: centerColumn.implicitHeight + 24
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore

        Rectangle {
            anchors.fill: parent
            radius: Theme.border_outer_radius
            color: Theme.background1
            border.width: Theme.border_size
            border.color: Theme.secondary

            ColumnLayout {
                id: centerColumn
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true
                        text: "Notifications"
                        color: Theme.cyan
                        font.family: Theme.fonts.primary
                        font.pixelSize: 14 * root.size
                        font.bold: true
                        elide: Text.ElideRight
                    }

                    Text {
                        text: "Clear all"
                        visible: history.count > 0
                        color: Theme.red
                        font.family: Theme.fonts.primary
                        font.pixelSize: 13 * root.size

                        MouseArea {
                            anchors.fill: parent
                            onClicked: history.clear()
                        }
                    }
                }

                Repeater {
                    model: history

                    Rectangle {
                        id: historyCard
                        required property var modelData

                        Layout.fillWidth: true
                        Layout.preferredHeight: 60
                        // Layout.preferredHeight: layout.implicitHeight + 20
                        radius: Theme.border_outer_radius
                        color: Theme.background0
                        border.width: Theme.border_size
                        border.color: modelData.urgency === NotificationUrgency.Critical ? Theme.important : Theme.secondary

                        RowLayout {
                            id: layout
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 10

                            Image {
                                Layout.preferredHeight: 36
                                Layout.preferredWidth: 36
                                Layout.alignment: Qt.AlignTop
                                fillMode: Image.PreserveAspectFit
                                visible: source.toString() !== ""
                                source: historyCard.modelData.image || historyCard.modelData.appIcon || ""
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                Text {
                                    Layout.fillWidth: true
                                    text: historyCard.modelData.summary
                                    color: Theme.cyan
                                    font.family: Theme.fonts.primary
                                    font.pixelSize: 14 * root.size
                                    font.bold: true
                                    elide: Text.ElideRight
                                }

                                Text {
                                    Layout.fillWidth: true
                                    visible: text !== ""
                                    text: historyCard.modelData.body
                                    color: Theme.primary
                                    font.family: Theme.fonts.primary
                                    font.pixelSize: 13 * size
                                    wrapMode: Text.WordWrap
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: historyCard.modelData.dismiss()
                        }
                    }
                }
            }
        }
    }

    PanelWindow {
        id: panel

        anchors {
            top: true
            right: true
        }

        margins {
            top: 12
            right: 12
        }

        implicitWidth: 380
        implicitHeight: Math.max(1, column.implicitHeight)
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore

        ColumnLayout {
            id: column
            width: parent.width
            spacing: 10

            Repeater {
                model: server.trackedNotifications

                Rectangle {
                    id: card
                    required property var modelData

                    Layout.fillWidth: true
                    Layout.preferredHeight: 60
                    // Layout.preferredHeight: layout.implicitHeight + 20
                    radius: Theme.border_outer_radius
                    color: Theme.background0
                    border.width: Theme.border_size
                    border.color: modelData.urgency === NotificationUrgency.Critical ? Theme.important : Theme.secondary

                    Timer {
                        running: card.modelData.urgency !== NotificationUrgency.Critical
                        interval: 5000
                        onTriggered: card.modelData.dismiss()
                    }

                    RowLayout {
                        id: layout
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10

                        Image {
                            Layout.preferredHeight: 36
                            Layout.preferredWidth: 36
                            Layout.alignment: Qt.AlignTop
                            fillMode: Image.PreserveAspectFit
                            visible: source.toString() !== ""
                            source: card.modelData.image || card.modelData.appIcon || ""
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                Layout.fillWidth: true
                                text: card.modelData.summary
                                color: Theme.cyan
                                font.family: Theme.fonts.primary
                                font.pixelSize: 14 * root.size
                                font.bold: true
                                elide: Text.ElideRight
                            }

                            Text {
                                Layout.fillWidth: true
                                visible: text !== ""
                                text: card.modelData.body
                                color: Theme.primary
                                font.family: Theme.fonts.primary
                                font.pixelSize: 13 * size
                                wrapMode: Text.WordWrap
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: card.modelData.dismiss()
                    }
                }
            }
        }
    }
}
