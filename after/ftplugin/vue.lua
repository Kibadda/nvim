vim.lsp.start {
  name = "tsserver",
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
