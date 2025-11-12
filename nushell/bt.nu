# bt — Bluetooth utilities for managing connections.

# pair and connect an existing bluetooth device
export def connect []: nothing -> nothing {
    let selected = find-devices | select-device
    let paired = paired

    if not ($paired | any {|it| $it.mac == $selected.mac}) {
        bluetoothctl pair $selected.mac
    }

    bluetoothctl connect $selected.mac
}

export alias con = connect
export alias c = connect

# disconnect a connected bluetooth device
export def disconnect []: nothing -> nothing {
    let selected = find-devices Connected | select-device
    bluetoothctl disconnect $selected.mac
}

export alias dis = disconnect
export alias d = disconnect

# trust a paired bluetooth device
export def trust []: nothing -> nothing {
    let selected = find-devices Paired | select-device
    bluetoothctl trust $selected.mac
}

export alias t = trust

# list all existing bluetooth devices
export def devices []: nothing -> table<mac: string, name: string> {
    find-devices
}

export alias ds = devices
export alias devs = devices

# list all paired bluetooth devices
export def paired []: nothing -> table<mac: string, name: string> {
    find-devices Paired
}

# list all connected bluetooth devices
export def connected []: nothing -> table<mac: string, name: string> {
    find-devices Connected
}

export alias cs = connected
export alias cons = connected

# list all trusted bluetooth devices
export def trusted []: nothing -> table<mac: string, name: string> {
    find-devices Trusted
}

# enable bluetooth scanning
export def "scan on" []: nothing -> nothing {
    bluetoothctl scan on
}

# disable bluetooth scanning
export def "scan off" []: nothing -> nothing {
    bluetoothctl scan off
}

def find-devices [
    mode?: string # Paired|Bonded|Trusted|Connected
]: nothing -> table<mac: string, name: string> {
    let devices = if ($mode | is-empty) {
        bluetoothctl devices
    } else {
        bluetoothctl devices $mode
    }

    let devices = $devices
    | lines
    | where ($it | str starts-with "Device")
    | str substring 7..
    | each { |it|
        let split = $it | split row --number 2 " ";
        let mac = $split | get 0 | str trim
        let name = $split | get 1 | str trim
        { mac: $mac, name: $name }
    }

    let named = $devices
    | where { |it|
        $it.mac != ($it.name | str replace --all "-" ":")
    }
    | sort-by name

    let unnamed = $devices
    | where { |it|
        $it.mac == ($it.name | str replace --all "-" ":")
    }
    | sort-by name

    let ordered = $named | append $unnamed

    $ordered
}

def select-device []: table<mac: string, name: string> -> record<mac: string, name: string> {
    let selected = $in | each { |it|
        $"($it.mac) - ($it.name)"
    } 
    | to text
    | fzf --height 40% --layout reverse -0
    | extract-selected-data

    $selected
}

def extract-selected-data []: string -> record<mac: string, name: string> {
    let split = $in | split row --number 2 "-"
    let mac = $split | get 0 | str trim
    let name = $split | get 1 | str trim
    { mac: $mac, name: $name }
}
