local M = {
  cmd = { "pull" },
}

function M:on_error(code)
  if code == 125 then
    vim.cmd.Git()

    return "Merge conflict"
  end
end

return M
