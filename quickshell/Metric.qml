import QtQuick 2.15
import QtQuick.Controls 2.15

Row {
    property alias label: label.text
    property int value: 0
    property int minimum: 0
    property int maximum: 100
    property bool editable: false

    id: root
    spacing: 4

    Text {
        id: label
        font.family: "Symbols Nerd Font"
        font.pixelSize: 14
        color: Theme.primary
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        id: metric
        text: root.value + "%"
        font.family: Theme.primary_style
        font.pixelSize: 14
        color: Theme.primary
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 1
    }
}
