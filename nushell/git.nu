source ~/.config/nushell/utils.nu

# Git status
alias gs = git status

# Git status --porcelain
alias gsp = git status --porcelain

# Git log
alias gl = git log --ext-diff

# Git diff
alias gd = git diff

# Git amend commit
alias gca = git commit --amend

# Git push with force and lease
alias gpf = git push --force-with-lease

# Git add patch
alias gap = git add --patch

# Git show with --ext-diff
alias "git show" = git show --ext-diff

# Git diff with fzf
alias gdf = git diff (git status --porcelain 
    | lines 
    | str substring 2.. 
    | str trim 
    | to text 
    | fzf --height 40% --layout=reverse)

# Start tracking files with git
alias gt = git add --intent-to-add

# Conventional commit
def cc [
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
        $"\(($scope)\)"
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
        git commit -m ($summary)
        return
    }

    gum confirm "Commit changes?"
    git commit -m $summary -m $details
}

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

    mut $branch = $branch_names 
    | uniq 
    | to text 
    | fzf --height 40% --layout=reverse -1 -0 --query $branch

    if ($branch | is-empty) {
        print "No branch selected"
        return
    }

    if ($branch | str starts-with "HEAD") {
        $branch = "HEAD"
    }

    git checkout $"($branch)"
}

