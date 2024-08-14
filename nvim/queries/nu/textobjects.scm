(decl_extern
  signature: (parameter_bracks . "[" . (_) @_start @_end (_)? @_end . "]"
    (#make-range! "function.inner" @_start @_end))) @function.outer


(decl_alias
  value: (_) @function.inner) @function.outer

(decl_def
  body: (block . "{" . (_) @_start @_end (_)? @_end . "}"
    (#make-range! "function.inner" @_start @_end))) @function.outer

