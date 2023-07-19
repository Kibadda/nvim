vim.filetype.add {
  extension = {
    v = "vlang",
    snippets = "snippets",
    http = "http",
    rasi = "rasi",
  },
  pattern = {
    [".*/kitty/.*%.conf"] = "kitty",
    [".*/nginx/.*"] = "nginx",
  },
}
