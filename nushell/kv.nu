alias manifest = echo $"($env.HOME)/secretspec.toml"
alias identity = echo $"($env.HOME)/.local/share/age/identity.age"

export alias sec = secretspec --file (manifest)

alias core-get = get

export def --env password [ ] {
    if ($env.AGE_IDENTITY? | is-not-empty) {
        return
    }

    $env.AGE_IDENTITY = ^age -d (identity)
}

def parse-keys [
    --dbs-only
    db: string = "@default"
] {
    $in | lines | each { |it|
        let split = $it | split row "@"
        let key = $split.0
        let db = if ($split | length) >= 2 {
            "@" + $split.1
        } else {
            $db
        }

        if $dbs_only {
            {db: $db}
        } else {
            {key: $key, db: $db}
        }
    }
}

export def main [] {
    help
}

export def help [] {
    print "kv, a personal key value store using skate and secretspec."
    print ""
    print "Usage:"
    print "  kv (options)"
    print "  kv <command> (options)"
    print ""
    print "Commands:"
    print "  delete, remove, rm           delete a key from a db"
    print "  delete-db, remove-db, rm-db  delete a db"
    print "  format, fmt                  format structured key, value, db records"
    print "  fzf                          search your skate store using fzf"
    print "  get                          get a value for a key with an optional @ db"
    print "  help                         print this help text"
    print "  list, ls                     list keys and values for a db"
    print "  list all, ls all, ls a       list all keys and values for all dbs"
    print "  list dbs, ls dbs, dbs        list dbs"
    print "  set                          set a value for a key with an optional @ db. if the value is omitted, read value from stdin"
    print ""
    print "Options:"
    print "  --help, -h                   print kvs help text"
    print ""
    print "the @secrets db is a special db that uses secretspec over the system keyring"
}

export def format [
    pattern: string = "{key}{db}"
]: oneof<record<key: string, db: string, value: string>, table<key: string, db: string, value: string>> -> string {
    $in | each { |it| 
        $it | format pattern $pattern
    } | to text
}

export alias fmt = format

export def "list dbs" [] {
    mut dbs = []
    let skate_dbs = ^skate list-dbs | parse-keys --dbs-only

    $dbs = $dbs | append $skate_dbs

    if (manifest | path exists) {
        $dbs = $dbs | where db != "@secrets" | append { db: "@secrets"}
    }

    $dbs
}

export alias dbs = list dbs
export alias "ls dbs" = list dbs

export def list [
    --show-values(-v) # show keys and values (including db)
    --values-only(-V) # only show values
    --show-binary(-b) # show binary values
    --reverse(-r) # list in reverse lexicographic order
    db: string = "default"
]: nothing -> table<key?: string, value?: string, db?: string> {
    let db = if not ($db | str starts-with "@") {
        $"@($db)"
    } else {
        $db
    }

    let keys = if $db == "@secrets" {
        sec schema | from json | core-get properties | columns
    } else {
        ^skate list --keys-only $db | lines
    }

    let keys = if $reverse {
        $keys | reverse
    } else {
        $keys
    }

    if $show_values {
        if $db == "@secrets" {
            password
        }

        return (do --env {
            ($keys | each { |key|
                let value = if $show_binary {
                    get $"($key)($db)" --show-binary
                } else {
                    get $"($key)($db)"
                }

                { key: $key, value: $value }
            } | insert db $db)
        })
        
    }

    if $values_only {
        if $db == "@secrets" {
            password
        }

        return ($keys | each { |key|
            { value: (get $"($key)($db)") }
        })
    }

    return ($keys | each { |key| 
        {key: $key, db: $db}
    })
}

export alias ls = list

export def "list all" [
    --show-values(-v) # show values
    --show-binary(-b) # show binary values
    --reverse(-r) # list in reverse lexicographic order
]: nothing -> table<key?: string, value?: string, db?: string> {
    let dbs = list dbs | core-get db

    let all = $dbs | reduce --fold [] { |db, acc|
        if $show_binary {
            $acc ++ (list --show-binary $db)
        } else {
            $acc ++ (list $db)
        }
    }


    match [$show_values, $reverse] {
        [true, false] => ($all | sort-by key),
        [false, false] => ($all | select key db | sort-by key),
        [true, true] => ($all | sort-by key --reverse),
        [false, true] => ($all | select key db | sort-by key --reverse),
    }
}

export alias "ls all" = list all
export alias "ls a" = list all

export def get [
    --show-binary(-b)
    key: string # in the format <key>(@<db>) where <db> defaults to "default" if omitted
] {
    let split = $key | split row "@"
    let key = $split.0
    let db = if ($split | length) >= 2 {
        "@" + $split.1
    } else {
        "@default"
    }

    if $db == "@secrets" {
        password
        sec get $key
    } else {
        if $show_binary {
            ^skate get $"($key)($db)" --show-binary
        } else {
            ^skate get $"($key)($db)"
        }
    }
}

alias g = get

export def set [
    key: string # in the format <key>(@<db>) where <db> defaults to "default" if omitted
    value: string
] {
    let split = $key | split row "@"
    let key = $split.0
    let db = if ($split | length) >= 2 {
        "@" + $split.1
    } else {
        "@default"
    }

    if $db == "@secrets" {
        sec set $key $value
    } else {
        ^skate set $"($key)($db)" $value
    }
}

export def fzf [
    --db-only(-d) # print selected db
    --key-only(-k) # print selected key
    --show-binary(-b) # show binary values
] {
    if $db_only and $key_only {
        print -e "--db_only and --key_only cannot be passed together"
    }

    if ($db_only or $key_only) and $show_binary {
        print -e "--db_only and --key_only don't work with --show-binary"
    }

    if $db_only {
        let dbs = list dbs
        let $selected_db = $dbs 
        | core-get db 
        | to text 
        | ^fzf --height 40% --layout reverse -0 --multi 
        | lines 
        | each { |it|
            { db: $it }
        }

        if ($selected_db | is-empty) {
            print -e "no db selected"
            return
        }

        return $selected_db
    }

    let keys = list all | format pattern '{key}{db}' | to text
    print -e $keys

    let selected = $keys 
    | ^fzf --height 40% --layout reverse -0 --multi 
    | lines
    | each {|it|
        let split = $it | split row "@"
        let key = $split.0
        let db = if ($split | length) >= 2 {
            "@" + $split.1
        } else {
            "@default"
        }

        { key: $key, db: $db }
    }

    if ($selected | is-empty) {
        print -e "no key selected"
        return
    }

    if $key_only {
        return $selected
    }

    if ($selected | any {|it| $it.db == "@secrets"}) {
        password
    }

    if $show_binary {
        $selected | each { |it| 
            get --show-binary $it.key
        }
    } else {
        $selected | each { |it| 
            get $it.key
        }
    }
}

export def delete [] {
    let selected = fzf --key-only

    if ($selected | is-empty) {
        return
    }

    gum confirm $"Are you sure you want to delete ($selected)"

    ^skate delete $selected
}

export alias remove = delete
export alias rm = delete

export def "delete db" [] {
    let selected = fzf --db-only

    if ($selected | is-empty) {
        return
    }

    gum confirm $"Are you sure you want to delete ($selected)"

    ^skate delete-db $selected
}

export alias "remove db" = delete db
export alias "rm db" = delete db
