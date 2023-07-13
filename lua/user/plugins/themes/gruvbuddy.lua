return {
  "tjdevries/gruvbuddy.nvim",
  dependencies = {
    "tjdevries/colorbuddy.nvim",
  },
  lazy = false,
  priority = 1000,
  init = function()
    require("user.themes").register("gruvbuddy", function()
      require("colorbuddy").colorscheme "gruvbuddy"
    end)
  end,
}
