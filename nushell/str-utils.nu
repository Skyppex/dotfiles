def "str before" [
    --inclusive(-i)
    pattern: string
    ...rest: cell-path
] {
    let inputs = $in

    let type = $inputs | describe

    if $type == string {
        let pattern_start = $inputs | str index-of $pattern

        if $pattern_start == -1 {
            return $inputs
        } 

        let index = ($pattern_start - 1) + (if $inclusive {
            $pattern | str length
        } else { 0 })

        $inputs | str substring ..$index
    } else if $type == "list<string>" {
        $inputs | each {|input|
            $input | str before --inclusive=$inclusive $pattern ...$rest
        }
    } else if ($type | str starts-with "record") {
        if ($rest | is-empty) {
            error make {msg: "pass cell path for table",}
        }

        let input = $inputs 
        | get ($rest | first) ...($rest | skip) 

        let result = $input | str before --inclusive=$inclusive $pattern ...$rest
        let zipped = $rest | zip $result

        let updated = $zipped | each {
            |zip| $inputs | update $zip.0 { $zip.1 }
        }
        | first

        $updated
    } else if ($type | str starts-with "table") {
        if ($rest | is-empty) {
            error make {msg: "pass cell path for table",}
        }

        let result = $inputs 
        | get ($rest | first) ...($rest | skip) 
        | each {|input|
            $input | str before --inclusive=$inclusive $pattern ...$rest
        }

        let zipped = $rest | zip $result

        let updated = $zipped | each {
            |zip| $inputs | update $zip.0 { $zip.1 }
        }

        $updated.0
    }
}

def "str after" [
    --inclusive(-i)
    pattern: string
] {
    let input = $in
    let pattern_start = $input | str index-of $pattern

    if $pattern_start == -1 {
        return $input
    } 

    let index = $pattern_start + (if not $inclusive { $pattern | str length } else { 0 })

    $input | str substring $index..
}
