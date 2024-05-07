use ~/.cache/starship/init.nu
source ~/.config/zoxide/.zoxide.nu

# Externs

# Calculate the result of a dice roll
export extern "dice" [
    --help(-h) # Print a more detailed help message
    --expr(-e) # Print the expression used to calculate the result
    --time(-t) # Print the time it took to calculate the result
    --mode(-m): string #Specify the evaluation mode (default: "random") [avg, simavg:uint, min, max, med]
    ...roll: string # The dice roll to calculate. eg: 2d6+1 or 2d20k or 2d20kl or 1d6! or 1d6!! or 1d6r<=5 or 1d6r=!6
]

# Curl
export extern curl [
    --help(-h) # Get help for commands
    --data(-d): string # <data> HTTP POST data
    --fail(-f) # Fail fast with no output on HTTP errors
    --include(-i) # Include protocol response headers in the output
    --output(-o): string # <file> Write to file instead of stdout
    --silent(-s) # Silent mode
    --upload-file(-T): string # <file> Transfer local FILE to destination
    --user(-u): string # <user:password> Server user and password
    --user-agent(-A): string # <name> Send User-Agent <name> to server
    --verbose(-v) # Make the operation more talkative
    --version(-V) # Show version number and quit
    url: string
]

# Copy to clipboard
export extern "clip" []

# Cascading print
export extern "cascade" [
    --message(-m): string # The message to cascade print
    --loop(-l) # Whether to loop the program
    --help(-h) # Print help
    --version(-V) # Print version
]

# Remember the old enter command
alias enter-old = enter;

# Neovim

# Open neovim
alias vim = nvim

# Utils

def "str surround" [
    start: string,
    end: string
] {
   $"($start)($in)($end)"
}

def fuck [
    --yes(-y),
    --yeah,
    --hard,
    --repeat(-r),
    --debug(-d)
    --enable-experimental-instant-mode,
    --shell-logger(-l)
    --help(-h),
    --version(-v),
] {
    if $help { thefuck -h; return }
    if $version { thefuck -v; return }

    mut options = []

    if $yes or $yeah or $hard { $options = ($options | append "-y") }
    if $repeat { $options = ($options | append "-r") }
    if $debug { $options = ($options | append "-d") }
    if $enable_experimental_instant_mode { $options = ($options | append "--enable-experimental-instant-mode") }
    if $shell_logger { $options = ($options | append "-l") }

    let options = ($options | str join " ")
    let hist = (history | last 1) | get command.0
    let fuck = $"(TF_ALIAS=fuck PYTHONIOENCODING=utf-8 thefuck $options $hist)"
    nu -e $"($fuck | str replace -a "\r" "" | str replace -a "\n" "")"
}

# Elevate the current shell to admin
alias sudo = gsudo

# Exit
alias q = exit

# Make directory
alias md = mkdir

# Bash
alias sh = bash

# Current working directory
alias loc = echo $"($env.PWD)"

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

