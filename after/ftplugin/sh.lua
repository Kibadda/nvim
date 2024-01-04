vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2

vim.lsp.start {
  name = "bash-language-server",
  cmd = { "bash-language-server", "start" },
  filetypes = { "sh" },
}
