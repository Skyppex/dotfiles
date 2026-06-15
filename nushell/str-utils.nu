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

# Returns true if a single-character string is an uppercase letter.
# (Non-letters like digits/spaces upcase and downcase to themselves, so they're excluded.)
def "str is-upper" [c: string] {
    (($c | str upcase) == $c) and (($c | str downcase) != $c)
}

# Returns true if a single-character string is a lowercase letter.
def "str is-lower" [c: string] {
    (($c | str downcase) == $c) and (($c | str upcase) != $c)
}

# split string into words based on common casing styles
def "split semantic-words" []: string -> list<string> {
    let input = $in
    mut words = []
    let runes = ($input | split chars)
    let n = ($runes | length)
    mut start = 0
    mut current_word = ""
    mut prev_rune = ""   # Go's rune(0) sentinel -> empty string (str is-lower "" is false)

    for $i in 0..<$n {
        let r = ($runes | get $i)

        if (str is-upper $r) {
            # lower -> upper transition is always a word boundary (e.g. "aB")
            if (str is-lower $prev_rune) {
                if $current_word != "" {
                    $words = ($words | append $current_word)
                }
                $current_word = $r
                $start = $i
                $prev_rune = $r
                continue
            }

            if $i < ($n - 1) {
                let next = ($runes | get ($i + 1))

                # part of an acronym run (next char isn't lowercase) -> keep accumulating
                if not (str is-lower $next) {
                    $current_word = $current_word + $r
                    $prev_rune = $r
                    continue
                }

                # acronym followed by a lowercase word starts a new word (e.g. "XMLParser" -> "XML","Parser")
                if $current_word != "" {
                    $words = ($words | append $current_word)
                }

                $current_word = $r
                $start = $i
                $prev_rune = $r
                continue
            }

            # last character
            $current_word = $current_word + $r
            $prev_rune = $r
        } else if (str is-lower $r) {
            $current_word = $current_word + $r
            $prev_rune = $r
        } else {
            # non-letter: flush and reset
            if $current_word != "" {
                $words = ($words | append $current_word)
            }
            $current_word = ""
            $start = $i + 1
            $prev_rune = $r
        }
    }

    if $current_word != "" {
        $words = ($words | append $current_word)
    }

    $words
}

# ## change the casing of strings
#
# ### flags:
#  - first character:
#   - 'l' - words are lowercase
#   - 'u' - words are UPPERCASE
#   - 'p' - words are PascalCase
#   - 'c' - words are camelCase
#   - 's' - first letter of first word is uppercase, rest is lowercase (sentence)
#   - 'r' - randomize uppercase and lowercase
#  - second character
#   - the second character is interpreted literally
#   - '_' - words are separated by an underscore (snake_case)
#   - '-' - words are separated by a dash (kebab-case)
# 
# ### recipes
#
# - snake_case: `str case l_`
# - SCREAMING_SNAKE_CASE: `str case u_`
# - Normal sentence structure: `str case 's '` (need quites to capture the space)
# - kebab-case: `str case l-`
# - Pascal_Case_With_Underscores: `str case p_`
# - RANdOM CASING wiTH SpAces (sarcasm casing): `str case 'r '` (need quites to capture the space)
def "str case" [
    flags: string
    ...rest: cell-path
] {
    let inputs = $in

    if ($flags | str length) > 2 {
        print -e "too many flags passed. max 2"
        return
    }

    let type = $inputs | describe

    if $type == string {
        let words = $inputs | split semantic-words
        let casing_style = $flags | split chars | first
        let separator = $flags | split chars | last

        match $casing_style { 
            'l' => {
                $words | str downcase | str join $separator
            }
            'u' => {
                $words | str upcase | str join $separator
            }
            'p' => {
                $words | str downcase | str pascal-case | str join $separator
            }
            'c' => {
                let lower = $words | str downcase
                let first = $lower | first
                let rest = $lower | skip | str pascal-case
                $rest | prepend $first | str join $separator
            }
            's' => {
                let lower = $words | str downcase
                let first = $lower | first | str pascal-case
                let rest = $lower | skip
                $rest | prepend $first | str join $separator
            }
            'r' => {
                $words 
                | str downcase 
                | each { |word| $word 
                    | split chars 
                    | each { |c| if (random bool) { $c | str upcase } else { $c } } 
                    | str join ""
                } | str join $separator
            }
        }
    } else if $type == "list<string>" {
        $inputs | each { |input|
            $input | str case $flags
        }
    } else if ($type | str starts-with "record") {
        if ($rest | is-empty) {
            error make {msg: "pass cell path for table",}
        }

        let input = $inputs 
        | get ($rest | first) ...($rest | skip) 

        let result = $input | str case $flags ...$rest
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
            $input | str case $flags ...$rest
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
