vim.pack.add({ "https://github.com/echasnovski/mini.hipatterns" }, { load = true })

if vim.g.loaded_plugin_mini_hipatterns then
  return
end

vim.g.loaded_plugin_mini_hipatterns = 1

local hipatterns = require "mini.hipatterns"

hipatterns.setup {
  highlighters = {
    hex_color = hipatterns.gen_highlighter.hex_color(),
    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "DiagnosticInfo" },
    crtx = { pattern = "%f[%w]()CRTX()%f[%W]", group = "DiagnosticWarn" },
    fix = { pattern = "%f[%w]()FIX()%f[%W]", group = "DiagnosticError" },
  },
}
