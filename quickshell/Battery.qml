pragma Singleton

import Quickshell
import Quickshell.Services.UPower
import QtQuick

import "utils"

Singleton {
    id: root
    property bool healthy: {
        let ready = UPower.displayDevice.ready;
        let isLaptopBattery = UPower.displayDevice.isLaptopBattery;
        return ready && isLaptopBattery;
    }

    property real percent: UPower.displayDevice.isLaptopBattery ? UPower.displayDevice.percentage * 100 : 100
}
