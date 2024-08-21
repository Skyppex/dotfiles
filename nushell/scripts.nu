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
            | insert BCP_API_ID { $api_id }
            | insert BCP_API_KEY { $api_key })
        let content = ($content | update stringData { $string_data })
        print $string_data
        print (ls)
        $content | save --force $file
        edcrypt --encryptFile --key=($key) ($file)
        cd ..
    }
}
