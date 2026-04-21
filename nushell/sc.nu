export def main [] {
    units | explore
}

export alias help = help sc

export def units [] {
    systemctl list-units --output json | from json
}

export alias ls = units

export def "unit files" [] {
    systemctl list-unit-files --output json | from json
}

export alias ufs = unit files

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

export def find [] {
    let unit_files = unit files

    let selected = $unit_files
    | get unit_file
    | to text
    | fzf --height 40% --layout reverse -0 -1 --multi

    let units = units | where unit in $selected

    if ($units | length) == 0 {
        $unit_files 
        | where unit_file == $selected 
        | rename --column { unit_file: unit }
    } else {
        $units
    }
}

export def timers [] {
    systemctl list-timers --output json 
    | from json
    | select unit next left last passed activates
}

export alias ts = timers
export alias "ls t" = timers

export def timer [] {
    let timers = timers
    let selected = $timers
    | get unit
    | to text
    | fzf --height 40% --layout reverse -0 -1

    $timers | where unit == $selected | first
}

export alias t = timer

export def paths [] {
    systemctl list-paths --output json 
    | from json
    | select unit path condition activates
}

export alias ps = paths
export alias "ls p" = paths

export def path [] {
    let paths = paths
    let selected = $paths
    | get unit
    | to text
    | fzf --height 40% --layout reverse -0 -1

    $paths | where unit == $selected | first
}

export alias p = path

export def sockets [] {
    systemctl list-sockets --output json 
    | from json
    | select unit listen activates
}

export alias cs = sockets
export alias "ls c" = sockets

export def socket [] {
    let sockets = sockets
    let selected = $sockets
    | get unit
    | to text
    | fzf --height 40% --layout reverse -0 -1

    $sockets | where unit == $selected | first
}

export alias c = socket

export def status [] {
    let unit = unit
    systemctl status $unit.unit
}

export alias s = status

export def start [] {
    let units = find
    $units | { |unit|
        systemctl start $unit.unit
    }
}

export alias u = start
export alias up = start

export def restart [] {
    let units = find
    $units | each { |unit|
        systemctl restart $unit.unit
    }
}

export alias r = restart

export def stop [] {
    let units = find
    $units | each { |unit|
        systemctl stop $unit.unit
    }
}

export alias d = stop
export alias down = stop

export def enable [] {
    let units = find
    $units | each { |unit|
        systemctl enable $unit.unit
    }
}

export alias on = enable

export def disable [] {
    let units = find
    $units | each { |unit|
        systemctl disable $unit.unit
    }
}

export alias off = disable
export alias of = disable
