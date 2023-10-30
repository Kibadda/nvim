return {
  "folke/todo-comments.nvim",
  enabled = false,
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
