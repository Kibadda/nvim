local snippets = {
  plugin = {
    ---@param uri string
    guard = function(uri)
      return uri:match "user/plugins/"
    end,
    command = "snippet_expand",
    snippet = 'return {\n\t"$1",\n\t$0\n}',
  },
  dependencies = {
    ---@param uri string
    guard = function(uri)
      return uri:match "user/plugins/"
    end,
    command = "snippet_expand",
    snippet = "dependencies = {\n\t$0\n},",
  },
  init = {
    ---@param uri string
    guard = function(uri)
      return uri:match "user/plugins/"
    end,
    command = "snippet_expand",
    snippet = "init = function($1)\n\t$0\nend,",
  },
  config = {
    ---@param uri string
    guard = function(uri)
      return uri:match "user/plugins/"
    end,
    command = "snippet_expand",
    snippet = "config = function(${1:_, opts})\n\t$0\nend,",
  },
}

---@param params lsp.CompletionParams
---@param items lsp.CompletionItem[]
return function(params, items)
  for name, data in pairs(snippets) do
    if not data.guard or data.guard(params.textDocument.uri) then
      ---@type lsp.CompletionItem
      local item = {
        label = name,
        kind = vim.lsp.protocol.CompletionItemKind.Snippet,
        insertText = "",
        command = {
          title = data.command,
          command = data.command,
          arguments = {
            snippet = data.snippet,
            label = name,
          },
        },
      }

      table.insert(items, item)
    end
  end
end
