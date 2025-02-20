const scripts_path = "~/.local/share/scripts"

def "scripts ls" [] {
    cd-old $scripts_path
    ls | get name
}

def "scripts cp" [
    --query(-q): string
    dest: path
] {
    let selected = if $query != null {
        scripts ls 
        | to text 
        | fzf --height 40% --layout=reverse -0 -1 --query $query
    } else {
        scripts ls 
        | to text 
        | fzf --height 40% --layout=reverse -0
    }

    if ($selected | is-empty) {
        print "No selection."
        return
    }

    let script = $scripts_path 
    | path join $selected 
    | path expand 

    let dest = $dest 
    | path join $selected
    | path expand 

    print $"copying ($script) to ($dest)"
    cp $script $dest
}
