import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

Item {
    id: root
    width: Math.min(parent.width / 3, 640)

    anchors.top: parent.top
    anchors.bottom: parent.bottom
    property real size: 1

    Image {
        id: art
        width: Math.min(parent.width, 640)
        height: width * (sourceSize.height / sourceSize.width)
        source: Media.albumArt
        cache: false
        sourceSize: Qt.size(640, 640)
        anchors.centerIn: parent
        anchors.verticalCenterOffset: height * 0.190625 * size
    }

    Text {
        id: media
        text: Media.mediaText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 1 * size
        font.pixelSize: 14 * size
        font.family: Theme.primary_style
        color: Theme.primary
    }
}
