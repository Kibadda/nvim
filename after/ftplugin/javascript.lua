if vim.env.LOCATION == "work" then
  vim.opt_local.tabstop = 4
  vim.opt_local.shiftwidth = 4
else
  vim.opt_local.tabstop = 2
  vim.opt_local.shiftwidth = 2
end

vim.lsp.start {
  cmd = { "typescript-language-server", "--stdio" },
  root_markers = { "package.json", ".git" },
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vim.fn.fnamemodify("./node_modules/@vue/typescript-plugin", ":p"),
        languages = { "vue" },
      },
    },
  },
}
