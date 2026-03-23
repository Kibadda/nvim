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
      require("me.git.commands").stash:run {
        "show",
        "-p",
        stash,
      }
    end
  end,
}

function M:pre_run(fargs)
  if fargs[1] == "list" then
    self.show_output_in_buffer = true
  elseif fargs[1] == "show" then
    self.show_output_in_buffer = true
    self.filetype = "diff"

    if #fargs == 1 then
      local stash = require("me.git.utils").select_stash()

      if not stash then
        return false
      end

      table.insert(fargs, stash)
    end

    table.insert(fargs, 2, "-p")
  elseif vim.tbl_contains({ "drop", "pop", "apply" }, fargs[1]) then
    if #fargs == 1 then
      local stash = require("me.git.utils").select_stash()

      if not stash then
        return false
      end

      table.insert(fargs, stash)
    end
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
    if fargs[1] == "list" then
      return {}
    elseif vim.tbl_contains({ "drop", "pop", "apply", "show" }, fargs[1]) then
      return require("me.git.cache").stashes
    else
      return { "--staged", "--include-untracked", "--message" }
    end
  else
    return { "drop", "pop", "apply", "list", "show", "--staged", "--include-untracked", "--message" }
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
