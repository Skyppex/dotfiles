# Nushell Environment Config File
#
# version = "0.88.1"

def create_left_prompt [] {
    let home =  $nu.home-path

    # Perform tilde substitution on dir
    # To determine if the prefix of the path matches the home dir, we split the current path into
    # segments, and compare those with the segments of the home dir. In cases where the current dir
    # is a parent of the home dir (e.g. `/home`, homedir is `/home/user`), this comparison will
    # also evaluate to true. Inside the condition, we attempt to str replace `$home` with `~`.
    # Inside the condition, either:
    # 1. The home prefix will be replaced
    # 2. The current dir is a parent of the home dir, so it will be uneffected by the str replace
    let dir = (
        if ($env.PWD | path split | zip ($home | path split) | all { $in.0 == $in.1 }) {
            ($env.PWD | str replace $home "~")
        } else {
            $env.PWD
        }
    )

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

def create_right_prompt [] {
    # create a right prompt in magenta with green separators and am/pm underlined
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%x %X %p') # try to respect user's locale
    ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
        str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
# FIXME: This default is not implemented in rust code as of 2023-09-08.
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# If you want previously entered commands to have a different prompt from the usual one,
# you can uncomment one or more of the following lines.
# This can be useful if you have a 2-line prompt and it's taking up a lot of space
# because every command entered takes up 2 lines instead of 1. You can then uncomment
# the line below so that previously entered commands show with a single `🚀`.
# $env.TRANSIENT_PROMPT_COMMAND = {|| "🚀 " }
# $env.TRANSIENT_PROMPT_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "" }
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')

if $env.HOMEPATH? != null {
    $env.HOME = ($env.HOMEDRIVE ++ $env.HOMEPATH | str replace "\\" "/")
}

mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

$env.CONFIG_PATH = $"($nu.home-path)/.config"
$env.XDG_CONFIG_HOME = $"($nu.home-path)/.config"
$env.CHEZMOI_PATH = $"($nu.home-path)/.local/share/chezmoi"
$env.SCRIPTS_PATH = $"($nu.home-path)/.local/share/scripts"
$env.SCOOP = $"($nu.home-path)/scoop"
$env.SCOOP_APPS = $"($env.SCOOP)/apps"
$env.SCOOP_SHIMS = $"($env.SCOOP)/shims"
$env.HOSTNAME = (sys host | get hostname)
$env.OS = (sys host | get name | str downcase)
$env.OS_VERSION = (sys host | get long_os_version)

match [$env.HOSTNAME, $env.OS] {
    ["brage-pc", "windows"] => {
        $env.DEV = ('~/dev' | path expand)
        $env.CODE = ('~/code' | path expand)
        $env.LANG = "en_US"
        $env.NU_PLUGIN_DIRS = $env.NU_LIB_DIRS | append $"($env.SCOOP)/persist/rustup/.cargo/bin"
        $env.YAZI_FILE_ONE = $"($env.SCOOP_APPS)/git/current/usr/bin/file.exe"
    },
    ["DESKTOP-RRC642H", "windows"] => {
        $env.CODE = "D:/code"
        $env.LANG = "en_US"
        $env.YAZI_FILE_ONE = $"($env.SCOOP_APPS)/git/current/usr/bin/file.exe"
    },
    ["brage-pc", "arch linux"] => {
        $env.DEV = ('~/dev' | path expand)
        $env.CODE = ('~/dev/code' | path expand)
        $env.DEV_BIN = ('~/dev/bin' | path expand)

        let nix_path = "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"

        if ($nix_path | path exists) {
            let more_env = bash -c $"source ($nix_path) && env" | lines
            mut env_vars = {}

            let ignore = [
                FILE_PWD
                CURRENT_FILE
                PWD
            ]

            for it in $more_env { 
                let split = $it | split row --number 2 "="
                let key = $split.0

                if ($ignore | any { |it| $key == $it }) {
                    continue
                }

                let value = $split.1
                $env_vars = ($env_vars | merge { $key: $value })
            }

            load-env $env_vars
        }
    }
    ["brage-work-laptop", "endeavouros"] => {
        $env.DEV = ('~/dev' | path expand)
        $env.CODE = ('~/dev/code' | path expand)
        $env.DEV_BIN = ('~/dev/bin' | path expand)

        let nix_path = "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"

        if ($nix_path | path exists) {
            let more_env = bash -c $"source ($nix_path) && env" | lines
            mut env_vars = {}

            let ignore = [
                FILE_PWD
                CURRENT_FILE
                PWD
            ]

            for it in $more_env { 
                let split = $it | split row --number 2 "="
                let key = $split.0

                if ($ignore | any { |it| $key == $it }) {
                    continue
                }

                let value = $split.1
                $env_vars = ($env_vars | merge { $key: $value })
            }

            load-env $env_vars
        }
    }
    ["skypex", "arch linux"] => {
        $env.DEV = ('~/dev' | path expand)
        $env.CODE = ('~/dev/code' | path expand)
        $env.DEV_BIN = ('~/dev/bin' | path expand)

        let nix_path = "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"

        if ($nix_path | path exists) {
            let more_env = bash -c $"source ($nix_path) && env" | lines
            mut env_vars = {}

            let ignore = [
                FILE_PWD
                CURRENT_FILE
                PWD
            ]

            for it in $more_env { 
                let split = $it | split row --number 2 "="
                let key = $split.0

                if ($ignore | any { |it| $key == $it }) {
                    continue
                }

                let value = $split.1
                $env_vars = ($env_vars | merge { $key: $value })
            }

            load-env $env_vars
        }
    }
    _ => {
        print "Unknown computer name"
    }
}

$env.PROJECTS = $"($env.CODE)/projects"

$env.PATH = ($env.PATH | split row (char esep) | prepend $"($env.HOME)/.dotnet/tools")
if ($env.DEV_BIN | is-not-empty) {
    $env.PATH = ($env.PATH | split row (char esep) | prepend $env.DEV_BIN)
}

# My favorite editor
$env.EDITOR = "nvim"

$env.JQ_COLORS = "0;90:1;31:1;31:1;31:1;32:1;34:1;33:1;35"
$env.DOCKER_CONTEXT = "desktop-linux"

$env.OPENAI_API_KEY = (do -i { skate get openai@api })
