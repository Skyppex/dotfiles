import QtQuick
import Quickshell.Io

Process {
    property string code
    command: ["nu", "--commands", code]
}
