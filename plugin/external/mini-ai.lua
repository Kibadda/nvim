vim.pack.add { "https://github.com/echasnovski/mini.ai" }

if vim.g.loaded_plugin_mini_ai then
  return
end

vim.g.loaded_plugin_mini_ai = 1

require("mini.ai").setup()
