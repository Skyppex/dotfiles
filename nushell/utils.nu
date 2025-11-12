### Generated from the os-specific-utils.nu.tmpl file by chezmoi
source os-specific-utils.nu

# Neovim

# Open a file found using fzf in neovim
def fim [...path] {
    fzp -1 --query ($path | str join " ") --bind "enter:become(nvim {})"
}

# Open neovim
alias vim = nvim

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
    if (sys host | get long_os_version | str contains -i "linux") {
        $in | wl-copy
    } else {
        let input = $in | str replace -a "\\" "\\\\"
        copyq add $"($input)"
        copyq copy $"($input)"
    }
}


# Paste from the clipboard
def paste [] {
    if (sys host | get long_os_version | str contains -i "linux") {
        wl-paste
    } else {
        copyq clipboard | complete | get stdout | to text
    }
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
]: string -> table {
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

    mut lines = $input | lines | skip $skip | str trim --right

    if $verbose {
        print $"Lines:\n($lines)"
    }

    mut $header_col = []
    
    # Parse header if it exists
    if $header {
        let header = $lines | first
        $header_col = ($header 
            | to text 
            | split column -r $regex 
            | to text 
            | lines 
            | each {|l|
                let s = ($l | str index-of ': ') + 2
                $l | str substring $s.. | str trim
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

    if ($lines | is-empty) {
        mut tbl = [[]; []]

        for $name in ($header_col | enumerate) {
            $tbl = $tbl | insert $name.item ($name.index + 1)
            let i = (($name.index + 1) | to text);
            let t = $tbl

            $tbl = try {
                $t | rename -c {$i: $name.item}
            } catch {
                $t | reject $name.item
            }
        }

        $tbl = $tbl | drop nth 0
        return $tbl
    }

    # Use regex to split each line into columns
    mut rows = $lines
    | each { |line|
        $line | to text | split column -r $regex
    }
    | reduce {|row, acc| $acc | append $row} 
    | rename --block { str replace --all 'column' ''}

    if $verbose {
        print $"Rows:\n($rows)"
    }

    # Rename columns if header exists
    if $header {
        for $name in ($header_col | enumerate) {
            let i = (($name.index + 1) | to text);
            let rs = $rows

            $rows = try {
                $rs | rename -c {$i: $name.item}
            } catch {
                $rs | reject $name.item
            }
        }
        
        if $verbose {
            print $"Rows:\n($rows)"
        }
    }

    $rows
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

def --env con [cmd: closure]: any -> any {
    let input = $in
    mut result = null

    enter $env.CONFIG_PATH

    if ($input | is-empty) {
        $result = (do -i --env $cmd)
    } else {
        $result = (do -i --env $cmd $input)
    }

    p

    if ($result | is-empty) {
        return
    }

    return $result
}

def --wrapped detatch [...command]: nothing -> nothing {
    let input = $in

    if ($input | is-empty) {
        $input | bash -c $"($command | str join ' ') &"
    } else {
        bash -c $"($command | str join ' ') &"
    }
}

def --wrapped shebang [
    path: string
    ...rest: string
]: any -> any {
    let input = $in
    let rest = $rest | str join " "

    let content = open -r $path

    if ($content | is-empty) {
        return ""
    }

    if ($content | lines | first | str starts-with "#!" | n) {
        return ""
    }

    let shebang = $content | lines | first | str substring 2..

    let known_shebangs = [
        "/usr/bin/env -S ", # includes the space due to strip-prefix
        "/usr/bin/env ", # includes the space due to strip-prefix
        "/usr/bin/",
        "/bin/",
    ]

    mut program = ""
    for $known in $known_shebangs {
        if ($shebang | str starts-with $known) {
            $program = ($shebang | str strip-prefix $known)
            break
        }
    }

    if ($in | is-empty) {
        nu --commands $"($program) ($path) ($rest)"
    } else {
        $input | nu --stdin --commands $"($program) ($path) ($rest)"
    }
}

def bin [] {
    let bin_locations = $env.PATH | split row ":"

    let programs = $bin_locations
    | each { |it|
        if ($it | path exists) {
            ls ($it | to text) | where type != dir | get name
        } else {
            []
        }
    }
    | flatten

    let selected = $programs
    | path basename
    | uniq
    | to text
    | fzf --height 40% --layout reverse

    if ($selected | is-empty) {
        print -e "No selection"
    }

    return ($programs | uniq | where (($it | path basename) == $selected))
}
