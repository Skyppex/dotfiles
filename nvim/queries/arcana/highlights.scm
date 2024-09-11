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
  "proto"
  "type"
  "where"
  "imp"
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
  "Void"
  "Unit"
  "Bool"
  "Int"
  "UInt"
  "Float"
  "Char"
  "String"
] @type.builtin

[
  ":"
  "::"
  ";"
  ","
  ".."
] @punctuation.delimiter

[
  "{"
  "}"
  "["
  "]"
  "("
  ")"
] @punctuation.bracket

[
  "=>" 
] @punctuation.special

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
  "->" 
] @operator

(line_comment) @comment @spell

(block_comment
  "/" @comment) @comment @spell

(string) @string @spell

(escape_sequence) @string.escape

(unit) @constant.builtin
(bool) @boolean

(int) @number
(uint) @number

(float) @number.float

(char) @character

(identifier) @variable

(mod_path
  (identifier) @module)

(mod_path
  (identifier) @module.builtin (#any-of? @module.builtin "core" "lib"))

(use_path
  (type_identifier_name) @type)

(use_path
  (identifier) @type)

(use_path
  (identifier) @module
  "::")

(use_path
  (identifier) @module.builtin (#any-of? @module.builtin "core" "lib"))

(type_identifier_name) @type

(function_type_identifier_name) @function @spell

(named_field
  field_name: (identifier) @property @spell)

(function_declaration
  body: (identifier) @variable @spell)

(function_declaration
  identifier: (function_type_identifier) @constructor @spell (#match? @constructor "new.*"))

(function_declaration
  params: (parameters
    (parameter) @keyword @spell (#eq? @keyword "self")))

(parameter
  (identifier) @variable.parameter @spell)

(protocol_declaration
  (function_declaration
    params: (parameters
      (parameter
        param_name: (identifier) @keyword @spell (#eq? @keyword "self")))))

(closure_parameter
  param_name: (identifier) @variable.parameter @spell)

(trailing_closure
  function: (identifier) @function.call)

(function_propagation
  function: (identifier) @function.call)

(member
  member: (identifier) @property)

(call
  callee: (identifier) @function.call)

(call
  callee: (member
    member: (identifier) @function.call))

(call
  callee: (identifier) @function.builtin (#any-of? @function.builtin "print" "drop"))

(struct_field
  field_name: (identifier) @property @spell)

(generic_type_parameters
  "<" @punctuation.bracket
  ">" @punctuation.bracket)

(concrete_type_parameters
  "<" @punctuation.bracket
  ">" @punctuation.bracket)

(generic_identifier) @type @spell

(enum_shared_field
  field_name: (identifier) @property @spell
  field_type: (type_annotation) @type)

(enum_variant
  variant_name: (type_identifier_name) @constant @spell)

(type_constructor
  member_type_name: (type_annotation
    (type_identifier_name) @constant @spell))

(union_declaration
  name: (type_identifier_name) @type @spell)

(implementation_declaration
  "for" @keyword.type)

(match_arms
  "|" @punctuation.special)

(wildcard) @character.special

(constructor_field
  field_pattern: (identifier) @property)

(constructor_field
  field_name: (identifier) @property
  field_pattern: (_))
