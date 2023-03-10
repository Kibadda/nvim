local M = {
  "Kibadda/projectodo.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  dev = true,
}

M.opts = {
  plugin = "mini-starter",
  main_section = {
    name = "Dotfiles",
    sessions = { "config", "notes" },
    has_create_command = false,
  },
}

return M
