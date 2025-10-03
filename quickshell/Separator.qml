import QtQuick

Rectangle {
  property real thickness: 1
  property color lineColor: Theme.secondary
  property real fadePower: 0.3

  width: thickness
  height: parent.height

  gradient: Gradient {
    GradientStop { position: 0.0; color: "#00000000" }
    GradientStop { position: 0.0 + fadePower; color: lineColor }
    GradientStop { position: 1.0 - fadePower; color: lineColor }
    GradientStop { position: 1.0; color: "#00000000" }
  }
}
