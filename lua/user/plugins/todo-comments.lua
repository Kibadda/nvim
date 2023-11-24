return {
  "folke/todo-comments.nvim",
  event = "VeryLazy",
  opts = {
    keywords = {
      CRTX = { icon = "🔥", color = "test" },
    },
    highlight = {
      multiline = false,
      keyword = "fg",
      pattern = [[(KEYWORDS)]],
      after = "",
    },
  },
}
