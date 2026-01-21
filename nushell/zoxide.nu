source ~/.config/zoxide/.zoxide.nu

# The new 'cd' command using zoxide and fzf
def --env z [
    --fzf-only(-f)
    ...path: string
] {
    if ($path | is-empty) {
        if $fzf_only {
            let target = (ls
                | where type == dir
                | get name
                | to text
                | fzf --preview='dir {}')

            cd-old $target
            return
        }

        cd-old $env.HOME
        return
    }

    let current = $env.PWD
    let path_split = $path
    let path = ($path | str join " ")

    if not $fzf_only {
        if (($path | str ends-with "/") or ($path | str ends-with "\\")) {
            cd-old $path 
            return
        } else {
            let immediate = if ($path_split | length) <= 1 {
                if ($path | str contains "/") or ($path | str contains "\\") {
                    let dirname = $path | path dirname
                    cd-old $dirname
                    let basename = $path | path basename
                    let x = fd --type d --max-depth 1 --full-path ($basename | path expand) --fixed-strings
                    p
                    $dirname | path join $x
                } else {
                    fd --type d --max-depth 1 --glob $path
                }
            } else {
                ""
            }

            if ($immediate | is-not-empty) {
                cd-old $immediate
                return
            }
        }

        do --env -i { cd-old (zoxide query ...$path_split) }
    }

    let new = $env.PWD

    if $current == $new {
        mut path = ($path | str join " ")

        if (($path | str ends-with "/") or ($path | str ends-with "\\")) {
            $path = ($path | str substring 0..(($path | str length) - 2))
        }

        let target = ls
        | where type == dir
        | get name 
        | to text 
        | fzf --height 40% --layout=reverse -0 -1 --query $path

        if $target == null or $target == "" {
            print "No result found."
            return
        }

        cd-old $target
    }
}

# Alias for z making it into cd
alias cd = z
alias cdf = cd (fzf | path dirname)

# Alias for __zoxide_zi
alias cdi = cd (zoxide query --interactive)

