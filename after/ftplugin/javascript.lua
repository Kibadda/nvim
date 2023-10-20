if require("user.utils").is_work() then
  vim.opt_local.tabstop = 4
  vim.opt_local.shiftwidth = 4
else
  vim.opt_local.tabstop = 2
  vim.opt_local.shiftwidth = 2
end

vim.lsp.start {
  name = "tsserver",
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript" },
  root_markers = { "package.json", ".git" },
}
