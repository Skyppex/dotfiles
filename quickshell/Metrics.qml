import QtQuick

Row {
    property int volume: 42
    property int ramPercent: 67
    property int cpuPercent: 12
    property int diskPercent: 81

    // Volume with ternary icon
    Metric {
        label: volume > 30 ? "" : volume > 0 ? "" : ""
        value: volume
        minimum: 0
        maximum: 100
    }

    // RAM
    Metric {
        label: "󰍛"
        value: ramPercent
        minimum: 0
        maximum: 100
    }

    // CPU
    Metric {
        label: ""
        value: cpuPercent
        minimum: 0
        maximum: 100
    }

    // Disk
    Metric {
        label: ""
        value: diskPercent
        minimum: 0
        maximum: 100
    }
}
