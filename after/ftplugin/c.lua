vim.lsp.start {
  name = "clangd",
  cmd = { "clangd" },
  filetypes = { "c" },
  root_markers = { ".git" },
}
