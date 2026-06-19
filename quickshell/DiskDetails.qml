import QtQuick
import Quickshell

PopupWindow {
    property real size: 1

    visible: true
    color: "#00000000"
    anchor.adjustment: PopupAdjustment.Slide
    implicitWidth: column.implicitWidth + 16
    implicitHeight: column.implicitHeight + 16

    Rectangle {
        anchors.fill: parent
        radius: Theme.border_outer_radius
        color: Theme.background0
        border.width: Theme.border_size
        border.color: Theme.secondary

        Column {
            id: column
            x: 8
            y: 8
            spacing: 4 * size

            Repeater {
                model: DiskUsage.disks

                delegate: Column {
                    spacing: 8 * size

                    Separator {
                        thickness: 1 * size
                        lineColor: Theme.quaternary
                        fadePower: 0.4
                        enabled: index > 0
                        visible: index > 0
                        vertical: true
                    }

                    Row {
                        spacing: 12 * size

                        Text {
                            text: modelData.mount
                            width: 80 * size
                            elide: Text.ElideRight
                            font.family: Theme.fonts.primary
                            font.pixelSize: 14 * size
                            color: Theme.primary
                        }

                        Text {
                            text: `${Math.round(modelData.usage)}%`
                            font.family: Theme.fonts.primary
                            font.pixelSize: 14 * size
                            color: Theme.primary
                        }
                    }
                }
            }
        }
    }
}
