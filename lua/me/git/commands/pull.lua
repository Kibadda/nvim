local M = {
  cmd = { "pull" },
  show_output_in_buffer = function(stdout)
    return stdout[1] ~= "Already up to date."
  end,
}

local data = {}

M.lsp = {
  -- TODO: maybe dont show whole diff but fist show commits
  [vim.lsp.protocol.Methods.textDocument_hover] = function()
    if data.diff then
      require("me.git.commands").diff:run { data.diff }
    end
  end,
}

function M:on_buf_load(stdout)
  local diff = stdout[1]:match "^Updating (.*)$"

  if diff then
    data.diff = diff
  end

  return {}
end

function M:on_error(code)
  if code == 125 then
    vim.cmd.Git()

    return "Merge conflict"
  end
end

return M
