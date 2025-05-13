; extends

(command
  flag: (long_flag
    name: (long_flag_identifier) @identifier (#eq? @identifier "regex"))
  arg: (val_string) @injection.content
    (#offset! @injection.content 0 1 0 -1)
    (#set! "injection.language" "regex")
)
