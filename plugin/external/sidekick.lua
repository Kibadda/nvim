vim.pack.add { "https://github.com/folke/sidekick.nvim" }

if vim.g.loaded_plugin_sidekick then
  return
end

vim.g.loaded_plugin_sidekick = 1

require("sidekick").setup {
  nes = {
    enabled = false,
  },
}
