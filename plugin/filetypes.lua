if vim.g.loaded_filetypes then
  return
end

vim.g.loaded_filetypes = 1

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
    [".*/waybar/config"] = "json",
  },
}
