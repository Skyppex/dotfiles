use ~/.cache/starship/init.nu
source ~/.config/zoxide/.zoxide.nu

# Externs

# Calculate the result of a dice roll
export extern "dice" [
    --help(-h) # Print a more detailed help message
    --expr(-e) # Print the expression used to calculate the result
    --time(-t) # Print the time it took to calculate the result
    --mode(-m): string #Specify the evaluation mode (default: "random") [avg, simavg:uint, min, max, med]
    ...roll: string # The dice roll to calculate. eg: 2d6+1 or 2d20k or 2d20kl or 1d6! or 1d6!! or 1d6r<=5 or 1d6r=!6
]

# Curl
export extern curl [
    --help(-h) # Get help for commands
    --data(-d): string # <data> HTTP POST data
    --fail(-f) # Fail fast with no output on HTTP errors
    --include(-i) # Include protocol response headers in the output
    --output(-o): string # <file> Write to file instead of stdout
    --silent(-s) # Silent mode
    --upload-file(-T): string # <file> Transfer local FILE to destination
    --user(-u): string # <user:password> Server user and password
    --user-agent(-A): string # <name> Send User-Agent <name> to server
    --verbose(-v) # Make the operation more talkative
    --version(-V) # Show version number and quit
    url: string
]

# Copy to clipboard
export extern "clip" []

# Utils

# Elevate the current shell to admin
alias sudo = gsudo

# Exit
alias q = exit

# Make directory
alias md = mkdir

# Bash
alias sh = bash

# Current working directory
alias loc = echo $"($env.PWD)"

# Paste from the clipboard
alias paste = powershell -command "Get-Clipboard"

# Split lines in a string into rows
alias "split lines" = split row "\n"

# Remove all files from the Downloads folder
def rmdl [] {
    let files = ls ~/Downloads
    for file in $files {
        rm -rv $file.name
    }
}

# History

# Extra utilities for managing the history file
def h [
    --help(-h) # Display the help message for this command
    --clear(-c): int # Clears out the history entries
    --clear-contains(-f): string # Clears out the history entries that match the filter
    --clear-starts-with(-s): string # Clears out the history entries that match the filter
    --long(-l) # Show long listing of entries for sqlite history
] {
    if $help {
        history --help
        return
    }

    if $clear != null {
        if $clear <= 0 {
            history --clear
            return
        }
        
        let history = open $nu.history-path
            | split lines
            | reverse
            | skip ($clear + 1)
            | reverse
        $history | append ""
            | str join "\n"
            | save --force $nu.history-path

        return
    }

    if $clear_contains != null {
        if $clear_contains == "" {
            print "An empty filter was provided, exiting."
            return
        }

        mut history = open $nu.history-path
            | split lines
            | reverse
            | where ($it | str contains --not $clear_contains)
            | reverse

        $history
            | str join "\n"
            | save --force $nu.history-path

        return
    }
    
    if $clear_starts_with != null {
        if $clear_starts_with == "" {
            print "An empty filter was provided, exiting."
            return
        }

        mut history = open $nu.history-path
            | split lines
            | reverse
            | where { |line|
                let starts_with = $line | str starts-with $clear_starts_with
                not $starts_with
            } | reverse

        $history
            | str join "\n"
            | save --force $nu.history-path

        return
    }
}

# Config / Env

# Open the custom nushell config file in vscode
alias conf = code $"($nu.home-path)/.config/nushell/custom.nu"

# Open the nushell env file in vscode
alias env = code $nu.env-path

# Open the config workspace in vscode
alias dconf = code $"($nu.home-path)/.config"

# Pull the dotfiles from the remote repository
def "pull dot" [] {
    enter $"($nu.home-path)/.config"
    print "---- pulling config ----"
    git pull --rebase
    git submodule update --init --recursive
    print "---- updating scoop ----"
    scoop update
    print "---- installing scoop apps ----"
    manifest install
    print "---- updating scoop apps ----"
    scoop update -a
    p # return to previous directory
}

# Push the dotfiles to the remote repository
def "push dot" [] {
    print "---- fixing nushell plugins ----"
    open ~/.config/nushell/plugin.nu | str replace -ar '[Cc]:\\[Uu]sers\\.*?\\' '~\' | save -f ~/.config/nushell/plugin.nu
    print "---- updating scoop manifest ----"
    manifest update
    enter $"($nu.home-path)/.config"
    print "---- pushing config ----"
    gcp "update config files"
    p
}

# Startship

# Open the starship config file in vscode
alias sc = code ~/.config/starship.toml

# Open the starship schema file in vscode
alias ss = code ~/.config/starship-schema.json

# Zoxide

# Zoxide query
alias cdq = zoxide query

# Git

# Git pull
alias gpl = git pull

# Git push
alias gps = git push

# Git push with force and lease
alias gpf = git push --force-with-lease

