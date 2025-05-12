source ~/.config/zoxide/.zoxide.nu

alias cd-old = cd

# Alias for __zoxide_zi
alias cdi = __zoxide_zi;

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

            enter $target
            return
        }

        enter $env.HOME
        return
    }

    let current = $env.PWD
    let path_split = $path
    let path = ($path | str join " ")

    if not $fzf_only {
        if (($path | str ends-with "/") or ($path | str ends-with "\\")) {
            enter $path

            if ($env.LAST_EXIT_CODE == 0) {
                return
            }
        }

        do --env -i { enter (zoxide query ...$path_split) }
    }

    let new = $env.PWD

    if $current == $new {
        mut path = ($path | str join " ")

        if (($path | str ends-with "/") or ($path | str ends-with "\\")) {
            $path = ($path | str substring 0..(($path | str length) - 2))
        }

        let target = ls
        | get name 
        | to text 
        | fzf --height 40% --layout=reverse -0 -1 --query $path

        if $target == null or $target == "" {
            print "No result found."
            return
        }

        enter $target
    }
}

# Alias for z making it into cd
alias cd = z
alias cdf = cd (fzf | path dirname)

# Zoxide query
alias cdq = zoxide query

def --env cv [...path: string] {
    cd ...$path
    vim .
}
