; extends

(class_declaration
  body: (declaration_list . "{" . (_) @_start @_end (_)? @_end . "}"
    (#make-range! "class.inner" @_start @_end))) @class.outer

(struct_declaration
  body: (declaration_list . "{" . (_) @_start @_end (_)? @_end . "}"
    (#make-range! "class.inner" @_start @_end))) @class.outer

(record_declaration
  body: (declaration_list . "{" . (_) @_start @_end (_)? @_end . "}"
    (#make-range! "class.inner" @_start @_end))) @class.outer

(enum_declaration
  body: (enum_member_declaration_list . "{" . (_) @_start @_end (_)? @_end . "}"
    (#make-range! "class.inner" @_start @_end))) @class.outer

(interface_declaration
  body: (declaration_list . "{" . (_) @_start @_end (_)? @_end . "}"
    (#make-range! "class.inner" @_start @_end))) @class.outer
