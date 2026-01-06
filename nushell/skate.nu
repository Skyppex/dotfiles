def parse-keys [
    --dbs-only
    db: string = "@default"
] {
    $in | lines | each { |it|
        let split = $it | split row "@"
        let key = $split | get 0
        let db = if ($split | length) >= 2 {
            "@" + ($split | get 1)
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

export def --wrapped main [
    ...$rest
] {
    if ($rest | is-empty) {
        help
        return
    }

    print (^skate ...$rest)
}

export def help [] {
    print "Skate, a personal key value store."
    print ""
    print "Usage:"
    print "  skate (options)"
    print "  skate <command> (options)"
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
    print "  --help, -h                   print skates help text"
    print "  --version, -v                print the version for skate"
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
    ^skate list-dbs | parse-keys --dbs-only
}

export alias dbs = list dbs
export alias "ls dbs" = list dbs

export def list [
    --keys-only(-k) # only show keys (including db)
    --values-only(-v) # only show values
    --show-binary(-b) # show binary values
    --reverse(-r) # list in reverse lexicographic order
    db: string = "default"
]: nothing -> table<key?: string, value?: string, db?: string> {
    let db = if not ($db | str starts-with "@") {
        $"@($db)"
    } else {
        $db
    }

    let keys = if $reverse {
        ^skate list --keys-only --reverse $db | lines
    } else {
        ^skate list --keys-only $db | lines
    }

    if $keys_only {
        return ($keys | each { |key| 
            {key: $key, db: $db}
        })
    }

    let kvps = $keys | each { |key|
        let value = skate get $"($key)($db)"
        {key: $key, value: $value}
    }

    if $values_only {
        return ($kvps | select value)
    }

    $kvps | insert db $db
}

export alias ls = list

export def "list all" [
    --show-values(-v) # show values
    --show-binary(-b) # show binary values
    --reverse(-r) # list in reverse lexicographic order
]: nothing -> table<key?: string, value?: string, db?: string> {
    let dbs = list dbs | get db

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
        let $selected_db = $dbs | get db | to text | ^fzf --height 40% --layout reverse -0

        if ($selected_db | is-empty) {
            print -e "no db selected"
            return
        }

        return $selected_db
    }

    let keys = list all | format pattern '{key}{db}' | to text
    let selected = $keys | ^fzf --height 40% --layout reverse -0

    if ($selected | is-empty) {
        print -e "no key selected"
        return
    }

    if $key_only {
        return $selected
    }

    if $show_binary {
        ^skate get --show-binary $selected
    } else {
        ^skate get $selected
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
