# bt — Bluetooth utilities for managing connections.
export def main [] {
    print (help modules bt)
    print "\nAlso see bluetoothctl --help"
}

# discover devices. does not pair or connect
export def discover [
    timeout?: int
]: nothing -> nothing {
    let timeout = if ($timeout | is-not-empty) {
        $timeout
    } else {
        3
    }

    bluetoothctl --timeout $timeout scan on
}

export alias find = discover
export alias fd = discover

# pair and connect a bluetooth device
export def connect [
    --discover(-d)
    --trust(-t)
]: nothing -> nothing {
    if $discover {
        discover
    }

    let selected = find-devices | select-device

    if not (paired | any {|it| $it.mac == $selected.mac}) {
        bluetoothctl pair $selected.mac
    }

    if $trust and not (trusted | any {|it| $it.mac == $selected.mac}) {
        bluetoothctl trust $selected.mac
    }

    bluetoothctl connect $selected.mac
}

export alias con = connect
export alias c = connect

# disconnect a connected bluetooth device
export def disconnect []: nothing -> nothing {
    let selected = connected | select-device
    bluetoothctl disconnect $selected.mac
}

export alias dis = disconnect
export alias d = disconnect

# trust a paired bluetooth device
export def trust []: nothing -> nothing {
    let selected = paired | select-device
    bluetoothctl trust $selected.mac
}

export alias t = trust

# untrust a trusted bluetooth device
export def untrust []: nothing -> nothing {
    let selected = trusted | select-device
    bluetoothctl untrust $selected.mac
}

export alias u = untrust

# list all existing bluetooth devices
export def devices []: nothing -> table<mac: string, name: string> {
    find-devices
}

export alias ds = devices
export alias ls = devices
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

    $selected | extract-selected-data
}

def extract-selected-data []: string -> record<mac: string, name: string> {
    let split = $in | split row --number 2 "-"
    let mac = $split | get 0 | str trim
    let name = $split | get 1 | str trim
    { mac: $mac, name: $name }
}
