return {
  "olimorris/onedarkpro.nvim",
  lazy = false,
  priority = 1000,
  init = function()
    require("user.themes").register("onedark", function()
      require("onedarkpro").setup {
        options = {
          transparency = true,
        },
      }

      vim.cmd.colorscheme "onedark"
    end)
  end,
}
