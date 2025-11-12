def --wrapped poll [
    --interval(-i): duration
    --count(-n): int
    --help(-h)
    ...rest
] {
    if $help {
        help follow
        return
    }

    let interval = if ($interval | is-empty) {
        1sec
    } else {
        $interval
    }

    let joined = $rest | str join ' '

    if ($joined | is-empty) {
        error make { msg: "no command to poll" }
    }

    mut current = if ($count | is-empty) {
        0
    } else {
        $count
    }

    loop {
        let result = do { nu --commands $joined } | complete

        if ($result.stdout | is-not-empty) {
            print ($result.stdout | str trim --right "\r")
        }

        if ($result.stderr | is-not-empty) {
            print -e ($result.stderr | str trim --right "\r")
        }

        if $result.exit_code != 0 {
            break
        }

        if ($count | is-not-empty) {
            $current = $current - 1

            if ($current <= 0) {
                break
            }
        }

        sleep $interval
    }
}
