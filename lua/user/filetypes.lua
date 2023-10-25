vim.filetype.add {
  extension = {
    v = "vlang",
    snippets = "snippets",
    http = "http",
    rasi = "rasi",
    etlua = "html",
  },
  pattern = {
    [".*/kitty/.*%.conf"] = "kitty",
    [".*/nginx/.*"] = "nginx",
  },
}
