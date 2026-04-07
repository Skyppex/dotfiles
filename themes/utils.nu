#!/usr/bin/env nu

def gompl [
    template: path
    out: path
]: table<name: string, url: path> -> nothing {
    let sources = $in | each { |it|
        ["--datasource", $"($it.name)=($it.url | path expand)"]
    } 
    | flatten

    gomplate --file $template --out $out ...$sources
}