# Git checkout main or master
def gcm [] {
    do -ip { git checkout main --quiet }
    let branch = git branch --show-current
    
    if ($branch == "main") {
        print "Switched to main branch"
        return;
    }

    do -ip { git checkout master --quiet }
    
    let branch = git branch --show-current
    
    if ($branch == "master") {
        print "Switched to master branch"
        return;
    }

    print "Couldn't find main or master branch"
    return;
}

# Git add all, amend
def gca [] {
    git add -A
    git commit --amend
}

# Git sync with commit message
def "git sync" [message: string] {
    gpr
    gcp $message
}

# Git pull with rebase and submodule update recursive
def gpr [] {
    git pull --rebase
    git submodule update --init --recursive
}

# Git commit and push
def gcp [message: string] {
    git add -A
    git commit -m $"($message)"
    git push
}

# Git stash and checkout
def gsw [branch: string] {
    git stash -u
    git checkout $"($branch)"
}

# Git checkout
def gc [branch: string] {
    git checkout $"($branch)"
}

# Scoop

# Open the scoop user manifest file
alias manifest = open $"($nu.home-path)/.config/scoop/user_manifest.json"

# Create the scoop user manifest file
def "manifest create" [] {
    touch $"($nu.home-path)/.config/scoop/user_manifest.json"
}

# Update the scoop user manifest file with installed scoop apps
def "manifest update" [] {
    scoop export | save --force $"($nu.home-path)/.config/scoop/user_manifest.json"
}

# Install scoop apps from the user manifest file
def "manifest install" [] {
    scoop import $"($nu.home-path)/.config/scoop/user_manifest.json"
}

# Remove the scoop user manifest file
def "manifest rm" [] {
    rm $"($nu.home-path)/.config/scoop/user_manifest.json"
}

# Nushell

# Add a plugin to the nushell config
def "plugin add" [name: string] {
    let plugin = $"~/.cargo/bin/($name).exe";
    nu -c $'register ($plugin)'
    version
}

# Neovim

# Open neovim
alias vim = nvim

# Fun

# Echo 'Hello, $user'
alias "hello world" = echo $"Hello, (whoami)!"

# Echo a sentence with all the letters of the alphabet only appearing once
alias cwm = echo "Cwm fjord bank glyphs vext quiz"

# Echo a sentence with all the letters of the alphabet
alias fox = echo "The quick brown fox jumps over the lazy dog"

# Echo a sentence with all the letters of the alphabet
alias dwarf = echo "Pack my box with five dozen liquor jugs"

