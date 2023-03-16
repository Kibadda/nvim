local M = {}

function M.open()
  local query_string = [[
      [
        (variable_declaration
          (assignment_statement
            (variable_list
              name: (identifier) @module (#eq? @module "M"))
            (expression_list
              value: (table_constructor
                [
                  (field
                    !name
                    value: (string) @plugin)
                  (field
                    name: (identifier) @dependencies (#eq? @dependencies "dependencies")
                    value: (table_constructor
                      [
                        (field
                          !name
                          value: (string) @plugin)
                        (field
                          !name
                          value: (table_constructor
                            (field
                              !name
                              value: (string) @plugin)))
                      ]))
                ]))))
        (return_statement
          (expression_list
            (table_constructor
              [
                (field
                  !name
                  value: (string) @plugin)
                (field
                  !name
                  value: (table_constructor
                    (field
                      !name
                      value: (string) @plugin)))
              ])))
      ]
    ]]

  local root = vim.treesitter.get_parser(0, "lua", {}):parse()[1]:root()
  local query = vim.treesitter.query.parse_query("lua", query_string)

  local plugins = {}
  for _, match in query:iter_matches(root, 0, 0, -1) do
    for id, node in pairs(match) do
      if query.captures[id] == "plugin" then
        local text = vim.treesitter.query.get_node_text(node, 0)
        if text then
          plugins[#plugins + 1] = text:gsub('"', "")
        end
      end
    end
  end

  if #plugins == 0 then
    return
  end

  local function open(plugin)
    os.execute(("xdg-open https://github.com/%s"):format(plugin))
  end

  if #plugins == 1 then
    open(plugins[1])
  else
    vim.ui.select(plugins, {
      prompt = "Select plugin to open",
    }, function(choice)
      if choice then
        open(choice)
      end
    end)
  end
end

function M.list()
  local directory = vim.fn.stdpath "config" .. "/lua/user/plugins"

  local function search_files(dir, prefix)
    local files = {}
    for name, type in vim.fs.dir(dir) do
      if type == "directory" then
        vim.list_extend(files, search_files(dir .. "/" .. name, name .. "/"))
      else
        table.insert(files, (prefix or "") .. name)
      end
    end

    return files
  end

  local files = search_files(directory)

  table.insert(files, 1, "New File")

  vim.ui.select(files, {}, function(choice, id)
    if not choice then
      return
    end

    if id == 1 then
      vim.ui.input({
        prompt = "Name: ",
      }, function(input)
        if input then
          vim.cmd(("e %s/%s.lua"):format(directory, input))
        end
      end)
    else
      vim.cmd(("e %s/%s"):format(directory, choice))
    end
  end)
end

return M
