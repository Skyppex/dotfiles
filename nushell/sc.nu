export def main [] {
    units | explore
}

export alias help = help sc

export def units [
    --user(-u)
] {
    if ($user | is-empty) {
        systemctl list-units --output json | from json
    } else {
        systemctl --user list-units --output json | from json
    }
}

export alias ls = units

export def "unit files" [
    --user(-u)
] {
    if ($user | is-empty) {
        systemctl list-unit-files --output json | from json
    } else {
        systemctl --user list-unit-files --output json | from json
    }
}

export alias ufs = unit files

export def unit [
    --user(-u)
] {
    let units = if ($user | is-empty) {
        unit files
    } else {
        unit files --user
    }

    let selected = $units
    | get unit_file
    | to text
    | fzf --height 40% --layout reverse -0 -1

    let unit = if ($user | is-empty) {
        units
    } else {
        units --user
    } | where unit == $selected

    if ($unit | length) == 0 {
        $units 
        | where unit_file == $selected 
        | first 
        | rename --column { unit_file: unit }
    } else {
        $unit | first
    }
}

export def find [
    --user(-u)
] {
    let unit_files = if ($user | is-empty) {
        unit files
    } else {
        unit files --user
    }

    let selected = $unit_files
    | get unit_file
    | to text
    | fzf --height 40% --layout reverse -0 -1 --multi

    let units = if ($user | is-empty) {
        units
    } else {
        units --user
    } | where unit in $selected

    if ($units | length) == 0 {
        $unit_files 
        | where unit_file == $selected 
        | rename --column { unit_file: unit }
    } else {
        $units
    }
}

export def timers [
    --user(-u)
] {
    if ($user | is-empty) {
        systemctl list-timers --output json
    } else {
        systemctl --user list-timers --output json
    }
    | from json
    | select unit next left last passed activates
}

export alias ts = timers
export alias "ls t" = timers

export def timer [
    --user(-u)
] {
    let timers = if ($user | is-empty) {
        timers
    } else {
        timers --user
    }

    let selected = $timers
    | get unit
    | to text
    | fzf --height 40% --layout reverse -0 -1

    $timers | where unit == $selected | first
}

export alias t = timer

export def paths [
    --user(-u)
] {
    if ($user | is-empty) {
        systemctl list-paths --output json
    } else {
        systemctl --user list-paths --output json
    }
    | from json
    | select unit path condition activates
}

export alias ps = paths
export alias "ls p" = paths

export def path [
    --user(-u)
] {
    let paths = if ($user | is-empty) {
        paths
    } else {
        paths --user
    }

    let selected = $paths
    | get unit
    | to text
    | fzf --height 40% --layout reverse -0 -1

    $paths | where unit == $selected | first
}

export alias p = path

export def sockets [
    --user(-u)
] {
    if ($user | is-empty) {
        systemctl list-sockets --output json
    } else {
        systemctl --user list-sockets --output json
    }
    | from json
    | select unit listen activates
}

export alias cs = sockets
export alias "ls c" = sockets

export def socket [
    --user(-u)
] {
    let sockets = if ($user | is-empty) {
        sockets
    } else {
        sockets --user
    }

    let selected = $sockets
    | get unit
    | to text
    | fzf --height 40% --layout reverse -0 -1

    $sockets | where unit == $selected | first
}

export alias c = socket

export def status [
    --user(-u)
] {
    if ($user | is-empty) {
        let unit = unit
        systemctl status $unit.unit
    } else {
        let unit = unit --user
        systemctl --user status $unit.unit
    }
}

export alias s = status

export def start [
    --user(-u)
] {
    if ($user | is-empty) {
        find | each { |unit|
            systemctl start $unit.unit
        }
    } else {
        find --user | each { |unit|
            systemctl --user start $unit.unit
        }
    }
}

export alias u = start
export alias up = start

export def restart [
    --user(-u)
] {
    if ($user | is-empty) {
        find | each { |unit|
            systemctl restart $unit.unit
        }
    } else {
        find --user | each { |unit|
            systemctl --user restart $unit.unit
        }
    }
}

export alias r = restart

export def stop [
    --user(-u)
] {
    if ($user | is-empty) {
        find | each { |unit|
            systemctl stop $unit.unit
        }
    } else {
        find --user | each { |unit|
            systemctl --user stop $unit.unit
        }
    }
}

export alias d = stop
export alias down = stop

export def enable [
    --user(-u)
] {
    if ($user | is-empty) {
        find | each { |unit|
            systemctl enable $unit.unit
        }
    } else {
        find --user | each { |unit|
            systemctl --user enable $unit.unit
        }
    }
}

export alias on = enable

export def disable [
    --user(-u)
] {
    if ($user | is-empty) {
        find | each { |unit|
            systemctl disable $unit.unit
        }
    } else {
        find --user | each { |unit|
            systemctl --user disable $unit.unit
        }
    }
}

export alias off = disable
