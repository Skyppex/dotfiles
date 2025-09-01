# find a project below the current cwd
def find-projects []: nothing -> table<type: string, opt: any> {
    let options = fd --type f --max-depth 1 --regex '^(flake\.nix|Cargo\.toml|go\.mod|.*\.sln|.*\.csproj|.*\.kt|build\.gradle\.kts|gradlew(\.bat)?)$'

    if ($options | is-empty) {
        print --stderr 'Not a recognized project directory'
        print --stderr 'Currently recognized project types are:'
        print --stderr ' - Nix (^flake.nix$)'
        print --stderr ' - Rust (^Cargo.toml$)'
        print --stderr ' - Go (^go.mod$)'
        print --stderr ' - C# (.*\.sln$, .*\.csproj$)'
        # print --stderr ' - Kotlin (*\.kt$, build\.gradle\.kts$, gradlew(\.bat)?$)'
        return
    }

    let options = $options | lines | each { |opt|
        mut o: record<type: string, opt: any> = {}

        if ($opt | str contains "flake.nix") {
            $o = { type: "Nix", opt: $opt }
        }

        if ($opt | str contains "Cargo.toml") {
            $o = { type: "Rust", opt: $opt }
        }

        if ($opt | str contains "go.mod") {
            $o = { type: "Go", opt: $opt }
        }

        if (($opt | str contains ".sln")
            or ($opt | str contains ".csproj")) {
            $o = { type: "C#", opt: $opt }
        }

        if (($opt | str contains ".kt")
            or ($opt | str contains "build.gradle.kts")
            or ($opt | str contains "gradlew")) {
            $o = { type: "Kotlin", opt: $opt }
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

    let selected = if $multi {
        $options | get type | to text | fzf --multi -0 -1
    } else {
        $options | get type | to text | fzf -0 -1
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
            "Nix" => {
                if $release {
                    nix build .#release
                } else if $debug {
                    nix build .#debug
                } else {
                    nix build
                }
            }
            "Rust" => {
                if $release {
                    do -i { cargo build --release ...$rest }
                } else {
                    do -i { cargo build ...$rest }
                }
            }
            "C#" => {
                if $release {
                    do -i { dotnet build --configuration Release ...$rest }
                } else {
                    do -i { dotnet build ...$rest }
                }
            }
            "Go" => {
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
        "Rust" => {
            cargo run ...$rest
        }
        "C#" => {
            dn run ...$rest
        }
        "Go" => {
            go run ...$rest
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
        "Rust" => {
            if $all {
                cargo test --workspace --all-targets ...$rest
            } else {
                cargo test ...$rest
            }
        }
        "C#" => {
            if $all {
                dn test all ...$rest
            } else {
                dn test
            }
        }
        "Go" => {
            go test ...$rest
        }
    }
}

alias t = test
