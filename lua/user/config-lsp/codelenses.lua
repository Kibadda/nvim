local cache = require "user.plugin-cache"

---@param params lsp.CodeLensParams
---@param lenses lsp.CodeLens[]
return function(params, lenses)
  if params.textDocument.uri:match "user/plugins/" then
    local buf = vim.uri_to_bufnr(params.textDocument.uri)

    for _, loc in ipairs(cache[buf]) do
      table.insert(lenses, {
        range = {
          start = { line = loc.range[1], character = loc.range[2] },
          ["end"] = { line = loc.range[3], character = loc.range[4] },
        },
        command = {
          title = "open plugin",
          command = "open_plugin_in_browser",
          arguments = {
            text = loc.text,
          },
        },
      })
    end
  end
end
