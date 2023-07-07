return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  init = function()
    require("user.themes").register("catppuccin", function()
      require("catppuccin").setup {
        flavour = "mocha",
        transparent_background = true,
      }
      vim.cmd.colorscheme "catppuccin"
    end)
  end,
}
