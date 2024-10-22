def "ahk start" [...name: string] {
    let selected = fd .ahk $env.CONFIG_PATH 
    | fzf --height 40% --layout=reverse --query ($name | str join " ")

    start ($selected | path expand)
}
