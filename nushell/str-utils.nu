# take anything after the first occurrence of the pattern
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
            $input | str before --inclusive=$inclusive $pattern ...$rest
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
    pattern: string
    ...rest: cell-path
] {

    # let input = $in
    # let pattern_start = $input | str index-of $pattern
    #
    # if $pattern_start == -1 {
    #     return $input
    # } 
    #
    # let index = $pattern_start + (if not $inclusive { $pattern | str length } else { 0 })
    #
    # $input | str substring $index..

    let inputs = $in

    let type = $inputs | describe

    if $type == string {
        let pattern_start = $inputs | str index-of $pattern

        if $pattern_start == -1 {
            return $inputs
        } 

        let index = $pattern_start + (if not $inclusive {
            $pattern | str length
        } else { 0 })

        $inputs | str substring $index..
    } else if $type == "list<string>" {
        $inputs | each {|input|
            $input | str after --inclusive=$inclusive $pattern ...$rest
        }
    } else if ($type | str starts-with "record") {
        if ($rest | is-empty) {
            error make {msg: "pass cell path for table",}
        }

        let input = $inputs 
        | get ($rest | first) ...($rest | skip) 

        let result = $input | str after --inclusive=$inclusive $pattern ...$rest
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
            $input | str after --inclusive=$inclusive $pattern ...$rest
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

