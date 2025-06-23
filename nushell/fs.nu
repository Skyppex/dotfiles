# Yazi with cwd
def --env y [...args] {
    let tmp = (mktemp -t "yazi-cwd.XXXXXX")
    yazi ...$args --cwd-file $tmp
    let cwd = (open $tmp)

    if $cwd != "" and $cwd != $env.PWD {
        enter $cwd
    }

    rm -fp $tmp
}

# Fzf with preview
alias fzp = fzf --preview="bat --color=always --wrap=never --number --line-range=:200 {}"

# Make directory
alias md = mkdir

# Remove all files from the Downloads folder
def rmdl [] {
    let files = ls ~/Downloads
    for file in $files {
        rm -rv $file.name
    }
}

# Reverse search for a glob pattern
def rev-parse [glob: glob]: nothing -> list<path> {
    mut results = glob $glob
    mut up = 0

    while ($results | is-empty) {
        let pwd = pwd
        enter ..

        if (pwd) == $pwd {
            print "No results found"
            return null;
        }

        $up += 1
        $results = (glob $glob)
    }

    return $results
}

alias rp = rev-parse
