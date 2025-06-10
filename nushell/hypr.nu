def hypr-parse [
    header_regex?: string
]: string -> table {
    plugin use regex;

    let inputs = $in | split row -r "\r?\n\r?\n" | each { |it| lines }

    mut table = []

    for input in $inputs { 
        mut record = {}
        if ($header_regex | is-not-empty) { 
            let captures = $input | first 
            | regex $header_regex 
            | select capture_name match
            | skip 1

            for capture in $captures { 
                $record = $record | insert $capture.capture_name $capture.match
            }
        }

        let rest = $input | skip 1

        for entry in $rest { 
            let match = $entry 
            | regex '\s*(\w+):\s*(.*)'
            | select match
            | skip 1

            $record = $record 
            | insert ($match | get 0 | get match) ($match | get 1 | get match)
        }

        $table = $table | append $record
    }

    $table
}
