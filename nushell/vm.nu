export def --wrapped ls [...$rest]: nothing -> table<id: string, name: string, state: string, connection: string> {
    if (which virsh | is-empty) {
        print -e "command: virsh is not available"
    }

    print -e
    let system = virsh -c qemu:///system list --all ...$rest
    | parse --regex '(?<id>\w+)\s\s+(?<name>\w+)\s\s+(?<state>\w+)'
    | skip
    | insert connection "qemu:///system"

    let session = virsh -c qemu:///session list --all ...$rest
    | parse --regex '(?<id>\w+)\s\s+(?<name>\w+)\s\s+(?<state>\w+)'
    | skip
    | insert connection "qemu:///session"

    $system | append $session
}
