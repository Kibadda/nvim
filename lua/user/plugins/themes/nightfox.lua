return {
  "EdenEast/nightfox.nvim",
  enabled = false,
  lazy = false,
  priority = 1000,
  opts = {
    options = {
      transparent = true,
    },
  },
  config = function(_, opts)
    require("nightfox").setup(opts)
    vim.cmd.colorscheme "nordfox"
  end,
}
