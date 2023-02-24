local M = {
  "Kibadda/terminal.nvim",
  dev = true,
  cmd = "TerminalOpen",
}

function M.init()
  vim.cmd.cabbrev "T TerminalOpen"
end

return M
