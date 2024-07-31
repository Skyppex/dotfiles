(struct_declaration
  fields: (struct_fields) @class.inner) @class.outer

(enum_declaration
  variants: (enum_variants) @class.inner) @class.outer

(union_declaration
  variants: (union_variants) @class.inner) @class.outer

(function_declaration
  body: (_) @function.inner) @function.outer

; parameters
((parameters
  "," @_start
  .
  (parameter) @parameter.inner)
  (#make-range! "parameter.outer" @_start @parameter.inner))

((parameters
  .
  (parameter) @parameter.inner
  .
  ","? @_end)
  (#make-range! "parameter.outer" @parameter.inner @_end))

((arguments
  "," @_start
  .
  (argument) @parameter.inner)
  (#make-range! "parameter.outer" @_start @parameter.inner))

((arguments
  .
  (argument) @parameter.inner
  .
  ","? @_end)
  (#make-range! "parameter.outer" @parameter.inner @_end))
