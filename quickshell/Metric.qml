import QtQuick 2.15
import QtQuick.Controls 2.15
import Quickshell

Item {
    id: root
    property alias label: label.text
    property int value: 0
    property int minimum: 0
    property int maximum: 100
    property bool editable: false
    property int labelLeftMargin: 0

    height: Math.max(label.implicitHeight, metric.implicitHeight)

    Text {
        id: label
        font.family: Theme.primary_style
        font.pixelSize: 14
        color: Theme.primary
        anchors.left: parent.left
        anchors.leftMargin: root.labelLeftMargin
        anchors.verticalCenter: parent.verticalCenter
    }

    Item {
        id: metricArea
        anchors.left: label.right
        anchors.right: root.right
        anchors.top: root.top
        anchors.bottom: root.bottom

        Text {
            id: metric
            text: root.value + "%"
            font.family: Theme.primary_style
            font.pixelSize: 14
            color: Theme.primary
            anchors.horizontalCenter: metricArea.horizontalCenter
            anchors.horizontalCenterOffset: 4
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 1
        }
    }
}
