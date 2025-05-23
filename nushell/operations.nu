# find a project below the current cwd
def find-projects []: nothing -> table<type: string, opt: any> {
    let options = fd --type f --max-depth 1 --regex '^(Cargo\.toml|go\.mod|.*\.sln|.*\.csproj|.*\.kt|build\.gradle\.kts|gradlew(\.bat)?)$'

    if ($options | is-empty) {
        print 'Not a recognized project directory'
        print 'Currently recognized project types are:'
        print ' - Rust (^Cargo.toml$)'
        print ' - Go (^go.mod$)'
        print ' - C# (.*\.sln$, .*\.csproj$)'
        print ' - Kotlin (*\.kt$, build\.gradle\.kts$, gradlew(\.bat)?$)'
        return
    }

    let options = $options | lines | each { |opt|
        mut o: record<type: string, opt: any> = {}

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
def select-projects []: table<type: string, opt: any> -> table<type: string, opt: any> {
    let options = $in
    let selected = $options | get type | to text | fzf --multi -0 -1

    if ($selected | is-empty) {
        print "No project type selected"
        return
    }

    print $options
    print $selected

    return $options | where { |o| $selected | lines | any { |s| $s == $o.type } }
}

# build a project in the current directory
def build [--release(-r)] {
    let options = find-projects
    let selected = $options | select-projects

    if ($selected | is-empty) {
        print "No project type selected"
        return
    }

    for $s in $selected {
        match $s.type {
            "Rust" => {
                if $release {
                    cargo build --release
                } else {
                    cargo build
                }
            }
        
            "C#" => {
                if $release {
                    dotnet build --configuration Release
                } else {
                    dotnet build
                }
            }

            "Go" => {

                if ($s | str ends-with "go.mod") {
                    go build
                }
            }
        }
    }
}

alias b = build

def --wrapped run [...rest] {
    let options = fd --type f --max-depth 1 --regex '^(Cargo\.toml|go\.mod|.*\.sln|.*\.csproj)$'

    if ($options | is-empty) {
        print 'Not a recognized project directory'
        print 'Currently recognized project types are:'
        print ' - Rust (^Cargo.toml$)'
        print ' - Go (^go.mod$)'
        print ' - C# (.*\.sln$, .*\.csproj$)'
        return
    }

    let selected = $options | fzf -0 -1

    if ($selected | is-empty) {
        print "No project type selected"
        return
    }

    if ($selected | str ends-with "Cargo.toml") {
        cargo run ...$rest
    }
    
    if ($selected | str ends-with ".sln") {
        dn run ...$rest
    }

    if ($selected | str ends-with ".csproj") {
        dn run ...$rest
    }

    if ($selected | str ends-with "go.mod") {
        go run ...$rest
    }
}

