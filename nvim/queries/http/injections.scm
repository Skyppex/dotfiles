; extends

((request
  header: (header
    name: (header_entity) @name (#match? @name "[Xx]-[Rr][Ee][Qq][Uu][Ee][Ss][Tt]-[Tt][Yy][Pp][Ee]")
    value: (value) @injection.language)
  body: (raw_body) @injection.content))

((request
  header: (header
    name: (header_entity) @name (#match? @name "[Cc][Oo][Nn][Tt][Ee][Nn][Tt]-[Tt][Yy][Pp][Ee]")
    value: (value) @injection.language (#offset! @injection.language 0 12 0 0))
  body: (raw_body) @injection.content))

((request
  header: (header
    name: (header_entity) @name (#match? @name "[Xx]-[Rr][Ee][Qq][Uu][Ee][Ss][Tt]-[Tt][Yy][Pp][Ee]")
    value: (value) @value (#match? @value "^[Ss][Uu][Rr]([Rr][Ee][Aa][Ll])?[Qq][Ll]$"))
  body: (raw_body) @injection.content
  (#set! "injection.language" "surql")))

((request
  header: (header
    name: (header_entity) @name (#match? @name "^[Cc][Oo][Nn][Tt][Ee][Nn][Tt]-[Tt][Yy][Pp][Ee]$")
    value: (value) @value (#match? @value "application/sur(real)?ql"))
  body: (raw_body) @injection.content
  (#set! "injection.language" "surql")))

((request
  header: (header
    name: (header_entity) @name (#match? @name "^[Xx]-[Rr][Ee][Qq][Uu][Ee][Ss][Tt]-[Tt][Yy][Pp][Ee]$")
    value: (value) @value (#match? @value "[Gg]([Rr][Aa][Pp][Hh])?[Qq][Ll]"))
  body: (raw_body) @injection.content
  (#set! "injection.language" "graphql")))

((request
  header: (header
    name: (header_entity) @name (#match? @name "^[Cc][Oo][Nn][Tt][Ee][Nn][Tt]-[Tt][Yy][Pp][Ee]$")
    value: (value) @value (#match? @value "application/g(raph)?ql"))
  body: (raw_body) @injection.content
  (#set! "injection.language" "graphql")))
