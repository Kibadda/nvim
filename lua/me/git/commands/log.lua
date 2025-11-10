local M = {
  cmd = { "log", "--pretty=%h -%C()%d%Creset %s (%cr)" },
  can_refresh = true,
  show_output_in_buffer = true,
}

local data = {}

M.lsp = {
  [vim.lsp.protocol.Methods.textDocument_hover] = function(params)
    --- @cast params lsp.HoverParams

    local commit = data[params.position.line + 1]

    if commit then
      local parent
      if params.position.line + 1 == #data then
        parent = "4b825dc642cb6eb9a060e54bf8d69288fbee4904"
      else
        parent = commit .. "^"
      end

      require("me.git.commands").diff:run {
        parent .. ".." .. commit,
      }
    end
  end,
}

function M:on_buf_load(stdout)
  local extmarks = {}

  data = {}

  for i, line in ipairs(stdout) do
    local hash, branch, date

    hash, branch, date = line:match "^([^%s]+) %- (%([^%)]+%)).*(%([^%)]+%))$"

    if not hash then
      hash, date = line:match "^([^%s]+) %-.*(%([^%)]+%))$"
    end

    if not hash then
      break
    end

    data[i] = hash

    table.insert(extmarks, { line = i, col = 1, end_col = #hash, hl = "@keyword" })
    if branch then
      table.insert(extmarks, { line = i, col = #hash + 3, end_col = #hash + 3 + #branch, hl = "@constant" })
    end
    table.insert(extmarks, { line = i, col = #line - #date, end_col = #line, hl = "@property" })
  end

  return {
    extmarks = extmarks,
  }
end

return M
