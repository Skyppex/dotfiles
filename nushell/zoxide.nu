source ~/.config/zoxide/.zoxide.nu

# Alias for __zoxide_zi
alias cdi = __zoxide_zi;

# The new 'cd' command using zoxide and fzf
def --env z [
    --fzf-only(-f)
    ...path: string
] {
    if ($path == null or ($path | is-empty)) {
        if $fzf_only {
            let target = (ls
                | where type == dir
                | get name
                | to text
                | fzf --preview='dir {}')

            __zoxide_z $target
            return
        }

        __zoxide_z
        return
    }

    let current = $env.PWD

    if not $fzf_only {
        __zoxide_z ...$path
    }

    let new = $env.PWD

    if $current == $new {
        let target = (ls | get name | to text | fzf --height 40% --layout=reverse -0 -1 --query ...$path)
        if $target == null or $target == "" {
            print "No result found."
            return
        }
        __zoxide_z $target
    }
}

# Alias for z making it into cd
alias cd = z
alias cdf = z --fzf-only

# Zoxide query
alias cdq = zoxide query

def --env cv [...path: string] {
    cd ...$path
    vim .
}

