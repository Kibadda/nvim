((style_element
  (raw_text) @injection.content
  (#set! injection.language "css")))

((attribute
  (attribute_name) @_attr
  (quoted_attribute_value (attribute_value) @injection.content
  (#set! injection.language "css")))
(#eq? @_attr "style"))

((script_element
  (raw_text) @injection.content
  (#set! injection.language "javascript")))

(comment) @comment
