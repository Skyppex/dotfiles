def "kb activate" [] {
    $env.AWS_PROFILE = "dev"
    aws sso login
}

alias "kb a" = kb activate

def "kb switch" [] {
    let contexts = kubectl config get-contexts --no-headers
    | awk "{print $1}"
    | lines
    | where { |it| $it | str starts-with "*" | n }

    let selected = $contexts | to text | fzf --height 40% --layout=reverse

    if ($selected | is-empty) {
        print -e "no context selected"
        return
    }

    let namespaces = kubectl get namespaces 
    | lines 
    | skip 1 
    | to text 
    | awk "{print $1}"

    let selected_ns = $namespaces | fzf --height 40% --layout=reverse

    if ($selected_ns | is-empty) {
        print -e "no namespace selected"
        return
    }

    kubectl config use-context $selected
    kubectl config set-context --current --namespace=$selected_ns
}

alias "kb sw" = kb switch

def "kb switch profile" [] {
    let profiles = [dev, test, pre, pro];
    let selected = $profiles | to text | fzf --height 40% --layout=reverse
    $env.AWS_PROFILE = $selected
}

alias "kb sw pf" = kb switch profile

def "kb pods" [] {
    kubectl get pods | lines
}

alias "kb pds" = kb pods

def "kb pod" [] {
    kubectl get pods 
    | lines 
    | skip 1 
    | to text 
    | fzf --height 40% --layout=reverse 
    | awk "{print $1}"
}

alias "kb pd" = kb pod

def "kb containers" [--pod: string] {
    let pod = if ($pod | is-empty) { kb pod } else { $pod }

    if ($pod | is-empty) {
        print -e "no pod selected"
        return
    }

    let containers = kubectl get pod $pod --output jsonpath='{.spec.containers[*].name}'
    let init_containers = kubectl get pod $pod --output jsonpath='{.spec.initContainers[*].name}'
    $containers | split row -r '\s' | append ($init_containers | split row -r '\s')
}

alias "kb cts" = kb containers

def "kb container" [--pod: string] {
    if ($pod | is-empty) {
        kb containers | to text | fzf --height 40% --layout=reverse
    } else {
        kb containers --pod $pod | to text | fzf --height 40% --layout=reverse
    }
}

alias "kb ct" = kb container

def --wrapped "kb logs" [...rest] {
    let pod = kb pod

    if ($pod | is-empty) {
        print -e "no pod selected"
        return
    }


    let container = kb container --pod $pod

    if ($container | is-empty) {
        print -e "no container selected"
        return
    }

    print -e $"($pod) - ($container)"
    kubectl logs $pod --container $container ...$rest
}

alias "kb lg" = kb logs
