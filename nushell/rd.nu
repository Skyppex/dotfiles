alias redis = redis-cli -h $env.REDIS_HOST -p $env.REDIS_PORT

export def --env connect [url: string] {
    let url = if ($url | str contains "://" | n) {
        $"redis://($url)"
    } else {
        $url
    }

    let url = $url | url parse

    if $url.scheme != "redis" {
        print -e $"invalid scheme: ($url.scheme)"
    }

    $env.REDIS_HOST = $url.host
    $env.REDIS_PORT = $url.port
}

export def --env disconnect [] {
    $env.REDIS_HOST = null
    $env.REDIS_PORT = null
}

export alias u = connect

export def status [] {
    {
        scheme: "redis"
        host: $env.REDIS_HOST
        port: $env.REDIS_PORT
    }
}

export alias st = status

export def list [
    --no-ttl
] {
    redis --scan
    | lines
    | str replace --all '"' ""
    | each { |key| 
        if $no_ttl {
            { key: $key }
        } else {
            let ttl = ((redis PTTL $key) + "ms") | into duration
            { key: $key, ttl: $ttl }
        }
    }
    | sort-by key
}

export alias ls = list
export alias keys = list --no-ttl

alias "builtin get" = get


export def find [] {
    keys 
    | builtin get key 
    | to text 
    | ^fzf --height 40% --layout reverse
}

export alias fd = find

export def get [] {
    let selection = find

    if ($selection | is-empty) {
        print -e "no key selected"
        return
    }

    redis GET $selection
}

export def hget [] {
    let selection = find

    if ($selection | is-empty) {
        print -e "no key selected"
        return
    }

    redis HGET $selection
}

export def length [] {
    let selection = find

    if ($selection | is-empty) {
        print -e "no key selected"
        return
    }

    let type = redis TYPE $selection

    if $type == "string" {
        redis STRLEN $selection
    } else {
        print -e $"value of type '($type)' is not supported.
        add it, cause redis probably does support it:)"
    }
}

export alias len = length

export def size [] {
    let selection = find

    if ($selection | is-empty) {
        print -e "no key selected"
        return
    }

    redis MEMORY USAGE $selection
}

def update-type [key: string, type: string] {
    let input = $in

    $input | update $key (
        $input | builtin get $key | match $type {
            "filesize" => ($in | into filesize),
            "duration" => ($in | into duration),
            "float" => ($in | into float),
            "int" => ($in | into int),
        }
    )
}

export def memory [] {
    let memory = redis INFO memory
    | lines
    | skip 1
    | parse --regex "^(?P<key>.*):(?P<value>.*)"
    | transpose --header-row --as-record

    $memory 
    | update-type "used_memory" "filesize"
    | update-type "used_memory_rss" "filesize"
    | update-type "used_memory_peak" "filesize"
    | update-type "used_memory_peak_time" "duration"
    | update-type "used_memory_overhead" "filesize"
    | update-type "used_memory_startup" "filesize"
    | update-type "used_memory_dataset" "filesize"
    | update-type "allocator_allocated" "filesize"
    | update-type "allocator_active" "filesize"
    | update-type "allocator_resident" "filesize"
    | update-type "allocator_muzzy" "filesize"
    | update-type "total_system_memory" "filesize"
    | update-type "used_memory_lua" "filesize"
    | update-type "used_memory_vm_eval" "filesize"
    | update-type "used_memory_scripts_eval" "filesize"
    | update-type "number_of_cached_scripts" "int"
    | update-type "number_of_functions" "int"
    | update-type "number_of_libraries" "int"
    | update-type "used_memory_vm_functions" "filesize"
    | update-type "used_memory_vm_total" "filesize"
    | update-type "used_memory_functions" "filesize"
    | update-type "used_memory_scripts" "filesize"
    | update-type "maxmemory" "filesize"
    | update-type "allocator_frag_ratio" "float"
    | update-type "allocator_frag_bytes" "filesize"
    | update-type "allocator_rss_ratio" "float"
    | update-type "allocator_rss_bytes" "filesize"
    | update-type "rss_overhead_ratio" "float"
    | update-type "rss_overhead_bytes" "filesize"
    | update-type "mem_fragmentation_ratio" "float"
    | update-type "mem_fragmentation_bytes" "filesize"
    | update-type "mem_not_counted_for_evict" "int"
    | update-type "mem_replication_backlog" "float"
    | update-type "mem_total_replication_buffers" "float"
    | update-type "mem_replica_full_sync_buffer" "float"
    | update-type "mem_clients_slaves" "float"
    | update-type "mem_clients_normal" "float"
    | update-type "mem_cluster_slot_migration_output_buffer" "float"
    | update-type "mem_cluster_slot_migration_input_buffer" "float"
    | update-type "mem_cluster_slot_migration_input_buffer_peak" "float"
    | update-type "mem_cluster_links" "float"
    | update-type "mem_aof_buffer" "float"
    | update-type "mem_overhead_db_hashtable_rehashing" "float"
    | update-type "active_defrag_running" "float"
    | update-type "lazyfree_pending_objects" "float"
    | update-type "lazyfreed_objects" "float"
    | reject "used_memory_human"
    | reject "used_memory_rss_human"
    | reject "used_memory_peak_human"
    | reject "used_memory_lua_human"
    | reject "total_system_memory_human"
    | reject "used_memory_vm_total_human"
    | reject "used_memory_scripts_human"
    | reject "maxmemory_human"

}

export alias mem = memory
export alias clients = redis INFO clients
export alias replication = redis INFO replication

export def type [] {
    let selection = find

    if ($selection | is-empty) {
        print -e "no key selected"
        return
    }

    redis TYPE $selection
}

export alias set = redis SET

export def expire [duration: duration] {
    let selection = find

    if ($selection | is-empty) {
        print -e "no key selected"
        return
    }

    let milliseconds = $duration | format duration ms | str strip-suffix " ms"
    redis PEXPIRE $selection $milliseconds
}

export def delete [] {
    let selection = find

    if ($selection | is-empty) {
        print -e "no key selected"
        return
    }

    redis DEL $selection
}

export alias del = delete
export alias rm = delete
