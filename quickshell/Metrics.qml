import QtQuick

Row {
    id: root
    property int elementWidth: 65

    property var metrics: [({
                label: () => Volume.volume > 30 ? "" : Volume.volume > 0 ? "" : "",
                value: () => Volume.volume,
                minimum: 0,
                maximum: 100,
                healthy: () => Volume.healthy
            }), ({
                label: () => "",
                value: () => MemoryUsage.mem,
                minimum: 0,
                maximum: 100,
                healthy: () => MemoryUsage.healthy
            }), ({
                label: () => "",
                value: () => CpuUsage.cpu,
                minimum: 0,
                maximum: 100,
                healthy: () => CpuUsage.healthy
            }), ({
                label: () => "󰍹",
                value: () => GpuUsage.gpu,
                minimum: 0,
                maximum: 100,
                healthy: () => GpuUsage.healthy
            }), ({
                label: () => "",
                value: () => DiskUsage.averageDiskUsage,
                minimum: 0,
                maximum: 100,
                healthy: () => DiskUsage.healthy
            }), ({
                label: () => Battery.percent > 90 ? "" : Battery.percent > 60 ? "" : Battery.percent > 25 ? "" : Battery.percent > 10 ? "" : "",
                value: () => Battery.percent,
                minimum: 0,
                maximum: 100,
                healthy: () => Battery.healthy
            })]

    property var visibleMetrics: metrics.filter(m => m.healthy())

    Repeater {
        id: rep
        model: visibleMetrics

        delegate: Row {
            spacing: 12

            Separator {
                thickness: 1
                lineColor: Theme.quaternary
                fadePower: 0.4
                enabled: index > 0
                visible: index > 0
            }

            Metric {
                label: modelData.label()
                value: modelData.value()
                minimum: modelData.minimum
                maximum: modelData.maximum
                width: root.elementWidth
                enabled: modelData.healthy()
                visible: modelData.healthy()
            }
        }
    }
}
