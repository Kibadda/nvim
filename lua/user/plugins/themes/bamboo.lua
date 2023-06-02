return {
  "ribru17/bamboo.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    transparent = true,
  },
  config = function(_, opts)
    require("bamboo").setup(opts)
    vim.cmd.colorscheme "bamboo"
  end,
  enabled = false,
}
