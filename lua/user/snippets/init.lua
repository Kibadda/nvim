local M = {}

local function load_by_filetype(filetype)
  local ok, snippets = pcall(require, "user.snippets." .. filetype)
  if ok then
    return snippets
  else
    return {}
  end
end

function M.new()
  return setmetatable({}, { __index = M })
end

function M:complete(params, callback)
  local items = load_by_filetype(params.context.filetype)

  local result = {}

  for trigger, item in pairs(items) do
    table.insert(result, {
      word = trigger,
      label = trigger,
      kind = require("cmp").lsp.CompletionItemKind.Snippet,
      data = {
        snippet = item,
      },
    })
  end

  callback(result)
end

function M:execute(item, callback)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  col = col - #item.word
  vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col + #item.word, { "" })
  vim.snippet.expand(item.data.snippet)
  callback(item)
end

return M
