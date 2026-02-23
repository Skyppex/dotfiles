# find a project below the current cwd
def --env find-projects []: nothing -> table<type: string, opt: any> {
    let options = fd --type f --max-depth 1 --regex '^(flake\.nix|Cargo\.toml|go\.mod|.*\.slnx?|.*\.csproj|.*\.kt|build\.gradle\.kts|gradlew(\.bat)?)$'

    if ($options | is-empty) {
        if (pwd) == "/" {
            print --stderr 'Not a recognized project directory'
            print --stderr 'Currently recognized project types are:'
            print --stderr ' - nix (^flake.nix$)'
            print --stderr ' - cargo (^Cargo.toml$)'
            print --stderr ' - go (^go.mod$)'
            print --stderr ' - dotnet (.*\.slnx?$, .*\.csproj$)'
            # print --stderr ' - Kotlin (*\.kt$, build\.gradle\.kts$, gradlew(\.bat)?$)'
            return
        }

        enter ..
        let options = find-projects
        return $options
    }

    let options = $options | lines | each { |opt|
        mut o: record<type: string, opt: any> = {}

        if ($opt | str contains "flake.nix") {
            $o = { type: "nix", opt: $opt }
        }

        if ($opt | str contains "Cargo.toml") {
            $o = { type: "cargo", opt: $opt }
        }

        if ($opt | str contains "go.mod") {
            $o = { type: "go", opt: $opt }
        }

        if (($opt | str contains ".sln")
            or ($opt | str contains ".csproj")) {
            $o = { type: "dotnet", opt: $opt }
        }

        if (($opt | str contains ".kt")
            or ($opt | str contains "build.gradle.kts")
            or ($opt | str contains "gradlew")) {
            $o = { type: "kotlin", opt: $opt }
        }

        $o
    }

    return $options
}

# select a project from a list of discovered projects
def select-project [
    --multi(-m)
]: table<type: string, opt: any> -> table<type: string, opt: any> {
    let options = $in

    if ($options | any { |o| $o.type == "nix" }) and (which nix | is-not-empty) {
        let nix = $options | where { |o| $o.type == "nix" }
        return $nix
    }

    let selected = if $multi {
        $options | get type | to text | fzf --multi --height 40% --layout reverse -0 -1
    } else {
        $options | get type | to text | fzf --height 40% --layout reverse -0 -1
    }

    if ($selected | is-empty) {
        print --stderr "No project type selected"
        return
    }

    let filtered_options = $options | where { |o| $selected | lines | any { |s| $s == $o.type } }

    return $filtered_options
}

# build a project in the current directory
def --wrapped build [
    --debug(-d)
    --release(-r)
    ...rest: string
] {
    let options = find-projects

    if ($options | is-empty) {
        return
    }

    let selected = $options | select-project --multi

    if ($selected | is-empty) {
        print --stderr "No project type selected"
        return
    }

    for $s in $selected {
        match $s.type {
            "nix" => {
                if $release {
                    nix build .#release ...$rest
                } else if $debug {
                    nix build .#debug ...$rest
                } else {
                    nix build ...$rest
                }
            }
            "cargo" => {
                if $release {
                    do -i { cargo build --release ...$rest }
                } else {
                    do -i { cargo build ...$rest }
                }
            }
            "dotnet" => {
                if $release {
                    do -i { dotnet build --configuration Release ...$rest }
                } else {
                    do -i { dotnet build ...$rest }
                }
            }
            "go" => {
                do -i { go build ...$rest }
            }
        }
    }
}

alias b = build

def --wrapped run [...rest] {
    let options = find-projects

    if ($options | is-empty) {
        return
    }

    let selected = $options | select-project | get 0

    if ($selected | is-empty) {
        print --stderr "No project type selected"
        return
    }

    match $selected.type {
        "nix" => {
            nix run . -- ...$rest
        }
        "cargo" => {
            cargo run -- ...$rest
        }
        "dotnet" => {
            dn run ...$rest
        }
        "go" => {
            go run . ...$rest
        }
    }
}

alias r = run

def --wrapped test [
    --all(-a)
    ...rest
] {
    let options = find-projects

    if ($options | is-empty) {
        return
    }

    let selected = $options | select-project | get 0

    if ($selected | is-empty) {
        print --stderr "No project type selected"
        return
    }

    match $selected.type {
        "nix" => {
            if $all {
                nix flake check --all-systems ...$rest
            } else {
                nix flake check ...$rest
            }
        }
        "cargo" => {
            if $all {
                cargo test --workspace --all-targets ...$rest
            } else {
                cargo test ...$rest
            }
        }
        "dotnet" => {
            if $all {
                dn test all ...$rest
            } else {
                dn test
            }
        }
        "go" => {
            if $all {
                go test "./..." ...$rest
            } else {
                go test ...$rest
            }
        }
    }
}

alias t = test
