use ~/.cache/starship/init.nu
source ~/.config/nushell/scripts.nu
source ~/.config/zoxide/.zoxide.nu

# Remember the old enter command
alias enter-old = enter

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
    ...path
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

    if (($path | str join " ") == "..") {
        if $verbose {
            print "Entering nvim in parent directory"
        }

        $stdin | nvim ..
        return
    } 

    if (($path | str join " ") == ".") {
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

    let found_path = do --ignore-errors { zoxide query ...$path }

    if ($found_path | is-empty)  {
        if $verbose {
            print $"Found no path in zoxide. Entering nvim at '($path | str join ' ')'"
        }

        $stdin | nvim ...$path
        return
    }

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

# Utils

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
    ...args: string
] {
    let cmd = $env.SCOOP_APPS + "/git/current/bin/bash.exe"

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

# Projects

# List project folder
alias proj = ls $env.PROJECTS;

# Find project in project folder
def "proj find" [...project: string] {
    let project_folder = $env.PROJECTS | path basename
    let project = $project | str join " "
    let result = (ls $env.PROJECTS | where type == symlink | get name | to text | fzf -0 -1 --query ($"($project)"))
    
    if ($result | is-empty) {
        print "No project found"
        return
    }

    $result
}

# Create a symlink for a project into the project folder
def "proj add" [
    --force(-f) # Pass force to the hook command
    --interactive(-i) # Pass interactive to the hook command
    --verbose(-v) # Print verbose output and pass verbose to the hook command
    ...project: string # The name of the project to add
] {
    if $force and $interactive {
        print "Cannot pass both force and interactive together"
        return
    }

    let project_folder = $env.PROJECTS | path basename

    if $verbose {
        print $"Project Folder: ($project_folder)"
    }

    let project = $project | str join " "
    mut project = fzf -0 -1 --query ($"($project) !($project_folder) .sln$ | Cargo.toml$")
    $project = ($project | path expand)

    if $verbose {
        print $"Project: ($project)"
    }

    let base = if ($project | str ends-with "Cargo.toml") {
        if $verbose {
            print "Rust project"
        }

        let ret = $project | path dirname | path basename
        
        if $verbose {
            print $"Ret: ($ret)"
        }

        $project = ($project | path dirname)
        
        if $verbose {
            print $"Project2: ($project)"
        }

        $ret
    } else {
        $project | path basename
    }

    if $verbose {
        print $"Base: ($base)"
    }

    match [$force, $interactive, $verbose] {
        [false, false, true] => { sudo hook -v -s $project -d ($env.PROJECTS | path join $base) }
        [true, false, true] => { sudo hook -vf -s $project -d ($env.PROJECTS | path join $base) }
        [false, true, true] => { sudo hook -vi -s $project -d ($env.PROJECTS | path join $base) }
        [false, false, false] => { sudo hook -q -s $project -d ($env.PROJECTS | path join $base) }
        [true, false, false] => { sudo hook -qf -s $project -d ($env.PROJECTS | path join $base) }
        [false, true, false] => { sudo hook -qi -s $project -d ($env.PROJECTS | path join $base) }
    }
}

# Remove project from project folder
def "proj rm" [
    ...project: string # The name of the project to remove
] {
    let project_folder = $env.PROJECTS | path basename
    let project = $project | str join " "
    let result = (ls $env.PROJECTS | where type == symlink | get name | to text | fzf -0 -1 --query ($"($project)"))

    if ($result | is-empty) {
        print "No project found"
        return
    }

    rm -t $result
}

# Create symlinks for all projects under your working directory into the project folder
def "proj update" [
    --force(-f) # Pass force to the hook command
    --interactive(-i) # Pass interactive to the hook command
    --verbose(-v) # Pass verbose to the hook command
] {
    if $force and $interactive {
        print "Cannot pass both force and interactive together"
        return
    }

    let csharp_projects = ls -f **\*.sln | where type == file | get name
    let rust_projects = ls -f **\Cargo.toml | where type == file | get name | each {|p| $p | path dirname}
    let projects = ($csharp_projects | append $rust_projects)

    $projects | each { |project|
        let base = ($project | path basename);

        match [$force, $interactive, $verbose] {
            [false, false, true] => { sudo hook -v -s $project -d ($env.PROJECTS | path join $base) }
            [true, false, true] => { sudo hook -vf -s $project -d ($env.PROJECTS | path join $base) }
            [false, true, true] => { sudo hook -vi -s $project -d ($env.PROJECTS | path join $base) }
            [false, false, false] => { sudo hook -q -s $project -d ($env.PROJECTS | path join $base) }
            [true, false, false] => { sudo hook -qf -s $project -d ($env.PROJECTS | path join $base) }
            [false, true, false] => { sudo hook -qi -s $project -d ($env.PROJECTS | path join $base) }
        }
    }
}

# Open a project from the project folder
def "proj open" [
    ...project_name: string # The name of the project to launch
    --editor(-e): string # Specify the editor to use (default: from file extension) [code, vim, nvim, rider]
    --verbose(-v) # Print verbose output
] {
    let paths = fd -HI -td ^.git$ --max-depth=4 --prune $env.CODE $env.CONFIG

    if $verbose {
        print $"Paths:"
        print $paths
    }

    let project_name = $project_name | str join " "
    let result = $paths | each {|p| $p | str replace -a '\.git\' ''} | fzf -0 -1 --query $project_name

    if $verbose {
        print $"Result: ($result)"
    }

    let folder = $result

    let sln_file = ls -f $folder
        | where type == file
        | where ($it.name | str ends-with ".sln")
        | get name
        | to text

    let project = if ($sln_file | is-empty) {
        $folder
    } else {
        $sln_file
    }

    if $verbose {
        print $"Folder: ($folder)"
        print $"Project: ($project)"
    }

    if $verbose {
        if ($editor | is-not-empty) {
            print $"Editor: ($editor)"
        } else {
            print "Editor: auto"
        }
    }

    match $editor {
        "code" => { code $folder }
        "vim" => { vim $folder }
        "nvim" => { nvim $folder }
        "rider" => { rider $project }
        _ => { 
            let ext = ($project | path parse).extension
            match $ext {
                "sln" => { rider $project }
                _ => { code $folder }
            }
        }
    }
}

# History

def --env history-fzf [] {
    let selected = history
    | reverse
    | get command
    | uniq
    | to text
    | fzf --height 40% --layout=reverse

    let command = [$selected (char nl)] | str join ""
    let config_file = $env.CONFIG_PATH | path join "nushell/config.nu"
    let env_file = $env.CONFIG_PATH | path join "nushell/env.nu"
    nu --config $config_file --env-config $env_file --execute $command
}

# Extra utilities for managing the history file
def h [
    --clear(-c): int # Clears out the history entries (less than 0 clears everything)
    --clear-contains(-f): string # Clears out the history entries that match the filter
    --clear-starts-with(-s): string # Clears out the history entries that match the filter
    --long(-l) # Show long listing of entries for sqlite history
] {
    if $clear != null {
        if $clear <= 0 {
            echo "Are you sure you wish to clear everything? (y/n)"
            let response = input
            
            match $response {
                "y" | "Y" | "yes" | "Yes" => { history --clear }
                _ => { print "Exiting." }
            }

            return
        }
        
        let history = open $nu.history-path
            | lines
            | reverse
            | skip ($clear + 1)
            | reverse
        $history | append ""
            | str join "\n"
            | save --force $nu.history-path

        return
    }

    if $clear_contains != null {
        if $clear_contains == "" {
            print "An empty filter was provided, exiting."
            return
        }

        mut history = open $nu.history-path
            | lines
            | reverse
            | where ($it | str contains $clear_contains | n)
            | reverse

        $history
            | str join "\n"
            | save --force $nu.history-path

        return
    }
    
    if $clear_starts_with != null {
        if $clear_starts_with == "" {
            print "An empty filter was provided, exiting."
            return
        }

        mut history = open $nu.history-path
            | lines
            | reverse
            | where (not ($it | str starts-with $clear_starts_with))
            | reverse

        $history
            | str join "\n"
            | save --force $nu.history-path

        return
    }

    history
}

# Replace strings in the history file
def "h replace" [
    --exact(-e) # Replace only when the entire line is an exact match (excluding the newline character at the end)
    old: string # The old string to replace
    new: string # The new string to replace with
] {
    let history = open $nu.history-path
        | lines
        | each { |line|
            if $exact {
                if $line == $old {
                    $"($new)\n"
                } else {
                    $"($line)\n"
                }
            } else {
                let new_line = $line | str replace -a $old $new
                $"($new_line)\n"
            }
        }

    $history
        | str join ""
        | save --force $nu.history-path
}

# Config / Env

# Open the custom nushell config file in vscode
alias conf = start $"($nu.home-path)/.config/nushell/custom.nu"

# Open the nushell env file in vscode
alias env = start $nu.env-path

# Open the config workspace in vscode
alias dconf = code $"($nu.home-path)/.config"

# Pull the dotfiles from the remote repository
def "pull" [] {
    enter-old $"($nu.home-path)/.config"
    print "---- pulling config ----"
    git stash -u
    git pull --rebase
    git submodule update --init --recursive
    print "---- updating scoop ----"
    scoop update
    print "---- installing scoop apps ----"
    manifest install
    print "---- updating scoop apps ----"
    scoop update -a
    p # return to previous directory
}

# Push the dotfiles to the remote repository
def "push" [] {
    print "---- updating scoop manifest ----"
    manifest update
    enter-old $"($nu.home-path)/.config"
    print "---- pushing config ----"
    gcp "update config files"
    p
}

# Starship

# Open the starship config file in vscode
alias sc = start ~/.config/starship.toml

# Open the starship schema file in vscode
alias ss = start ~/.config/starship-schema.json

# Zoxide

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

# Custom version of 'enter' using zoxide and fzf. The original 'enter' command is aliased to 'enter-old'
# Add one or more directories to the list.
# PWD becomes first of the newly added directories.
def --env enter [
    ...paths: string
] {
    for _path in ($paths | reverse) {
        mut _path = $_path;
        if ($_path | str ends-with '/') or ($_path | str ends-with '\') {
            $_path = ($_path | str substring ..-1)
        }

        let target = cdq $_path;
        enter-old $target
    }
}

def "dn run" [
    --verbose(-V) # Print verbose output for the nushell script
    ...launch_profile: string
] {
    let sln = ls
    | where type == file
    | where ($it.name | str ends-with ".sln")
    | get name
    | to text
    | fzf --height 40% --layout=reverse -0 -1

    if $verbose {
        print $sln
    }

    if ($sln | is-not-empty) {
        if $verbose {
            print "Found sln file"
        }
        
        let dir = (glob "**/*.csproj"
            | path dirname
            | path relative-to $env.PWD
            | to text
            | fzf --height 40% --layout=reverse)

        if $verbose {
            print $dir
        }

        enter-old $dir
    }

    if (glob "**/*.csproj" | is-empty) {
        print "No csproj file found"
        return
    }

    let launch_settings_path = glob "**/launchSettings.json"
    | path relative-to $env.PWD
    | to text
    | fzf --height 40% --layout=reverse -0 -1

    if ($launch_settings_path | is-empty) {
        print "No launch settings found"
        return
    }

    let launch_settings = open $launch_settings_path

    if $verbose {
        print $launch_settings
    }

    let launch_profile = $launch_profile | str join " "
    let launch_profile = ($launch_settings
    | to json
    | jq ".profiles | keys[]" -r
    | fzf --height 40% --layout=reverse -0 -1 --query $launch_profile)

    dotnet run --launch-profile $launch_profile
}

def "dn us init" [
    --verbose(-v)
] {
    let sln = ls
    | where type == file
    | where ($it.name | str ends-with ".sln")
    | get name
    | to text
    | fzf --height 40% --layout=reverse -0 -1

    if $verbose {
        print $sln
    }

    if ($sln | is-not-empty) {
        if $verbose {
            print "Found sln file"
        }
        
        let dir = (glob "**/*.csproj"
            | path dirname
            | path relative-to $env.PWD
            | to text
            | fzf --height 40% --layout=reverse)

        if $verbose {
            print $dir
        }

        enter-old $dir
    }

    dotnet user-secrets init
}

def "dn us list" [
    --verbose(-v)
] {
    let sln = ls
    | where type == file
    | where ($it.name | str ends-with ".sln")
    | get name
    | to text
    | fzf --height 40% --layout=reverse -0 -1

    if $verbose {
        print $sln
    }

    if ($sln | is-not-empty) {
        if $verbose {
            print "Found sln file"
        }
        
        let dir = (glob "**/*.csproj"
            | path dirname
            | path relative-to $env.PWD
            | to text
            | fzf --height 40% --layout=reverse)

        if $verbose {
            print $dir
        }

        enter-old $dir
    }


    let secrets = dotnet user-secrets list

    mut map = {}

    for $secret in ($secrets | lines) {
        let split = ($secret | split row " = ")
        let key = $split | get 0
        let value = $split | get 1
        $map = ($map | insert $key $value)
    }

    return $map
}

def "dn us set" [
    --verbose(-v)
    key: string,
    value: string,
] {
    let sln = ls
    | where type == file
    | where ($it.name | str ends-with ".sln")
    | get name
    | to text
    | fzf --height 40% --layout=reverse -0 -1

    if $verbose {
        print $sln
    }

    if ($sln | is-not-empty) {
        if $verbose {
            print "Found sln file"
        }
        
        let dir = (glob "**/*.csproj"
            | path dirname
            | path relative-to $env.PWD
            | to text
            | fzf --height 40% --layout=reverse)

        if $verbose {
            print $dir
        }

        enter-old $dir
    }

    dotnet user-secrets set $key $value
}

def "dn us rm" [
    --verbose(-v)
] {
    let sln = ls
    | where type == file
    | where ($it.name | str ends-with ".sln")
    | get name
    | to text
    | fzf --height 40% --layout=reverse -0 -1

    if $verbose {
        print $sln
    }

    if ($sln | is-not-empty) {
        if $verbose {
            print "Found sln file"
        }
        
        let dir = (glob "**/*.csproj"
            | path dirname
            | path relative-to $env.PWD
            | to text
            | fzf --height 40% --layout=reverse)

        if $verbose {
            print $dir
        }

        enter-old $dir
    }

    let secrets = dotnet user-secrets list | lines | str replace " =" ":"

    if $verbose {
        print $secrets
    }

    let selected_secrets = $secrets | to text | fzf --multi --height 40% --layout=reverse

    if $verbose {
        print $selected_secrets
    }

    for $secret in $selected_secrets {
        let e = ($secret | str index-of ":") - 1
        let key = $secret | str substring ..$e

        if $verbose {
            print $"Deleting secret: ($key)"
        }

        dotnet user-secrets remove $key
    }
}

def "dn add" [
    --verbose(-v) # Print verbose output
    --dry-run(-d) # Print the command that would be run
    query: string
] {
    let sln = ls
    | where type == file
    | where ($it.name | str ends-with ".sln")
    | get name
    | to text
    | fzf --height 40% --layout=reverse -0 -1

    if $verbose {
        print $sln
    }

    if ($sln | is-not-empty) {
        if $verbose {
            print "Found sln file"
        }
        
        let dir = (glob "**/*.csproj"
            | path dirname
            | path relative-to $env.PWD
            | to text
            | fzf --height 40% --layout=reverse)

        if $verbose {
            print $dir
        }

        enter-old $dir
    }

    let packages = dotnet search $query --take 500

    let packages = $packages 
    | lines
    | where ($it | is-not-empty)
    | where ($it | str contains "-----" | n)
    | where ($it | str starts-with " " | n)
    | drop 1

    let headers = $packages | first
    let packages = $packages | skip 2

    if ($packages | is-empty) {
        print -e "No packages found"
        return
    }

    let name_index = ($headers | str index-of "Name")
    let description_index = ($headers | str index-of "Description")
    let author_index = ($headers | str index-of "Author")
    let version_index = ($headers | str index-of "Version")
    let downloads_index = ($headers | str index-of "Downloads")
    let verified_index = ($headers | str index-of "Verified")

    let names = $packages | each { |p|
        let end = $description_index - 1
        $p | str substring $name_index..$end | str trim
    }
    
    let authors = $packages | each { |p|
        let end = $version_index - 1
        $p | str substring $author_index..$end | str trim
    }
    
    let versions = $packages | each { |p|
        let end = $downloads_index - 1
        $p | str substring $version_index..$end | str trim
    }
    
    let downloads = $packages | each { |p|
        let end = $verified_index - 1
        $p | str substring $downloads_index..$end | str trim
    }

    let verified = $packages | each { |p|
        $p
        | str substring $verified_index..
        | str trim
        | str replace -a "*" "true"
    }

    mut packages = []

    let len = ($names | length) - 1

    if ($len <= 0) {
        print -e "No packages found"
        return
    }

    if $verbose {
        print $"Listing ($len) packages"
    }

    for i in 0..$len {
        $packages = ($packages | append {
            name: ($names | get $i),
            author: ($authors | get $i),
            version: ($versions | get $i),
            downloads: ($downloads| get $i),
            verified: ($verified| get $i)
        })
    }

    if $verbose {
        print $"Packages:"
        print $packages
    }

    let selections = $packages
    | to text
    | fzf --height 40% --layout=reverse -0 -1 --multi --query $query

    let selections = $selections | lines

    if $verbose {
        print $"Selections:"
        print $selections
    }
    
    for $selection in $selections {
        let name_start = ($selection | str index-of "name: ") + 6
        let name_end = ($selection | str index-of ", author: ") - 1
        let name = ($selection | str substring $name_start..$name_end)

        if $dry_run {
            print $"dotnet add package ($name)"
        } else {
            if $verbose {
                print $"Adding package: ($name)"
            }

            dotnet add package $name
        }
    }
}

# Dotnet test with some help to find what file you wish to test
def "dn test" [
    --verbose(-v) # Print verbose output
    name?: string
] {
    let test_folders = ls -f
    | get name
    | where ($it | str contains "test")
    | where ($it | path type | str contains "dir")

    let test_folder = $test_folders
    | to text
    | fzf --height 40% --layout=reverse -0 -1

    if $verbose {
        print $"Test folder: ($test_folder)"
    }

    if ($test_folder | is-empty) {
        print "No test folder found"
        return
    }

    enter-old $test_folder
    let projects = glob "**/*.csproj"

    if $verbose {
        print $"Projects: ($projects)"
    }

    if ($projects | is-empty) {
        print "No projects found"
        p
        return
    }

    mut namespaces = [];

    for $project in $projects {
        let dirname = ($project | path dirname)

        if $verbose {
            print $"Dirname: ($dirname)"
        }

        enter-old $dirname

        let files = glob "**/*.cs"
        | str replace -a "\\" "/"
        | where ($it | str contains "/bin/" | n)
        | where ($it | str contains "/obj/" | n)

        if ($files | is-empty) {
            print $"No files found in project: ($project)"
            p
            continue
        }

        for $file in $files {
            if $verbose {
                print $"File: ($file)"
            }

            let content = open $file | lines

            if ($content | is-empty) {
                print $"No content found in file: ($file)"
                continue
            }

            let line = ($content | where ($it | str starts-with "namespace"))

            if ($line | is-empty) {
                print $"No namespace found in file: ($file)"
                continue
            }

            let namespace = ($line | first | split row " " | get 1)
            let namespace = ($namespace | str replace -a ";" "")
            $namespaces = ($namespaces ++ $namespace)
        }

        p
    }

    p

    $namespaces = ($namespaces | each {|n|
        let split = $n | split row "."
        mut namespaces = []
        mut namespace = ""

        for part in $split {
            if ($namespace | is-empty) {
                $namespace = $part
            } else {
                $namespace = ($namespace ++ "." ++ $part)
            }

            $namespaces = ($namespaces ++ $namespace)
        }

        $namespaces
    } | flatten)

    let namespaces = ($namespaces | uniq | append "Test All")

    if $verbose {
        print $"Namespaces: ($namespaces)"
    }

    let name = if $name == null { "" } else { $name }

    let selected = ($namespaces | to text | fzf --height 40% --layout=reverse -0 -1 --query $name)

    if $verbose {
        print $"Selected: ($selected)"
    }

    if ($selected | is-empty) {
        print "No namespace selected"
        return
    }

    if $selected == "Test All" {
        print $"Running all tests in WD: ($env.PWD)"
        dotnet test
        return
    }

    print $"Running tests for: ($selected) in WD: ($env.PWD)"
    dotnet test --filter $"FullyQualifiedName~($selected)"
}

# Git

# Git status
alias gs = git status

# Git log
alias gl = git log

# Git diff
alias gd = git diff

# Git amend commit
alias gca = git commit --amend

# Git push with force and lease
alias gpf = git push --force-with-lease

# Git add patch
alias gap = git add --patch

# Git Squash
alias "git squash" = git rebase -i

# Git diff with fzf
alias gdf = git diff (git status --porcelain | lines | str substring 2.. | str trim | to text | fzf --height 40% --layout=reverse)

# Start tracking files with git
alias gt = git add --intent-to-add

# Git checkout but with fzf for branch selection
def gc [
    -b # Create and checkout a new branch
    ...branch: string
] {
    let branch = ($branch | str join "-")

    let in_workspace = (git rev-parse --git-common-dir
        | str ends-with ".git" | n)

    if $in_workspace {
        git w c $branch
        return
    }

    if $b {
        if ($branch | is-empty) {
            print "No branch name provided"
            return
        }

        git checkout -b $"($branch)"
        return
    }

    mut branch = $branch;
    if ($branch | is-empty) {
        $branch = "";
    }

    let branches = git branch -a | lines

    let branch_names = ($branches | each { |b|
        mut name = ($b | str substring 2..);

        if ($name | str starts-with "remotes/") {
            $name = ($name | str substring 8..);
            let slash = ($name | str index-of '/');
            $name = ($name | str substring ($slash + 1)..);
        }

        $name
    })

    mut $branch = $branch_names | uniq | to text | fzf --height 40% --layout=reverse -1 -0 --query $branch

    if ($branch | is-empty) {
        print "No branch selected"
        return
    }

    if ($branch | str starts-with "HEAD") {
        $branch = "HEAD"
    }

    git checkout $"($branch)"
}

# Git remote using fzf
def gr [
    --find(-f) # Find a remote
    --verbose(-v) # Print verbose output
    --name-only(-n) # Print only the name of the remote
    --consice(-c) # Print consice remote information (merge fetch and push into one line)
    --query(-q): string # Query to send to fzf
] {
    if ($name_only and (not $verbose or not $find)) {
        print "Cannot pass --name-only without --verbose and --find"
        return
    }

    if ($name_only and $consice) {
        print "Cannot pass --name-only with --consice"
        return
    }

    if $consice and not $verbose {
        print "Cannot pass --consice without --verbose"
        return
    }

    let query = if $query == null { "" } else { $query }
    match [$find, $verbose] {
        [false, false] => { git remote },
        [false, true] => {
            let remotes = (git remote -v);

            if (not $consice) {
                $remotes
            } else {
                mut table = [[info modes]; ["", ""]] | skip

                let remotes = ($remotes | lines | each { |r|
                    let split = ($r | split row " ")
                    let name_url = ($split | get 0)
                    let mode = ($split | get 1 | str replace -ar "[()]" "")
                    [[info modes]; [$name_url, $mode]]
                })

                for row in $remotes {
                    $table = ($table ++ $row)
                }

                let remotes = $table | each {|r|
                    let info = ($r | get info)
                    let modes = ($r | get modes | str join "|" | str surround "(" ")")
                    $info + " " + $modes
                }

                let groups = ($table | group-by --to-table info)
            
                mut remotes = [];
                for $it in ($groups | enumerate) {
                    let index = $it.index
                    let group = $it.item
                    let info = ($group.items | get info | uniq | str join " -- ")
                    let modes = ($group.items | get modes)
                    let mode = ($modes | str join "|")
                    let mode = $"\(($mode)\)"
                    $remotes = ($remotes ++ $"($info) ($mode)")
                }
    
                $remotes | to text
            }
        },
        [true, false] => {
            let remotes = git remote
            let target = ($remotes | lines | to text | fzf --height 40% --layout=reverse -0 -1 --query $query)

            if ($target | is-empty) {
                print "No remote selected"
                return
            }

            $target
        },
        [true, true] => {
            let remotes = git remote -v
            mut table = [[name url mode]; ["", "", ""]] | skip
            let rows = ($remotes | lines | each { |r|
                let split = ($r | split row "\t")
                let split = ($split | split row " ")
                let name = ($split | get 0)
                let url = ($split | get 1)
                let mode = ($split | get 2 | str replace -ar "[()]" "")
                [[name url mode]; [$name, $url, $mode]]
            })

            for row in $rows {
                $table = ($table ++ $row)
            }
            
            let groups = ($table | group-by --to-table name)
            
            mut remotes = [];
            for $it in ($groups | enumerate) {
                let index = $it.index
                let group = $it.item
                let name = ($group.items | get name | uniq | first)

                let url_group = ($group.items | group-by --to-table url)

                let urls_with_modes = ($url_group | each { |g|
                    let url = ($g.items | get url | first)
                    let modes = ($g.items | get mode | str join "|" | str surround "(" ")")
                    $url + " " + $modes
                })

                let url = ($urls_with_modes | str join " | ")

                $remotes = ($remotes ++ $"($name)\t($url)")
            }

            let target = ($remotes | to text | fzf --height 40% --layout=reverse -0 -1 --query $query)

            if ($target | is-empty) {
                print "No remote selected"
                return
            }

            if $name_only {
                let name = ($target | split row "\t" | first)
                $name
            } else {
                if not $consice {
                    let name = ($target | split row "\t" | first)
                    let split_urls = ($target | split row "\t" | skip | first | split row " | ")
                    $split_urls | each {|s|
                        let split = ($s | split row " ")
                        let url = ($split | get 0)
                        let modes = ($split | get 1 | str replace -ar "[()]" "" | split row "|" | each { |m| $m | str surround "(" ")" })
                        $modes | each {|m|
                            $"($name)\t($url) ($m)"
                        }
                    } | to text
                } else {
                    $target
                }
            }
        }
    }
}

# Git remote add
def "gr add" [
    name: string
    url: string
] {
    git remote add $name $url
}

# Git remote remove using fzf
def "gr rm" [
    name?: string
] {
    let target = if name == null { gr -fvc } else { gr -fvcq $name }

    if $target == null {
        return
    }

    print $"Removing remote: ($target)"
    let name = ($target | split row "\t" | first)
    git remote remove $name
}

# Git remote rename using fzf
def "gr mv" [
    --old(-o): string,
    --new(-n): string
] {
    let input = $in;
    let old = if $old != null {
        $old
    } else if $input != null {
        $input
    } else {
        gr -fvn
    }

    print $"Renaming remote: ($old)"

    let new = if $new == null {
        print "Enter the new name for the remote:"
        input
    } else {
        $new
    }

    print $"($old) -> ($new)"
    git remote rename $old $new
}

# Git branch alias
def gb [
    --all(-a)
    --show-current(-s)
    --set-upstream(-u)
] {
    if $all and $show_current {
        print "Cannot pass more than one argument"
        return
    }

    if $all {
        return (git branch --all)
    }

    if $show_current {
        return (git branch --show-current)
    }

    if $set_upstream {

    }

    git branch
}

# Git branch rename using fzf
def "gb mv" [...query: string] {
    let branches = (git branch --list | lines)
    let query = $query | str join " "
    let selected_branch = ($branches | to text | fzf --height 40% --layout=reverse -0 -1 -q $query)

    if ($selected_branch | is-empty) {
        print "No branch selected"
        return
    }

    let selected_branch = ($selected_branch | str substring 2..)
    print $"Selected branch: ($selected_branch)"
    
    print "Enter a new name for the branch:"
    let new_name = input
    let new_name = ($new_name | split row " " | str join "-")
    if ($new_name | is-empty) {
        print "No new name provided"
        return
    }
    print $"Renaming ($selected_branch) -> ($new_name)"
    git branch --move $selected_branch $new_name
}

# Git branch delete using fzf
def "gb rm" [
    --force(-f)
    ...query: string
] {
    let branches = (git branch --all | lines)
    let query = $query | str join " "
    let selected_branch = ($branches | to text | fzf --height 40% --layout=reverse -0 -q $query)

    if ($selected_branch | is-empty) {
        print "No branch selected"
        return
    }

    mut selected_branch = ($selected_branch | str substring 2..)
    
    mut remote = false

    if ($selected_branch | str starts-with "remotes") {
        $selected_branch = ($selected_branch | str substring 8..)
        $remote = true
    } 

    match [$force, $remote] {
        [false, false] => {
            print $"Deleting branch: ($selected_branch)"
            git branch --delete $selected_branch
        },
        [true, false] => {
            print $"Deleting branch even if unmerged: ($selected_branch)"
            git branch -D $selected_branch
        },
        [false, true] => {
            print $"Deleting remote branch: ($selected_branch)"
            git branch --delete --remote $selected_branch
        },
        [true, true] => {
            print $"Deleting remote branch even if unmerged: ($selected_branch)"
            git branch -D --remote $selected_branch
        }
    }
}

def "bisect start" [...query] {
    let status = git status --porcelain

    if ($status | is-not-empty) {
        print "There are uncommitted changes"
        return
    }

    git bisect start
    git bisect bad

    let query = $query | str join " "
    let chosen = git log --oneline 
    | lines 
    | to text 
    | fzf --height 40% --layout=reverse --query $query

    if ($chosen | is-empty) {
        print "No commit selected"
        return
    }

    let commit = ($chosen | split row " " | first)

    print $"Selected commit: ($commit)"
    git checkout $commit
}

def "bisect good" [] {
    git bisect good
}

def "bisect bad" [] {
    git bisect bad
}

def "bisect reset" [] {
    git bisect reset
}

# Get a link to the current github repository
def ghlink [
    --type(-t): string #Specify the link type (default: "ssh") [ssh, http]
    --owner(-o): string #Specify the owner of the repository
    repo?: string, #The repository name
] {
    if $repo == null {
        let http_match = git remote -v | find -r 'https://github\.com.*\.git'
        let is_https = $http_match | is-not-empty

        if $is_https {
            let a = $http_match | lines | first
            let s = $a | str index-of 'https://github.com'
            let e = ($a | str index-of -e '.git') + 4
            let link = $a | str substring $s..$e
            
            if $type == null or $type == "http" {
                return $link
            }

            let repo_start = $link | str index-of -e '/'
            let repo = $link | str substring $repo_start..
            let link = $link | str substring ..$repo_start
            let owner_start = ($link | str index-of -e '/') + 1
            let owner = $link | str substring $owner_start..
            return $"git@github:($owner)($repo)"
        }

        let a = git remote -v | find -r 'git@github\.com.*\.git' | lines | first
        let s = $a | str index-of 'git@github.com'
        let e = ($a | str index-of -e '.git') + 4
        let link = $a | str substring $s..$e

        if $type == null or $type == "ssh" {
            return $link
        }
        
        let repo_start = $link | str index-of -e '/'
        let repo = $link | str substring $repo_start..
        let link = $link | str substring ..$repo_start
        let owner_start = ($link | str index-of -e ':') + 1
        let owner = $link | str substring $owner_start..
        return $"https://github.com/($owner)($repo)"
    }
    
    if $owner != null {
        let link = match $type {
            "http" => { ghlink-http $owner $repo }
            "ssh" | "shh" => { ghlink-ssh $owner $repo }
            _ => { ghlink-ssh $owner $repo }
        }
        
        return $link
    }

    let owner = gh api user | jq -r '.login'
    match $type {
        "http" => { ghlink-http $owner $repo }
        "ssh" | "shh" => { ghlink-ssh $owner $repo }
        _ => { ghlink-ssh $owner $repo }
    }
}

# GitHub link using ssh
def "ghlink-ssh" [owner: string, repo: string] {
    echo $"git@github.com:($owner)/($repo).git"
}

# GitHub link using http
def "ghlink-http" [owner: string, repo: string] {
    echo $"https://github.com/($owner)/($repo).git"
}

# Git checkout main or master
def gcm [
    --pull(-p) # Pull the latest changes
    --fetch(-f) # Fetch the latest changes
] {
    do -ip { git checkout main --quiet }
    let branch = git branch --show-current
    
    if ($branch == "main") {
        print "Switched to main branch"

        if $fetch {
            print "Fetching latest changes"
            git fetch
        }

        if $pull {
            print "Pulling latest changes"
            git pull
        }

        return;
    }

    do -ip { git checkout master --quiet }
    
    let branch = git branch --show-current
    
    if ($branch == "master") {
        print "Switched to master branch"

        if $fetch {
            print "Fetching latest changes"
            git fetch
        }

        if $pull {
            print "Pulling latest changes"
            git pull
        }

        return;
    }

    print "Couldn't find main or master branch"
    return;
}

# Git add all, amend, push --force-with-lease
def gcapf [] {
    git add -A
    gca
    gpf
}

# Git commit and push
def gcp [...message: string] {
    git add -A
    let message = ($message | str join " ")
    git commit -m $"($message)"
    git push
}

def --env "git w c" [
    ...query: string
] {
    let root = git rev-parse --git-common-dir
    let worktrees = (ls worktrees | get name | path basename)
    let selected_branch = ($worktrees | to text | fzf --height 40% --layout=reverse -0 -q ($query | str join "-"))

    if ($selected_branch | is-empty) {
        print "No branch selected"
        return
    }

    cd $selected_branch
}

# Git worktree add using fzf
def --env "git w add" [
    --branch(-b): string
    ...query: string
] {
    let root = git rev-parse --git-common-dir

    enter-old $root

    let query = ($query | str join "-")

    if $branch != null {
        git worktree add -b $branch $query
        return
    }

    let branches = (git branch --all | lines)
    let selected_branch = ($branches | to text | fzf --height 40% --layout=reverse -0 -q $query)

    if ($selected_branch | is-empty) {
        print "No branch selected"
        return
    }

    mut selected_branch = ($selected_branch | str substring 2..)

    if ($selected_branch | str starts-with "remotes") {
        $selected_branch = ($selected_branch | str substring 8..)
        let slash = ($selected_branch | str index-of '/')
        $selected_branch = ($selected_branch | str substring ($slash + 1)..)
    }

    print $"Selected branch: ($selected_branch)"

    git worktree add $selected_branch
    cd $selected_branch
    print "Run 'p' to return to the previous directory"
}

# Git worktree remove using fzf
def --env "git w rm" [
    ...query: string
] {
    let root = git rev-parse --git-common-dir
    let current_dir = $env.PWD | path basename
    enter-old $root

    let query = ($query | str join "-")
    let worktrees = (ls worktrees | get name | path basename)
    let selected_branch = ($worktrees | to text | fzf --height 40% --layout=reverse -0 -q $query)

    if ($selected_branch | is-empty) {
        print "No branch selected"
        return
    }

    print $"Selected branch: ($selected_branch)"

    print $"Current dir: ($current_dir)"
    if ($current_dir == $selected_branch) {
        p
        print "Cannot remove the current directory"
        return
    }

    git worktree remove $selected_branch
    p
}

# GitHub

# Open a repo in the browser
def "gh open" [
    --verbose(-v) # Print verbose output
    --owner(-o): string
    --user(-u)
    --exact(-e)
    ...repo: string
] {
    let repo = $repo | str join " "
    if $user {
        if ($repo != null and $repo != "") {
            print "Cannot pass both --user and a repo name"
            return
        }

        if $verbose {
            print "Opening User"
        }

        mut users = [];

        if $owner != null {
            $users = ($users | append $owner)
        }


        if ($users | is-empty) {
            $users = (gh api user | jq -r '.login')
            let orgusers = gh org list -L 100 | lines
            $users = ($users | append $orgusers)
        }

        let user = if $exact {
            $users | to text | fzf --height 40% --layout=reverse -e -0 -1
        } else {
            $users | to text | fzf --height 40% --layout=reverse -0 -1
        }

        start $"https://github.com/($user)"
    }

    mut repo = $repo
    if $repo == null { $repo = "" } else {}
    
    if $owner != null {
        if $verbose {
            print $"Owner: ($owner)"
        }

        let repos = gh repo list -L 500 $owner
        let repos = ($repos | parse table "\t+" | get '1')

        if $verbose {
            print "Repos:"
            print $repos
        }
        
        if $verbose {
            print $"Repo: ($repo)"
        }

        $repo = if $exact {
            $repos | to text | fzf --height 40% --layout=reverse -e -0 -1 --query $repo
        } else {
            $repos | to text | fzf --height 40% --layout=reverse -0 -1 --query $repo
        }
    } else {
        if $verbose {
            print "No owner provided"
        }

        mut repos = gh repo list -L 500
        $repos = ($repos | parse table "\t+" | get '1')

        if $verbose {
            print "Owned Repos:"
            print $repos
        }

        let orgs = gh org list -L 100 | lines
        
        if $verbose {
            print "Orgs:"
            print $orgs
        }

        for org in $orgs {
            let orgrepos = gh repo list -L 500 $org
            let orgrepos = ($orgrepos | parse table "\t+" | get '1')
            
            if $verbose {
                print $"Org: ($org)"
                print "Repos:"
                print $orgrepos
            }

            $repos = ($repos | append $orgrepos)
        }

        if $verbose {
            print $"Repo: ($repo)"
        }

        $repo = if $exact {
            $repos | to text | fzf --height 40% --layout=reverse -e -0 -1 --query $repo
        } else {
            $repos | to text | fzf --height 40% --layout=reverse -0 -1 --query $repo
        }
    }

    if $verbose {
        print $"Repo: ($repo)"
    }

    if ($repo == "" or $repo == null) {
        print "No repo selected"
        return
    }

    let link = $"https://github.com/($repo)"
    
    if $verbose {
        print $"Link: ($link)"
    }

    start $link
}

# Autohotkey

# Start an autohotkey script
def "ahk start" [
    ...name: string
] {
    let name = ($name | str join " ")
    let path = $"($env.CONFIG)/autohotkey" | path expand

    enter-old $path
    let ahks = (ls -f
        | where type == file
        | get name
        | where ($it | str ends-with ".ahk"))
    p

    let result = ($ahks | to text | fzf --height 40% --layout=reverse -0 -1 --query $name)

    if ($result | is-empty) {
        print "No script found"
        return
    }

    print $"Starting ($result)"
    start $result
}

def --env "ahk kill" [
    --force(-f) # Force kill the process
    --verbose(-v) # Print verbose output
    ...name: string
] {
    let name = ($name | str join " ")

    let ahks = ps -l | where { |p|
        let command = $p.command
        let split = ($command | split row " ")
        ($split | length) == 2
    } | where {|p| 
        let command = $p.command
        let split = $command | split row " "
        let ahk = $split | get 0
        let name = $split | get 1
        ($ahk | str contains -i "autohotkey") and ($name | str ends-with ".ahk")
    }

    let result = ($ahks | each {|a| $a.command | split row " " | get 1} | to text | fzf --height 40% --layout=reverse -0 -1 --query $name)

    if ($result | is-empty) {
        print "No running process found"
        return
    }

    let pids = (ps -l | where ($it.command | str ends-with $result) | get pid)

    if $verbose {
        print $"Pids: ($pids)"
    }

    if ($pids | is-empty) {
        print "No running process found"
        return
    }

    for pid in $pids {
        if $verbose {
            print $"Killing ($pid)"
        }
        if $force {
            kill -f $pid
        } else {
            kill $pid
        }
    }
}

# Scoop

# Open the scoop user manifest file
alias manifest = open $"($nu.home-path)/.config/scoop/manifest.json"

# Create the scoop user manifest file
def "manifest create" [] {
    touch $"($nu.home-path)/.config/scoop/manifest.json"
}

# Update the scoop user manifest file with installed scoop apps
def "manifest update" [] {
    let old = manifest
    scoop export | save --force $"($nu.home-path)/.config/scoop/manifest.json"
    let new = manifest
    
    for bucket in $old.buckets {
        let name = $bucket.Name
        let source = $bucket.Source
        let old_bucket = $new.buckets | where Name == $name

        if $old_bucket == null or ($old_bucket | is-empty) {
            print $"Removed bucket -> ($name) : ($source)"
        }
    }

    for bucket in $new.buckets {
        let name = $bucket.Name
        let source = $bucket.Source
        let old_bucket = $old.buckets | where Name == $name

        if $old_bucket == null or ($old_bucket | is-empty) {
            print $"New bucket -> ($name) : ($source)"
        }
    }

    for app in $old.apps {
        let name = $app.Name
        let source = $app.Source
        let version = $app.Version
        let new_app = $new.apps | where Name == $name

        if $new_app == null or ($new_app | is-empty) {
            print $"Removed app -> ($name) ($version) : ($source)"
        }
    }

    for app in $new.apps {
        let name = $app.Name
        let version = $app.Version
        let source = $app.Source
        let old_app = $old.apps | where Name == $name

        if $old_app == null or ($old_app | is-empty) {
            print $"New app -> ($name) ($version) : ($source)"
            continue
        }
        
        let old_app = $old_app | first

        if ($old_app.Version) != $version {
            print $"Updated app -> ($name) from ($old_app.Version) to ($version)"
        } else if ($old_app.Source) != $source {
            print $"Moved app -> ($old_app.Name) ($old_app.Version) : ($old_app.Source) to ($name) ($version) : ($source)"
        }
    }
}

# Install scoop apps from the user manifest file
def "manifest install" [] {
    let buckets = (manifest).buckets
    
    let current = scoop bucket list | lines | filter {|l| $l | str trim | is-not-empty} | skip 2
    let current_names = $current | each {|l| $l | split row " " | get 0}
    let current_repo = $current | each {|l|
        let s = $l | str index-of "https://";
        let from_s = $l | str substring $s..;
        let e = $from_s | str index-of " ";
        $from_s | str substring ..$e;
    }

    for bucket in ($current_names | zip $current_repo) {
        let name = $bucket.0
        let source = $bucket.1
        let old_bucket = $buckets | where Name == $name

        if $old_bucket == null or ($old_bucket | is-empty) {
            print $"Removing bucket -> ($name) : ($source)"
            scoop bucket rm $name
        }
    }

    let apps = (manifest).apps

    let current = scoop list | lines | filter {|l| $l | str trim | is-not-empty} | skip 3
    let current_names = $current | each {|l| $l | split row " " | get 0}

    for app in $current_names {
        let name = $app
        let old_app = $apps | where Name == $name | get Name

        if $old_app == null or ($old_app | is-empty) {
            print $"Removing app -> ($name)"
            scoop uninstall $name
        }
    }

    $buckets | get name | zip { $buckets | get source } | each { |b| scoop bucket add $b.0 $b.1 }
    scoop import $"($nu.home-path)/.config/scoop/manifest.json"
}

# Remove the scoop user manifest file
def "manifest rm" [] {
    rm $"($nu.home-path)/.config/scoop/manifest.json"
}

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

# Scoop reinstall
def "scoop reinstall" [
    ...name: string
] {
    if ($name | str contains "/") {
        let split = ($name | split row "/")
        let app = ($split | get 1)
        scoop uninstall $app
        scoop install $name
    } else {
        scoop uninstall $name
        scoop install $name
    }
}

# Scoop uninstall with fzf
def "scoop rm" [
    ...name: string
] {
    let names = (scoop list | lines | skip 4 | each { |l| $l | split row " " | get 0 }) | where ($it | is-not-empty)

    let selected = if ($name | is-empty) {
        ($names | to text | fzf --height 40% --layout=reverse -0 -1)
    } else {
        ($names | to text | fzf --height 40% --layout=reverse -0 -1 --query ...$name)
    }

    if ($selected | is-empty) {
        print "No app selected"
        return
    }

    print $"Uninstalling ($selected)"
    scoop uninstall $selected
}

# Unleash

# List Toggles
def "unleash list" [
    --auth(-a): string
] {
    if ($auth | is-empty) {
        print "You must provide an api-key in the 'auth' flag"
        return
    }

    let raw = curl -X GET "https://features.carweb.no/api/admin/features" -H $auth
    print $raw
}

# Fun

# Wrapper for wezterm imgcat using fzf to find images
def img [
    --width(-W): int # Specify the display width; defaults to "auto" which automatically selects an appropriate size.  You may also use an integer value `N` to specify the number of cells, or `Npx` to specify the number of pixels, or `N%` to size relative to the terminal width
    --height(-H): int # Specify the display height; defaults to "auto" which automatically selects an appropriate size.  You may also use an integer value `N` to specify the number of cells, or `Npx` to specify the number of pixels, or `N%` to size relative to the terminal height
    --no-preserve-aspect-ratio(-P) # Do not respect the aspect ratio.  The default is to respect the aspect ratio
    --position(-p): string # Set the cursor position prior to displaying the image. The default is to use the current cursor position. Coordinates are expressed in cells with 0,0 being the top left cell position
    --no-move-cursor(-M) # Do not move the cursor after displaying the image. Note that when used like this from the shell, there is a very high chance that shell prompt will overwrite the image; you may wish to also use `--hold` in that case
    --hold # Wait for enter to be pressed after displaying the image
    --max-pixels(-m): int # Set the maximum number of pixels per image frame. Images will be scaled down so that they do not exceed this size, unless `--no-resample` is also used. The default value matches the limit set by wezterm. Note that resampling the image here will reduce any animated images to a single frame [default: 25000000]
    --no-resample(-R) # Do not resample images whose frames are larger than the max-pixels value. Note that this will typically result in the image refusing to display in wezterm
    --resample-format: string # Specify the image format to use to encode resampled/resized images.  The default is to match the input format, but you can choose an alternative format [default: input] [possible values: png, jpeg, input]
    --resample-filter: string # Specify the filtering technique used when resizing/resampling images.  The default is a reasonable middle ground of speed and quality [default: catmull-rom] [possible values: nearest, triangle, catmull-rom, gaussian, lanczos3]
    --resize(-r): string # Pre-process the image to resize it to the specified dimensions, expressed as eg: 800x600 (width x height). The resize is independent of other parameters that control the image placement and dimensions in the terminal; this is provided as a convenience preprocessing step
    --show-resample-timing(-t) # When resampling or resizing, display some diagnostics around the timing/performance of that operation
    --direct(-d) # Use the weztern imgcat command directly instead of going through fzf
    file_name?: string # The name of the image file to be displayed. If omitted, will attempt to read it from stdin
] {
    let stdin = $in
    mut params = []

    if $width != null {
        $params = ($params | append $"--width=($width)")
    }

    if $height != null {
        $params = ($params | append $"--height=($height)")
    }

    if $no_preserve_aspect_ratio {
        $params = ($params | append "--no-preserve-aspect-ratio")
    }

    if $position != null {
        $params = ($params | append $"--position=($position)")
    }

    if $no_move_cursor {
        $params = ($params | append "--no-move-cursor")
    }

    if $hold {
        $params = ($params | append "--hold")
    }

    if $max_pixels != null {
        $params = ($params | append $"--max-pixels=($max_pixels)")
    }

    if $no_resample {
        $params = ($params | append "--no-resample")
    }

    if $resample_format != null {
        $params = ($params | append $"--resample-format=($resample_format)")
    }

    if $resample_filter != null {
        $params = ($params | append $"--resample-filter=($resample_filter)")
    }

    if $resize != null {
        $params = ($params | append $"--resize=($resize)")
    }

    if $show_resample_timing {
        $params = ($params | append "--show-resample-timing")
    }

    if $direct {
        if ($stdin | is-empty) {
            wezterm imgcat ($params | str join " ") $file_name
            return
        }

        $stdin | wezterm imgcat ($params | str join " ") $file_name
        return
    }

    mut query = ""

    if $file_name != null {
        $query = $"($file_name) .png$ | .jpg$ | .jpeg$ | .gif$ | .bmp$ | .tiff$ | .webp$ | .ico$ | .svg$"
    } else {
        $query = $".png$ | .jpg$ | .jpeg$ | .gif$ | .bmp$ | .tiff$ | .webp$ | .ico$ | .svg$"
    }

    let file_name = fzf --height 40% --layout=reverse -0 -1 --query $query

    print $"wezterm imgcat ($params | str join ' ') ($file_name)"
    print $"Displaying image: ($file_name)"

    if ($params | is-empty) {
        wezterm imgcat $file_name
        return
    }

    wezterm imgcat ($params | str join " ") ($file_name)
}

# Echo 'Hello, $user'
alias "hello world" = echo $"Hello, (whoami)!"

# Echo 'Hello, $user'
alias "hello" = echo $"Hello, (whoami)!"

# Echo 'Hello, $user'
alias "hi" = echo $"Hi, (whoami)!"

# Echo a sentence with all the letters of the alphabet only appearing once
alias cwm = echo "Cwm fjord bank glyphs vext quiz"

# Echo a sentence with all the letters of the alphabet
alias fox = echo "The quick brown fox jumps over the lazy dog"

# Echo a sentence with all the letters of the alphabet
alias dwarf = echo "Pack my box with five dozen liquor jugs"

# Echo a sentence with all the letters of the alphabet
alias sphinx = echo "Sphinx of black quartz, judge my vow"

# Echo a sentence with all the letters of the alphabet
alias disco = echo "Amazingly few discoteques provide jukeboxes"

# Echo a sentence with all the letters of the alphabet
alias waltz = echo "Waltz, bad nymph, for quick jigs vex"

# Echo the lorem ipsum text
# proof: ignore
def lorem [] {
    let lorem = [
        "Lorem ipsum dolor sit amet, erroribus constituam duo ut. Eum audiam disputando",
        "\nne, ius an assum offendit consequat. Per iuvaret detraxit et, nominati torquatos",
        "\ncu nec. Ei ius luptatum explicari, ex has dolorum facilisis voluptatum. Te sed",
        "\ntibique recteque imperdiet, altera invidunt liberavisse cu has. Id qui probo",
        "\ndolorem, tota porro ei eum.",
        "\n",
        "\nCu duo nostrum invenire, laboramus vituperata conclusionemque et quo. Errem",
        "\niudico et vim, no omnium accusata ius. Detracto argumentum vis et. Nam liber",
        "\nessent facete in, in eum virtute ancillae, dico magna ea cum.",
        "\n",
        "\nIn audire pertinax vis, sed id insolens mnesarchum mediocritatem. Enim labore et",
        "\nquo, nam ex aperiam interesset. Vis nonumy aliquip ei, nec habeo ridens impedit",
        "\nei. Ea eam eleifend posidonium, no quo enim consequuntur, usu eu omnesque",
        "\niracundia. Vim cu tamquam argumentum disputando.",
        "\n",
        "\nNo his iracundia voluptatibus, eos assum placerat no. Ex vel vivendo copiosae.",
        "\nAccusam sapientem eam eu, ex duo solum ludus, an equidem accusamus euripidis",
        "\nmel. Case epicurei ad sed, rebum nominati vix ei, tota ceteros corrumpit has in.",
        "\n",
        "\nId sit graece quodsi prodesset. Cu est sint elaboraret, sed veri timeam no.",
        "\nRebum fugit populo eu eos. Eu regione enserit honestatis vix, nobis detraxit",
        "\nduo ut. Te audiam iisque vel. Id cum choro efficiantur, per eu ubique discere",
        "\nscripserit, nec meliore accusam invidunt id. Stet fabellas qui an, mei id",
        "\nplacerat ponderum.",
        "\n",
        "\nGraeco singulis ei per, no tation interpretaris sed. Vim agam petentium an,",
        "\nte per wisi ludus homero. Ea iuvaret efficiendi mea, vide assum dolorum ius",
        "\nno. Fabulas feugait no cum. Nobis epicurei abhorreant vel eu, rebum dolor vim",
        "\nad, vel menandri praesent intellegam no. Quo corpora percipitur et, ut admodum",
        "\nullamcorper mel.",
        "\n",
        "\nDecore suscipiantur duo ei. Nec id hinc libris. Dolorum lucilius principes eos",
        "\ncu, eam ad tation alterum. Posse probatus at est.",
        "\n",
        "\nEirmod option philosophia ne mel. Ut magna eirmod eos. Putant everti salutatus",
        "\neu has. Affert patrioque persequeris usu ne. No vocent iuvaret elaboraret vis,",
        "\nne sit vitae urbanitas omittantur. Has eripuit splendide efficiantur ad, ad eos",
        "\nomnium docendi salutandi.",
        "\n",
        "\nNe dicant adipiscing constituam mea. Vivendum disputationi sed id. Mel tale",
        "\ntantas no. Eu odio consulatu ullamcorper vel, nam aliquip oportere consulatu at.",
        "\nNe iudico consequuntur eos, facilis laboramus id pri, no mea cibo salutandi.",
        "\n",
        "\nSonet adipiscing an nec. Quo at erroribus explicari, dissentiunt disputationi eu",
        "\nest. Elit sale sonet no ius. An vis libris dolorum. At cibo corrumpit duo. Vis",
        "\nei omnium audiam admodum.",
        "\n",
        "\nSit et probo antiopam elaboraret, ei fabulas blandit mei. Assum labitur civibus",
        "\nin quo. Clita minimum sit eu, vel nulla ludus persecuti ei. Suscipit appetere",
        "\nvivendum te sea. Te nec officiis nominati pericula, cu habeo dicam eum, velit",
        "\nscripta maluisset no sed.",
        "\n",
        "\nEt graeci aliquip deserunt est. Qui detracto similique eu. Pro cu assentior",
        "\nmediocritatem, his zril facilis vivendum ut. Duo no error periculis",
        "\nvituperatoribus. Ius solum labore antiopam ei, blandit salutandi adolescens eam",
        "\ncu, prodesset contentiones reprehendunt id vix.",
        "\n",
        "\nPri diceret eruditi ea, reque impetus duo in. Pri brute munere corrumpit te, ex",
        "\nfacete omnesque democritum vim. An modus labore duo, stet regione temporibus ne",
        "\nsed. His no veri vivendo maiestatis, ad liber officiis eum.",
        "\n",
        "\nVide regione iuvaret his an. Ne vis tibique suavitate, at usu legimus",
        "\nadolescens. Te per oratio verear, cu sumo magna sea, vim no sumo graeci",
        "\nrecusabo. Natum forensibus argumentum nec no, dico nemore aeterno id sed, mei",
        "\nquod indoctum argumentum an. Vel euismod reprehendunt at, cum ne dicunt commune",
        "\niudicabit. Cum ne debitis inciderint reprehendunt, vix albucius dissentias",
        "\nconcludaturque in.",
        "\n",
        "\nVim brute aliquam repudiandae eu. Qui ludus ceteros salutatus id. Vel te melius",
        "\ninermis, sea at maluisset similique. Consul nostrum ei vim. Mea eius aperiam",
        "\nmnesarchum te.",
        "\n",
        "\nCu nibh verterem electram per. Iusto noster nam ad, ius ne eligendi inimicus.",
        "\nNisl intellegam neglegentur an mel, in eos diam agam possit, mea cu assum",
        "\nconclusionemque. Nihil invidunt facilisi mea et, ea populo nusquam ius. Nec",
        "\nte quem aliquid, usu ex soleat expetendis quaerendum. Mel at iriure mentitum",
        "\npostulant, vivendum contentiones est eu. Sea an tollit convenire temporibus.",
        "\n",
        "\nVis ad quis falli, est ad dictas dicunt adipisci. Laudem consulatu ex vix,",
        "\npostea platonem theophrastus eu eos, copiosae appetere adipiscing vim ad. Vim",
        "\nnulla recteque ei, vix ex etiam dicam invidunt. Mea ne graece patrioque. Pri cu",
        "\ntation recusabo interesset. His at doctus copiosae signiferumque.",
        "\n",
        "\nInvenire patrioque ei eum, brute putent te vim. Legere cetero qui ex, deseruisse",
        "\ncotidieque consequuntur mel ea. Enim choro id mel. Usu no labitur fuisset",
        "\ntemporibus.",
        "\n",
        "\nMei an nibh definiebas, odio aperiam consequat vis no. Ut duo veri impedit",
        "\nrationibus. Est eu erat ancillae. Nobis docendi appareat eam cu, erant laudem an",
        "\nquo.",
        "\n",
        "\nQuo ex labitur quaeque ocurreret. Honestatis eloquentiam appellantur est ei, mei",
        "\nveritus nusquam at. Vis te periculis conclusionemque, sed ne integre luptatum",
        "\nconstituto. Eos ex accumsan forensibus conclusionemque. Verterem conclusionemque",
        "\nno sea, sed soluta fabulas ex. Clita detracto lucilius eu sea, nam esse recusabo",
        "\nne, aperiri adipiscing no sed. Tale persius comprehensam qui id, qui aliquam",
        "\nconstituam et."
    ]

    let result = $lorem | str join ""
    echo $result
}
