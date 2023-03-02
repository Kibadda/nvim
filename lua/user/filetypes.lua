vim.filetype.add {
  extension = {
    v = "vlang",
    snippets = "snippets",
    http = "http",
  },
  pattern = {
    [".*/kitty/.*%.conf"] = "kitty",
    [".*/nginx/.*"] = "nginx",
  },
}
