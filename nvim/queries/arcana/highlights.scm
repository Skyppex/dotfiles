(access_modifier) @keyword.modifier

"mod" @keyword.import
"use" @keyword.import

"fun" @keyword.function

"let" @keyword
"mut" @keyword

"struct" @keyword.type
"enum" @keyword.type
"union" @keyword.type

"if" @keyword.conditional
"else" @keyword.conditional
"match" @keyword.conditional

"loop" @keyword.repeat
"while" @keyword.repeat

(for
  "for" @keyword.repeat
  "in" @keyword.repeat)

"break" @keyword.return
"continue" @keyword.repeat
"return" @keyword.return

"void" @type.builtin
"unit" @type.builtin
"bool" @type.builtin
"int" @type.builtin
"float" @type.builtin
"char" @type.builtin
"string" @type.builtin

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

"+" @operator
"-" @operator
"*" @operator
"/" @operator
"%" @operator
"&" @operator
"|" @operator
"^" @operator
"<<" @operator
">>" @operator
"&&" @operator
"||" @operator
"==" @operator
"!=" @operator
"<" @operator
">" @operator
"<=" @operator
">=" @operator

"+=" @operator
"-=" @operator
"*=" @operator
"/=" @operator
"%=" @operator
"&=" @operator
"|=" @operator
"^=" @operator

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
  struct_name: (identifier) @type)

(enum_literal
  enum_name: (identifier) @type
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
  "<" @punctuation.special
  ">" @punctuation.special)

(generic_identifier) @type @spell

(enum_variant
  variant_name: (type_identifier_name) @constant @spell)

(union_declaration
  name: (identifier) @type @spell)

(match_arms
  "|" @punctuation.special)

(wildcard) @character.special
