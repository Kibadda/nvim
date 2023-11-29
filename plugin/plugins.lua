if vim.g.loaded_plugins then
  return
end

vim.g.loaded_plugins = 1

local cache = setmetatable({}, {
  __index = function(self, buf)
    local root = vim.treesitter.get_parser(buf, "lua", {}):parse()[1]:root()
    local query = vim.treesitter.query.parse(
      "lua",
      [[
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
                ])))
        ]]
    )

    local plugins = {}
    for _, match in query:iter_matches(root, buf, 0, -1) do
      for id, node in pairs(match) do
        if query.captures[id] == "plugin" then
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

    self[buf] = plugins

    return self[buf]
  end,
})

local function open_url(name)
  vim.ui.open(("https://github.com/%s"):format(name))
end

local function open_in_browser(buf)
  if #cache[buf] == 1 then
    open_url(cache[buf][1].text)
  elseif #cache[buf] > 1 then
    vim.ui.select(cache[buf], {
      prompt = "Select plugin to open",
    }, function(choice)
      if choice then
        open_url(choice.text)
      end
    end)
  end
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("PluginOpenInBrowser", { clear = true }),
  pattern = "lua",
  callback = function(args)
    if args.file:match "lua/user/plugins/" then
      vim.keymap.set("n", "gP", function()
        open_in_browser(args.buf)
      end, { desc = "Open Plugin", buffer = args.buf })
    end
  end,
})
