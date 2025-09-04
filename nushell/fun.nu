# Wrapper for wezterm imgcat using fzf to find images
def img [
    --width(-W): int # Specify the display width; defaults to "auto" which automatically selects an appropriate size.  You may also use an integer value `N` to specify the number of cells, or `Npx` to specify the number of pixels, or `N%` to size relative to the terminal width
    --height(-H): int # Specify the display height; defaults to "auto" which automatically selects an appropriate size.  You may also use an integer value `N` to specify the number of cells, or `Npx` to specify the number of pixels, or `N%` to size relative to the terminal height
    --no-preserve-aspect-ratio(-P) # Do not respect the aspect ratio.  The default is to respect the aspect ratio
    --position(-p): string # Set the cursor position prior to displaying the image. The default is to use the current cursor position. Coordinates are expressed in cells with 0,0 being the top left cell position
    --no-move-cursor(-M) # Do not move the cursor after displaying the image. Note that when used like this from the shell, there is a very high chance that shell prompt will overwrite the image; you may wish to also use `--hold` in that case
    --hold # Wait for enter to be pressed after displaying the image
    --max-pixels(-m): int # Set the maximum number of pixels per image frame. Images will be scaled down so that they do not exceed this size, unless `--no-resample` is also used. The default value matches the limit set by wezterm. Note that resampling the image here will reduce any animated images to a single frame [default: 25000000]
    --no-resample(-R) # Do not resample images whose frames are larger than the max-pixels value. Note that this will typically result in the image refusing to display in wezterm
    --resample-format: string # Specify the image format to use to encode resampled/resized images.  The default is to match the input format, but you can choose an alternative format [default: input] [possible values: png, jpeg, input]
    --resample-filter: string # Specify the filtering technique used when resizing/resampling images.  The default is a reasonable middle ground of speed and quality [default: catmull-rom] [possible values: nearest, triangle, catmull-rom, gaussian, lanczos3]
    --resize(-r): string # Pre-process the image to resize it to the specified dimensions, expressed as eg: 800x600 (width x height). The resize is independent of other parameters that control the image placement and dimensions in the terminal; this is provided as a convenience preprocessing step
    --show-resample-timing(-t) # When resampling or resizing, display some diagnostics around the timing/performance of that operation
    --direct(-d) # Use the weztern imgcat command directly instead of going through fzf
    search_root: string # The name of the image file to be displayed. If omitted, will attempt to read it from stdin
    file_name?: string # The name of the image file to be displayed. If omitted, will attempt to read it from stdin
] {
    let stdin = $in
    mut params = []

    if $width != null {
        $params = ($params | append $"--width=($width)")
    }

    if $height != null {
        $params = ($params | append $"--height=($height)")
    }

    if $no_preserve_aspect_ratio {
        $params = ($params | append "--no-preserve-aspect-ratio")
    }

    if $position != null {
        $params = ($params | append $"--position=($position)")
    }

    if $no_move_cursor {
        $params = ($params | append "--no-move-cursor")
    }

    if $hold {
        $params = ($params | append "--hold")
    }

    if $max_pixels != null {
        $params = ($params | append $"--max-pixels=($max_pixels)")
    }

    if $no_resample {
        $params = ($params | append "--no-resample")
    }

    if $resample_format != null {
        $params = ($params | append $"--resample-format=($resample_format)")
    }

    if $resample_filter != null {
        $params = ($params | append $"--resample-filter=($resample_filter)")
    }

    if $resize != null {
        $params = ($params | append $"--resize=($resize)")
    }

    if $show_resample_timing {
        $params = ($params | append "--show-resample-timing")
    }

    if $direct {
        if ($stdin | is-empty) {
            wezterm imgcat ($params | str join " ") $file_name
            return
        }

        $stdin | wezterm imgcat ($params | str join " ") $file_name
        return
    }

    mut query = ""

    if $file_name != null {
        $query = $"($file_name) .png$ | .jpg$ | .jpeg$ | .gif$ | .bmp$ | .tiff$ | .webp$ | .ico$ | .svg$"
    } else {
        $query = $".png$ | .jpg$ | .jpeg$ | .gif$ | .bmp$ | .tiff$ | .webp$ | .ico$ | .svg$"
    }

    enter $search_root

    let file_name = fzf --height 40% --layout=reverse -0 -1 --query $query

    print $"wezterm imgcat ($params | str join ' ') ($file_name)"
    print $"Displaying image: ($file_name)"

    if ($params | is-empty) {
        wezterm imgcat $file_name
        return
    }

    wezterm imgcat ($params | str join " ") ($file_name)
}

