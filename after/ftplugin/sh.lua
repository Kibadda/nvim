vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2

vim.lsp.start {
  cmd = { "bash-language-server", "start" },
}
