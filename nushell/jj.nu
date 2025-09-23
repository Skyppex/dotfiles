# Jujutsu status
alias js = jj status

# Jujutsu log
alias jl = jj log

# Jujutsu diff
alias jd = jj diff

# Jujutsu restore
alias jrs = jj restore

# Jujutsu describe
alias jds = jj describe

# Jujutsu diff with fzf
alias jdf = jj diff (jj diff --name-only | fzf --height 40% --layout=reverse)

# Jujutsu edit
alias je = jj edit

# Conventional describe
def jcc [
    --type(-t): string # Specify the type of the commit
    --scope(-s): string # Specify the scope of the commit
    --no-details(-n) # Do not prompt for a description
    ...message: string
] {
    let types = [
        "fix",
        "feat",
        "docs",
        "style",
        "refactor",
        "test",
        "chore",
        "revert",
        "wip"
    ]

    if ($type | is-not-empty) {
        if ($types | any { |t| $t == $type } | n) {
            print $"Invalid type: ($type)"
            return
        }
    }

    let type = if ($type | is-empty) {
        gum filter --height=9 ...$types 
    } else {
        $type
    }

    if ($type | is-empty) {
        print "No type provided"
        return
    }

    let scope = if ($scope | is-empty) {
        let s = (gum input --placeholder "scope")
        if ($s | is-empty) { "" } else { $"\(($s)\)" }
    } else {
        if $scope == "none" { "" } else { $"\(($scope)\)" }
    }

    let summary = if ($message | is-not-empty) {
        $"($type + $scope): ($message | str join ' ')"
    } else {
        gum input --value $"($type + $scope): " --placeholder "Summary of this change"
    }

    if ($summary | is-empty) {
        print "No summary provided"
        return
    }

    mut details = ""

    if not $no_details {
        $details = (gum write --placeholder "Details of this change")
    }

    if ($details | is-empty) {
        gum confirm "Commit changes?"
        jj describe --message $summary
        return
    }

    gum confirm "Commit changes?"
    jj describe --message $"($summary)\n\n($details)"
}

# Jujutsu checkout but with fzf for branch selection
def jc [
    --branch(-b): string # Create and checkout a new branch
] {
    let branch = if ($branch | is-not-empty) {
        ($branch | str join "-")
    } else {
        ""
    }

    if ($branch | is-not-empty) {
        jj new
        jj bookmark set $branch
        return
    }

    mut branch = $branch;

    if ($branch | is-empty) {
        $branch = "";
    }

    let branches = jj bookmark list --all-remotes 
    | lines 
    | where ($it | str starts-with " " | n)
    | each {|it|
        let colon = $it | str index-of ":"
        $it | str substring ..($colon - 1)
    }

    let $branch = $branches
    | uniq 
    | to text 
    | fzf --height 40% --layout=reverse -1 -0 --query $branch

    if ($branch | is-empty) {
        print "No branch selected"
        return
    }

    jj new $branch
}

def jr [
    --find(-f) # Find a remote
    --name-only(-n) # Print only the name of the remote
    --uri-only(-u) # Print only the uri of the remote
] {
    if ($name_only and $uri_only) {
        print "Cannot pass both --name-only and --uri-only"
        return
    }

    let remotes = jj git remote list

    if $find {
        let selected = $remotes | fzf --height 40% --layout=reverse -0 -1

        if $name_only {
            return ($selected | awk "{print $1}")
        }

        if $uri_only {
            return ($selected | awk "{print $2}")
        }

        return $selected
    }

    if $name_only {
        return ($remotes | awk "{print $1}")
    }

    if $uri_only {
        return ($remotes | awk "{print $2}")
    }

    return $remotes
}

# Git remote add
def "jr add" [
    name: string
    url: string
] {
    jj git remote add $name $url
}

# Git remote remove using fzf
def "jr rm" [] {
    let target = jr -fn

    if ($target | is-empty) {
        return
    }

    gum confirm $"Are you sure you with to remove ($target)?"
    print $"Removing remote: ($target)"
    let name = ($target | split row "\t" | first)
    jj git remote remove $name
}

# Git remote rename using fzf
def "jr mv" [
    --old(-o): string,
    --new(-n): string
] {
    let input = $in;
    let old = if ($old | is-not-empty) {
        $old
    } else if ($input | is-not-empty) {
        $input
    } else {
        jr -fn
    }

    print $"Renaming remote: ($old)"

    let new = if $new == null {
        print "Enter the new name for the remote:"
        input
    } else {
        $new
    }

    print $"($old) -> ($new)"
    jj git remote rename --quiet $old $new
}

# Git branch alias
def jb [
    --all(-a)
    # --show-current(-s)
] {
    if $all {
        jj bookmark list --all-remotes
        return
    }

    # if $show_current {
    #     return (git branch --show-current)
    # }

    jj bookmark list
}

# Jujutsu rename bookmark using fzf
def "jb mv" [] {
    let bookmarks = jj bookmark list
    | lines
    | each { |it|
        let colon = $it | str index-of ":"
        $it | str substring ..($colon - 1)
    }
    | to text

    let selected = $bookmarks | fzf --height 40% --layout=reverse -0 -1

    if ($selected | is-empty) {
        print "No bookmark selected"
        return
    }

    print $"Selected bookmark: ($selected)"

    print "Enter a new name for the bookmark:"
    let new_name = input
    let new_name = $new_name 
    | split row " " 
    | str join "-"

    if ($new_name | is-empty) {
        print "No new name provided"
        return
    }

    print $"Renaming ($selected) -> ($new_name)"
    jj bookmark rename $selected $new_name
}

# Git branch delete using fzf
def "jb rm" [] {
    let bookmarks = jj bookmark list
    | lines
    | each { |it|
        let colon = $it | str index-of ":"
        $it | str substring ..($colon - 1)
    }
    | to text

    let selected = $bookmarks | fzf --multi --height 40% --layout=reverse -0

    if ($selected | is-empty) {
        print "No bookmark selected"
        return
    }

    print $"Removing bookmarks: ($selected)"
    jj bookmark delete ...($selected | split row "\n")
}


# Jujutsu new on main or master
def jcm [] {
    let completion = jj new main --quiet | complete

    if $completion.exit_code == 0 {
        return;
    }

    let completion = jj new master --quiet | complete

    if $completion.exit_code == 0 {
        return;
    }

    print -e "No main or master bookmarks found"
}
