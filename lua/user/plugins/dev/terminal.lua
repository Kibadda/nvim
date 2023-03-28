return {
  "Kibadda/terminal.nvim",
  dev = true,
  cmd = "TerminalOpen",
  init = function()
    vim.cmd.cabbrev "T TerminalOpen"
  end,
}
