; extends

(fenced_code_block
  (info_string
    (language) @language (#eq? @language "csharp"))
  (code_fence_content) @injection.content
  (#set! "injection.language" "cs"))

(fenced_code_block
  (info_string
    (language) @language (#eq? @language "arcana"))
  (code_fence_content) @injection.content
  (#set! "injection.language" "arcana"))

(fenced_code_block
  (info_string
    (language) @language (#eq? @language "ar"))
  (code_fence_content) @injection.content
  (#set! "injection.language" "arcana"))

(fenced_code_block
  (info_string
    (language) @language (#eq? @language "mage"))
  (code_fence_content) @injection.content
  (#set! "injection.language" "arcana"))
