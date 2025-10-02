import QtQuick 2.15
import QtQuick.Controls 2.15

Row {
    id: root
    spacing: 6
    property alias label: label.text
    property int value: 0
    property int minimum: 0
    property int maximum: 100
    property bool editable: false

    Text {
        id: label
        font.family: "Symbols Nerd Font"
        font.pixelSize: 14
        color: Theme.primary
    }

    Slider {
        id: slider
        from: root.minimum
        to: root.maximum
        value: root.value
        enabled: root.editable   // disable editing by default
        width: 54
        height: 14
    }
}
