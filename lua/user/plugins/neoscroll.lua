return {
  "karb94/neoscroll.nvim",
  keys = {
    { "<C-u>", desc = "Scroll cursor up half page", mode = { "x", "n" } },
    { "<C-d>", desc = "Scroll curosr down half page", mode = { "x", "n" } },
    { "<C-b>", desc = "Scroll cursor up full page", mode = { "x", "n" } },
    { "<C-f>", desc = "Scroll cursor down full page", mode = { "x", "n" } },
    { "<C-e>", desc = "Scroll page up", mode = { "x", "n" } },
    { "<C-y>", desc = "Scroll page down", mode = { "x", "n" } },
  },
  opts = {
    mappings = {
      "<C-u>",
      "<C-d>",
      "<C-b>",
      "<C-f>",
      "<C-y>",
      "<C-e>",
      "zt",
      "zz",
      "zb",
    },
  },
}
