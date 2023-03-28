return {
  "folke/todo-comments.nvim",
  event = "VeryLazy",
  opts = {
    keywords = {
      CRTX = { icon = "🔥", color = "warning" },
    },
    highlight = {
      pattern = [[.*<(KEYWORDS)>\s*]],
    },
  },
  init = function()
    require("user.utils").keymaps {
      n = {
        ["<Leader>"] = {
          s = {
            t = { "<Cmd>TodoTelescope<CR>", "Todos" },
          },
        },
      },
    }
  end,
}
