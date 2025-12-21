export def main [] {
    hcloud --help
}

export def "servers list" [] {
    hcloud servers list 
    | lines 
    | skip 
    | parse --regex '^(?P<id>\d+?)\s\s+(?P<name>.*?)\s\s+(?P<status>.*?)\s\s+(?P<ipv4>.*?)\s\s+(?P<ipv6>.*?)\s\s+(?P<private_net>.*?)\s\s+(?P<datacenter>.*?)\s\s+(?P<age>.*?)\s+$'
}

export alias ls = servers list
export alias "servers ls" = servers list
export alias "sv list" = servers list
export alias "sv ls" = servers list

export def "context list" [] {
    mut contexts = hcloud context list 
    | lines 
    | skip 
    | parse --regex '^(?P<active>.)\s\s+(?P<name>.+)$'

    for $context in $contexts { 
        let name = $context.name
        let active = $context.active
        $contexts = $contexts | update active ($active == "*")
    }

    $contexts | select name active
}

export alias "context ls" = context list
export alias "ctx list" = context list
export alias "ctx ls" = context list

export def "context switch" [] {
    let contexts = context list

    let selected = $contexts
    | get name
    | to text
    | fzf --height 40% --layout reverse -0 -1

    print -e $"setting context to '($selected)'"

    hcloud context use $selected
}

export alias "context sw" = context switch
export alias "ctx switch" = context switch
export alias "ctx sw" = context switch

export def "datacenters list" [] {
    hcloud datacenter list 
    | lines 
    | skip 
    | parse --regex '^(?P<id>\d+?)\s\s+(?P<name>.*?)\s\s+(?P<description>.*?)\s\s+(?P<location>.*?)\s+$'
}

export alias "datacenters ls" = datacenters list
export alias "dc list" = datacenters list
export alias "dc ls" = datacenters list

export def "server up" [name?: string] {
    let name = if ($name | is-not-empty) {
        $name
    } else {
        ""
    }

    let selected = servers list
    | where status == off
    | get name
    | to text
    | fzf --height 40% --layout reverse -0 -1 --query $name

    hcloud server poweron $selected
}

export alias u = server up
export alias up = server up
export alias "sv up" = server up

export def "server down" [name?: string] {
    let name = if ($name | is-not-empty) {
        $name
    } else {
        ""
    }

    let selected = servers list
    | where status == running
    | get name
    | to text
    | fzf --height 40% --layout reverse -0 -1 --query $name

    hcloud server poweroff $selected
}

export alias down = server down
export alias d = server down
export alias "sv down" = server down
export alias "sv d" = server down

export def "server reboot" [name?: string] {
    let name = if ($name | is-not-empty) {
        $name
    } else {
        ""
    }

    let selected = servers list
    | where status == running
    | get name
    | to text
    | fzf --height 40% --layout reverse -0 -1 --query $name

    hcloud server reboot $selected
}

export alias reboot = server reboot
export alias r = server reboot
export alias "sv reboot" = server reboot
export alias "sv r" = server reboot