# Echo 'Hello, $user'
alias "hello world" = echo $"Hello, (whoami)!"

# Echo 'Hello, $user'
alias "hello" = echo $"Hello, (whoami)!"

# Echo 'Hello, $user'
alias "hi" = echo $"Hi, (whoami)!"

# Echo a sentence with all the letters of the alphabet only appearing once
alias cwm = echo "Cwm fjord bank glyphs vext quiz"

# Echo a sentence with all the letters of the alphabet
alias fox = echo "The quick brown fox jumps over the lazy dog"

# Echo a sentence with all the letters of the alphabet
alias dwarf = echo "Pack my box with five dozen liquor jugs"

# Echo a sentence with all the letters of the alphabet
alias sphinx = echo "Sphinx of black quartz, judge my vow"

# Echo a sentence with all the letters of the alphabet
alias disco = echo "Amazingly few discoteques provide jukeboxes"

# Echo a sentence with all the letters of the alphabet
alias waltz = echo "Waltz, bad nymph, for quick jigs vex"

# Play the monty hall game
def hall [
    --quiet(-q)
    --answer(-a): number # (1|2|3)
    --switch(-s): string # (yes|no)
] {
    mut $result = ""

    # make the first choice
    if not $quiet {
        print -e "there are three doors in front of you"
        print -e "two have goats, and one has a new car"
        $result = if ($answer | is-empty) {
            (["left", "middle", "right"] | input list "pick one of the doors")
        } else {
            let answer = match $answer {
                1 => "left",
                2 => "middle",
                3 => "right",
            }

            $answer
        }
    } else {
        if ($answer | is-empty) {
            print -e "please provide an answer with --answer when using --quiet"
            return
        }

        if ($answer <= 0) or ($answer > 3) {
            print -e "answer out of range. use --help for more info"
            return
        }

        let answer = match $answer {
            1 => "left",
            2 => "middle",
            3 => "right",
        }

        $result = $answer
    }

    if not $quiet {
        print -e $"you picked the ($result) door"
    }

    # generate correct answer
    let correct = gen int 1..3
    mut given = gen int 1..3

    let result_num = match $result {
        "left" => "1"
        "middle" => "2"
        "right" => "3"
    }

    # generate wrong answer
    while (($given == $correct) or ($given == $result_num)) {
        $given = ^gen int 1..3
    }

    let given_text = match $given {
        "1" => "left",
        "2" => "middle",
        "3" => "right",
    }

    mut switched = ""

    # ask to change the original answer two the only other door not revealed
    if not $quiet {
        print -e $"the ($given_text) door is a goat"

        if ($switch | is-empty) {
            $switched = (["no", "yes"] | input list "would you like to change your answer?")
        } else {
            $switched = $switch
        }
    } else {
        if ($switch | is-empty) {
            print -e "please provide a mode for --switch when using --quiet"
            return
        }

        if ($switch != "yes") and ($switch != "no") {
            print -e "invalid mod for switch. use --help for more info"
            return
        }

        $switched = $switch
    }

    if $switch == "yes" {
        $result = (["left", "middle", "right"] 
            | where { |it|
                $it != $result and $it != $given_text
            } 
            | first
        )
    }

    let result_num = match $result {
        "left" => "1"
        "middle" => "2"
        "right" => "3"
    }

    # present results
    if $result_num == $correct {
        if not $quiet {
            print -e "you won the new car"
        }

        echo 1
    } else {
        if not $quiet {
            print -e "you won a goat"
        }

        echo 0
    }
}

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

alias k = echo "gnarly speed, bruh"
