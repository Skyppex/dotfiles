def --env history-fzf [] {
    let selected = history
    | reverse
    | get command
    | uniq
    | to text
    | fzf --height 40% --layout=reverse

    let command = [$selected (char nl)] | str join ""
    let config_file = $env.CONFIG_PATH | path join "nushell/config.nu"
    let env_file = $env.CONFIG_PATH | path join "nushell/env.nu"
    nu --config $config_file --env-config $env_file --execute $command
}

# Extra utilities for managing the history file
def h [
    --clear(-c): int # Clears out the history entries (less than 0 clears everything)
    --clear-contains(-f): string # Clears out the history entries that match the filter
    --clear-starts-with(-s): string # Clears out the history entries that match the filter
    --long(-l) # Show long listing of entries for sqlite history
] {
    if $clear != null {
        if $clear <= 0 {
            echo "Are you sure you wish to clear everything? (y/n)"
            let response = input
            
            match $response {
                "y" | "Y" | "yes" | "Yes" => { history --clear }
                _ => { print "Exiting." }
            }

            return
        }
        
        let history = open $nu.history-path
            | lines
            | reverse
            | skip ($clear + 1)
            | reverse
        $history | append ""
            | str join "\n"
            | save --force $nu.history-path

        return
    }

    if $clear_contains != null {
        if $clear_contains == "" {
            print "An empty filter was provided, exiting."
            return
        }

        mut history = open $nu.history-path
            | lines
            | reverse
            | where ($it | str contains $clear_contains | n)
            | reverse

        $history
            | str join "\n"
            | save --force $nu.history-path

        return
    }
    
    if $clear_starts_with != null {
        if $clear_starts_with == "" {
            print "An empty filter was provided, exiting."
            return
        }

        mut history = open $nu.history-path
            | lines
            | reverse
            | where (not ($it | str starts-with $clear_starts_with))
            | reverse

        $history
            | str join "\n"
            | save --force $nu.history-path

        return
    }

    history
}

# Replace strings in the history file
def "h replace" [
    --exact(-e) # Replace only when the entire line is an exact match (excluding the newline character at the end)
    old: string # The old string to replace
    new: string # The new string to replace with
] {
    let history = open $nu.history-path
        | lines
        | each { |line|
            if $exact {
                if $line == $old {
                    $"($new)\n"
                } else {
                    $"($line)\n"
                }
            } else {
                let new_line = $line | str replace -a $old $new
                $"($new_line)\n"
            }
        }

    $history
        | str join ""
        | save --force $nu.history-path
}

