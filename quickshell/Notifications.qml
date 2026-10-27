import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

Scope {
    id: root

    property bool centerOpen: false
    property real size: 1
    property var targetScreen: null
    property int selectedIndex: 0
    property int unreadCount: 0
    property var notificationObjects: ({})
    property var sourceToplevels: ({})
    property ListModel history: ListModel {}

    function updateUnreadCount(): void {
        let count = 0;
        for (let i = 0; i < history.count; ++i) {
            if (!history.get(i).read)
                ++count;
        }
        unreadCount = count;
        if (history.count === 0)
            selectedIndex = 0;
        else
            selectedIndex = Math.min(selectedIndex, history.count - 1);
    }

    function selectedNotification(): var {
        if (history.count === 0)
            return null;
        return notificationObjects[history.get(selectedIndex).id] || null;
    }

    function focusSource(notification, sourceToplevel): void {
        if (!notification)
            return;

        if (sourceToplevel && sourceToplevel.wayland) {
            sourceToplevel.wayland.activate();
            return;
        }

        const desktopEntry = notification.desktopEntry.toLowerCase();
        const appName = notification.appName.toLowerCase();

        for (const toplevel of Hyprland.toplevels) {
            const appId = (toplevel.appId || "").toLowerCase();
            if ((desktopEntry !== "" && (appId === desktopEntry || appId.includes(desktopEntry))) || (appName !== "" && appId.includes(appName))) {
                toplevel.activate();
                return;
            }
        }
    }

    function markRead(index): void {
        if (index < 0 || index >= history.count)
            return;

        const entry = history.get(index);
        const notification = notificationObjects[entry.id];
        if (!entry.read) {
            history.setProperty(index, "read", true);
            if (notification)
                notification.tracked = false;
            updateUnreadCount();
        }
        focusSource(notification, sourceToplevels[entry.id] || null);
    }

    function markAllRead(): void {
        const notificationsToDismiss = [];

        for (let i = 0; i < history.count; ++i) {
            const entry = history.get(i);
            const notification = notificationObjects[entry.id];
            if (!entry.read) {
                history.setProperty(i, "read", true);
                if (notification)
                    notificationsToDismiss.push(notification);
            }
        }

        updateUnreadCount();

        for (const notification of notificationsToDismiss)
            notification.tracked = false;
    }

    function moveSelection(delta): void {
        if (history.count === 0)
            return;
        selectedIndex = (selectedIndex + delta + history.count) % history.count;
    }

    function dismissTop(): void {
        const notification = server.trackedNotifications.values[0];
        if (notification)
            notification.tracked = false;
    }

    function select(): void {
        markRead(selectedIndex);
    }

    function invokeAction(): void {
        const notification = selectedNotification();
        if (!notification || notification.actions.length === 0)
            return;
        notification.actions[0].invoke();
        markRead(selectedIndex);
    }

    function setNotificationSubmap(active): void {
        Hyprland.dispatch(active ? 'hl.dsp.submap("notifications")' : 'hl.dsp.submap("reset")');
    }

    NotificationServer {
        id: server

        actionsSupported: true
        actionIconsSupported: true
        bodySupported: true
        imageSupported: true
        bodyImagesSupported: true
        bodyHyperlinksSupported: true
        bodyMarkupSupported: false
        persistenceSupported: false
        inlineReplySupported: false
        keepOnReload: true

        onNotification: notification => {
            notificationObjects[notification.id] = notification;
            sourceToplevels[notification.id] = Hyprland.activeToplevel;
            history.insert(0, {
                id: notification.id,
                appName: notification.appName,
                summary: notification.summary,
                body: notification.body,
                image: notification.image,
                read: notification.appName.toLowerCase() === "screenshot" ? true : false,
                actionCount: notification.actions.length,
                actionText: notification.actions.length > 0 ? notification.actions[0].text : ""
            });
            notification.tracked = true;
            selectedIndex = 0;
            updateUnreadCount();
        }
    }

    IpcHandler {
        target: "notifications"

        function toggle(): void {
            root.centerOpen = !root.centerOpen;
            root.setNotificationSubmap(root.centerOpen);
        }

        function show(): void {
            root.centerOpen = true;
            root.setNotificationSubmap(true);
        }

        function hide(): void {
            root.centerOpen = false;
            root.setNotificationSubmap(false);
        }

        function next(): void {
            root.moveSelection(1);
        }

        function previous(): void {
            root.moveSelection(-1);
        }

        function select(): void {
            root.select();
        }

        function action(): void {
            root.invokeAction();
        }

        function markAllRead(): void {
            root.markAllRead();
        }

        function dismissTop(): void {
            root.dismissTop();
        }
    }

    PanelWindow {
        id: center

        screen: root.targetScreen
        visible: root.centerOpen
        anchors {
            top: true
            left: true
        }
        margins {
            top: Math.round(32 * root.size)
            left: Math.max(0, (root.targetScreen.width - implicitWidth) / 2)
        }

        implicitWidth: 420
        implicitHeight: Math.min(620, centerColumn.implicitHeight + 24)
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore

        Rectangle {
            anchors.fill: parent
            radius: 0
            color: Theme.background0
            border.width: 0
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
                        text: "Notifications (" + root.unreadCount + " unread)"
                        color: Theme.cyan50
                        font.family: Theme.fonts.primary
                        font.pixelSize: 14 * root.size
                        font.bold: true
                    }

                    Text {
                        text: "mark all read"
                        color: Theme.red50
                        font.family: Theme.fonts.primary
                        font.pixelSize: 12 * root.size
                    }
                }

                ListView {
                    id: historyView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    implicitHeight: Math.min(contentHeight, 570 * root.size)
                    model: root.history
                    currentIndex: root.selectedIndex
                    spacing: 8
                    clip: true

                    delegate: Rectangle {
                        required property var modelData
                        required property int index

                        width: historyView.width
                        height: cardColumn.implicitHeight + 20
                        radius: Theme.border_outer_radius
                        color: index === root.selectedIndex ? Theme.background2 : Theme.background0
                        border.width: Theme.border_size
                        border.color: modelData.read ? Theme.secondary : Theme.cyan50

                        ColumnLayout {
                            id: cardColumn
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 4

                            RowLayout {
                                Layout.fillWidth: true

                                Text {
                                    Layout.fillWidth: true
                                    text: modelData.appName + ": " + modelData.summary
                                    color: Theme.cyan50
                                    font.family: Theme.fonts.primary
                                    font.pixelSize: 14 * root.size
                                    font.bold: true
                                    elide: Text.ElideRight
                                }

                                Text {
                                    text: modelData.read ? "read" : "new"
                                    color: modelData.read ? Theme.quaternary : Theme.green50
                                    font.family: Theme.fonts.primary
                                    font.pixelSize: 11 * root.size
                                }
                            }

                            Image {
                                Layout.fillWidth: true
                                Layout.preferredHeight: visible && implicitWidth > 0 ? Math.min(360 * root.size, width * implicitHeight / implicitWidth) : 0
                                source: modelData.image
                                visible: source !== ""
                                fillMode: Image.PreserveAspectFit
                                horizontalAlignment: Image.AlignHCenter
                                verticalAlignment: Image.AlignVCenter
                                smooth: true
                                mipmap: true
                                asynchronous: true
                            }

                            Text {
                                Layout.fillWidth: true
                                text: modelData.body
                                color: Theme.primary
                                font.family: Theme.fonts.primary
                                font.pixelSize: 13 * root.size
                                textFormat: Text.PlainText
                                wrapMode: Text.WordWrap
                            }

                            Text {
                                Layout.fillWidth: true
                                visible: modelData.actionCount > 0
                                text: "action: " + (modelData.actionCount > 0 ? modelData.actionText : "")
                                color: Theme.yellow50
                                font.family: Theme.fonts.primary
                                font.pixelSize: 11 * root.size
                                elide: Text.ElideRight
                            }
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: root.history.count === 0
                        text: "No notifications"
                        color: Theme.quaternary
                        font.family: Theme.fonts.primary
                        font.pixelSize: 13 * root.size
                    }
                }
            }

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: Theme.border_size
                color: Theme.secondary
            }

            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: Theme.border_size
                color: Theme.secondary
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: Theme.border_size
                color: Theme.secondary
            }
        }
    }

    PanelWindow {
        id: popup

        screen: root.targetScreen
        visible: server.trackedNotifications.values.length > 0 && !root.centerOpen
        anchors {
            top: true
            right: true
        }
        margins {
            top: 12
            right: 12
        }
        implicitWidth: 380
        implicitHeight: Math.min(620, popupColumn.implicitHeight)
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore

        ColumnLayout {
            id: popupColumn
            width: parent.width
            spacing: 10

            Repeater {
                model: server.trackedNotifications

                Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    Layout.preferredHeight: popupBody.implicitHeight + 20
                    Layout.maximumHeight: 320 * root.size
                    radius: Theme.border_outer_radius
                    color: Theme.background0
                    border.width: Theme.border_size
                    border.color: modelData.urgency === NotificationUrgency.Critical ? Theme.important : Theme.secondary

                    Timer {
                        running: modelData.urgency !== NotificationUrgency.Critical
                        interval: 5000
                        onTriggered: modelData.tracked = false
                    }

                    ColumnLayout {
                        id: popupBody
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 3

                        Text {
                            Layout.fillWidth: true
                            text: modelData.appName + ": " + modelData.summary
                            color: Theme.cyan50
                            font.family: Theme.fonts.primary
                            font.pixelSize: 14 * root.size
                            font.bold: true
                            elide: Text.ElideRight
                        }

                        Image {
                            Layout.fillWidth: true
                            Layout.preferredHeight: visible && implicitWidth > 0 ? Math.min(360 * root.size, width * implicitHeight / implicitWidth) : 0
                            source: modelData.image
                            visible: source !== ""
                            fillMode: Image.PreserveAspectFit
                            horizontalAlignment: Image.AlignHCenter
                            verticalAlignment: Image.AlignVCenter
                            smooth: true
                            mipmap: true
                            asynchronous: true
                        }

                        Text {
                            Layout.fillWidth: true
                            text: modelData.body
                            color: Theme.primary
                            font.family: Theme.fonts.primary
                            font.pixelSize: 13 * root.size
                            textFormat: Text.PlainText
                            wrapMode: Text.WordWrap
                        }
                    }
                }
            }
        }
    }
}
