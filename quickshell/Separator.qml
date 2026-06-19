import QtQuick

Rectangle {
    property real thickness: 1
    property color lineColor: Theme.secondary
    property real fadePower: 0.3
    property bool vertical: false

    width: vertical ? parent.width : thickness
    height: vertical ? thickness : parent.height

    gradient: Gradient {
        // this is inverse of what i consider to be vertical.
        // not sure whats going on honestly
        orientation: vertical ? Gradient.Horizontal : Gradient.Vertical

        GradientStop {
            position: 0.0
            color: "#00000000"
        }

        GradientStop {
            position: 0.0 + fadePower
            color: lineColor
        }

        GradientStop {
            position: 1.0 - fadePower
            color: lineColor
        }

        GradientStop {
            position: 1.0
            color: "#00000000"
        }
    }
}