# Echo the lorem ipsum text
def lorem [] {
    let lorem = [
        "Lorem ipsum dolor sit amet, erroribus constituam duo ut. Eum audiam disputando",
        "\nne, ius an assum offendit consequat. Per iuvaret detraxit et, nominati torquatos",
        "\ncu nec. Ei ius luptatum explicari, ex has dolorum facilisis voluptatum. Te sed",
        "\ntibique recteque imperdiet, altera invidunt liberavisse cu has. Id qui probo",
        "\ndolorem, tota porro ei eum.",
        "\n",
        "\nCu duo nostrum invenire, laboramus vituperata conclusionemque et quo. Errem",
        "\niudico et vim, no omnium accusata ius. Detracto argumentum vis et. Nam liber",
        "\nessent facete in, in eum virtute ancillae, dico magna ea cum.",
        "\n",
        "\nIn audire pertinax vis, sed id insolens mnesarchum mediocritatem. Enim labore et",
        "\nquo, nam ex aperiam interesset. Vis nonumy aliquip ei, nec habeo ridens impedit",
        "\nei. Ea eam eleifend posidonium, no quo enim consequuntur, usu eu omnesque",
        "\niracundia. Vim cu tamquam argumentum disputando.",
        "\n",
        "\nNo his iracundia voluptatibus, eos assum placerat no. Ex vel vivendo copiosae.",
        "\nAccusam sapientem eam eu, ex duo solum ludus, an equidem accusamus euripidis",
        "\nmel. Case epicurei ad sed, rebum nominati vix ei, tota ceteros corrumpit has in.",
        "\n",
        "\nId sit graece quodsi prodesset. Cu est sint elaboraret, sed veri timeam no.",
        "\nRebum fugit populo eu eos. Eu regione enserit honestatis vix, nobis detraxit",
        "\nduo ut. Te audiam iisque vel. Id cum choro efficiantur, per eu ubique discere",
        "\nscripserit, nec meliore accusam invidunt id. Stet fabellas qui an, mei id",
        "\nplacerat ponderum.",
        "\n",
        "\nGraeco singulis ei per, no tation interpretaris sed. Vim agam petentium an,",
        "\nte per wisi ludus homero. Ea iuvaret efficiendi mea, vide assum dolorum ius",
        "\nno. Fabulas feugait no cum. Nobis epicurei abhorreant vel eu, rebum dolor vim",
        "\nad, vel menandri praesent intellegam no. Quo corpora percipitur et, ut admodum",
        "\nullamcorper mel.",
        "\n",
        "\nDecore suscipiantur duo ei. Nec id hinc libris. Dolorum lucilius principes eos",
        "\ncu, eam ad tation alterum. Posse probatus at est.",
        "\n",
        "\nEirmod option philosophia ne mel. Ut magna eirmod eos. Putant everti salutatus",
        "\neu has. Affert patrioque persequeris usu ne. No vocent iuvaret elaboraret vis,",
        "\nne sit vitae urbanitas omittantur. Has eripuit splendide efficiantur ad, ad eos",
        "\nomnium docendi salutandi.",
        "\n",
        "\nNe dicant adipiscing constituam mea. Vivendum disputationi sed id. Mel tale",
        "\ntantas no. Eu odio consulatu ullamcorper vel, nam aliquip oportere consulatu at.",
        "\nNe iudico consequuntur eos, facilis laboramus id pri, no mea cibo salutandi.",
        "\n",
        "\nSonet adipiscing an nec. Quo at erroribus explicari, dissentiunt disputationi eu",
        "\nest. Elit sale sonet no ius. An vis libris dolorum. At cibo corrumpit duo. Vis",
        "\nei omnium audiam admodum.",
        "\n",
        "\nSit et probo antiopam elaboraret, ei fabulas blandit mei. Assum labitur civibus",
        "\nin quo. Clita minimum sit eu, vel nulla ludus persecuti ei. Suscipit appetere",
        "\nvivendum te sea. Te nec officiis nominati pericula, cu habeo dicam eum, velit",
        "\nscripta maluisset no sed.",
        "\n",
        "\nEt graeci aliquip deserunt est. Qui detracto similique eu. Pro cu assentior",
        "\nmediocritatem, his zril facilis vivendum ut. Duo no error periculis",
        "\nvituperatoribus. Ius solum labore antiopam ei, blandit salutandi adolescens eam",
        "\ncu, prodesset contentiones reprehendunt id vix.",
        "\n",
        "\nPri diceret eruditi ea, reque impetus duo in. Pri brute munere corrumpit te, ex",
        "\nfacete omnesque democritum vim. An modus labore duo, stet regione temporibus ne",
        "\nsed. His no veri vivendo maiestatis, ad liber officiis eum.",
        "\n",
        "\nVide regione iuvaret his an. Ne vis tibique suavitate, at usu legimus",
        "\nadolescens. Te per oratio verear, cu sumo magna sea, vim no sumo graeci",
        "\nrecusabo. Natum forensibus argumentum nec no, dico nemore aeterno id sed, mei",
        "\nquod indoctum argumentum an. Vel euismod reprehendunt at, cum ne dicunt commune",
        "\niudicabit. Cum ne debitis inciderint reprehendunt, vix albucius dissentias",
        "\nconcludaturque in.",
        "\n",
        "\nVim brute aliquam repudiandae eu. Qui ludus ceteros salutatus id. Vel te melius",
        "\ninermis, sea at maluisset similique. Consul nostrum ei vim. Mea eius aperiam",
        "\nmnesarchum te.",
        "\n",
        "\nCu nibh verterem electram per. Iusto noster nam ad, ius ne eligendi inimicus.",
        "\nNisl intellegam neglegentur an mel, in eos diam agam possit, mea cu assum",
        "\nconclusionemque. Nihil invidunt facilisi mea et, ea populo nusquam ius. Nec",
        "\nte quem aliquid, usu ex soleat expetendis quaerendum. Mel at iriure mentitum",
        "\npostulant, vivendum contentiones est eu. Sea an tollit convenire temporibus.",
        "\n",
        "\nVis ad quis falli, est ad dictas dicunt adipisci. Laudem consulatu ex vix,",
        "\npostea platonem theophrastus eu eos, copiosae appetere adipiscing vim ad. Vim",
        "\nnulla recteque ei, vix ex etiam dicam invidunt. Mea ne graece patrioque. Pri cu",
        "\ntation recusabo interesset. His at doctus copiosae signiferumque.",
        "\n",
        "\nInvenire patrioque ei eum, brute putent te vim. Legere cetero qui ex, deseruisse",
        "\ncotidieque consequuntur mel ea. Enim choro id mel. Usu no labitur fuisset",
        "\ntemporibus.",
        "\n",
        "\nMei an nibh definiebas, odio aperiam consequat vis no. Ut duo veri impedit",
        "\nrationibus. Est eu erat ancillae. Nobis docendi appareat eam cu, erant laudem an",
        "\nquo.",
        "\n",
        "\nQuo ex labitur quaeque ocurreret. Honestatis eloquentiam appellantur est ei, mei",
        "\nveritus nusquam at. Vis te periculis conclusionemque, sed ne integre luptatum",
        "\nconstituto. Eos ex accumsan forensibus conclusionemque. Verterem conclusionemque",
        "\nno sea, sed soluta fabulas ex. Clita detracto lucilius eu sea, nam esse recusabo",
        "\nne, aperiri adipiscing no sed. Tale persius comprehensam qui id, qui aliquam",
        "\nconstituam et."
    ]

    let result = $lorem | str join ""
    echo $result
}
