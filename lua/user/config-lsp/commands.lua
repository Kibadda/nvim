local commands = {}

---@param arguments { text: string }
function commands.open_plugin_in_browser(arguments)
  vim.ui.open(("https://github.com/%s"):format(arguments.text))
end

---@param arguments { label: string, snippet: string }
function commands.snippet_expand(arguments)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  col = col - #arguments.label
  vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col + #arguments.label, { "" })
  vim.snippet.expand(arguments.snippet)
end

return commands
