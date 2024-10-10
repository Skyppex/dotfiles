# Dotnet run from sln using fzf to select project and launch profile
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

def "dn us ls" [
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

def "dn test all" [] {
    dotnet test
}

