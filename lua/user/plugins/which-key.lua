return {
  "folke/which-key.nvim",
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
  init = function()
    require("user.utils").keymaps {
      n = {
        ["<Leader>"] = {
          name = "<Leader>",
        },
      },
    }
  end,
}
