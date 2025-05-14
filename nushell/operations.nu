# build a project in the current directory
def build [--release(-r)] {
    let options = fd --type f --max-depth 1 --regex '^(Cargo\.toml|go\.mod|.*\.sln|.*\.csproj)$'

    if ($options | is-empty) {
        print 'Not a recognized project directory'
        print 'Currently recognized project types are:'
        print ' - Rust (^Cargo.toml$)'
        print ' - Go (^go.mod$)'
        print ' - C# (.*\.sln$, .*\.csproj$)'
        return
    }

    let selected = $options | fzf --multi -0 -1 --query "^Cargo.toml$ | .sln$ | .csproj$ | ^go.mod$"

    if ($selected | is-empty) {
        print "No project type selected"
        return
    }

    for $s in $selected {
        if ($s | str ends-with "Cargo.toml") {
            if $release {
                cargo build --release
            } else {
                cargo build
            }
        }
        
        if ($s | str ends-with ".sln") {
            if $release {
                dotnet build --configuration Release
            } else {
                dotnet build
            }
        }

        if ($s | str ends-with ".csproj") {
            if $release {
                dotnet build --configuration Release
            } else {
                dotnet build
            }
        }

        if ($s | str ends-with "go.mod") {
            go build
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

    let selected = $options | fzf -0 -1 --query "^Cargo.toml$ | .sln$ | .csproj$ | ^go.mod$"

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

