return {
  "tjdevries/gruvbuddy.nvim",
  dependencies = {
    "tjdevries/colorbuddy.nvim",
  },
  lazy = false,
  priority = 1000,
  config = function()
    require("colorbuddy").colorscheme "gruvbuddy"
  end,
  enabled = false,
}
