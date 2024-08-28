; extends

(invocation_expression
  function: (member_access_expression
    name: (identifier) @_name (#any-of? @_name "LogTrace" "LogDebug" "LogInformation" "LogWarning" "LogError" "LogCritical" "LogFatal"))
  arguments: (argument_list
    (argument
      (string_literal
        (string_literal_content) @punctuation.special (#any-of? @punctuation.special "{" "}")))))
