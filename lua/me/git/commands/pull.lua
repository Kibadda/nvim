local M = {
  cmd = { "pull" },
}

function M:on_error(_, code)
  if code == 125 then
    vim.cmd.Git()

    return "Merge conflict"
  end
end

return M
