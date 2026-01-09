export def units [] {
    systemctl list-units --output json | from json
}

export def "unit files" [] {
    systemctl list-unit-files --output json | from json
}

export def unit [] {
    let units = unit files

    let selected = $units
    | get unit_file
    | to text
    | fzf --height 40% --layout reverse -0 -1

    let unit = units | where unit == $selected

    if ($unit | length) == 0 {
        $units 
        | where unit_file == $selected 
        | first 
        | rename --column { unit_file: unit }
    } else {
        $unit | first
    }
}

export def timers [] {
    systemctl list-timers --output json 
    | from json
    | select unit next left last passed activates
}

export def timer [] {
    let timers = timers
    let selected = $timers
    | get unit
    | to text
    | fzf --height 40% --layout reverse -0 -1

    $timers | where unit == $selected | first
}

export def paths [] {
    systemctl list-paths --output json 
    | from json
    | select unit path condition activates
}

export def path [] {
    let paths = paths
    let selected = $paths
    | get unit
    | to text
    | fzf --height 40% --layout reverse -0 -1

    $paths | where unit == $selected | first
}

export def sockets [] {
    systemctl list-sockets --output json 
    | from json
    | select unit listen activates
}

export def socket [] {
    let sockets = sockets
    let selected = $sockets
    | get unit
    | to text
    | fzf --height 40% --layout reverse -0 -1

    $sockets | where unit == $selected | first
}

export def status [] {
    let unit = unit
    systemctl status $unit.unit
}

export def start [] {
    let unit = unit
    systemctl start $unit.unit
}

export def restart [] {
    let unit = unit
    systemctl restart $unit.unit
}

export def stop [] {
    let unit = unit
    systemctl stop $unit.unit
}

export def enable [] {
    let unit = unit
    systemctl enable $unit.unit
}

export def disable [] {
    let unit = unit
    systemctl disable $unit.unit
}
