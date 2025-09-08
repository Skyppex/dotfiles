# Nushell Config File

let andromeda_colors = {
    gray: "#23262e"
    light_gray: "#857e89" # Custom stuff for hints
    orange: "#f39c12"
    pink: "#ff00aa"
    blue: "#7cb7ff"
    cyan: "#00e8c6"
    yellow: "#ffe66d"
    green: "#96e072"
    white: "#d5ced9"
    black: "#181a16"
    purple: "#c74ded"
    red: "#a52a2a"
}

let andromeda_theme = {
    # color for nushell primitives
    separator: $andromeda_colors.gray
    leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
    header: { fg: $andromeda_colors.pink, attr: b }
    empty: $andromeda_colors.blue
    # Closures can be used to choose colors for specific values.
    # The value (in this case, a bool) is piped into the closure.
    # eg) {|| if $in { 'dark_cyan' } else { 'dark_gray' } }
    bool: $andromeda_colors.purple
    int: $andromeda_colors.orange
    filesize: $andromeda_colors.blue
    duration: $andromeda_colors.blue
    datetime: $andromeda_colors.orange
    range: $andromeda_colors.white
    float: $andromeda_colors.orange
    string: $andromeda_colors.green
    nothing: $andromeda_colors.black
    binary: $andromeda_colors.red
    cell-path: $andromeda_colors.orange
    row_index: $andromeda_colors.cyan
    record: $andromeda_colors.white
    list: $andromeda_colors.white
    block: $andromeda_colors.white
    hints: $andromeda_colors.light_gray
    search_result: $andromeda_colors.white
    # shapes are used to change the cli syntax highlighting
    shape_and: $andromeda_colors.purple
    shape_binary: $andromeda_colors.red
    shape_block: $andromeda_colors.white
    shape_bool: $andromeda_colors.purple
    shape_closure: $andromeda_colors.pink
    shape_custom: $andromeda_colors.yellow
    shape_datetime: $andromeda_colors.orange
    shape_directory: $andromeda_colors.blue
    shape_external: $andromeda_colors.purple
    shape_externalarg: $andromeda_colors.pink
    shape_external_resolved: $andromeda_colors.yellow
    shape_filepath: $andromeda_colors.green
    shape_flag: $andromeda_colors.pink
    shape_float: $andromeda_colors.orange
    shape_garbage: $andromeda_colors.red
    shape_globpattern: $andromeda_colors.green
    shape_int: $andromeda_colors.orange
    shape_internalcall: $andromeda_colors.purple
    shape_keyword: $andromeda_colors.purple
    shape_list: $andromeda_colors.white
    shape_literal: $andromeda_colors.orange
    shape_match_pattern: $andromeda_colors.blue
    shape_matching_brackets: $andromeda_colors.white
    shape_nothing: $andromeda_colors.black
    shape_operator: $andromeda_colors.red
    shape_or: $andromeda_colors.purple
    shape_pipe: $andromeda_colors.orange
    shape_range: $andromeda_colors.white
    shape_record: $andromeda_colors.white
    shape_redirection: $andromeda_colors.yellow
    shape_signature: $andromeda_colors.blue
    shape_string: $andromeda_colors.green
    shape_string_interpolation: $andromeda_colors.purple
    shape_table: $andromeda_colors.white
    shape_variable: $andromeda_colors.cyan
    shape_vardecl: $andromeda_colors.cyan
}

source ~/.config/nushell/colors.nu

