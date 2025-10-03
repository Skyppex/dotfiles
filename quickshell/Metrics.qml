import QtQuick

Row {
    property int volume: 28
    property int ramPercent: 67
    property int cpuPercent: 12
    property int diskPercent: 81

    // Volume with ternary icon
    Metric {
        label: Volume.volume > 30 ? "" : Volume.volume > 0 ? "" : ""
        value: Volume.volume
        minimum: 0
        maximum: 100
    }

    Separator {
        thickness: 1
        lineColor: Theme.quaternary
        fadePower: 0.4
    }

    // RAM
    Metric {
        label: ""
        value: ramPercent
        minimum: 0
        maximum: 100
    }

    Separator {
        thickness: 1
        lineColor: Theme.quaternary
        fadePower: 0.4
    }

    // CPU
    Metric {
        label: ""
        value: cpuPercent
        minimum: 0
        maximum: 100
    }

    Separator {
        thickness: 1
        lineColor: Theme.quaternary
        fadePower: 0.4
    }

    // Disk
    Metric {
        label: ""
        value: diskPercent
        minimum: 0
        maximum: 100
    }
}
