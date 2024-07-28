"fun" @keyword.function

"let" @keyword
"mut" @keyword

"struct" @keyword.type
"enum" @keyword.type
"union" @keyword.type

"if" @keyword.conditional
"else" @keyword.conditional

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

(line_comment
  "//" @comment) @comment

(block_comment
  "/" @comment) @comment

(literal
  (string) @string)

(escape_sequence) @string.escape

(literal
  (bool) @boolean)

(literal
  (int) @number)

(literal
  (float) @number.float)

(literal
  (char) @char)

(identifier) @variable

(struct_literal
  struct_name: (identifier) @type)

(enum_literal
  enum_name: (identifier) @type
  enum_variant: (identifier) @type)

(fields
  field_name: (identifier) @property)

(function_declaration
  (identifier) @function)

(function_declaration
  body: (identifier) @variable)

(parameters
  (identifier) @variable.parameter)

(trailing_closure
  function: (identifier) @function.call)

(function_propagation
  function: (identifier) @function.call)

(call
  callee: (identifier) @function.call)

(call
  callee: (identifier) @function.builtin (#any-of? @function.builtin "print" "drop"))

(type_annotation) @type

(type_annotation
  type: (identifier) @type)

(type_annotation
  enum_name: (identifier) @type
  enum_variant: (identifier) @type)

(struct_declaration
  name: (identifier) @type)

(struct_declaration
  field_name: (identifier) @property)

(enum_declaration
  name: (identifier) @type)

(enum_variant
  variant_name: (identifier) @constant)

(enum_variant
  field_name: (identifier) @property)

(union_declaration
  name: (identifier) @type)
