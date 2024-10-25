# Yazi with cwd
def --env y [...args] {
    let tmp = (mktemp -t "yazi-cwd.XXXXXX")
    yazi ...$args --cwd-file $tmp
    let cwd = (open $tmp)

    if $cwd != "" and $cwd != $env.PWD {
        cd $cwd
    }

    rm -fp $tmp
}

# Fzf with preview
alias fzp = fzf --preview="bat --color=always --wrap=never --number --line-range=:200 {}"

# Neovim

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

# # Custom definition for the 'fuck' command from 'thefuck'
# def fuck [
#     --yes(-y),
#     --yeah,
#     --hard,
#     --repeat(-r),
#     --debug(-d)
#     --enable-experimental-instant-mode,
#     --shell-logger(-l)
#     --help(-h),
#     --version(-v),
# ] {
#     if $help { thefuck -h; return }
#     if $version { thefuck -v; return }
#
#     mut options = []
#
#     if $yes or $yeah or $hard { $options = ($options | append "-y") }
#     if $repeat { $options = ($options | append "-r") }
#     if $debug { $options = ($options | append "-d") }
#     if $enable_experimental_instant_mode { $options = ($options | append "--enable-experimental-instant-mode") }
#     if $shell_logger { $options = ($options | append "-l") }
#
#     let options = ($options | str join " ")
#     let hist = (history | last 1) | get command.0
#     let fuck = $"(TF_ALIAS=fuck PYTHONIOENCODING=utf-8 thefuck $options $hist)"
#     nu -e $"($fuck | str replace -a "\r" "" | str replace -a "\n" "")"
# }

# Fuck?
def --env "fuck" [] {
    let h = history | get command
    let last = $h | last

    let h = history | get command | drop 1

    let selected = $h | to text | fzf --height 40% --layout=reverse -0 -1 --query $last

    if ($selected | is-empty) {
        print "No substitute found"
        return
    } else {
        let r = input $"Run '($selected)'? \(y/n\): "

        if ($r == "y") {
            let command = [$selected (char nl)] | str join ""
            let config_file = $env.CONFIG_PATH | path join "nushell/config.nu"
            let env_file = $env.CONFIG_PATH | path join "nushell/env.nu"
            nu --config $config_file --env-config $env_file --execute $command
        }
    }
}

def cheat [...doc] {
    curl $"cheat.sh/($doc | str join "/")"
}

# Elevate the current shell to admin
alias sudo = gsudo

def --env nudo [func: closure] {
    sudo nu --stdin --command $"do (view source $func)"
}

# Exit
alias q = exit

# Make directory
alias md = mkdir

# Pseudo alias to gits bash command which can parse \r\n line endings
def bash [
    --version(-v) # Print the version of bash
    ...args: string
] {
    let cmd = $env.SCOOP_APPS + "/git/current/bin/bash.exe"

    if $version {
        nu --commands $"($cmd) --version"
        return
    }
    
    if ($args | is-empty) {
        nu --commands $cmd
    } else {
        nu --commands $"($cmd) ($args | str join "")"
    }
}

# Shorthand for bash
alias sh = bash

# Paste from the clipboard
alias paste = powershell -command "Get-Clipboard"

# Get current local time
def "time now" [] { date now | format date "%H:%M:%S" }

# Remove all files from the Downloads folder
def rmdl [] {
    let files = ls ~/Downloads
    for file in $files {
        rm -rv $file.name
    }
}

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
        $header_col = ($lines | first | to text | split column -r $regex | to text | lines | each {|l|
            let s = ($l | str index-of ': ') + 2
            $l | str substring $s..
        })

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
    } | reduce {|row, acc| $acc | append $row} | rename --block { str replace --all 'column' ''}

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

# Specify a color to echo (gray|light_gray|lighter_gray|orange|pink|blue|cyan|yellow|green|white|black|purple)
def "andromeda" [] {
    echo "Specify a color to echo (gray|light_gray|lighter_gray|orange|pink|blue|cyan|yellow|green|white|black|purple)"
}

alias "andromeda gray" = echo "#23262e"
alias "andromeda light_gray" = echo "#373941"
alias "andromeda lighter_gray" = echo "#857e89"
alias "andromeda orange" = echo "#f39c12"
alias "andromeda pink" = echo "#ff00aa"
alias "andromeda blue" = echo "#7cb7ff"
alias "andromeda cyan" = echo "#00e8c6"
alias "andromeda yellow" = echo "#ffe66d"
alias "andromeda green" = echo "#96e072"
alias "andromeda white" = echo "#d5ced9"
alias "andromeda black" = echo "#181a16"
alias "andromeda purple" = echo "#c74ded"
alias "andromeda red" = echo "#ee5d43"
