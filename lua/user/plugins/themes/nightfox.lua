return {
  "EdenEast/nightfox.nvim",
  lazy = false,
  priority = 1000,
  init = function()
    require("user.themes").register("nighfox", function()
      require("nightfox").setup {
        options = {
          transparent = true,
        },
      }

      vim.cmd.colorscheme "nordfox"
    end)
  end,
}