alias proj = ls $env.PROJECTS;

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
    --verbose(-v) # Pass verbose to the hook command
    ...project: string # The name of the project to add
] {
    if $force and $interactive {
        print "Cannot pass both force and interactive together"
        return
    }

    let project_folder = $env.PROJECTS | path basename

    let project = $project | str join " "
    mut project = fzf -0 -1 --query ($"($project) !($project_folder) .sln$ | Cargo.toml$")

    let base = if ($project | str ends-with "Cargo.toml") {
        let ret = $project | path dirname | path basename
        $project = ($project | path dirname)
        $ret
    } else {
        $project | path basename
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
    project_name: string # The name of the project to launch
    --editor(-e): string # Specify the editor to use (default: from file extension) [code, vim, nvim, rider]
    --verbose(-v) # Print verbose output
] {
    enter-old $env.PROJECTS
    let result = (ls | get name | to text | fzf -0 -1 -f $project_name)
    p

    if ($result | is-empty) or $result == null or $result == "" {
        print "No project found"
        return
    }

    let result = $result | lines | first

    if $verbose {
        print $"Result: ($result)"
    }

    mut folder = $env.PROJECTS | path join $result | path expand

    if (($folder | path parse).extension | is-not-empty) {
        $folder = ($folder | path dirname)
    }

    if $verbose {
        print $"Folder: ($folder)"
    }
    
    let project = $env.PROJECTS | path join $result | path expand

    if $verbose {
        print $"Project: ($project)"
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
            | where ($it | str contains --not $clear_contains)
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
    print "---- fixing nushell plugins ----"
    open ~/.config/nushell/plugin.nu | str replace -ar '[Cc]:\\[Uu]sers\\.*?\\' '~\' | save -f ~/.config/nushell/plugin.nu
    print "---- updating scoop manifest ----"
    manifest update
    enter-old $"($nu.home-path)/.config"
    print "---- pushing config ----"
    gcp "update config files"
    p
}

# Startship

# Open the starship config file in vscode
alias sc = start ~/.config/starship.toml

# Open the starship schema file in vscode
alias ss = start ~/.config/starship-schema.json

# Zoxide

alias cdi = __zoxide_zi;

def --env z [...path: string] {
    if ($path == null or ($path | is-empty)) {
        __zoxide_z
        return
    }

    let current = $env.PWD
    __zoxide_z ...$path
    let new = $env.PWD

    if $current == $new {
        let target = (ls | get name | to text | fzf -0 -1 --query ...$path)
        if $target == null or $target == "" {
            print "No result found."
            return
        }
        __zoxide_z $target
    }
}

alias cd = z

# Zoxide query
alias cdq = zoxide query

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

# Git

# Git amend commit
alias gca = git commit --amend

# Git push with force and lease
alias gpf = git push --force-with-lease

# Git checkout but with fzf for branch selection
def gc [
    -b # Create and checkout a new branch
    ...branch: string
] {
    let branch = ($branch | str join "-")

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

    mut $branch = $branch_names | uniq | to text | fzf -1 -0 --query $branch

    if ($branch | str starts-with "HEAD") {
        $branch = "HEAD"
    }

    git checkout $"($branch)"
    git fetch
}

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
                for -n $it in $groups {
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
            let target = ($remotes | lines | to text | fzf -0 -1 --query $query)

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
            for -n $it in $groups {
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

            let target = ($remotes | to text | fzf -0 -1 --query $query)

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

def "gr add" [
    name: string
    url: string
] {
    git remote add $name $url
}

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

def "ghlink-ssh" [owner: string, repo: string] {
    echo $"git@github.com:($owner)/($repo).git"
}

def "ghlink-http" [owner: string, repo: string] {
    echo $"https://github.com/($owner)/($repo).git"
}

# Git checkout main or master
def gcm [] {
    do -ip { git checkout main --quiet }
    let branch = git branch --show-current
    
    if ($branch == "main") {
        print "Switched to main branch"
        git fetch
        return;
    }

    do -ip { git checkout master --quiet }
    
    let branch = git branch --show-current
    
    if ($branch == "master") {
        print "Switched to master branch"
        git fetch
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

# GitHub

# Open a repo in the browser
def "gh open" [
    --verbose(-v) # Print verbose output
    --owner(-o): string
    --user(-u)
    repo?: string
] {
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

        let user = ($users | to text | fzf -0 -1)
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
        
        $repo = ($repos | to text | fzf -0 -1 --query $repo)
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

        $repo = ($repos | to text | fzf -0 -1 --query $repo)
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

# Scoop

# Reinstall an app
# This uninstalls all versions of the app and then installs the latest version
def "scoop reinstall" [
    app?: string
] {
    print $"Reinstalling ($app)"
    mut app = $app;
    let apps = (scoop list | parse table -s 2 -hcv " +")
    print $apps

    if $app == null {
        $app = ($apps | get name | fzf | lines | first)
    } else {
        $app = ($apps | get name | fzf -0 -1 -f $app | lines | first)
    }

    print $"Reinstalling ($app)"
    # scoop uninstall $app
    # scoop install $app
}

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

    $buckets | get name | zip { $buckets | get source } | each { |b| scoop bucket add $b.0 $b.1 }
    scoop import $"($nu.home-path)/.config/scoop/manifest.json"
}

# Remove the scoop user manifest file
def "manifest rm" [] {
    rm $"($nu.home-path)/.config/scoop/manifest.json"
}

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
        for -n $name in $header_col {
            let i = (($name.index + 1) | to text);
            $rows = ($rows | rename -c {$i: $name.item})
        }
        
        if $verbose {
            print $"Rows:\n($rows)"
        }
    }

    $rows
}

# Nushell

# Add a plugin to the nushell config
def "plugin add" [name: string] {
    let plugin = $"~/.cargo/bin/($name).exe";
    nu -c $'register ($plugin)'
    version
}

# Fun

# Echo 'Hello, $user'
alias "hello world" = echo $"Hello, (whoami)!"

# Echo a sentence with all the letters of the alphabet only appearing once
alias cwm = echo "Cwm fjord bank glyphs vext quiz"

# Echo a sentence with all the letters of the alphabet
alias fox = echo "The quick brown fox jumps over the lazy dog"

# Echo a sentence with all the letters of the alphabet
alias dwarf = echo "Pack my box with five dozen liquor jugs"

# Echo a sentence with almost all the letters of the alphabet (no f)
alias sphinx = echo "Sphinx of black quartz, judge my vow"

# Echo the lorem ipsum text
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
