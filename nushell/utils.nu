### Generated from the os-specific-utils.nu.tmpl file by chezmoi
source os-specific-utils.nu

# Neovim

# Open a file found using fzf in neovim
def fim [...path] {
    fzp -1 --query ($path | str join " ") --bind "enter:become(nvim {})"
}

# Open neovim
def vim [
    --empty(-e) # Open neovim with an empty file
    --verbose(-v) # Enable verbose output
    ...path: string
] {
    let stdin = $in

    if $empty and ($path | is-empty) {
        print "--empty requires a path to be specified"
        return
    }

    if ($path | is-empty) {
        if $verbose {
            print "Path is empty"
        }

        $stdin | nvim
        return
    }

    let path = $path | str join " "

    if ($path == "..") {
        if $verbose {
            print "Entering nvim in parent directory"
        }

        $stdin | nvim ..
        return
    } 

    if ($path == ".") {
        if $verbose {
            print "Entering nvim in current directory"
        }

        $stdin | nvim .
        return
    }

    if $empty {
        if $verbose {
            print "Entering nvim in empty file"
        }

        $stdin | nvim ...$path
        return
    }

    if ($path | path exists) {
        if $verbose {
            print $"Found no path in zoxide. Entering nvim at '($path)'"
        }

        $stdin | nvim $path
        return
    } 

    let found_path = fd --type=d
    | fzf --height 40% --layout=reverse -0 -1 --query $path

    enter $found_path

    if $verbose {
        print $"Found path in zoxide: ($found_path)"
    }

    $stdin | nvim .
    p
}

# Fix the shada file stuff. You have to be in the shada directory
def "fix shada" [] {
    let newest = ls | where type == file
    | sort-by --reverse modified
    | first
    | get name

    cp $newest main.shada-cp

    ls | where type == file
    | where $it.name =~ "tmp"
    | each { |f| rm $f.name }

    rm main.shada
    mv main.shada-cp main.shada
}

# Lazydocker
alias ld = lazydocker

# Lazygit
alias lg = lazygit

# Not command
def n [] {
    not $in
}

# Surround the input with the provided strings
def "str surround" [
    start: string,
    end: string
] {
   $"($start)($in)($end)"
}

def cheat [...doc] {
    curl $"cheat.sh/($doc | str join "/")"
}

# Elevate the current shell and execute the nu command in the closure
def --env nudo [func: closure] {
    if (which sudo | is-empty) {
        gsudo nu --stdin --command $"do (view source $func)"
        return
    }

    sudo nu --stdin --command $"do (view source $func)"
}

# Exit
alias q = exit


# Copy to the clipboard
def clip [] {
    let input = $in | str replace -a "\\" "\\\\"
    copyq add $"($input)"
    copyq copy $"($input)"
}


# Paste from the clipboard
def paste [] {
    copyq clipboard | complete | get stdout | to text
}

# Get current local time
def "time now" [] { date now | format date "%H:%M:%S" }

# Open the starship config file in vscode
alias sc = start ~/.config/starship.toml

# Open the starship schema file in vscode
alias ss = start ~/.config/starship-schema.json

# Parse text into a table using regex
def "parse table" [
    --skip(-s): int # Specify the number of rows to skip
    --header(-h) # There is a header row
    --header-spacer(-c) # The header row is separated by a spacer row
    --verbose(-v) # Print verbose output
    regex: string # Specify the regex to split the table
] {
    let input = $in;

    if $verbose {
        print $"Input:\n($input)"
    }

    # Skip n rows in the beginning before the table starts
    let skip = (if $skip != null {
        $skip
    } else {
        0
    })

    if $verbose {
        print $"Skip:\n($skip)"
    }

    mut lines = $input | lines | skip $skip

    if $verbose {
        print $"Lines:\n($lines)"
    }

    mut $header_col = []
    
    # Parse header if it exists
    if $header {
        let header = $lines | first
        $header_col = ($lines 
            | first 
            | to text 
            | split column -r $regex 
            | to text 
            | lines 
            | each {|l|
                let s = ($l | str index-of ': ') + 2
                $l | str substring $s..
            }
        )

        if $verbose {
            print $"Header:\n($header)"
            print $"Header Columns:\n($header_col)"
        }

        $lines = ($lines | to text | lines | skip 1)
        if $header_spacer {
            $lines = ($lines | to text | lines | skip 1)
        }
    }

    if $verbose {
        print $"Lines:\n($lines)"
    }

    # Use regex to split each line into columns
    mut rows = $lines | each { |line|
        let cols = $line | to text | split column -r $regex
        $cols
    } | reduce {|row, acc| $acc | append $row} 
    | rename --block { str replace --all 'column' ''}

    if $verbose {
        print $"Rows:\n($rows)"
    }

    # Rename columns if header exists
    if $header {
        for $name in ($header_col | enumerate) {
            let i = (($name.index + 1) | to text);
            $rows = ($rows | rename -c {$i: $name.item})
        }
        
        if $verbose {
            print $"Rows:\n($rows)"
        }
    }

    $rows
}

alias "andromeda gray" = echo "#23262e"
alias "andromeda light_gray" = echo "#373941"
alias "andromeda lighter_gray" = echo "#857e89"
alias "andromeda orange" = echo "#f39c12"
alias "andromeda pink" = echo "#ff00aa"
alias "andromeda pastel_pink" = echo "#ff99cc"
alias "andromeda blue" = echo "#7cb7ff"
alias "andromeda cyan" = echo "#00e8c6"
alias "andromeda yellow" = echo "#ffe66d"
alias "andromeda green" = echo "#96e072"
alias "andromeda white" = echo "#d5ced9"
alias "andromeda black" = echo "#181a16"
alias "andromeda purple" = echo "#c74ded"
alias "andromeda pastel purple" = echo "#cda4de"
alias "andromeda red" = echo "#ee5d43"

# list all the colors
def "andromeda" [] {
    mut str = ""
    $str += $"gray: (andromeda gray)\n"
    $str += $"light_gray: (andromeda light_gray)\n"
    $str += $"lighter_gray: (andromeda lighter_gray)\n"
    $str += $"orange: (andromeda orange)\n"
    $str += $"pink: (andromeda pink)\n"
    $str += $"blue: (andromeda blue)\n"
    $str += $"cyan: (andromeda cyan)\n"
    $str += $"yellow: (andromeda yellow)\n"
    $str += $"green: (andromeda green)\n"
    $str += $"white: (andromeda white)\n"
    $str += $"black: (andromeda black)\n"
    $str += $"purple: (andromeda purple)\n"
    $str += $"red: (andromeda red)"
    echo $str
}

alias cm = chezmoi
alias cma = chezmoi apply --force

def "count-by-group" [] {
    $in
    | group-by --to-table
    | each { |g| { group: $g.group, count: ($g.items | length) } }
}

def void [] {}

def distribute [
    total: int
    size: int
]: nothing -> list<int> {
    mut chunks = []

    for _ in 1..$size {
        $chunks = ($chunks | append 0)
    }

    mut current_chunk = 0

    for _ in 1..$total {
        $chunks = ($chunks | update $current_chunk (($chunks | get $current_chunk) + 1))
        $current_chunk = ($current_chunk + 1) mod $size
    }

    return $chunks
}

def "str strip-prefix" [prefix: string]: string -> string {
    let input = $in

    if ($input | str starts-with $prefix) {
        return ($input | str substring ($prefix | str length)..)
    }

    return $input
}