# Git remote using fzf
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
                    $table = ($table | append $row)
                }

                let remotes = $table | each {|r|
                    let info = $r | get info
                    let modes = $r | get modes 
                    | str join "|" 
                    | str surround "(" ")"

                    $info + " " + $modes
                }

                let groups = ($table | group-by --to-table info)
            
                mut remotes = [];

                for $it in ($groups | enumerate) {
                    let index = $it.index
                    let group = $it.item
                    let info = $group.items 
                    | get info 
                    | uniq 
                    | str join " -- "

                    let modes = $group.items | get modes
                    let mode = $modes | str join "|"
                    let mode = $"\(($mode)\)"
                    $remotes = ($remotes | append $"($info) ($mode)")
                }
    
                $remotes | to text
            }
        },
        [true, false] => {
            let remotes = git remote
            let target = $remotes 
            | lines 
            | to text 
            | fzf --height 40% --layout=reverse -0 -1 --query $query

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
                $table = ($table | append $row)
            }
            
            let groups = ($table | group-by --to-table name)
            
            mut remotes = [];
            for $it in ($groups | enumerate) {
                let index = $it.index
                let group = $it.item
                let name = $group.items | get name | uniq | first

                let url_group = ($group.items | group-by --to-table url)

                let urls_with_modes = ($url_group | each { |g|
                    let url = $g.items | get url | first
                    let modes = $g.items 
                    | get mode 
                    | str join "|" 
                    | str surround "(" ")"

                    $url + " " + $modes
                })

                let url = $urls_with_modes | str join " | "
                $remotes = ($remotes | append $"($name)\t($url)")
            }

            let target = $remotes 
            | to text 
            | fzf --height 40% --layout=reverse -0 -1 --query $query

            if ($target | is-empty) {
                print "No remote selected"
                return
            }

            if $name_only {
                let name = ($target | split row "\t" | first)
                $name
            } else {
                if not $consice {
                    let name = $target | split row "\t" | first
                    let split_urls = $target 
                    | split row "\t" 
                    | skip 
                    | first 
                    | split row " | "

                    $split_urls | each {|s|
                        let split = $s | split row " "
                        let url = $split | get 0
                        let modes = $split 
                        | get 1 
                        | str replace -ar "[()]" "" 
                        | split row "|" 
                        | each { |m| $m | str surround "(" ")" }

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

# Git remote add
def "gr add" [
    name: string
    url: string
] {
    git remote add $name $url
}

# Git remote remove using fzf
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

# Git remote rename using fzf
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

# Git branch alias
def gb [
    --all(-a)
    --show-current(-s)
    --set-upstream(-u)
] {
    if $all and $show_current {
        print "Cannot pass more than one argument"
        return
    }

    if $all {
        return (git branch --all)
    }

    if $show_current {
        return (git branch --show-current)
    }

    if $set_upstream {
        let branch = git branch --show-current
        print $"Select upstream branch for ($branch)"

        let remote_branches = git branch --all 
        | lines 
        | str substring 2.. 
        | where ($it | str starts-with "remotes")
        | str substring 8..

        let selected = $remote_branches 
        | to text 
        | fzf --height 40% --layout=reverse -0 -1

        print $"Selected ($selected)"

        print $"Setting upstream branch for ($branch) to ($selected)"
        git branch --set-upstream-to=($selected) ($branch)
        return
    }

    git branch
}

# Git branch rename using fzf
def "gb mv" [...query: string] {
    let branches = (git branch --list | lines)
    let query = $query | str join " "
    let selected_branch = $branches 
    | to text 
    | fzf --height 40% --layout=reverse -0 -1 -q $query

    if ($selected_branch | is-empty) {
        print "No branch selected"
        return
    }

    let selected_branch = $selected_branch | str substring 2..
    print $"Selected branch: ($selected_branch)"
    
    print "Enter a new name for the branch:"
    let new_name = input
    let new_name = $new_name 
    | split row " " 
    | str join "-"

    if ($new_name | is-empty) {
        print "No new name provided"
        return
    }

    print $"Renaming ($selected_branch) -> ($new_name)"
    git branch --move $selected_branch $new_name
}

# Git branch delete using fzf
def "gb rm" [
    --force(-f)
    ...query: string
] {
    let branches = (git branch --all | lines)
    let query = $query | str join " "
    let selected_branch = $branches 
    | to text 
    | fzf --height 40% --layout=reverse -0 -q $query

    if ($selected_branch | is-empty) {
        print "No branch selected"
        return
    }

    mut selected_branch = ($selected_branch | str substring 2..)
    
    mut remote = false

    if ($selected_branch | str starts-with "remotes") {
        $selected_branch = ($selected_branch | str substring 8..)
        $remote = true
    } 

    match [$force, $remote] {
        [false, false] => {
            print $"Deleting branch: ($selected_branch)"
            git branch --delete $selected_branch
        },
        [true, false] => {
            print $"Deleting branch even if unmerged: ($selected_branch)"
            git branch -D $selected_branch
        },
        [false, true] => {
            print $"Deleting remote branch: ($selected_branch)"
            git branch --delete --remote $selected_branch
        },
        [true, true] => {
            print $"Deleting remote branch even if unmerged: ($selected_branch)"
            git branch -D --remote $selected_branch
        }
    }
}

def "bisect start" [...query] {
    let status = git status --porcelain

    if ($status | is-not-empty) {
        print "There are uncommitted changes"
        return
    }

    git bisect start
    git bisect bad

    let query = $query | str join " "
    let chosen = git log --oneline 
    | lines 
    | to text 
    | fzf --height 40% --layout=reverse --query $query

    if ($chosen | is-empty) {
        print "No commit selected"
        return
    }

    let commit = ($chosen | split row " " | first)

    print $"Selected commit: ($commit)"
    git checkout $commit
}

def "bisect good" [] {
    git bisect good
}

def "bisect bad" [] {
    git bisect bad
}

def "bisect reset" [] {
    git bisect reset
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
                return ($link | str trim)
            }

            let repo_start = $link | str index-of -e '/'
            let repo = $link | str substring $repo_start..
            let link = $link | str substring ..$repo_start
            let owner_start = ($link | str index-of -e '/') + 1
            let owner = $link | str substring $owner_start..
            return ($"git@github:($owner)($repo)" | str trim)
        }

        let a = git remote -v | find -r 'git@github\.com.*\.git' | lines | first
        let s = $a | str index-of 'git@github.com'
        let e = ($a | str index-of -e '.git') + 4
        let link = $a | str substring $s..$e

        if $type == null or $type == "ssh" {
            return ($link | str trim)
        }
        
        let repo_start = $link | str index-of -e '/'
        let repo = $link | str substring $repo_start..
        let link = $link | str substring ..$repo_start
        let owner_start = ($link | str index-of -e ':') + 1
        let owner = $link | str substring $owner_start..
        return ($"https://github.com/($owner)($repo)" | str trim)
    }
    
    if $owner != null {
        let link = match $type {
            "http" => { ghlink-http $owner $repo }
            "ssh" | "shh" => { ghlink-ssh $owner $repo }
            _ => { ghlink-ssh $owner $repo }
        }
        
        return ($link | str trim)
    }

    let owner = gh api user | jq -r '.login'
    match $type {
        "http" => { ghlink-http $owner $repo }
        "ssh" | "shh" => { ghlink-ssh $owner $repo }
        _ => { ghlink-ssh $owner $repo }
    }
}

# GitHub link using ssh
def "ghlink-ssh" [owner: string, repo: string] {
    echo $"git@github.com:($owner)/($repo).git"
}

# GitHub link using http
def "ghlink-http" [owner: string, repo: string] {
    echo $"https://github.com/($owner)/($repo).git"
}

