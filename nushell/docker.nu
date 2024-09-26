def "dk run" [
    --verbose(-v)
    --env-file(-e): string
    ...query: string
] {
    let images = docker images --all
    let selected = $images 
    | lines 
    | skip 
    | where ($it | str starts-with "<none>" | n) 
    | to text 
    | fzf --height 40% --layout=reverse -0 -1 --query ($query | str join " ")

    let selected = $selected | split row -r " +" | get 2

    if ($env_file | is-empty) {
        docker run $selected
        return
    }

    if $verbose {
        print $env_file
    }

    docker run $selected --env-file $env_file
}

def "dk build" [
    --verbose(-v)
    --tag(-t): string,
    --build-args-file(-b): string
    --no-cache(-c)
    path: string
] {
    mut build_args = []

    let args = open $build_args_file | lines

    for arg in $args { 
        $build_args = ($build_args | append $"--build-arg ($arg)")
    }

    mut args = []

    if ($tag | is-not-empty) {
        $args = ($args | append $"--tag $tag")
    }

    if $no_cache {
        $args = ($args | append "--no-cache")
    }

    $args = ($args | append $build_args)

    if $verbose {
        print $"docker build ($path) ($args | str join ' ')"
    }

    docker build $path ($args | str join " ")
}
