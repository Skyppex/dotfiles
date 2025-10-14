export alias ls = nmcli connection show

export def wifi [] {
    nmcli device status

    print -e "scanning for wifi stations..."

    let wifi_stations = nmcli device wifi list --rescan auto
    | parse table --header '\s\s+'
    | update IN-USE { |v|
        if ($v.IN-USE == "*") {
            true
        } else {
            false
        }
    }

    if ($wifi_stations | is-empty) {
        print -e "no wifi stations found"
        return
    }

    let selected = $wifi_stations 
    | where (not $it.IN-USE)
    | each {|it|
        let ssid_len = $it.SSID | str length
        let tabs = if $ssid_len < 4 { "\t\t" } else { "\t" }
        $"($it.BSSID) - ($it.SSID)($tabs)($it.RATE)\t($it.SECURITY)"
    }
    | to text
    | fzf --height 40% --layout reverse

    let bssid = $selected | str substring ..16

    let i = $selected | str index-of "\t"
    let ssid = $selected | str substring 20..($i - 1)

    print -e $"connecting to ($ssid) - ($bssid)"
    nmcli device wifi connect $bssid --ask
}

export alias connect = nmcli connection up
export alias disconnect = nmcli connection down
