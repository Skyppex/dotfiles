export def list []: nothing -> table<id: string, name: string, state: string, connection: string> {
    let candidates = [
        "qemu:///system",
        "qemu:///session",
        "qemu+ssh://localhost/system",
        "qemu+ssh://localhost/session",
        "qemu+tcp://localhost/system",
    ];

    mut vms = [];

    for url in $candidates {
        let result = virsh -c $url list --all | complete
        if ($result.exit_code != 0) {
            continue;
        }

        let found = $result.stdout
        | parse --regex '(?<id>\w+)\s\s+(?<name>\w+)\s\s+(?<state>\w+)'
        | skip
        | insert connection $url

        $vms = $vms | append $found
    }

    $vms = $vms | uniq-by id

    return $vms

    # let session = virsh -c qemu:///session list --all
    # | parse --regex '(?<id>\w+)\s\s+(?<name>\w+)\s\s+(?<state>\w+)'
    # | skip
    # | insert connection "qemu:///session"

    # $system | append $session
}

export alias ls = list

export def start [name?: string] {
    let vm = if ($name | is-empty) {
        ls | select-vm
    } else {
        ls | where ($it.name == $name) | first
    }

    virsh --connect $vm.connection start $vm.name
}

export alias up = start
export alias u = start
export alias s = start

export def suspend [name?: string] {
    let vm = if ($name | is-empty) {
        ls | select-vm
    } else {
        ls | where ($it.name == $name) | first
    }

    virsh --connect $vm.connection suspend $vm.name
}

export alias pause = suspend
export alias p = suspend
export alias sus = suspend

export def resume [name?: string] {
    let vm = if ($name | is-empty) {
        ls | select-vm
    } else {
        ls | where ($it.name == $name) | first
    }

    virsh --connect $vm.connection resume $vm.name
}

export alias unpause = resume
export alias res = resume

export def reboot [name?: string] {
    let vm = if ($name | is-empty) {
        ls | select-vm
    } else {
        ls | where ($it.name == $name) | first
    }

    virsh --connect $vm.connection reboot $vm.name
}

export alias r = reboot

export def shutdown [name?: string] {
    let vm = if ($name | is-empty) {
        ls | select-vm
    } else {
        ls | where ($it.name == $name) | first
    }

    virsh --connect $vm.connection shutdown $vm.name
}

export alias down = shutdown
export alias d = shutdown

export def destroy [name?: string] {
    let vm = if ($name | is-empty) {
        ls | select-vm
    } else {
        ls | where ($it.name == $name) | first
    }

    virsh --connect $vm.connection destroy $vm.name
}

export alias kill = destroy

export def dominfo [name?: string] {
    let vm = if ($name | is-empty) {
        ls | select-vm
    } else {
        ls | where ($it.name == $name) | first
    }

    virsh --connect $vm.connection dominfo $vm.name | str trim --right
}

export alias info = dominfo
export alias i = dominfo
export alias status = dominfo

def select-vm []: table<id: string, name: string, state: string, connection: string> -> record<id: string, name: string, state: string, connection: string> {
    let vms = $in
    let selected = $vms | each { |it|
        $"($it.id): ($it.name) ($it.state) - ($it.connection)"
    } 
    | to text 
    | fzf --layout reverse --height 40%

    if ($selected | is-empty) {
        print -e "no vm selected"
        return
    }

    let id = $selected | str substring ..(($selected | str index-of ":") - 1)
    $vms | where ($it.id == $id) | first
}
