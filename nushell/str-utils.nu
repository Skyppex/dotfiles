def "str index-of-n" [
    occurrence: int
    pattern: string
]: string -> int {
    if $occurrence == 0 {
        return (-1)
    }

    let input = $in

    mut current_index = -1

    for $i in 1..$occurrence {
        let index = $input | str index-of $pattern --range ($current_index + 1)..
        $current_index = $index
    }

    $current_index
}

# take anything after the first occurrence of the pattern
def "str before" [
    --inclusive(-i)
    --occurrence(-n): int
    pattern: string
    ...rest: cell-path
] {
    let inputs = $in
    let type = $inputs | describe
    let occurrence = if ($occurrence | is-not-empty) { $occurrence } else { 1 }

    if $type == string {
        let pattern_start = $inputs | str index-of-n $occurrence $pattern

        if $pattern_start == -1 {
            return $inputs
        } 

        let index = ($pattern_start - 1) + (if $inclusive {
            $pattern | str length
        } else { 0 })

        $inputs | str substring ..$index
    } else if $type == "list<string>" {
        $inputs | each {|input|
            $input | str before --inclusive=$inclusive --occurrence=$occurrence $pattern ...$rest
        }
    } else if ($type | str starts-with "record") {
        if ($rest | is-empty) {
            error make {msg: "pass cell path for table",}
        }

        let input = $inputs 
        | get ($rest | first) ...($rest | skip) 

        let result = $input | str before --inclusive=$inclusive --occurrence=$occurrence $pattern ...$rest
        let zipped = $rest | zip $result

        mut updated = $inputs

        for $zip in $zipped { 
            $updated = $updated | update $zip.0 $zip.1 
        }

        $updated
    } else if ($type | str starts-with "table") {
        if ($rest | is-empty) {
            error make {msg: "pass cell path for table",}
        }

        let results = $inputs 
        | select ($rest | first) ...($rest | skip) 
        | each { |input|
            $input | str before --inclusive=$inclusive --occurrence=$occurrence $pattern ...$rest
        }

        mut updated = []

        for $zip in ($inputs | zip $results) {
            let row = $zip.0
            let result = $zip.1
            mut u = $row

            for $path in $rest {
                $u = $u | update $path ($result | get $path)
            }

            $updated = $updated | append $u
        }

        $updated
    }
}

# take anything after the first occurrence of the pattern
def "str after" [
    --inclusive(-i)
    --occurrence(-n): int
    pattern: string
    ...rest: cell-path
] {
    let inputs = $in
    let type = $inputs | describe
    let occurrence = if ($occurrence | is-not-empty) { $occurrence } else { 1 }

    if $type == string {
        let pattern_start = $inputs | str index-of-n $occurrence $pattern

        if $pattern_start == -1 {
            return $inputs
        } 

        let index = $pattern_start + (if not $inclusive {
            $pattern | str length
        } else { 0 })

        $inputs | str substring $index..
    } else if $type == "list<string>" {
        $inputs | each {|input|
            $input | str after --inclusive=$inclusive --occurrence=$occurrence $pattern ...$rest
        }
    } else if ($type | str starts-with "record") {
        if ($rest | is-empty) {
            error make {msg: "pass cell path for table",}
        }

        let input = $inputs 
        | get ($rest | first) ...($rest | skip) 

        let result = $input | str after --inclusive=$inclusive --occurrence=$occurrence $pattern ...$rest
        let zipped = $rest | zip $result

        mut updated = $inputs

        for $zip in $zipped { 
            $updated = $updated | update $zip.0 $zip.1 
        }

        $updated
    } else if ($type | str starts-with "table") {
        if ($rest | is-empty) {
            error make {msg: "pass cell path for table",}
        }

        let results = $inputs 
        | select ($rest | first) ...($rest | skip) 
        | each { |input|
            $input | str after --inclusive=$inclusive --occurrence=$occurrence $pattern ...$rest
        }

        mut updated = []

        for $zip in ($inputs | zip $results) {
            let row = $zip.0
            let result = $zip.1
            mut u = $row

            for $path in $rest {
                $u = $u | update $path ($result | get $path)
            }

            $updated = $updated | append $u
        }

        $updated
    }
}

# surround the input with the provided strings
def "str surround" [
    start: string,
    end: string
] {
   $"($start)($in)($end)"
}

# remove string from the start of the input
def "str strip-prefix" [prefix: string]: string -> string {
    str replace --regex $"^($prefix)" ""
}

# remove string from the end of the input
def "str strip-suffix" [suffix: string]: string -> string {
    str replace --regex $"($suffix)$" ""
}

# find extras in two lists of strings
def diff-lines [
    left: list<string>
    right: list<string>
] {
    let left_only = ($left | where { |l| $l not-in $right })
    let right_only = ($right | where { |r| $r not-in $left })

    {
        left: $left_only
        right: $right_only
    }
}
