# Jujutsu status
alias js = jj status

# Jujutsu log
alias jl = jj log

# Jujutsu log all
alias jla = jj log --revisions 'all()'

# Jujutsu diff
alias jd = jj diff

# Jujutsu restore
alias jrs = jj restore

# Jujutsu describe
alias jds = jj describe

# Jujutsu diff with fzf
alias jdf = jj diff (jj diff --name-only | fzf --height 40% --layout=reverse)

# Jujutsu new
alias jn = jj new

# Jujutsu edit
alias je = jj edit

# Conventional message
def jj-conventional-message [
    --type(-t): string # Specify the type of the commit
    --scope(-s): string # Specify the scope of the commit
    --no-details(-n) # Do not prompt for a description
    ...message: string
]: nothing -> string {
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
        return $summary
    }

    return $"($summary)\n\n($details)"
}

# Conventional describe
def jcc [
    --type(-t): string # Specify the type of the commit
    --scope(-s): string # Specify the scope of the commit
    --no-details(-n) # Do not prompt for a description
    --message(-m): string # Optionally pass the entire message
    revsets?: string # Revsets to apply the description to
] {
    let revsets = if ($revsets | is-not-empty) { $revsets } else '@'

    let has_type = $type | is-not-empty
    let has_scope = $scope | is-not-empty
    let has_no_details = $no_details
    let has_message = $message | is-not-empty

    let message = match [$has_type, $has_scope, $has_no_details, $has_message] {
        [false, false, false, false] => (jj-conventional-message)
        [true, false, false, false] => (jj-conventional-message --type $type)
        [false, true, false, false] => (jj-conventional-message --scope $scope)
        [true, true, false, false] => (jj-conventional-message --type $type --scope $scope)
        [false, false, true, false] => (jj-conventional-message --no-details)
        [true, false, true, false] => (jj-conventional-message --type $type --no-details)
        [false, true, true, false] => (jj-conventional-message --scope $scope --no-details)
        [true, true, true, false] => (jj-conventional-message --type $type --scope $scope --no-details)
        [false, false, false, true] => (jj-conventional-message $message)
        [true, false, false, true] => (jj-conventional-message --type $type $message)
        [false, true, false, true] => (jj-conventional-message --scope $scope $message)
        [true, true, false, true] => (jj-conventional-message --type $type --scope $scope $message)
        [false, false, true, true] => (jj-conventional-message --no-details $message)
        [true, false, true, true] => (jj-conventional-message --type $type --no-details $message)
        [false, true, true, true] => (jj-conventional-message --scope $scope --no-details $message)
        [true, true, true, true] => (jj-conventional-message --type $type --scope $scope --no-details $message)
    }

    jj describe --message $message $revsets
}

# Jujutsu checkout but with fzf for bookmark selection
def jc [
    --bookmark(-b): string # Create and checkout a new bookmark
] {
    let bookmark = if ($bookmark | is-not-empty) {
        ($bookmark | str join "-")
    } else {
        ""
    }

    if ($bookmark | is-not-empty) {
        jj bookmark set $bookmark
        jj bookmark track $bookmark --remote origin # assume origin is the correct remote since it is in 99% of cases
        return
    }

    mut bookmark = $bookmark;

    if ($bookmark | is-empty) {
        $bookmark = "";
    }

    let bookmarks = jj bookmark list --all-remotes 
    | lines 
    | where ($it | str starts-with " " | n)
    | each {|it|
        let colon = $it | str index-of ":"
        $it | str substring ..($colon - 1)
    }

    let $bookmark = $bookmarks
    | uniq 
    | to text 
    | fzf --height 40% --layout=reverse -1 -0 --query $bookmark

    if ($bookmark | is-empty) {
        print "No bookmark selected"
        return
    }

    jj new $bookmark
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

# Jujutsu remote add
def "jr add" [
    name: string
    url: string
] {
    jj git remote add $name $url
}

# Jujutsu remote remove using fzf
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

# Jujutsu remote rename using fzf
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

# Jujutsu bookmark alias
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
def "jb rn" [] {
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

# Jujutsu move bookmark using fzf
def "jb mv" [
    to?: string
] {
    let bookmarks = jj bookmark list
    | lines
    | each { |it|
        $it | str before ":"
    }
    | to text

    let selected = $bookmarks | fzf --height 40% --layout=reverse -0 -1

    if ($selected | is-empty) {
        print "No bookmark selected"
        return
    }

    mut to = $to

    if ($to | is-empty) {
        $to = "@"
    }

    print $"Moving ($selected) to ($to)"
    jj bookmark move $selected --allow-backwards --to $to
}

# Jujutsu bookmark delete using fzf
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

def jj-get-description [] {
    jj log --revisions '@' --template 'description'
    | lines
    | str substring 3..
    | str join "\n"
    | str trim
}

## Jujutsu commit and push
def jcp [
    --type(-t): string # Specify the type of the commit
    --scope(-s): string # Specify the scope of the commit
    --no-details(-n) # Do not prompt for a description
    --message(-m): string # Optionally pass the entire message
] {
    let has_type = $type | is-not-empty
    let has_scope = $scope | is-not-empty
    let has_no_details = $no_details | is-not-empty
    let has_message = $message | is-not-empty

    let has_description = jj log --revisions '@' --template 'if(description == "", "false", "true")'
    | lines
    | first
    | str trim
    | str ends-with "true"

    match [$has_type, $has_scope, $has_no_details, $has_message, $has_description] {
        [false, false, false, false, true] => {}
        [false, false, false, false, false] => (jcc)
        [true, false, false, false, _] => (jcc --type $type)
        [false, true, false, false, _] => (jcc --scope $scope)
        [true, true, false, false, _] => (jcc --type $type --scope $scope)
        [false, false, true, false, _] => (jcc --no-details)
        [true, false, true, false, _] => (jcc --type $type --no-details)
        [false, true, true, false, _] => (jcc --scope $scope --no-details)
        [true, true, true, false, _] => (jcc --type $type --scope $scope --no-details)
        [false, false, false, true, _] => (jcc --message $message)
        [true, false, false, true, _] => (jcc --type $type --message $message)
        [false, true, false, true, _] => (jcc --scope $scope --message $message)
        [true, true, false, true, _] => (jcc --type $type --scope $scope --message $message)
        [false, false, true, true, _] => (jcc --no-details --message $message)
        [true, false, true, true, _] => (jcc --type $type --no-details --message $message)
        [false, true, true, true, _] => (jcc --scope $scope --no-details --message $message)
        [true, true, true, true, _] => (jcc --type $type --scope $scope --no-details --message $message)
    }

    jb mv

    let bookmarks = jj log --revisions '@' --template 'bookmarks'
    | lines
    | first
    | str substring 3..
    | str trim

    gum confirm "Push changes?"
    jj git push
}

## Jujutsu split
def jsp [] {
    let current_description = jj-get-description
    jj split --interactive --message $current_description
    jcc @-
}
