(decl_extern
  signature: (parameter_bracks . "[" . (_) @_start @_end (_)? @_end . "]"
    (#make-range! "function.inner" @_start @_end))) @function.outer


(decl_alias
  value: (_) @function.inner) @function.outer

(decl_def
  body: (block . "{" . (_) @_start @_end (_)? @_end . "}"
    (#make-range! "function.inner" @_start @_end))) @function.outer

((comment) @comment.inner (#offset! @comment.inner 0 1 0 0)) @comment.outer

((parameter_bracks
  ((parameter) 
   (comment)?) @parameter.inner @parameter.outer))

((command
  .
  flag: (_) @parameter.inner @parameter.outer))

((command
  .
  arg_str: (_) @parameter.inner @parameter.outer))

((command
  .
  arg: (_) @parameter.inner @parameter.outer))

