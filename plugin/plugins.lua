if vim.g.loaded_plugins then
  return
end

vim.g.loaded_plugins = 1

local function open_in_browser()
  local root = vim.treesitter.get_parser(0, "lua", {}):parse()[1]:root()
  local query = vim.treesitter.query.parse(
    "lua",
    [[
      (return_statement
        (expression_list
          (table_constructor
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
            ])))
    ]]
  )

  local plugins = {}
  for _, match in query:iter_matches(root, 0, 0, -1) do
    for id, node in pairs(match) do
      if query.captures[id] == "plugin" then
        local text = vim.treesitter.get_node_text(node, 0)
        if text then
          plugins[#plugins + 1] = text:gsub('"', "")
        end
      end
    end
  end

  if #plugins == 0 then
    return
  end

  local function url(plugin)
    vim.ui.open(("https://github.com/%s"):format(plugin))
  end

  if #plugins == 1 then
    url(plugins[1])
  else
    vim.ui.select(plugins, {
      prompt = "Select plugin to open",
    }, function(choice)
      if choice then
        url(choice)
      end
    end)
  end
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("PluginOpenInBrowser", { clear = true }),
  pattern = "lua",
  callback = function(args)
    if args.file:match "lua/user/plugins/" then
      vim.keymap.set("n", "gP", open_in_browser, { desc = "Open Plugin", buffer = args.buf })
    end
  end,
})
