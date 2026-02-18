(call_expression
  (member_expression
    (identifier) @identifier (#eq? @identifier "Database")
    (property_identifier) @property_identifier (#eq? @property_identifier "execute"))
  (template_string
    (string_fragment) @injection.content
    (#set! "injection.language" "sql")))

(call_expression
  (member_expression
    (identifier) @identifier (#eq? @identifier "Database")
    (property_identifier) @property_identifier (#eq? @property_identifier "execute"))
  (_
    (template_string
      (string_fragment) @injection.content
      (#set! "injection.language" "sql"))))

(call_expression
  (member_expression
    (identifier) @identifier (#eq? @identifier "Database")
    (property_identifier) @property_identifier (#eq? @property_identifier "execute"))
  (_
    (_
      (template_string
        (string_fragment) @injection.content
        (#set! "injection.language" "sql")))))

(call_expression
  (identifier) @identifier (#match? @identifier ".*[Ss][Qq][Ll].*")
  (template_string
    (string_fragment) @injection.content
    (#set! "injection.language" "sql")))

(call_expression
  (identifier) @identifier (#match? @identifier ".*[Ss][Qq][Ll].*")
  (_
    (template_string
      (string_fragment) @injection.content
      (#set! "injection.language" "sql"))))

(call_expression
  (identifier) @identifier (#match? @identifier ".*[Ss][Qq][Ll].*")
  (_
    (_
      (template_string
        (string_fragment) @injection.content
        (#set! "injection.language" "sql")))))

(pair
  key: (_) @identifier (#match? @identifier ".*[Ss][Qq][Ll].*")
  value: (_
   (string_fragment) @injection.content
   (#set! "injection.language" "sql")))
