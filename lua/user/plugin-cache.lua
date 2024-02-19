return setmetatable({}, {
  __index = function(self, buf)
    local root = vim.treesitter.get_parser(buf, "lua", {}):parse()[1]:root()
    local query = vim.treesitter.query.parse(
      "lua",
      [[
          (chunk
            (return_statement
              (expression_list
                (table_constructor
                  [
                    (field
                      !name
                      value: (string content: (string_content) @plugin))
                    (field
                      name: (identifier) @_dependencies (#eq? @_dependencies "dependencies")
                      value: (table_constructor
                        (field
                          !name
                          value: [
                            (string content: (string_content) @plugin)
                            (table_constructor
                              (field
                                !name
                                value: (string content: (string_content) @plugin)))
                          ])))
                  ]))))
        ]]
    )

    local plugins = {}
    for _, match in query:iter_matches(root, buf, 0, -1, { all = true }) do
      for id, nodes in pairs(match) do
        if query.captures[id] == "plugin" then
          for _, node in ipairs(nodes) do
            local text = vim.treesitter.get_node_text(node, buf)
            if text then
              local ls, cs, le, ce = node:range()
              table.insert(plugins, {
                text = text,
                range = { ls, cs, le, ce },
              })
            end
          end
        end
      end
    end

    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
      buffer = buf,
      callback = function()
        self[buf] = nil
      end,
    })

    self[buf] = plugins

    return self[buf]
  end,
})
