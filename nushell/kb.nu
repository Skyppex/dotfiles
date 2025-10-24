export def activate [] {
    $env.AWS_PROFILE = "dev"
    aws sso login
}

export alias a = activate

export def switch [] {
    let contexts = kubectl config get-contexts --no-headers
    | awk "{print $1}"
    | lines
    | where { |it| $it | str starts-with "*" | n }

    let selected = $contexts | to text | fzf --height 40% --layout=reverse

    if ($selected | is-empty) {
        print -e "no context selected"
        return
    }

    let namespaces = kubectl get namespaces --no-headers
    | lines 
    | to text 
    | awk "{print $1}"

    let selected_ns = $namespaces | fzf --height 40% --layout=reverse

    if ($selected_ns | is-empty) {
        print -e "no namespace selected"
        return
    }

    kubectl config use-context $selected
    kubectl config set-context --current --namespace=($selected_ns)
}

export alias sw = switch

export def "switch profile" [] {
    let profiles = [dev, test, pre, pro];
    let selected = $profiles | to text | fzf --height 40% --layout=reverse
    $env.AWS_PROFILE = $selected
}

export alias "sw pf" = switch profile

export def pods [] {
    kubectl get pods | lines
}

export def pod [] {
    kubectl get pods --no-headers
    | lines 
    | to text 
    | fzf --height 40% --layout=reverse 
    | awk "{print $1}"
}

export def containers [--pod: string] {
    let pod = if ($pod | is-empty) { pod } else { $pod }

    if ($pod | is-empty) {
        print -e "no pod selected"
        return
    }

    let containers = kubectl get pod $pod --output jsonpath='{.spec.containers[*].name}'
    let init_containers = kubectl get pod $pod --output jsonpath='{.spec.initContainers[*].name}'
    $containers | split row -r '\s' | append ($init_containers | split row -r '\s')
}

export alias cts = containers

export def container [--pod: string] {
    if ($pod | is-empty) {
        containers | to text | fzf --height 40% --layout=reverse
    } else {
        containers --pod $pod | to text | fzf --height 40% --layout=reverse
    }
}

export alias ct = container

export def --wrapped logs [...rest] {
    let pod = pod

    if ($pod | is-empty) {
        print -e "no pod selected"
        return
    }


    let container = container --pod $pod

    if ($container | is-empty) {
        print -e "no container selected"
        return
    }

    print -e $"($pod) - ($container)"
    kubectl logs $pod --container $container ...$rest
}

export alias lg = logs
