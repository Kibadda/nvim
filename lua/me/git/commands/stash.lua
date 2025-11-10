local M = {
  cmd = { "stash" },
  can_refresh = true,
}

local data = {}

M.lsp = {
  [vim.lsp.protocol.Methods.textDocument_hover] = function(params)
    --- @cast params lsp.HoverParams

    local stash = data[params.position.line + 1]

    if stash then
      require("me.git.commands").diff:run {
        "HEAD",
        stash,
      }
    end
  end,
}

function M:pre_run(fargs)
  if fargs[1] == "list" then
    self.show_output_in_buffer = true
  elseif vim.tbl_contains({ "drop", "pop", "apply" }, fargs[1]) then
    local stash = require("me.git.utils").select_stash()

    table.insert(fargs, stash)
  else
    local insert
    for i, arg in ipairs(fargs) do
      if arg == "--message" then
        insert = i + 1
        break
      end
    end

    if insert then
      local message

      vim.ui.input({
        prompt = "Enter message: ",
      }, function(input)
        message = input
      end)

      if not message or message == "" then
        return false
      end

      table.insert(fargs, insert, message)
    end
  end
end

function M.completions(fargs)
  if #fargs > 1 then
    if vim.tbl_contains({ "drop", "pop", "apply", "list" }, fargs[1]) then
      return {}
    else
      return { "--staged", "--include-untracked", "--message" }
    end
  else
    return { "drop", "pop", "apply", "list", "--staged", "--include-untracked", "--message" }
  end
end

function M:on_buf_load(stdout)
  local extmarks = {}

  data = {}

  for i, line in ipairs(stdout) do
    local stash = line:match "^(stash@{%d+})"

    if not stash then
      break
    end

    data[i] = stash

    table.insert(extmarks, { line = i, col = 1, end_col = #stash, hl = "@keyword" })
  end

  self.show_output_in_buffer = false

  return {
    extmarks = extmarks,
  }
end

return M
