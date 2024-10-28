def "ahk start" [...name: string] {
    let selected = fd .ahk $env.CONFIG_PATH 
    | fzf --height 40% --layout=reverse -0 -1 --query ($name | str join " ")

    if ($selected | is-empty) {
        echo "No file selected"
        return
    }

    start ($selected | path expand)
}
