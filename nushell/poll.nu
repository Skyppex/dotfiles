def --wrapped poll [
    --sleep: duration
    --help(-h)
    ...rest
] {
    if $help {
        help follow
        return
    }

    let sleep = if ($sleep | is-empty) {
        1sec
    } else {
        $sleep
    }

    let joined = $rest | str join ' '

    if ($joined | is-empty) {
        error make { msg: "no command to poll" }
    }

    loop {
        let result = do { nu --commands $joined } | complete

        if ($result.stdout | is-not-empty) {
            print $result.stdout
        }

        if ($result.stderr | is-not-empty) {
            print $result.stderr
        }

        if $result.exit_code != 0 {
            break
        }

        sleep $sleep
    }
}
