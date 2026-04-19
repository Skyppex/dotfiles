(shebang) @keyword.directive

[
 "!"
 "$"
 "L"
 "."
 "="
] @operator

[
  "("
  ")"
] @punctuation.bracket

[
  ";"
] @punctuation.delimiter

[
  "source"
] @keyword.import

(comment) @comment @spell

(variable
  (ident) @property)

(lambda
  param: (ident) @variable.parameter @spell)
