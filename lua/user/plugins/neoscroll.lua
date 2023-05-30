return {
  "karb94/neoscroll.nvim",
  keys = {
    { "<C-u>", desc = "Scroll cursor up half page" },
    { "<C-d>", desc = "Scroll curosr down half page" },
    { "<C-b>", desc = "Scroll cursor up full page" },
    { "<C-f>", desc = "Scroll cursor down full page" },
    { "<C-e>", desc = "Scroll page up" },
    { "<C-y>", desc = "Scroll page down" },
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
