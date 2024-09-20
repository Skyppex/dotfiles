def "bcp" [
    key: string
    api_id: string
    api_key: string
    file: string
] {
    let enc = $file
    let file = ($file | str replace ".enc" "")

    let data = [
        ["AWS_DEV", "dev"],
        ["AWS_TEST", "test"],
        ["AWS_PREPROD", "pre"],
        ["AWS_PROD", "prod"],
    ]

    for d in $data {
        let aws = $d | get 0
        let name = $d | get 1

        print (ls)
        cd $aws
        print (ls)
        edcrypt --decryptFile --key=($key) ($enc)
        let content = open $file
        let string_data = ($content | get stringData)
        let string_data = ($string_data
            | upsert BCP_API_ID { $api_id }
            | upsert BCP_API_KEY { $api_key })
        let content = ($content | update stringData { $string_data })
        print $string_data
        print (ls)
        $content | save --force $file
        edcrypt --encryptFile --key=($key) ($file)
        cd ..
    }
}

def "aws" [
    from: string
    to: string
] {
    let launch_settings_path = glob "**/launchSettings.json"
    | to text
    | fzf --height 40% --layout=reverse -0 -1

    print $launch_settings_path
    let launch_settings = open $launch_settings_path -r
    let launch_settings = $launch_settings | str replace -a $"\"($from)\"" $"\"($to)\""
    $launch_settings | save --force $launch_settings_path

    git diff

    gc -b us 42852 set aws env to local

    let answer = input "Do you want to push the changes?"

    if $answer == "y" {
        gcp set aws env to local
        gh pr create
        gh pr merge --auto
        gcm
    }
}
