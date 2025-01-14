def --env dotenv [file: string] {
    let file = $file
    let content = open $file -r
    let lines = $content | lines

    for $line in $lines {
        if ($line | str starts-with "#") {
            continue
        }

        if ($line | str starts-with "export" | n) {
            continue
        }

        let assignment = $line 
        | str strip-prefix "export" 
        | str trim

        let parts = $assignment | split row --number 2 "="
        let name = $parts.0 | str trim
        mut value = $parts.1 | str trim | str trim --char '"'
        let i = $value | str index-of "#"

        if $i >= 0 {
            $value = ($value | str substring 0..($i - 1))
        }

        print $"$env.($name) = ($value)"
        set-env $name $value
    }
}
