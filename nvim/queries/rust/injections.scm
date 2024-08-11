(call_expression
  function: (scoped_identifier
    path: (scoped_identifier
      name: (identifier) @_type_name (#eq? @_type_name "Regex"))
    name: (identifier) @_name (#eq? @_name "new"))
  arguments: (arguments
    (raw_string_literal
      (string_content) @injection.content
      (#set! "injection.language" "regex"))))

(call_expression
  function: (scoped_identifier
    path: (scoped_identifier
      name: (identifier) @_type_name (#eq? @_type_name "Regex"))
    name: (identifier) @_name (#eq? @_name "new"))
  arguments: (arguments
    (string_literal
      (string_content) @injection.content
      (#set! "injection.language" "regex"))))
