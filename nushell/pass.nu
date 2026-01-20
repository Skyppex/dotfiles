export def --env activate [] {
    $env.BW_SESSION = ^bw login --raw
}

export alias a = activate

export def --env deactivate [] {
    bw logout
    $env.BW_SESSION = null
}

export alias d = deactivate

export def list [] {
    bw list items 
    | from json 
    | select --optional name login.username login.password
    | rename --column {
        "login.username": "username",
        "login.password": "password"
    }
}

export alias ls = list

export def pick [require: cell-path] {
    let list = list

    let names = $list
    | where ($it | get $require | is-not-empty)
    | get name

    let selected = $names 
    | to text 
    | str trim 
    | fzf --height 40% --layout reverse -0

    if ($selected | is-empty) {
        print -e "no key selected"
        return
    }

    $list | where name == $selected | first
}

export def "copy username" [] {
    pick username | get username | clip
    print "username copied to clipboard"
}

export alias "copy user" = copy username
export alias "copy u" = copy username
export alias "cp username" = copy username
export alias "cp user" = copy username
export alias "cp u" = copy username

export def "copy password" [] {
    pick password | get password | clip
    print "password copied to clipboard"
}

export alias "copy pass" = copy password
export alias "copy p" = copy password
export alias "cp password" = copy password
export alias "cp pass" = copy password
export alias "cp p" = copy password

export def "print username" [] {
    pick username | get username
}

export alias "print user" = print username
export alias "print u" = print username
export alias "p username" = print username
export alias "p user" = print username
export alias "p u" = print username

export def "print password" [] {
    pick password | get password
}

export alias "print pass" = print password
export alias "print p" = print password
export alias "p password" = print password
export alias "p pass" = print password
export alias "p p" = print password
