let manifest_path = $"($env.CHEZMOI_PATH)/scoop/manifest.json";

# Open the scoop user manifest file
alias manifest = open $manifest_path

# Create the scoop user manifest file
def "manifest create" [] {
    touch $manifest_path
}

# Update the scoop user manifest file with installed scoop apps
def "manifest update" [] {
    let old = manifest
    scoop export | save --force $manifest_path
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
    
    let current = scoop bucket list 
    | lines 
    | where {|l| $l | str trim | is-not-empty} 
    | skip 2

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

    $buckets 
    | get name 
    | zip { $buckets | get source } 
    | each { |b| scoop bucket add $b.0 $b.1 }

    scoop import $manifest_path
}

# Remove the scoop user manifest file
def "manifest rm" [] {
    rm $manifest_path
}

# Scoop reinstall
def "scoop reinstall" [
    name: string
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
    let names = scoop list 
    | lines 
    | skip 4 
    | each { |l| $l | split row " " | get 0 } 
    | where ($it | is-not-empty)

    let selected = if ($name | is-empty) {
        $names 
        | to text 
        | fzf --height 40% --layout=reverse -0 -1
    } else {
        $names 
        | to text 
        | fzf --height 40% --layout=reverse -0 -1 --query ...$name
    }

    if ($selected | is-empty) {
        print "No app selected"
        return
    }

    print $"Uninstalling ($selected)"
    scoop uninstall $selected
}

