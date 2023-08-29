return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = {
      spelling = {
        enabled = true,
        suggestions = 20,
      },
    },
    window = {
      border = "single",
    },
  },
  config = function(_, opts)
    local wk = require "which-key"
    wk.setup(opts)
    wk.register {
      ["<Leader>"] = {
        name = "<Leader>",
        D = { name = "DB" },
        g = { name = "Git" },
        l = { name = "LSP" },
        s = { name = "Search" },
        S = { name = "Session" },
      },
    }
  end,
}
