(access_modifier) @keyword.modifier

[
  "mod"
  "use"
] @keyword.import

"fun" @keyword.function

[
  "let"
  "mut"
] @keyword

[
  "struct"
  "enum"
  "union"
  "type"
] @keyword.type

[
  "if"
  "else"
  "match"
] @keyword.conditional

[
  "loop"
  "while"
] @keyword.repeat

[
 "or"
] @keyword.operator

(for
  "for" @keyword.repeat
  "in" @keyword.repeat)

"break" @keyword.return
"continue" @keyword.repeat
"return" @keyword.return

[
  "void"
  "bool"
  "int"
  "float"
  "char"
  "string"
] @type.builtin

[
 "unit"
] @constant.builtin

":" @punctuation.delimiter
"::" @punctuation.delimiter
";" @punctuation.delimiter
"," @punctuation.delimiter
"=>" @punctuation.delimiter

"{" @punctuation.bracket
"}" @punctuation.bracket
"[" @punctuation.bracket
"]" @punctuation.bracket
"(" @punctuation.bracket
")" @punctuation.bracket

[
  "+"
  "-"
  "*"
  "/"
  "%"
  "&"
  "|"
  "^"
  "<<"
  ">>"
  "&&"
  "||"
  "=="
  "!="
  "<"
  ">"
  "<="
  ">="
  "="
  "+="
  "-="
  "*="
  "/="
  "%="
  "&="
  "|="
  "^="
] @operator

(line_comment) @comment @spell

(block_comment
  "/" @comment) @comment @spell

(mod_path
  (identifier) @module)

(use_path
  (identifier) @module)

(use_path
  (identifier) @module.builtin (#any-of? @module.builtin "core" "lib"))

(string) @string @spell

(escape_sequence) @string.escape

(bool) @boolean

(int) @number
(uint) @number

(float) @number.float

(char) @character

(identifier) @variable

(struct_literal
  struct_name: (type_identifier_name) @type)

(enum_literal
  enum_name: (type_identifier_name) @type
  enum_variant: (identifier) @type)

(field
  field_name: (identifier) @property @spell)

(function_declaration
  body: (identifier) @variable)

(function_declaration
  identifier: (function_type_identifier) @constructor @spell (#match? @constructor "new.*"))

(parameter
  (identifier) @variable.parameter @spell)

(closure_parameter
  param_name: (identifier) @variable.parameter @spell)

(trailing_closure
  function: (identifier) @function.call)

(function_propagation
  function: (identifier) @function.call)

(call
  callee: (identifier) @function.call)

(call
  callee: (identifier) @function.builtin (#any-of? @function.builtin "print" "drop"))

(type_annotation
  (identifier) @type) @type

(type_annotation
  "unit" @type.builtin)

(type_annotation
  enum_name: (type_identifier_name) @type
  enum_variant: (type_identifier_name) @type)

(struct_declaration
  identifier: (type_identifier) @type)

(struct_field
  field_name: (identifier) @property @spell)

(type_identifier
  (type_identifier_name) @type @spell)

(function_type_identifier
  (function_type_identifier_name) @function @spell)

(generic_type_parameters
  "<" @punctuation.bracket
  ">" @punctuation.bracket)

(generic_identifier) @type @spell

(enum_variant
  variant_name: (type_identifier_name) @constant @spell)

(union_declaration
  name: (identifier) @type @spell)

(type_alias_declaration
  name: (type_identifier) @type @spell)

(match_arms
  "|" @punctuation.special)

(wildcard) @character.special
