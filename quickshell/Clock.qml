import QtQuick

Text {
    property real size: 1

    text: Time.time
    color: Theme.primary
    font.pixelSize: 14 * size
    font.family: Theme.primary_style
    anchors.verticalCenter: parent.verticalCenter
    anchors.verticalCenterOffset: 1 * size
}
