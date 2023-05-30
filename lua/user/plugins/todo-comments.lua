return {
  "folke/todo-comments.nvim",
  event = "VeryLazy",
  keys = {
    { "<Leader>st", "<Cmd>TodoTelescope<CR>", desc = "Todos" },
  },
  opts = {
    keywords = {
      CRTX = { icon = "🔥", color = "warning" },
    },
    highlight = {
      pattern = [[.*<(KEYWORDS)\s*]],
    },
  },
}
