import QtQuick

Row {
    property int volume: 28
    property int ramPercent: 67
    property int cpuPercent: 12
    property int diskPercent: 81
    property int elementWidth: 65

    // Volume with ternary icon
    Metric {
        label: Volume.volume > 30 ? "" : Volume.volume > 0 ? "" : ""
        value: Volume.volume
        minimum: 0
        maximum: 100
        width: elementWidth
    }

    Separator {
        thickness: 1
        lineColor: Theme.quaternary
        fadePower: 0.4
    }

    // RAM
    Metric {
        label: ""
        value: MemoryUsage.mem
        minimum: 0
        maximum: 100
        width: elementWidth
    }

    Separator {
        thickness: 1
        lineColor: Theme.quaternary
        fadePower: 0.4
    }

    // CPU
    Metric {
        label: ""
        value: CpuUsage.cpu
        minimum: 0
        maximum: 100
        width: elementWidth
    }

    Separator {
        thickness: 1
        lineColor: Theme.quaternary
        fadePower: 0.4
    }

    // Disk
    Metric {
        label: ""
        value: DiskUsage.disk
        minimum: 0
        maximum: 100
        width: elementWidth
    }
}
