return {
  "karb94/neoscroll.nvim",
  keys = { "<C-u>", "<C-d>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
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
  init = function()
    require("user.utils").keymaps {
      n = {
        ["<C-u>"] = "Scroll cursor up half page",
        ["<C-d>"] = "Scroll cursor down half page",
        ["<C-b>"] = "Scroll cursor up full page",
        ["<C-f>"] = "Scroll cursor down full page",
        ["<C-y>"] = "Scroll page down",
        ["<C-e>"] = "Scroll page up",
      },
    }
  end,
}
