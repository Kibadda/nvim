local M = {
  cmd = { "pull" },
  show_output_in_buffer = function(stdout)
    return stdout[1] ~= "Already up to date."
  end,
}

M.lsp = {
  [vim.lsp.protocol.Methods.textDocument_hover] = function()
    require("me.git.commands").log:run { "HEAD@{1}..HEAD" }
  end,
}

function M:on_error(code)
  if code == 125 then
    vim.cmd.Git()

    return "Merge conflict"
  end
end

return M