# Git checkout main or master
def gcm [
    --pull(-p) # Pull the latest changes
    --fetch(-f) # Fetch the latest changes
] {
    do -i { git checkout main --quiet }
    let branch = git branch --show-current
    
    if ($branch == "main") {
        print "Switched to main branch"

        if $fetch {
            print "Fetching latest changes"
            git fetch
        }

        if $pull {
            print "Pulling latest changes"
            git pull
        }

        return;
    }

    do -i { git checkout master --quiet }
    
    let branch = git branch --show-current
    
    if ($branch == "master") {
        print "Switched to master branch"

        if $fetch {
            print "Fetching latest changes"
            git fetch
        }

        if $pull {
            print "Pulling latest changes"
            git pull
        }

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
def gcp [
    --type(-t): string # Specify the type of the commit
    --scope(-s): string # Specify the scope of the commit
    --no-details(-n) # Do not prompt for a description
    ...message: string
] {
    git add -A

    mut args = []

    let has_type = $type | is-not-empty
    let has_scope = $scope | is-not-empty
    let has_no_details = $no_details | is-not-empty

    match [$has_type, $has_scope, $has_no_details] {
        [false, false, false] => (cc ...$message)
        [true, false, false] => (cc --type $type ...$message)
        [false, true, false] => (cc --scope $scope ...$message)
        [true, true, false] => (cc --type $type --scope $scope ...$message)
        [false, false, true] => (cc --no-details ...$message)
        [true, false, true] => (cc --type $type --no-details ...$message)
        [false, true, true] => (cc --scope $scope --no-details ...$message)
        [true, true, true] => (cc --type $type --scope $scope --no-details ...$message)
    }
    gum confirm "Push changes?"
    git push
}

# GitHub

# Open a repo in the browser
def "gh open" [
    --verbose(-v) # Print verbose output
    --owner(-o): string
    --user(-u)
    --exact(-e)
    ...repo: string
] {
    let repo = $repo | str join " "
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

        let user = if $exact {
            $users | to text | fzf --height 40% --layout=reverse -e -0 -1
        } else {
            $users | to text | fzf --height 40% --layout=reverse -0 -1
        }

        start $"https://github.com/($user)"
    }

    mut repo = $repo
    if $repo == null { $repo = "" } else {}
    
    if $owner != null {
        if $verbose {
            print $"Owner: ($owner)"
        }

        let repos = gh repo list -L 500 $owner --json nameWithOwner 
        | from json
        | get nameWithOwner

        if $verbose {
            print "Repos:"
            print $repos
        }
        
        if $verbose {
            print $"Repo: ($repo)"
        }

        $repo = if $exact {
            $repos 
            | to text 
            | fzf --height 40% --layout=reverse -e -0 -1 --query $repo
        } else {
            $repos 
            | to text 
            | fzf --height 40% --layout=reverse -0 -1 --query $repo
        }
    } else {
        if $verbose {
            print "No owner provided"
        }

        mut repos = gh repo list -L 500 --json nameWithOwner 
        | from json
        | get nameWithOwner

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
            let orgrepos = gh repo list --limit 500 $org --json nameWithOwner 
            | from json
            | get nameWithOwner
            
            if $verbose {
                print $"Org: ($org)"
                print "Repos:"
                print $orgrepos
            }

            $repos = ($repos | append $orgrepos)
        }

        if $verbose {
            print $"Repo: ($repo)"
        }

        $repo = (if $exact {
            $repos | to text | fzf --height 40% --layout=reverse --exact -0 -1 --query $repo
        } else {
            $repos | to text | fzf --height 40% --layout=reverse -0 -1 --query $repo
        })
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

# fzf powered search to find a commit sha
def gf [
    --multi(-m) # Allow multiple refs to be selected. Printed on separate lines
    --long(-l) # Print the full ref instead of the short version
] {
    let refs = git reflog | lines | str replace "HEAD@" ""

    let selected = if not $multi {
        $refs | to text | fzf --height 40% --layout=reverse -0 -1
    } else {
        $refs | to text | fzf --multi --height 40% --layout=reverse -0 -1
    }

    if ($selected | is-empty) {
        print "No ref selected"
        return
    }

    let shorts = $selected | lines | str substring 0..6

    if $long {
        return ($shorts | each { |it| git rev-parse $it } | to text | str trim)
    } else {
        return ($shorts | to text | str trim)
    }
}

# Git rebase interactive
def gri [] {
    let root = gf --long
    git rebase --interactive $root
}
