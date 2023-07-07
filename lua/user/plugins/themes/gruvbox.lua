return {
  "ellisonleao/gruvbox.nvim",
  lazy = false,
  priority = 1000,
  init = function()
    require("user.themes").register("gruvbox", function()
      require("gruvbox").setup {
        transparent_mode = true,
      }

      vim.cmd.colorscheme "gruvbox"
    end)
  end,
}
