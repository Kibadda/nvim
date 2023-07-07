return {
  "tjdevries/gruvbuddy.nvim",
  enabled = false,
  dependencies = {
    "tjdevries/colorbuddy.nvim",
  },
  lazy = false,
  priority = 1000,
  config = function()
    require("colorbuddy").colorscheme "gruvbuddy"
  end,
}