let theme = {
    # color for nushell primitives
    separator: $colors.background1
    leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
    header: { fg: $colors.blue, attr: b }
    empty: $colors.cyan
    # Closures can be used to choose colors for specific values.
    # The value (in this case, a bool) is piped into the closure.
    # eg) {|| if $in { 'dark_cyan' } else { 'dark_gray' } }
    bool: $colors.cyan
    int: $colors.orange
    filesize: $colors.purple
    duration: $colors.purple
    datetime: $colors.orange
    range: $colors.primary
    float: $colors.orange
    string: $colors.green
    nothing: $colors.background0
    binary: $colors.red
    cell-path: $colors.orange
    row_index: $colors.cyan
    record: $colors.primary
    list: $colors.primary
    block: $colors.primary
    hints: $colors.background3
    search_result: $colors.primary
    # shapes are used to change the cli syntax highlighting
    shape_and: $colors.cyan
    shape_closure: $colors.blue
    shape_custom: $colors.yellow
    shape_datetime: $colors.orange
    shape_directory: $colors.purple
    shape_external: $colors.cyan
    shape_externalarg: $colors.blue
    shape_external_resolved: $colors.yellow
    shape_filepath: $colors.green
    shape_flag: $colors.blue
    shape_float: $colors.orange
    shape_garbage: $colors.red
    shape_globpattern: $colors.green
    shape_int: $colors.orange
    shape_internalcall: $colors.cyan
    shape_keyword: $colors.cyan
    shape_list: $colors.primary
    shape_literal: $colors.orange
    shape_match_pattern: $colors.purple
    shape_matching_brackets: $colors.primary
    shape_nothing: $colors.background0
    shape_operator: $colors.red
    shape_or: $colors.cyan
    shape_pipe: $colors.orange
    shape_range: $colors.primary
    shape_record: $colors.primary
    shape_redirection: $colors.yellow
    shape_signature: $colors.cyan
    shape_string: $colors.green
    shape_string_interpolation: $colors.cyan
    shape_table: $colors.primary
    shape_variable: $colors.pink
    shape_vardecl: $colors.pink
}

let theme = if (
    (sys host).hostname == "skypex" or
    (sys host).hostname == "brage-work-laptop"
) {
    $theme
} else {
    $andromeda_theme
}

