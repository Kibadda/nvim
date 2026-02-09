(binding
  (attrpath
    (identifier) @_inputs
    (#eq? @_inputs "inputs")
  )
  (attrset_expression
    (binding_set
      [
        (binding
          (attrpath
            .
            (identifier) @input
            (identifier) @_url
            (#eq? @_url "url")
          )
          (string_expression
            (string_fragment) @url
          )
        )
        (binding
          (attrpath
            (identifier) @input
            .
          )
          (attrset_expression
            (binding_set
              (binding
                (attrpath
                  .
                  (identifier) @_url
                  (#eq? @_url "url")
                )
                (string_expression
                  (string_fragment) @url
                )
              )
            )
          )
        )
      ]
    )
  )
)
