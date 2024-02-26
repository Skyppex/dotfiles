use ~/.cache/starship/init.nu
source ~/.config/zoxide/.zoxide.nu

export extern "dice" [
    --help(-h) # Print a more detailed help message
    --expr(-e) # Print the expression used to calculate the result
    --time(-t) # Print the time it took to calculate the result
    --mode(-m): string #Specify the evaluation mode (default: "random") [avg, simavg:uint, min, max, med]
    ...roll: string # The dice roll to calculate. eg: 2d6+1 or 2d20k or 2d20kl or 1d6! or 1d6!! or 1d6r<=5 or 1d6r=!6
]

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

export extern "clip" []

alias q = exit
alias conf = code $"($nu.home-path)/.config/nushell/custom.nu"
alias env = code $nu.env-path
alias dconf = code $"($nu.home-path)/.config"
alias sc = code ~/.config/starship.toml
alias ss = code ~/.config/starship-schema.json
alias md = mkdir
alias sh = bash
alias loc = echo $"($env.PWD)"
alias paste = powershell -command "Get-Clipboard"
alias cdq = zoxide query

alias manifest = open $"($nu.home-path)/.config/scoop/user_manifest.json"

def "manifest create" [] {
    touch $"($nu.home-path)/.config/scoop/user_manifest.json"
}

def "manifest update" [] {
    scoop export | save --force $"($nu.home-path)/.config/scoop/user_manifest.json"
}

def "manifest install" [] {
    scoop import $"($nu.home-path)/.config/scoop/user_manifest.json"
}

def "manifest rm" [] {
    rm $"($nu.home-path)/.config/scoop/user_manifest.json"
}

def "git sync" [message: string] {
    git pull --rebase
    git submodule update --init --recursive
    gcp $message
}

def "pull dot" [] {
    let path = loc;
    cd $"($nu.home-path)/.config"
    print "---- pulling config ----"
    git pull --rebase
    git submodule update --init --recursive
    print "---- updating scoop ----"
    scoop update
    print "---- installing scoop apps ----"
    manifest install
    print "---- updating scoop apps ----"
    scoop update -a
    cd $path
}

def "push dot" [] {
    print "---- fixing nushell plugins ----"
    open ~/.config/nushell/plugin.nu | str replace -ar '[Cc]:\\[Uu]sers\\.*?\\' '~\' | save -f ~/.config/nushell/plugin.nu
    print "---- updating scoop manifest ----"
    manifest update
    let path = loc;
    cd $"($nu.home-path)/.config"
    print "---- pushing config ----"
    gcp "sync config"
    cd $path
}

def rmdl [] {
    let files = ls ~/Downloads
    for file in $files {
        rm -rv $file.name
    }
}

def "plugin add" [name: string] {
    let plugin = $"~/.cargo/bin/($name).exe";
    nu -c $'register ($plugin)'
    version
}

def gprs [] {
    git pull --rebase
    git submodule update --init --recursive
}

def gcp [message: string] {
    git add -A
    git commit -m $"($message)"
    git push
}

alias gpf = git push --force-with-lease

def gsw [branch: string] {
    git stash -u
    git checkout $"($branch)"
}