# The default config record. This is where much of your global configuration is setup.
$env.config = {
    show_banner: false # true or false to enable or disable the welcome banner at startup

    ls: {
        use_ls_colors: false # use the LS_COLORS environment variable to colorize output
        clickable_links: true # enable or disable clickable links. Your terminal has to support links.
    }

    rm: {
        always_trash: false # always act as if -t was given. Can be overridden with -p
    }

    table: {
        mode: rounded # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
        index_mode: always # "always" show indexes, "never" show indexes, "auto" = show indexes when a table has "index" column
        show_empty: true # show 'empty list' and 'empty record' placeholders for command output
        padding: { left: 1, right: 1 } # a left right padding of each column in a table
        trim: {
            methodology: wrapping # wrapping or truncating
            wrapping_try_keep_words: true # A strategy used by the 'wrapping' methodology
            truncating_suffix: "..." # A suffix used by the 'truncating' methodology
        }
        header_on_separator: false # show header text on separator/border line
        # abbreviated_row_count: 10 # limit data rows from top and bottom after reaching a set point
    }

    error_style: "fancy" # "fancy" or "plain" for screen reader-friendly error messages
    display_errors: {
        exit_code: false
        termination_signal: true
    }

    # datetime_format determines what a datetime rendered in the shell would look like.
    # Behavior without this configuration point will be to "humanize" the datetime display,
    # showing something like "a day ago."
    datetime_format: {
        # normal: '%a, %d %b %Y %H:%M:%S %z'    # shows up in displays of variables or other datetime's outside of tables
        # table: '%m/%d/%y %I:%M:%S%p'          # generally shows up in tabular outputs such as ls. commenting this out will change it to the default human readable datetime format
    }

    explore: {
        status_bar_background: {fg: $colors.background1, bg: $colors.tertiary},
        command_bar_text: {fg: $colors.tertiary},
        highlight: {fg: $colors.background1, bg: $colors.yellow},
        status: {
            error: {fg: $colors.primary, bg: $colors.red},
            warn: {}
            info: {}
        },
        table: {
            split_line: {fg: $colors.background2},
            selected_cell: {bg: $colors.cyan},
            selected_row: {},
            selected_column: {},
        },
    }

    history: {
        max_size: 100_000 # Session has to be reloaded for this to take effect
        sync_on_enter: true # Enable to share history between multiple sessions, else you have to close the session to write history to file
        file_format: "plaintext" # "sqlite" or "plaintext"
        isolation: false # only available with sqlite file_format. true enables history isolation, false disables it. true will allow the history to be isolated to the current session using up/down arrows. false will allow the history to be shared across all sessions.
    }

    completions: {
        case_sensitive: false # set to true to enable case-sensitive completions
        quick: true    # set this to false to prevent auto-selecting completions when only one remains
        partial: true    # set this to false to prevent partial filling of the prompt
        algorithm: "fuzzy"    # prefix or fuzzy
        external: {
            enable: true # set to false to prevent nushell looking into $env.PATH to find more suggestions, `false` recommended for WSL users as this look up may be very slow
            max_results: 100 # setting it lower can improve completion performance at the cost of omitting some options
            completer: null # check 'carapace_completer' above as an example
        }
    }

    filesize: {
        unit: binary
        precision: 4
    }

    cursor_shape: {
        emacs: line # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (line is the default)
        vi_insert: line # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (block is the default)
        vi_normal: block # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (underscore is the default)
    }

    color_config: $theme # if you want a more interesting theme, you can replace the empty record with `$dark_theme`, `$light_theme` or another custom record
    footer_mode: 25 # always, never, number_of_rows, auto
    float_precision: 2 # the precision for displaying floats in tables
    buffer_editor: "" # command that will be used to edit the current line buffer with ctrl+o, if unset fallback to $env.EDITOR and $env.VISUAL
    use_ansi_coloring: true
    bracketed_paste: true # enable bracketed paste, currently useless on windows
    edit_mode: vi # emacs, vi
    shell_integration: {
        # osc2 abbreviates the path if in the home_dir, sets the tab/window title, shows the running command in the tab/window title
        osc2: true
        # osc7 is a way to communicate the path to the terminal, this is helpful for spawning new tabs in the same directory
        osc7: true
        # osc8 is also implemented as the deprecated setting ls.show_clickable_links, it shows clickable links in ls output if your terminal supports it. show_clickable_links is deprecated in favor of osc8
        osc8: true
        # osc9_9 is from ConEmu and is starting to get wider support. It's similar to osc7 in that it communicates the path to the terminal
        osc9_9: false
        # osc133 is several escapes invented by Final Term which include the supported ones below.
        # 133;A - Mark prompt start
        # 133;B - Mark prompt end
        # 133;C - Mark pre-execution
        # 133;D;exit - Mark execution finished with exit code
        # This is used to enable terminals to know where the prompt is, the command is, where the command finishes, and where the output of the command is
        osc133: false
        # osc633 is closely related to osc133 but only exists in visual studio code (vscode) and supports their shell integration features
        # 633;A - Mark prompt start
        # 633;B - Mark prompt end
        # 633;C - Mark pre-execution
        # 633;D;exit - Mark execution finished with exit code
        # 633;E - NOT IMPLEMENTED - Explicitly set the command line with an optional nonce
        # 633;P;Cwd=<path> - Mark the current working directory and communicate it to the terminal
        # and also helps with the run recent menu in vscode
        osc633: true
        # reset_application_mode is escape \x1b[?1l and was added to help ssh work better
        reset_application_mode: true
    }
    render_right_prompt_on_last_line: false # true or false to enable or disable right prompt to be rendered on last line of the prompt.
    use_kitty_protocol: false # enables keyboard enhancement protocol implemented by kitty console, only if your terminal support this.
    highlight_resolved_externals: false # true enables highlighting of external commands in the repl resolved by which.

    hooks: {
        pre_prompt: [{ null }] # run before the prompt is shown
        pre_execution: [{ null }] # run before the repl input is run
        env_change: {
            PWD: [{ ||
                if (which direnv | is-empty) {
                    print "direnv not found"
                    return
                }

                direnv export json | from json | default {} | load-env
            }] 
        }
        display_output: "if (term size).columns >= 100 { table -e } else { table }" # run to display the output of a pipeline
        command_not_found: { null } # return an error message when a command is not found
    }

    menus: [
        # Configuration for default nushell menus
        # Note the lack of source parameter
        {
            name: completion_menu
            only_buffer_difference: false
            marker: "󰁨 "
            type: {
                layout: columnar
                columns: 4
                col_width: 20     # Optional value. If missing all the screen width is used to calculate column width
                col_padding: 2
            }
            style: {
                text: $colors.green
                selected_text: $colors.blue
                description_text: $colors.yellow
            }
        }
        {
            name: history_menu
            only_buffer_difference: true
            marker: " "
            type: {
                layout: list
                page_size: 10
            }
            style: {
                text: $colors.green
                selected_text: $colors.blue
                description_text: $colors.yellow
            }
        }
        {
            name: help_menu
            only_buffer_difference: true
            marker: "󰋖 "
            type: {
                layout: description
                columns: 4
                col_width: 20     # Optional value. If missing all the screen width is used to calculate column width
                col_padding: 2
                selection_rows: 4
                description_rows: 10
            }
            style: {
                text: $colors.green
                selected_text: $colors.blue
                description_text: $colors.yellow
            }
        }
    ]

    keybindings: [
        {
            name: completion_menu
            modifier: none
            keycode: tab
            mode: [emacs vi_normal vi_insert]
            event: {
                until: [
                    { send: menu name: completion_menu }
                    { send: menunext }
                    { edit: complete }
                ]
            }
        }
        {
            name: history_menu
            modifier: control
            keycode: char_r
            mode: [emacs, vi_insert, vi_normal]
            event: { send: menu name: history_menu }
        }
        {
            name: help_menu
            modifier: none
            keycode: f1
            mode: [emacs, vi_insert, vi_normal]
            event: { send: menu name: help_menu }
        }
        {
            name: completion_previous_menu
            modifier: shift
            keycode: backtab
            mode: [emacs, vi_normal, vi_insert]
            event: { send: menuprevious }
        }
        {
            name: next_page_menu
            modifier: control
            keycode: char_x
            mode: emacs
            event: { send: menupagenext }
        }
        {
            name: undo_or_previous_page_menu
            modifier: control
            keycode: char_z
            mode: emacs
            event: {
                until: [
                    { send: menupageprevious }
                    { edit: undo }
                ]
            }
        }
        {
            name: escape
            modifier: none
            keycode: escape
            mode: [emacs, vi_normal, vi_insert]
            event: { send: esc }    # NOTE: does not appear to work
        }
        {
            name: cancel_command
            modifier: control
            keycode: char_c
            mode: [emacs, vi_normal, vi_insert]
            event: { send: ctrlc }
        }
        {
            name: quit_shell
            modifier: control
            keycode: char_d
            mode: [emacs, vi_normal, vi_insert]
            event: { send: ctrld }
        }
        {
            name: clear_screen
            modifier: control
            keycode: char_l
            mode: [emacs, vi_normal, vi_insert]
            event: { send: clearscreen }
        }
        {
            name: search_history
            modifier: control
            keycode: char_q
            mode: [emacs, vi_normal, vi_insert]
            event: { send: searchhistory }
        }
        {
            name: open_command_editor
            modifier: control
            keycode: char_o
            mode: [emacs, vi_normal, vi_insert]
            event: { send: openeditor }
        }
        {
            name: move_up
            modifier: none
            keycode: up
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {send: menuup}
                    {send: up}
                ]
            }
        }
        {
            name: move_down
            modifier: none
            keycode: down
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {send: menudown}
                    {send: down}
                ]
            }
        }
        {
            name: move_left
            modifier: none
            keycode: left
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {send: menuleft}
                    {send: left}
                ]
            }
        }
        {
            name: move_right_or_take_history_hint
            modifier: none
            keycode: right
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {send: historyhintcomplete}
                    {send: menuright}
                    {send: right}
                ]
            }
        }
        {
            name: move_one_word_left
            modifier: control
            keycode: left
            mode: [emacs, vi_normal, vi_insert]
            event: {edit: movewordleft}
        }
        {
            name: move_one_word_right_or_take_history_hint
            modifier: control
            keycode: right
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {send: historyhintwordcomplete}
                    {edit: movewordright}
                ]
            }
        }
        {
            name: move_to_line_start
            modifier: none
            keycode: home
            mode: [emacs, vi_normal, vi_insert]
            event: {edit: movetolinestart}
        }
        {
            name: move_to_line_start
            modifier: control
            keycode: char_a
            mode: [emacs, vi_normal, vi_insert]
            event: {edit: movetolinestart}
        }
        {
            name: move_to_line_end_or_take_history_hint
            modifier: none
            keycode: end
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {send: historyhintcomplete}
                    {edit: movetolineend}
                ]
            }
        }
        {
            name: move_to_line_end_or_take_history_hint
            modifier: control
            keycode: char_e
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {send: historyhintcomplete}
                    {edit: movetolineend}
                ]
            }
        }
        {
            name: move_to_line_start
            modifier: control
            keycode: home
            mode: [emacs, vi_normal, vi_insert]
            event: {edit: movetolinestart}
        }
        {
            name: move_to_line_end
            modifier: control
            keycode: end
            mode: [emacs, vi_normal, vi_insert]
            event: {edit: movetolineend}
        }
        {
            name: move_up
            modifier: control
            keycode: char_p
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {send: menuup}
                    {send: up}
                ]
            }
        }
        {
            name: move_down
            modifier: control
            keycode: char_t
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {send: menudown}
                    {send: down}
                ]
            }
        }
        {
            name: delete_one_character_backward
            modifier: none
            keycode: backspace
            mode: [emacs, vi_insert]
            event: {edit: backspace}
        }
        {
            name: delete_one_word_backward
            modifier: control
            keycode: backspace
            mode: [emacs, vi_insert]
            event: {edit: backspaceword}
        }
        {
            name: delete_one_character_forward
            modifier: none
            keycode: delete
            mode: [emacs, vi_insert]
            event: {edit: delete}
        }
        {
            name: delete_one_character_forward
            modifier: control
            keycode: delete
            mode: [emacs, vi_insert]
            event: {edit: delete}
        }
        {
            name: delete_one_character_forward
            modifier: control
            keycode: char_h
            mode: [emacs, vi_insert]
            event: {edit: backspace}
        }
        {
            name: delete_one_word_backward
            modifier: control
            keycode: char_w
            mode: [emacs, vi_insert]
            event: {edit: backspaceword}
        }
        {
            name: move_left
            modifier: none
            keycode: backspace
            mode: vi_normal
            event: {edit: moveleft}
        }
        {
            name: newline_or_run_command
            modifier: none
            keycode: enter
            mode: emacs
            event: {send: enter}
        }
        {
            name: move_left
            modifier: control
            keycode: char_b
            mode: emacs
            event: {
                until: [
                    {send: menuleft}
                    {send: left}
                ]
            }
        }
        {
            name: move_right_or_take_history_hint
            modifier: control
            keycode: char_f
            mode: emacs
            event: {
                until: [
                    {send: historyhintcomplete}
                    {send: menuright}
                    {send: right}
                ]
            }
        }
        {
            name: redo_change
            modifier: control
            keycode: char_g
            mode: emacs
            event: {edit: redo}
        }
        {
            name: undo_change
            modifier: control
            keycode: char_z
            mode: emacs
            event: {edit: undo}
        }
        {
            name: paste_before
            modifier: control
            keycode: char_y
            mode: emacs
            event: {edit: pastecutbufferbefore}
        }
        {
            name: cut_word_left
            modifier: control
            keycode: char_w
            mode: emacs
            event: {edit: cutwordleft}
        }
        {
            name: cut_line_to_end
            modifier: control
            keycode: char_k
            mode: emacs
            event: {edit: cuttoend}
        }
        {
            name: cut_line_from_start
            modifier: control
            keycode: char_u
            mode: emacs
            event: {edit: cutfromstart}
        }
        {
            name: swap_graphemes
            modifier: control
            keycode: char_t
            mode: emacs
            event: {edit: swapgraphemes}
        }
        {
            name: move_one_word_left
            modifier: alt
            keycode: left
            mode: emacs
            event: {edit: movewordleft}
        }
        {
            name: move_one_word_right_or_take_history_hint
            modifier: alt
            keycode: right
            mode: emacs
            event: {
                until: [
                    {send: historyhintwordcomplete}
                    {edit: movewordright}
                ]
            }
        }
        {
            name: move_one_word_left
            modifier: alt
            keycode: char_b
            mode: emacs
            event: {edit: movewordleft}
        }
        {
            name: move_one_word_right_or_take_history_hint
            modifier: alt
            keycode: char_f
            mode: emacs
            event: {
                until: [
                    {send: historyhintwordcomplete}
                    {edit: movewordright}
                ]
            }
        }
        {
            name: delete_one_word_forward
            modifier: alt
            keycode: delete
            mode: emacs
            event: {edit: deleteword}
        }
        {
            name: delete_one_word_backward
            modifier: alt
            keycode: backspace
            mode: emacs
            event: {edit: backspaceword}
        }
        {
            name: delete_one_word_backward
            modifier: alt
            keycode: char_m
            mode: emacs
            event: {edit: backspaceword}
        }
        {
            name: cut_word_to_right
            modifier: alt
            keycode: char_d
            mode: emacs
            event: {edit: cutwordright}
        }
        {
            name: upper_case_word
            modifier: alt
            keycode: char_u
            mode: emacs
            event: {edit: uppercaseword}
        }
        {
            name: lower_case_word
            modifier: alt
            keycode: char_l
            mode: emacs
            event: {edit: lowercaseword}
        }
        {
            name: capitalize_char
            modifier: alt
            keycode: char_c
            mode: emacs
            event: {edit: capitalizechar}
        }
    ]
}

