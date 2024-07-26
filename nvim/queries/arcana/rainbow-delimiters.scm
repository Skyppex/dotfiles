(struct_declaration
  "{" @delimiter
  "}" @delimiter @sentinel) @container

(enum_declaration
  "{" @delimiter
  "}" @delimiter @sentinel) @container

(enum_variant
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(union_declaration
  "{" @delimiter
  "}" @delimiter @sentinel) @container

(function_declaration
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(block
  "{" @delimiter
  "}" @delimiter @sentinel) @container

(type_annotation
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(call
  "(" @delimiter
  ")" @delimiter @sentinel) @container

