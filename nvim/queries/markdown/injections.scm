; extends

(fenced_code_block
  (info_string
    (language) @language (#eq? @language "csharp"))
  (code_fence_content) @injection.content
  (#set! "injection.language" "cs"))