$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.PROMPT_MULTILINE_INDICATOR = ""

use std/dirs shells-aliases *
zoxide init --no-cmd nushell | save -f ~/.config/zoxide/.zoxide.nu

use ~/.cache/starship/init.nu
source ~/.config/nushell/fs.nu
source ~/.config/nushell/utils.nu
source ~/.config/nushell/history.nu
source ~/.config/nushell/zoxide.nu
source ~/.config/nushell/dotnet.nu
source ~/.config/nushell/git.nu
source ~/.config/nushell/autohotkey.nu
source ~/.config/nushell/scoop.nu
source ~/.config/nushell/fun.nu
source ~/.config/nushell/docker.nu
use ~/.config/nushell/task.nu
source ~/.config/nushell/dotenv.nu
source ~/.config/nushell/scripts.nu
source ~/.config/nushell/scripts-tools.nu
source ~/.config/nushell/operations.nu
source ~/.config/nushell/poll.nu
source ~/.config/nushell/kb.nu

# Pull the dotfiles from the remote repository
def pull [] {
    enter $env.CHEZMOI_PATH
    print "---- pulling config ----"
    git stash -u
    git pull --rebase
    git submodule update --init --recursive
    chezmoi apply --force

    if $env.OS == "windows" {
        print "---- updating scoop ----"
        scoop update
        print "---- installing scoop apps ----"
        manifest install
        print "---- updating scoop apps ----"
        scoop update -a
    } else {
        print "---- updating nix ----"
        nix profile upgrade --all
        print "---- updating nix ----"
    }
}
