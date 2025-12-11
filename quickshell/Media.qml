pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import "utils"

Singleton {
    id: root
    property string albumArt: ""
    property string mediaText: ""

    property string _nextArt: ""
    property string _nextText: ""

    Process {
        id: artProc
        command: ["python3", Qt.resolvedUrl("scripts/get-album-art").toString().replace("file://", "")]
        running: true

        stdout: SplitParser {
            onRead: data => {
                root._nextArt = data;

                if (root._nextText !== "") {
                    root.albumArt = root._nextArt;
                    root.mediaText = root._nextText;
                    root._nextArt = "";
                    root._nextText = "";
                    fallbackTimer.stop();
                } else {
                    fallbackTimer.start();
                }
            }
        }
    }

    Nu {
        id: mediaProc
        code: "playerctl --follow metadata --format {{ artist }} - {{ title }}"
        running: true

        stdout: SplitParser {
            onRead: data => {
                if (data.length > 40) {
                    root._nextText = data.substring(0, 40) + "...";
                } else {
                    root._nextText = data;
                }

                if (root._nextArt !== "") {
                    root.albumArt = root._nextArt;
                    root.mediaText = root._nextText;
                    root._nextArt = "";
                    root._nextText = "";
                    fallbackTimer.stop();
                } else {
                    fallbackTimer.start();
                }
            }
        }
    }

    Timer {
        id: fallbackTimer
        interval: 1000
        running: false
        repeat: false
        onTriggered: function () {
            if (root._nextArt !== "") {
                root.albumArt = root._nextArt;
                root._nextArt = "";
            }

            if (root._nextText !== "") {
                root.mediaText = root._nextText;
                root._nextText = "";
            }
        }
    }
}
