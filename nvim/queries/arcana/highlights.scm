"fun" @keyword
"let" @keyword

(literal
  (string) @string)
(literal
  (bool) @boolean)

(literal
  (int) @number)

(literal
  (float) @number.float)


(literal
  (char) @char)

(identifier) @variable

(function_declaration
  (identifier) @function)

(function_declaration
  body: (identifier) @variable)

(parameters
  (identifier) @variable.parameter)


(type_annotation) @type
